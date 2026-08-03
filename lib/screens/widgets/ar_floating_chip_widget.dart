import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/models/ar_code_target.dart';
import 'package:sreeraj_qr_reader/providers/ar_codevision_provider.dart';

/// Interactive Material 3 floating chip anchored in AR camera space.
class ArFloatingChipWidget extends StatelessWidget {
  final ArCodeTarget target;
  final Offset position;
  final ArHudMode hudMode;
  final VoidCallback onTap;
  final ValueChanged<bool?> onSelectionChanged;

  const ArFloatingChipWidget({
    super.key,
    required this.target,
    required this.position,
    required this.hudMode,
    required this.onTap,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      left: (position.dx - 90).clamp(
        10,
        MediaQuery.of(context).size.width - 190,
      ),
      top: (position.dy - 40).clamp(
        80,
        MediaQuery.of(context).size.height - 180,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _getChipBackgroundColor(theme),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getChipBorderColor(theme), width: 1.8),
              boxShadow: [
                BoxShadow(
                  color: _getShadowColor(),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hudMode == ArHudMode.warehouse) ...[
                  // Checkbox for batch multi-select in Warehouse mode
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: target.isSelected,
                      onChanged: onSelectionChanged,
                      activeColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      target.formatName,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    target.priceTag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ] else ...[
                  // Safety HUD Mode Badge
                  _buildSafetyBadge(theme),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      target.isUrl
                          ? _truncateUrl(target.rawValue)
                          : target.formatName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                const Icon(Icons.touch_app, size: 14, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyBadge(ThemeData theme) {
    switch (target.safetyStatus) {
      case TargetSafetyStatus.safe:
        return const CircleAvatar(
          radius: 10,
          backgroundColor: Colors.green,
          child: Icon(Icons.shield, size: 12, color: Colors.white),
        );
      case TargetSafetyStatus.warning:
        return const CircleAvatar(
          radius: 10,
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.warning, size: 12, color: Colors.white),
        );
      case TargetSafetyStatus.unknown:
        return const CircleAvatar(
          radius: 10,
          backgroundColor: Colors.amber,
          child: Icon(Icons.help_outline, size: 12, color: Colors.black87),
        );
    }
  }

  Color _getChipBackgroundColor(ThemeData theme) {
    if (hudMode == ArHudMode.safety) {
      switch (target.safetyStatus) {
        case TargetSafetyStatus.safe:
          return Colors.black.withValues(alpha: 0.85);
        case TargetSafetyStatus.warning:
          return Colors.red.shade900.withValues(alpha: 0.9);
        case TargetSafetyStatus.unknown:
          return Colors.black.withValues(alpha: 0.85);
      }
    }
    return target.isSelected
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.95)
        : Colors.black.withValues(alpha: 0.85);
  }

  Color _getChipBorderColor(ThemeData theme) {
    if (hudMode == ArHudMode.safety) {
      switch (target.safetyStatus) {
        case TargetSafetyStatus.safe:
          return Colors.greenAccent;
        case TargetSafetyStatus.warning:
          return Colors.redAccent;
        case TargetSafetyStatus.unknown:
          return Colors.amberAccent;
      }
    }
    return target.isSelected ? theme.colorScheme.primary : Colors.white38;
  }

  Color _getShadowColor() {
    if (hudMode == ArHudMode.safety) {
      return target.safetyStatus == TargetSafetyStatus.warning
          ? Colors.red.withValues(alpha: 0.5)
          : Colors.green.withValues(alpha: 0.4);
    }
    return Colors.black54;
  }

  String _truncateUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty ? uri.host : url;
    } catch (_) {
      return url;
    }
  }
}
