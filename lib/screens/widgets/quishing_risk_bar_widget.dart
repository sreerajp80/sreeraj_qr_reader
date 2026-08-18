import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/l10n/app_message_text.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/models/quishing_analysis_result.dart';

/// Widget displaying the QuishingGuard Physical Print & Sticker Tamper Alert Index.
class QuishingRiskBarWidget extends StatefulWidget {
  final QuishingAnalysisResult result;

  const QuishingRiskBarWidget({super.key, required this.result});

  @override
  State<QuishingRiskBarWidget> createState() => _QuishingRiskBarWidgetState();
}

class _QuishingRiskBarWidgetState extends State<QuishingRiskBarWidget> {
  bool _isExpanded = false;

  Color get _statusColor {
    switch (widget.result.riskLevel) {
      case QuishingRiskLevel.authentic:
        return Colors.green;
      case QuishingRiskLevel.wearAndTear:
        return Colors.amber.shade800;
      case QuishingRiskLevel.highWarning:
        return Colors.red.shade700;
    }
  }

  IconData get _statusIcon {
    switch (widget.result.riskLevel) {
      case QuishingRiskLevel.authentic:
        return Icons.verified;
      case QuishingRiskLevel.wearAndTear:
        return Icons.warning_amber_rounded;
      case QuishingRiskLevel.highWarning:
        return Icons.security_update_warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = widget.result;
    final l10n = AppLocalizations.of(context);
    final color = _statusColor;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title
            Row(
              children: [
                Icon(Icons.center_focus_strong, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  l10n.quishingGuardTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    l10n.quishingTamperBadge,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Banner with Risk Level
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(_statusIcon, color: color, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appMessageText(l10n, res.statusLabel),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appMessageText(l10n, res.summaryMessage),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Quishing Alert Index Risk Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.quishingRiskScoreLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  l10n.percentValue(
                    (res.overallRiskScore * 100).toStringAsFixed(0),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: res.overallRiskScore.clamp(0.02, 1.0),
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 12),

            // Toggle Expand Forensic Signal Breakdown
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isExpanded
                          ? l10n.quishingHideSignals
                          : l10n.quishingViewSignals,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            if (_isExpanded) ...[
              const Divider(height: 16),

              // Metric Sub-scores
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: l10n.quishingMetricEdgeLabel,
                      score: res.edgeDiscontinuityScore,
                      description: l10n.quishingMetricEdgeDescription,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricTile(
                      label: l10n.quishingMetricGrainLabel,
                      score: res.textureGrainScore,
                      description: l10n.quishingMetricGrainDescription,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                l10n.quishingSignalsHeading,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              ...res.detectedSignals.map(
                (signal) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          appMessageText(l10n, signal),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required double score,
    required String description,
  }) {
    final subColor = score >= 0.70
        ? Colors.red
        : score >= 0.35
        ? Colors.amber.shade800
        : Colors.green;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                ).percentValue((score * 100).toStringAsFixed(0)),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: subColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
