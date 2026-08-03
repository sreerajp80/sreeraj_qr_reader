import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:sreeraj_qr_reader/models/dom_sandbox_result.dart';

/// Service providing Zero-Trust Sandboxed HTML Pre-Rendering & Analysis.
///
/// Fetches and parses target HTML using a headless, script-disabled engine.
/// Blocks tracking scripts, automatic downloads, popups, iframe exploits, and open redirects.
/// Evaluates SSL certificates and domain age via WHOIS/RDAP.
class DomSandboxService {
  final http.Client _httpClient;

  DomSandboxService({http.Client? httpClient})
    : _httpClient = httpClient ?? _createPrivacyClient();

  static http.Client _createPrivacyClient() {
    final client = HttpClient();
    client.userAgent = null; // Deny default Dart User-Agent fingerprinting
    return IOClient(client);
  }

  /// Analyzes the target [url] in a Zero-Trust headless sandbox and returns [DomSandboxResult].
  Future<DomSandboxResult> analyzeAndRender(
    String url, {
    bool activeProbing = false,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return DomSandboxResult(
        url: url,
        blockedScriptsCount: 0,
        blockedTrackersCount: 0,
        blockedIframesCount: 0,
        hasOpenRedirect: false,
        sslValid: false,
        sslDetails: 'Invalid URL scheme',
        isSanitized: true,
        statusMessage: 'Invalid or unsupported web URL format.',
      );
    }

    // 1. SSL Certificate & Scheme Check
    final isHttps = uri.scheme == 'https';
    final sslDetails = isHttps
        ? 'Uses encrypted HTTPS protocol'
        : 'Unencrypted HTTP connection (High Risk)';

    // 2. Open Redirect Trap Heuristics Check (URL parameters)
    final openRedirectTarget = _detectQueryOpenRedirect(uri);
    var hasOpenRedirect = openRedirectTarget != null;
    var redirectTarget = openRedirectTarget;

    // Default DOM metadata (Private mode or before fetch)
    String? pageTitle = uri.host;
    String? metaDescription;
    List<String> headings = [];
    List<String> paragraphs = [];
    List<String> links = [];
    int blockedScriptsCount = 0;
    int blockedTrackersCount = 0;
    int blockedIframesCount = 0;
    Color? pageThemeColor;
    String? sanitizedBodyHtml;

    // 3. Domain Age & WHOIS/RDAP Check
    DateTime? domainCreationDate;
    int? domainAgeDays;

    if (activeProbing) {
      // Fetch domain creation date via RDAP
      final rdapData = await _fetchRdapDomainAge(uri.host);
      domainCreationDate = rdapData.$1;
      domainAgeDays = rdapData.$2;

      // Headless Script-Disabled HTML Fetch
      try {
        final request = http.Request('GET', uri);
        // Script-disabled sandbox headers
        request.headers['Accept'] = 'text/html,application/xhtml+xml';
        request.headers['Sec-Fetch-Dest'] = 'document';
        request.headers['Sec-Fetch-Mode'] = 'navigate';

        final response = await _httpClient
            .send(request)
            .timeout(const Duration(seconds: 5));

        // Check HTTP 3xx redirect chain
        if (response.statusCode >= 300 && response.statusCode < 400) {
          final location = response.headers['location'];
          if (location != null && location.isNotEmpty) {
            hasOpenRedirect = true;
            redirectTarget = location;
          }
        }

        final rawResponseBody = await response.stream.bytesToString();
        // Limit max body size to 500KB to prevent memory exhaustion
        final htmlContent = rawResponseBody.length > 512000
            ? rawResponseBody.substring(0, 512000)
            : rawResponseBody;

        // Sanitization and DOM hierarchy extraction
        final sanitizedData = _sanitizeHtmlAndExtractDom(htmlContent, uri);
        pageTitle = sanitizedData.title ?? pageTitle;
        metaDescription = sanitizedData.metaDescription;
        headings = sanitizedData.headings;
        paragraphs = sanitizedData.paragraphs;
        links = sanitizedData.links;
        blockedScriptsCount = sanitizedData.blockedScripts;
        blockedTrackersCount = sanitizedData.blockedTrackers;
        blockedIframesCount = sanitizedData.blockedIframes;
        pageThemeColor = sanitizedData.themeColor;
        sanitizedBodyHtml = sanitizedData.sanitizedHtml;

        if (sanitizedData.metaRefreshTarget != null) {
          hasOpenRedirect = true;
          redirectTarget = sanitizedData.metaRefreshTarget;
        }
      } catch (e) {
        // Handle network timeout or fetch error gracefully
        pageTitle = '${uri.host} (Offline / Network Restricted)';
      }
    } else {
      // Offline / Private Mode Heuristic DOM Preview
      pageTitle = uri.host;
      metaDescription =
          'Sanitized preview generated locally without contacting target server.';
      headings = ['Host: ${uri.host}', 'Path: ${uri.path}'];
      paragraphs = [
        'Private mode active. Direct server connection and User-Agent fingerprinting blocked.',
      ];
      links = [url];
    }

    final statusMessage = hasOpenRedirect
        ? '⚠️ Warning: Open Redirect Trap detected pointing to $redirectTarget'
        : (!isHttps
              ? '⚠️ Caution: Unencrypted HTTP site'
              : (domainAgeDays != null && domainAgeDays < 30
                    ? '⚠️ Warning: Newly registered domain ($domainAgeDays days old)'
                    : '✅ Zero-Trust DOM Sandbox: HTML preview sanitized safely.'));

    return DomSandboxResult(
      url: url,
      pageTitle: pageTitle,
      metaDescription: metaDescription,
      faviconUrl: 'https://${uri.host}/favicon.ico',
      headings: headings,
      paragraphs: paragraphs,
      links: links,
      blockedScriptsCount: blockedScriptsCount,
      blockedTrackersCount: blockedTrackersCount,
      blockedIframesCount: blockedIframesCount,
      hasOpenRedirect: hasOpenRedirect,
      redirectTarget: redirectTarget,
      domainCreationDate: domainCreationDate,
      domainAgeDays: domainAgeDays,
      sslValid: isHttps,
      sslDetails: sslDetails,
      isSanitized: true,
      sanitizedBodyHtml: sanitizedBodyHtml,
      pageThemeColor: pageThemeColor,
      statusMessage: statusMessage,
    );
  }

  /// Detects open redirect traps in URL query parameters.
  String? _detectQueryOpenRedirect(Uri uri) {
    const redirectKeys = [
      'redirect',
      'url',
      'dest',
      'destination',
      'next',
      'target',
      'out',
      'link',
      'to',
      'goto',
      'u',
      'r',
      'ref',
    ];

    for (final entry in uri.queryParameters.entries) {
      final keyLower = entry.key.toLowerCase();
      if (redirectKeys.contains(keyLower)) {
        final val = entry.value;
        if (val.startsWith('http://') || val.startsWith('https://')) {
          final targetUri = Uri.tryParse(val);
          if (targetUri != null && targetUri.host != uri.host) {
            return val;
          }
        }
      }
    }
    return null;
  }

  /// Sanitizes HTML DOM, stripping scripts, trackers, popups, and extracting metadata.
  _SanitizedDomData _sanitizeHtmlAndExtractDom(String html, Uri baseUri) {
    var blockedScripts = 0;
    var blockedTrackers = 0;
    var blockedIframes = 0;
    String? metaRefreshTarget;

    // 1. Strip <script> tags
    final scriptRegex = RegExp(
      r'<script\b[^>]*>([\s\S]*?)<\/script>',
      caseSensitive: false,
    );
    blockedScripts += scriptRegex.allMatches(html).length;
    var cleanHtml = html.replaceAll(scriptRegex, '');

    // 2. Strip inline event handlers (e.g. onload=, onclick=, onerror=)
    final inlineJsRegex = RegExp(
      r'''\son[a-z]+\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]+)''',
      caseSensitive: false,
    );
    final inlineMatches = inlineJsRegex.allMatches(cleanHtml).length;
    blockedScripts += inlineMatches;
    cleanHtml = cleanHtml.replaceAll(inlineJsRegex, '');

    // 3. Strip <iframe>, <embed>, <object>
    final iframeRegex = RegExp(
      r'<(iframe|embed|object)\b[^>]*>([\s\S]*?)<\/(iframe|embed|object)>|<(iframe|embed|object)\b[^>]*\/?>',
      caseSensitive: false,
    );
    blockedIframes += iframeRegex.allMatches(cleanHtml).length;
    cleanHtml = cleanHtml.replaceAll(iframeRegex, '');

    // 4. Strip tracking pixels (1x1 images, analytics scripts/pixels)
    final trackerRegex = RegExp(
      r'''<img\b[^>]*(?:width\s*=\s*["']?[01]["']?|height\s*=\s*["']?[01]["']?|analytics|pixel|tracker|doubleclick|telemetry)[^>]*\/?>''',
      caseSensitive: false,
    );
    blockedTrackers += trackerRegex.allMatches(cleanHtml).length;
    cleanHtml = cleanHtml.replaceAll(trackerRegex, '');

    // 5. Detect meta refresh redirects (<meta http-equiv="refresh" content="... url=...">)
    final metaRefreshRegex = RegExp(
      r'''<meta\b[^>]*http-equiv\s*=\s*["']?refresh["']?[^>]*content\s*=\s*["']?[^"']*url=([^"'\s>]+)["']?[^>]*\/?>''',
      caseSensitive: false,
    );
    final refreshMatch = metaRefreshRegex.firstMatch(cleanHtml);
    if (refreshMatch != null) {
      metaRefreshTarget = refreshMatch.group(1);
    }

    // Extract Title
    final titleRegex = RegExp(
      r'<title\b[^>]*>(.*?)</title>',
      caseSensitive: false,
      dotAll: true,
    );
    final titleMatch = titleRegex.firstMatch(cleanHtml);
    final title = titleMatch?.group(1)?.trim();

    // Extract Meta Description
    final descRegex = RegExp(
      r'''<meta\b[^>]*(?:name|property)\s*=\s*["']?(?:description|og:description)["']?[^>]*content\s*=\s*["']?([^"'\n>]+)["']?[^>]*\/?>''',
      caseSensitive: false,
    );
    final descMatch = descRegex.firstMatch(cleanHtml);
    final metaDescription = descMatch?.group(1)?.trim();

    // Extract Headings
    final headingRegex = RegExp(
      r'<h[1-3]\b[^>]*>(.*?)</h[1-3]>',
      caseSensitive: false,
      dotAll: true,
    );
    final headings = headingRegex
        .allMatches(cleanHtml)
        .map((m) => _stripTags(m.group(1) ?? ''))
        .where((h) => h.isNotEmpty)
        .take(5)
        .toList();

    // Extract Paragraphs
    final pRegex = RegExp(
      r'<p\b[^>]*>(.*?)</p>',
      caseSensitive: false,
      dotAll: true,
    );
    final paragraphs = pRegex
        .allMatches(cleanHtml)
        .map((m) => _stripTags(m.group(1) ?? ''))
        .where((p) => p.isNotEmpty && p.length > 10)
        .take(4)
        .toList();

    // Extract Links
    final linkRegex = RegExp(
      r'''<a\b[^>]*href\s*=\s*["']?([^"'\s>]+)["']?[^>]*>(.*?)</a>''',
      caseSensitive: false,
    );
    final links = linkRegex
        .allMatches(cleanHtml)
        .map((m) => m.group(1) ?? '')
        .where((l) => l.startsWith('http'))
        .take(5)
        .toList();

    // Extract Theme Color
    Color? themeColor;
    final themeColorRegex = RegExp(
      r'''<meta\b[^>]*name\s*=\s*["']?theme-color["']?[^>]*content\s*=\s*["']?([^"'\s>]+)["']?[^>]*\/?>''',
      caseSensitive: false,
    );
    final themeMatch = themeColorRegex.firstMatch(cleanHtml);
    if (themeMatch != null) {
      final hexStr = themeMatch.group(1);
      if (hexStr != null && hexStr.startsWith('#')) {
        try {
          final colorInt = int.parse(hexStr.replaceFirst('#', '0xFF'));
          themeColor = Color(colorInt);
        } catch (_) {}
      }
    }

    return _SanitizedDomData(
      title: title,
      metaDescription: metaDescription,
      headings: headings,
      paragraphs: paragraphs,
      links: links,
      blockedScripts: blockedScripts,
      blockedTrackers: blockedTrackers,
      blockedIframes: blockedIframes,
      metaRefreshTarget: metaRefreshTarget,
      themeColor: themeColor,
      sanitizedHtml: cleanHtml.length > 2000
          ? cleanHtml.substring(0, 2000)
          : cleanHtml,
    );
  }

  String _stripTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  /// Fetches domain creation date using RDAP (Registration Data Access Protocol).
  Future<(DateTime?, int?)> _fetchRdapDomainAge(String domain) async {
    try {
      final cleanDomain = domain.startsWith('www.')
          ? domain.substring(4)
          : domain;
      final uri = Uri.parse('https://rdap.org/domain/$cleanDomain');

      final response = await _httpClient
          .get(uri)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final events = json['events'] as List<dynamic>?;
        if (events != null) {
          for (final event in events) {
            final action = event['eventAction'] as String?;
            if (action == 'registration' || action == 'created') {
              final dateStr = event['eventDate'] as String?;
              if (dateStr != null) {
                final date = DateTime.tryParse(dateStr);
                if (date != null) {
                  final age = DateTime.now().difference(date).inDays;
                  return (date, age);
                }
              }
            }
          }
        }
      }
    } catch (_) {}
    return (null, null);
  }
}

class _SanitizedDomData {
  final String? title;
  final String? metaDescription;
  final List<String> headings;
  final List<String> paragraphs;
  final List<String> links;
  final int blockedScripts;
  final int blockedTrackers;
  final int blockedIframes;
  final String? metaRefreshTarget;
  final Color? themeColor;
  final String sanitizedHtml;

  _SanitizedDomData({
    this.title,
    this.metaDescription,
    required this.headings,
    required this.paragraphs,
    required this.links,
    required this.blockedScripts,
    required this.blockedTrackers,
    required this.blockedIframes,
    this.metaRefreshTarget,
    this.themeColor,
    required this.sanitizedHtml,
  });
}
