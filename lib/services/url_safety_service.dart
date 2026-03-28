import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/models/safety_check_result.dart';

class UrlSafetyService {
  final http.Client _httpClient;
  final FlutterSecureStorage _secureStorage;

  UrlSafetyService({
    http.Client? httpClient,
    FlutterSecureStorage? secureStorage,
  })  : _httpClient = httpClient ?? http.Client(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<List<SafetyCheckResult>> runAllChecks(String url) async {
    return [
      await checkSslCertificate(url),
      await checkUrlRedirects(url),
      await checkSuspiciousPatterns(url),
      await checkUrlShorteners(url),
      await checkHomographAttacks(url),
      await checkGoogleSafeBrowsing(url),
    ];
  }

  Future<SafetyCheckResult> checkSslCertificate(String url) async {
    try {
      final uri = Uri.parse(url);

      if (uri.scheme != 'https') {
        return const SafetyCheckResult(
          checkName: 'HTTPS Connection',
          passed: false,
          message: 'URL uses unencrypted HTTP connection',
        );
      }

      final client = HttpClient();
      var certificateValid = true;
      var certMessage = 'Valid SSL certificate';

      client.badCertificateCallback = (cert, host, port) {
        final now = DateTime.now();
        if (cert.endValidity.isBefore(now)) {
          certificateValid = false;
          certMessage = 'SSL certificate has expired';
          return false;
        }
        if (cert.startValidity.isAfter(now)) {
          certificateValid = false;
          certMessage = 'SSL certificate not yet valid';
          return false;
        }
        return true;
      };

      try {
        final request =
            await client.getUrl(uri).timeout(const Duration(seconds: 5));
        request.followRedirects = false;
        final response = await request.close();
        await response.drain<void>();
        return SafetyCheckResult(
          checkName: 'SSL/TLS Certificate',
          passed: certificateValid,
          message: certMessage,
        );
      } catch (e) {
        return const SafetyCheckResult(
          checkName: 'SSL/TLS Certificate',
          passed: false,
          message: 'Unable to verify certificate',
        );
      } finally {
        client.close();
      }
    } catch (e) {
      return const SafetyCheckResult(
        checkName: 'SSL/TLS Certificate',
        passed: false,
        message: 'Certificate check failed',
      );
    }
  }

  Future<SafetyCheckResult> checkUrlRedirects(String url) async {
    try {
      var redirectCount = 0;
      var currentUrl = url;
      final visitedUrls = <String>{};

      while (redirectCount < 5) {
        if (visitedUrls.contains(currentUrl)) {
          return const SafetyCheckResult(
            checkName: 'Redirect Analysis',
            passed: false,
            message: 'Redirect loop detected',
          );
        }

        visitedUrls.add(currentUrl);

        final response = await _httpClient
            .head(Uri.parse(currentUrl))
            .timeout(const Duration(seconds: 5));

        final sc = response.statusCode;
        if (sc < 300 || sc >= 400) break;

        redirectCount++;
        final location = response.headers['location'];
        if (location == null) break;

        if (location.startsWith('/')) {
          final uri = Uri.parse(currentUrl);
          currentUrl = '${uri.scheme}://${uri.host}$location';
        } else if (!location.startsWith('http')) {
          final uri = Uri.parse(currentUrl);
          currentUrl = '${uri.scheme}://${uri.host}/$location';
        } else {
          currentUrl = location;
        }
      }

      if (redirectCount == 0) {
        return const SafetyCheckResult(
          checkName: 'Redirect Analysis',
          passed: true,
          message: 'No redirects detected',
        );
      } else if (redirectCount >= 3) {
        return SafetyCheckResult(
          checkName: 'Redirect Analysis',
          passed: false,
          message: 'Suspicious redirect chain ($redirectCount redirects)',
        );
      } else {
        return SafetyCheckResult(
          checkName: 'Redirect Analysis',
          passed: true,
          message: '$redirectCount redirect(s) - within normal range',
        );
      }
    } catch (e) {
      return const SafetyCheckResult(
        checkName: 'Redirect Analysis',
        passed: false,
        message: 'Unable to check redirects',
      );
    }
  }

  Future<SafetyCheckResult> checkSuspiciousPatterns(String url) async {
    try {
      final uri = Uri.parse(url);
      final domain = uri.host.toLowerCase();

      final suspiciousPatterns = {
        'IP Address': RegExp(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'),
        'Long Number Sequence': RegExp(r'[0-9]{8,}'),
        'Multiple Dashes/Underscores': RegExp(r'[-_]{4,}'),
        'Phishing Keywords': RegExp(
          r'(login|signin|verify|secure|update|confirm|account|suspend|locked).*[0-9]+',
        ),
        'Data URI': RegExp(r'data:'),
        'Multiple Subdomains': RegExp(r'([\w-]+\.){4,}'),
      };

      final detectedPatterns = <String>[];
      for (final entry in suspiciousPatterns.entries) {
        if (entry.value.hasMatch(domain) || entry.value.hasMatch(uri.path)) {
          detectedPatterns.add(entry.key);
        }
      }

      if (detectedPatterns.isEmpty) {
        return const SafetyCheckResult(
          checkName: 'Pattern Detection',
          passed: true,
          message: 'No suspicious patterns found',
        );
      }
      return SafetyCheckResult(
        checkName: 'Pattern Detection',
        passed: false,
        message: 'Detected: ${detectedPatterns.join(', ')}',
      );
    } catch (e) {
      return const SafetyCheckResult(
        checkName: 'Pattern Detection',
        passed: false,
        message: 'Unable to analyze patterns',
      );
    }
  }

  Future<SafetyCheckResult> checkUrlShorteners(String url) async {
    try {
      final uri = Uri.parse(url);
      final domain = uri.host.toLowerCase();
      final path = uri.path;

      const knownShorteners = [
        'bit.ly', 'tinyurl.com', 'goo.gl', 't.co', 'ow.ly', 'is.gd',
        'buff.ly', 'adf.ly', 'short.link', 'cutt.ly', 'rb.gy', 'tiny.cc',
        'cli.gs', 'lnkd.in', 'bitly.com', 'j.mp', 'tinyarrows.com',
        'shortened.link', 's.id',
      ];

      for (final shortener in knownShorteners) {
        if (domain.contains(shortener)) {
          return SafetyCheckResult(
            checkName: 'URL Shortener Check',
            passed: false,
            message: 'Known URL shortener detected ($shortener)',
          );
        }
      }

      var isSuspiciousShortener = false;
      var reason = '';

      if (domain.length <= 8 && path.length <= 10 && path.length > 1) {
        isSuspiciousShortener = true;
        reason = 'Short domain with minimal path (typical shortener pattern)';
      }

      const shortenerTLDs = ['.ly', '.gl', '.me', '.co', '.link', '.to', '.id'];
      for (final tld in shortenerTLDs) {
        if (domain.endsWith(tld) && domain.length <= 10) {
          isSuspiciousShortener = true;
          reason = 'Short domain with common shortener TLD ($tld)';
          break;
        }
      }

      if (path.length > 1 && path.length <= 10) {
        final pathWithoutSlash = path.substring(1);
        final hasOnlyAlphanumeric =
            RegExp(r'^[a-zA-Z0-9]+$').hasMatch(pathWithoutSlash);
        final hasUpperAndLower =
            RegExp(r'[a-z]').hasMatch(pathWithoutSlash) &&
                RegExp(r'[A-Z]').hasMatch(pathWithoutSlash);
        if (hasOnlyAlphanumeric && hasUpperAndLower && domain.length <= 12) {
          isSuspiciousShortener = true;
          reason = 'Random character pattern in short path';
        }
      }

      var networkCheckCompleted = false;
      try {
        final response =
            await _httpClient.head(uri).timeout(const Duration(seconds: 5));
        networkCheckCompleted = true;

        if (response.isRedirect && domain.length <= 12) {
          final location = response.headers['location'];
          if (location != null) {
            final redirectUri = Uri.parse(
              location.startsWith('http')
                  ? location
                  : '${uri.scheme}://${uri.host}$location',
            );
            if (redirectUri.host != uri.host) {
              return SafetyCheckResult(
                checkName: 'URL Shortener Check',
                passed: false,
                message:
                    'Detected URL shortener (redirects to ${redirectUri.host})',
              );
            }
          }
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Could not check redirect for shortener detection: $e');
      }

      if (isSuspiciousShortener) {
        return SafetyCheckResult(
          checkName: 'URL Shortener Check',
          passed: false,
          message: 'Possible URL shortener: $reason',
        );
      } else if (!networkCheckCompleted) {
        return const SafetyCheckResult(
          checkName: 'URL Shortener Check',
          passed: false,
          message: 'Unable to perform full check (offline) - heuristics only',
        );
      } else {
        return const SafetyCheckResult(
          checkName: 'URL Shortener Check',
          passed: true,
          message: 'No URL shortener detected',
        );
      }
    } catch (e) {
      return const SafetyCheckResult(
        checkName: 'URL Shortener Check',
        passed: false,
        message: 'Unable to check for shorteners',
      );
    }
  }

  Future<SafetyCheckResult> checkHomographAttacks(String url) async {
    try {
      // Extract host from the raw URL string so Unicode characters are preserved.
      // Uri.parse percent-encodes non-ASCII host chars, which defeats lookalike detection.
      final authorityIndex = url.indexOf('://');
      final rawHost = authorityIndex >= 0
          ? url.substring(authorityIndex + 3).split('/').first.split(':').first
          : Uri.parse(url).host;
      final domain = rawHost.toLowerCase();

      const suspiciousChars = {
        'ı': 'i', 'ł': 'l', 'о': 'o', 'а': 'a', 'е': 'e',
        'с': 'c', 'р': 'p', 'х': 'x', 'у': 'y', 'ѕ': 's',
        'һ': 'h', 'і': 'i', 'ј': 'j', 'ԁ': 'd', 'ԛ': 'q',
        'ο': 'o', 'υ': 'u', 'ν': 'v', 'ρ': 'p',
      };

      final foundChars = <String>[];
      for (final entry in suspiciousChars.entries) {
        if (domain.contains(entry.key)) {
          foundChars.add('${entry.key} (looks like ${entry.value})');
        }
      }

      final hasLatin = RegExp(r'[a-zA-Z]').hasMatch(domain);
      final hasCyrillic = RegExp(r'[\u0400-\u04FF]').hasMatch(domain);
      final hasGreek = RegExp(r'[\u0370-\u03FF]').hasMatch(domain);

      var scriptCount = 0;
      if (hasLatin) scriptCount++;
      if (hasCyrillic) scriptCount++;
      if (hasGreek) scriptCount++;

      if (foundChars.isNotEmpty || scriptCount > 1) {
        return SafetyCheckResult(
          checkName: 'Homograph Attack Check',
          passed: false,
          message: foundChars.isNotEmpty
              ? 'Lookalike characters detected: ${foundChars.join(', ')}'
              : 'Mixed character scripts detected',
        );
      }
      return const SafetyCheckResult(
        checkName: 'Homograph Attack Check',
        passed: true,
        message: 'No lookalike characters detected',
      );
    } catch (e) {
      return const SafetyCheckResult(
        checkName: 'Homograph Attack Check',
        passed: false,
        message: 'Unable to check for homographs',
      );
    }
  }

  Future<SafetyCheckResult> checkGoogleSafeBrowsing(String url) async {
    try {
      final apiKey = await _secureStorage.read(
        key: 'google_safe_browsing_api_key',
      );

      if (apiKey == null || apiKey.isEmpty) {
        return const SafetyCheckResult(
          checkName: 'Malicious Content Check',
          passed: true,
          message: 'Skipped (API key not configured)',
        );
      }

      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastReset = prefs.getString('safe_browsing_last_reset');

      if (lastReset != today) {
        await prefs.setInt('safe_browsing_request_count', 0);
        await prefs.setString('safe_browsing_last_reset', today);
      }

      final requestCount = prefs.getInt('safe_browsing_request_count') ?? 0;
      const maxRequests = 10000;

      if (requestCount >= maxRequests) {
        return const SafetyCheckResult(
          checkName: 'Malicious Content Check',
          passed: true,
          message: 'Daily API limit reached (resets tomorrow)',
        );
      }

      final apiUrl =
          'https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$apiKey';

      final requestBody = {
        'client': {'clientId': 'sreeraj-qr-reader', 'clientVersion': '1.0.0'},
        'threatInfo': {
          'threatTypes': [
            'MALWARE',
            'SOCIAL_ENGINEERING',
            'UNWANTED_SOFTWARE',
            'POTENTIALLY_HARMFUL_APPLICATION',
          ],
          'platformTypes': ['ANY_PLATFORM'],
          'threatEntryTypes': ['URL'],
          'threatEntries': [
            {'url': url},
          ],
        },
      };

      final response = await _httpClient
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      await prefs.setInt('safe_browsing_request_count', requestCount + 1);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data.containsKey('matches') &&
            (data['matches'] as List).isNotEmpty) {
          final threats = data['matches'] as List<dynamic>;
          final threatTypes = threats
              .map((t) => (t as Map)['threatType'].toString().replaceAll('_', ' '))
              .toSet()
              .join(', ');
          return SafetyCheckResult(
            checkName: 'Malicious Content Check',
            passed: false,
            message: 'Threats detected: $threatTypes',
          );
        }
        return const SafetyCheckResult(
          checkName: 'Malicious Content Check',
          passed: true,
          message: 'No known threats detected',
        );
      } else if (response.statusCode == 400) {
        return const SafetyCheckResult(
          checkName: 'Malicious Content Check',
          passed: false,
          message: 'Invalid API key or request',
        );
      } else if (response.statusCode == 429) {
        return const SafetyCheckResult(
          checkName: 'Malicious Content Check',
          passed: true,
          message: 'Rate limit exceeded',
        );
      } else {
        return SafetyCheckResult(
          checkName: 'Malicious Content Check',
          passed: false,
          message: 'API error (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Google Safe Browsing check error: ${e.runtimeType}');
      return const SafetyCheckResult(
        checkName: 'Malicious Content Check',
        passed: false,
        message: 'Unable to check for malicious content',
      );
    }
  }
}
