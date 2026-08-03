import 'package:flutter/material.dart';

/// Model representing the results of the Zero-Trust Sandboxed HTML Pre-Render Previewer.
class DomSandboxResult {
  final String url;
  final String? pageTitle;
  final String? metaDescription;
  final String? faviconUrl;
  final List<String> headings;
  final List<String> paragraphs;
  final List<String> links;
  final int blockedScriptsCount;
  final int blockedTrackersCount;
  final int blockedIframesCount;
  final bool hasOpenRedirect;
  final String? redirectTarget;
  final DateTime? domainCreationDate;
  final int? domainAgeDays;
  final bool sslValid;
  final String sslDetails;
  final bool isSanitized;
  final String? sanitizedBodyHtml;
  final Color? pageThemeColor;
  final String statusMessage;

  const DomSandboxResult({
    required this.url,
    this.pageTitle,
    this.metaDescription,
    this.faviconUrl,
    this.headings = const [],
    this.paragraphs = const [],
    this.links = const [],
    required this.blockedScriptsCount,
    required this.blockedTrackersCount,
    required this.blockedIframesCount,
    required this.hasOpenRedirect,
    this.redirectTarget,
    this.domainCreationDate,
    this.domainAgeDays,
    required this.sslValid,
    required this.sslDetails,
    required this.isSanitized,
    this.sanitizedBodyHtml,
    this.pageThemeColor,
    required this.statusMessage,
  });

  /// True if domain age is considered newly registered (< 30 days old).
  bool get isNewlyRegisteredDomain =>
      domainAgeDays != null && domainAgeDays! < 30;

  /// Overall risk score derived from sandbox security heuristics.
  bool get isSafe =>
      sslValid &&
      !hasOpenRedirect &&
      !isNewlyRegisteredDomain &&
      blockedTrackersCount < 10;
}
