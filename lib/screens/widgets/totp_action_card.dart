import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/services/totp_service.dart';
import 'package:sreeraj_qr_reader/services/payload_action_service.dart';

class TotpActionCard extends StatefulWidget {
  final TotpPayload payload;

  const TotpActionCard({super.key, required this.payload});

  @override
  State<TotpActionCard> createState() => _TotpActionCardState();
}

class _TotpActionCardState extends State<TotpActionCard> {
  final TotpService _totpService = TotpService();
  Timer? _timer;
  String _currentTotp = '';
  int _remainingSeconds = 30;
  bool _showSecret = false;
  bool _isCopiedSecret = false;
  bool _isCopiedToken = false;

  @override
  void initState() {
    super.initState();
    _updateTotp();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTotp());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTotp() {
    if (!mounted) return;
    final totp = widget.payload;
    final newToken = _totpService.generateTotp(
      secret: totp.secret,
      period: totp.period,
      digits: totp.digits,
      algorithm: totp.algorithm,
    );
    final remaining = _totpService.getRemainingSeconds(period: totp.period);

    setState(() {
      _currentTotp = newToken;
      _remainingSeconds = remaining;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totp = widget.payload;
    final l10n = AppLocalizations.of(context);
    final progress = _remainingSeconds / totp.period;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.deepPurple[300]!, width: 1.5),
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
                    color: Colors.deepPurple[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    color: Colors.deepPurple[700],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totp.issuer.isNotEmpty
                            ? totp.issuer
                            : l10n.totpDefaultIssuer,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      Text(
                        totp.accountName.isEmpty
                            ? l10n.totpDefaultAccount
                            : totp.accountName,
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
              ],
            ),

            const SizedBox(height: 16),

            // Live 30-second TOTP Token Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepPurple[200]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.totpLivePasscode(totp.period),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _formattedToken(_currentTotp),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isCopiedToken ? Icons.check : Icons.copy,
                                size: 20,
                              ),
                              onPressed: () => _copyToken(_currentTotp),
                              tooltip: l10n.totpCopyToken,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Live Timer Ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 4,
                          backgroundColor: Colors.deepPurple[100],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _remainingSeconds <= 5
                                ? Colors.red
                                : Colors.deepPurple[700]!,
                          ),
                        ),
                      ),
                      Text(
                        l10n.totpSecondsLeft(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _remainingSeconds <= 5
                              ? Colors.red
                              : Colors.deepPurple[900],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Secret Key display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.3)
                      : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    l10n.totpSecretLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: SelectableText(
                      _showSecret ? totp.secret : '••••••••••••••••',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _showSecret ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _showSecret = !_showSecret;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isCopiedSecret ? Icons.check : Icons.copy,
                      size: 18,
                    ),
                    onPressed: () => _copySecret(totp.secret),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Import into Authenticator Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download_for_offline),
                label: Text(l10n.totpImportButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final launched =
                      await PayloadActionService.importToAuthenticator(totp);
                  if (!launched && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.totpLaunchFailed)),
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

  String _formattedToken(String token) {
    if (token.length == 6) {
      return '${token.substring(0, 3)} ${token.substring(3)}';
    }
    return token;
  }

  Future<void> _copyToken(String token) async {
    await Clipboard.setData(ClipboardData(text: token));
    if (!mounted) return;

    setState(() {
      _isCopiedToken = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).totpTokenCopied)),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopiedToken = false;
        });
      }
    });
  }

  Future<void> _copySecret(String secret) async {
    await Clipboard.setData(ClipboardData(text: secret));
    if (!mounted) return;

    setState(() {
      _isCopiedSecret = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).totpSecretCopied)),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopiedSecret = false;
        });
      }
    });
  }
}
