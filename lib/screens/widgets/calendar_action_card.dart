import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/services/payload_action_service.dart';

class CalendarActionCard extends StatelessWidget {
  final CalendarPayload payload;

  const CalendarActionCard({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final event = payload;
    final l10n = AppLocalizations.of(context);

    String formatDate(DateTime? dt) {
      if (dt == null) return l10n.calendarNoDate;
      final year = dt.year;
      final month = dt.month.toString().padLeft(2, '0');
      final day = dt.day.toString().padLeft(2, '0');
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');

      if (dt.hour == 0 && dt.minute == 0) {
        return '$year-$month-$day';
      }
      return '$year-$month-$day $hour:$min';
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange[300]!, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF3F2B0D) : Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event,
                    color: isDark ? Colors.orange[300] : Colors.orange[800],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.calendarCardTitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.orange[300]
                              : Colors.orange[900],
                        ),
                      ),
                      Text(
                        event.summary.isEmpty
                            ? l10n.calendarCardTitle
                            : event.summary,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Time range
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3F2B0D) : Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.orange[800]! : Colors.orange[200]!,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: isDark ? Colors.orange[300] : Colors.orange[900],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.calendarStart(formatDate(event.dtStart)),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? theme.colorScheme.onSurface
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  if (event.dtEnd != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 18,
                          color: isDark
                              ? Colors.orange[300]
                              : Colors.orange[900],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.calendarEnd(formatDate(event.dtEnd)),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? theme.colorScheme.onSurface
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Location
            if (event.location.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: isDark ? Colors.orange[300] : Colors.orange[900],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Description
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? theme.colorScheme.onSurfaceVariant
                      : Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(l10n.calendarAddButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final launched = await PayloadActionService.addToCalendar(
                    event,
                  );
                  if (!launched && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.calendarLaunchFailed)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
