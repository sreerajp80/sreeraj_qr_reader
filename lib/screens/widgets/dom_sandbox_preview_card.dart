import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/models/dom_sandbox_result.dart';

/// Widget rendering a Zero-Trust Sandboxed HTML Pre-Render Preview Card.
class DomSandboxPreviewCard extends StatelessWidget {
  final DomSandboxResult result;

  const DomSandboxPreviewCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final headerColor = result.pageThemeColor ?? theme.colorScheme.primary;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: result.isSafe ? Colors.teal.shade300 : Colors.amber.shade700,
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Simulated Browser Address Header Bar
          Container(
            color: Colors.grey.shade900,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Window Control Buttons Mockup
                Row(
                  children: [
                    _buildDot(Colors.red.shade400),
                    const SizedBox(width: 4),
                    _buildDot(Colors.amber.shade400),
                    const SizedBox(width: 4),
                    _buildDot(Colors.green.shade400),
                  ],
                ),
                const SizedBox(width: 12),
                // Browser URL Address Bar
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          result.sslValid ? Icons.lock : Icons.lock_open,
                          size: 14,
                          color: result.sslValid
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            result.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade900,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 12,
                        color: Colors.tealAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.domSandboxedBadge,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sanitized Visual Thumbnail Preview Viewport
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Site Header Banner Mockup
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: headerColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: headerColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: headerColor,
                        child: Text(
                          (result.pageTitle != null &&
                                  result.pageTitle!.isNotEmpty)
                              ? result.pageTitle![0].toUpperCase()
                              : l10n.domTitleInitialFallback,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.pageTitle ?? l10n.domUntitledPage,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.grey.shade900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              l10n.domThumbnailCaption,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Meta Description if available
                if (result.metaDescription != null &&
                    result.metaDescription!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    result.metaDescription!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Extracted Headings & Snippets Preview
                if (result.headings.isNotEmpty ||
                    result.paragraphs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result.headings.isNotEmpty) ...[
                          Text(
                            result.headings.first,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (result.paragraphs.isNotEmpty)
                          Text(
                            result.paragraphs.first,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Security & Sandbox Shield Badges Grid
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildShieldBadge(
                      icon: Icons.shield,
                      label: l10n.domBlockedBadge(
                        result.blockedScriptsCount,
                        result.blockedTrackersCount,
                      ),
                      color: Colors.teal.shade800,
                      bgColor: Colors.teal.shade50,
                    ),
                    _buildShieldBadge(
                      icon: result.sslValid
                          ? Icons.verified
                          : Icons.warning_amber,
                      label: result.sslDetails,
                      color: result.sslValid
                          ? Colors.green.shade800
                          : Colors.orange.shade900,
                      bgColor: result.sslValid
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                    ),
                    if (result.domainAgeDays != null)
                      _buildShieldBadge(
                        icon: result.isNewlyRegisteredDomain
                            ? Icons.error_outline
                            : Icons.calendar_today,
                        label: result.isNewlyRegisteredDomain
                            ? l10n.domNewlyRegistered(result.domainAgeDays!)
                            : l10n.domDomainAge(result.domainAgeDays!),
                        color: result.isNewlyRegisteredDomain
                            ? Colors.red.shade800
                            : Colors.blue.shade800,
                        bgColor: result.isNewlyRegisteredDomain
                            ? Colors.red.shade50
                            : Colors.blue.shade50,
                      ),
                    _buildShieldBadge(
                      icon: result.hasOpenRedirect
                          ? Icons.alt_route
                          : Icons.check_circle_outline,
                      label: result.hasOpenRedirect
                          ? l10n.domOpenRedirectFound
                          : l10n.domNoOpenRedirect,
                      color: result.hasOpenRedirect
                          ? Colors.red.shade800
                          : Colors.indigo.shade800,
                      bgColor: result.hasOpenRedirect
                          ? Colors.red.shade50
                          : Colors.indigo.shade50,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Status banner
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: result.isSafe
                        ? Colors.green.shade50
                        : Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: result.isSafe
                          ? Colors.green.shade300
                          : Colors.amber.shade400,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        result.isSafe ? Icons.check_circle : Icons.warning,
                        size: 18,
                        color: result.isSafe
                            ? Colors.green.shade700
                            : Colors.amber.shade900,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          result.statusMessage,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: result.isSafe
                                ? Colors.green.shade900
                                : Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Inspect DOM Sandbox Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.code, size: 18),
                    label: Text(l10n.domInspectButton),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                      side: BorderSide(color: theme.primaryColor),
                    ),
                    onPressed: () => _showDomInspectModal(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildShieldBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showDomInspectModal(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.terminal, color: Colors.teal),
                    const SizedBox(width: 8),
                    Text(
                      l10n.domInspectTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailItem(
                  l10n.domDetailPageTitle,
                  result.pageTitle ?? l10n.domDetailNotSpecified,
                ),
                _buildDetailItem(
                  l10n.domDetailMetaDescription,
                  result.metaDescription ?? l10n.domDetailNoneFound,
                ),
                _buildDetailItem(
                  l10n.domDetailHeadingsCount,
                  l10n.domDetailHeadingsValue(result.headings.length),
                ),
                _buildDetailItem(
                  l10n.domDetailLinksFound,
                  l10n.domDetailLinksValue(result.links.length),
                ),
                _buildDetailItem(
                  l10n.domDetailBlockedScripts,
                  l10n.domDetailBlockedScriptsValue(result.blockedScriptsCount),
                ),
                _buildDetailItem(
                  l10n.domDetailBlockedTrackers,
                  l10n.domDetailBlockedTrackersValue(
                    result.blockedTrackersCount,
                  ),
                ),
                _buildDetailItem(
                  l10n.domDetailBlockedIframes,
                  l10n.domDetailBlockedIframesValue(result.blockedIframesCount),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.domSanitizedSnippetHeading,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    result.sanitizedBodyHtml ??
                        '<!-- Sanitized DOM hierarchy pre-rendered without JavaScript execution -->\n<title>${result.pageTitle}</title>',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
