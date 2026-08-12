import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/services/payload_action_service.dart';

class WifiActionCard extends StatefulWidget {
  final WifiPayload payload;

  const WifiActionCard({super.key, required this.payload});

  @override
  State<WifiActionCard> createState() => _WifiActionCardState();
}

class _WifiActionCardState extends State<WifiActionCard> {
  bool _showPassword = false;
  bool _isCopied = false;

  @override
  Widget build(BuildContext context) {
    final wifi = widget.payload;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue[300]!, width: 1.5),
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
                    color: isDark ? const Color(0xFF0D253F) : Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi,
                    color: isDark ? Colors.blue[300] : Colors.blue[700],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wi-Fi Network',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.blue[300] : Colors.blue[800],
                        ),
                      ),
                      Text(
                        wifi.ssid,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.blue[900] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    wifi.securityType.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.blue[100] : Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Password Field
            if (wifi.password.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surfaceContainerHighest
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? theme.colorScheme.outline.withValues(alpha: 0.3)
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: isDark
                          ? theme.colorScheme.onSurfaceVariant
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SelectableText(
                        _showPassword ? wifi.password : '••••••••••••',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? theme.colorScheme.onSurface
                              : Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      tooltip: _showPassword
                          ? 'Hide Password'
                          : 'Show Password',
                    ),
                    IconButton(
                      icon: Icon(
                        _isCopied ? Icons.check : Icons.copy,
                        size: 20,
                      ),
                      onPressed: () => _copyPassword(wifi.password),
                      tooltip: 'Copy Password',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.wifi_find),
                label: const Text('Connect to Wi-Fi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (wifi.password.isNotEmpty && !_isCopied) {
                    await _copyPassword(wifi.password);
                  }
                  final launched =
                      await PayloadActionService.openWifiSettings();
                  if (!launched && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password copied. Open Wi-Fi Settings on your device to connect.',
                        ),
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

  Future<void> _copyPassword(String password) async {
    await Clipboard.setData(ClipboardData(text: password));
    if (!mounted) return;

    setState(() {
      _isCopied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password copied to clipboard')),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }
}
