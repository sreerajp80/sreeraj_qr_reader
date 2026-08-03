import 'package:flutter/material.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/services/payload_action_service.dart';

class GeoActionCard extends StatelessWidget {
  final GeoPayload payload;

  const GeoActionCard({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final geo = payload;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red[300]!, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Preview Snippet / Header Banner
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3F0D0D) : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.red[800]! : Colors.red[200]!,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Stylized Grid pattern / Map Pin preview banner
                  Icon(
                    Icons.map_outlined,
                    size: 80,
                    color: isDark ? Colors.red[900] : Colors.red[100],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 36,
                        color: isDark ? Colors.red[300] : Colors.red[700],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black87
                              : Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          geo.label.isNotEmpty
                              ? geo.label
                              : '${geo.latitude.toStringAsFixed(4)}, ${geo.longitude.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.red[200] : Colors.red[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Location Info
            Row(
              children: [
                Icon(
                  Icons.explore_outlined,
                  color: isDark ? Colors.red[300] : Colors.red[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lat: ${geo.latitude}, Lng: ${geo.longitude}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),

            if (geo.query.isNotEmpty && geo.query != geo.label) ...[
              const SizedBox(height: 6),
              Text(
                'Query: ${geo.query}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? theme.colorScheme.onSurfaceVariant
                      : Colors.grey[700],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.navigation),
                label: const Text('Navigate in Google Maps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final launched = await PayloadActionService.openGoogleMaps(geo);
                  if (!launched && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not launch Google Maps app'),
                      ),
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
