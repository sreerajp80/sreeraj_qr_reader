import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/safety_check_result.dart';
import 'package:sreeraj_qr_reader/models/parsed_payload.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';
import 'package:sreeraj_qr_reader/screens/widgets/wifi_action_card.dart';
import 'package:sreeraj_qr_reader/screens/widgets/contact_action_card.dart';
import 'package:sreeraj_qr_reader/screens/widgets/geo_action_card.dart';
import 'package:sreeraj_qr_reader/screens/widgets/calendar_action_card.dart';
import 'package:sreeraj_qr_reader/screens/widgets/payment_action_card.dart';
import 'package:sreeraj_qr_reader/screens/widgets/totp_action_card.dart';
import 'package:sreeraj_qr_reader/screens/widgets/quishing_risk_bar_widget.dart';
import 'package:sreeraj_qr_reader/screens/widgets/dom_sandbox_preview_card.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isCopied = false;
  bool _isSecretCopied = false;
  bool _showSecretText = true;

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final isUrl = scanProvider.isUrl;
    final isStego = scanProvider.isStegoQr;

    final displayedContent = isStego
        ? (scanProvider.stegoQrData?.decoyText ?? scanProvider.scanResult ?? '')
        : (scanProvider.scanResult ?? 'No result');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            scanProvider.clearScan();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
            tooltip: 'Scan History',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result type indicator
            _buildResultTypeCard(scanProvider),
            const SizedBox(height: 20),

            // QuishingGuard Risk Indicator Card
            if (scanProvider.quishingResult != null) ...[
              QuishingRiskBarWidget(result: scanProvider.quishingResult!),
              const SizedBox(height: 20),
            ],

            // StegoQR Card if detected
            if (isStego) ...[
              _buildStegoCard(scanProvider),
              const SizedBox(height: 20),
            ],

            // Smart Action Card if parsed
            if (scanProvider.parsedPayload != null &&
                scanProvider.parsedPayload is! GenericPayload) ...[
              _buildSmartPayloadCard(scanProvider),
              const SizedBox(height: 20),
            ],

            // Zero-Trust Sandboxed HTML Pre-Render Preview Card if URL
            if (isUrl && scanProvider.domSandboxResult != null) ...[
              DomSandboxPreviewCard(result: scanProvider.domSandboxResult!),
              const SizedBox(height: 20),
            ],

            // Content display (Decoy or plain text)
            _buildContentCard(
              displayedContent,
              title: isStego ? 'Public Decoy Content:' : 'Content:',
            ),
            const SizedBox(height: 20),

            // URL safety indicator (if URL)
            if (isUrl) _buildSafetyCard(scanProvider),
            const SizedBox(height: 20),

            // Action buttons
            _buildActionButtons(context, scanProvider, displayedContent),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartPayloadCard(ScanProvider provider) {
    final payload = provider.parsedPayload;
    if (payload == null || payload is GenericPayload) return const SizedBox();

    if (payload is WifiPayload) {
      return WifiActionCard(payload: payload);
    } else if (payload is ContactPayload) {
      return ContactActionCard(payload: payload);
    } else if (payload is GeoPayload) {
      return GeoActionCard(payload: payload);
    } else if (payload is CalendarPayload) {
      return CalendarActionCard(payload: payload);
    } else if (payload is PaymentPayload) {
      return PaymentActionCard(payload: payload);
    } else if (payload is TotpPayload) {
      return TotpActionCard(payload: payload);
    }
    return const SizedBox();
  }

  Widget _buildResultTypeCard(ScanProvider provider) {
    final isStego = provider.isStegoQr;
    final payload = provider.parsedPayload;

    final typeLabel = isStego
        ? 'STEGO-QR (Encrypted Dual-Layer)'
        : (payload != null && payload is! GenericPayload)
        ? payload.type.name.toUpperCase()
        : provider.scanType?.name.toUpperCase() ?? 'TEXT';

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              isStego
                  ? Icons.lock_person
                  : payload is WifiPayload
                  ? Icons.wifi
                  : payload is ContactPayload
                  ? Icons.contact_page
                  : payload is GeoPayload
                  ? Icons.map
                  : payload is CalendarPayload
                  ? Icons.event
                  : payload is PaymentPayload
                  ? Icons.payment
                  : payload is TotpPayload
                  ? Icons.shield
                  : provider.scanType == BarcodeType.url
                  ? Icons.link
                  : Icons.qr_code,
              size: 32,
              color: isStego
                  ? Colors.deepPurple
                  : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detected Type:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    typeLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isStego ? Colors.deepPurple : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStegoCard(ScanProvider provider) {
    final stegoData = provider.stegoQrData;
    if (stegoData == null) return const SizedBox();

    final isUnlocked = stegoData.isUnlocked;

    return Card(
      elevation: 4,
      color: isUnlocked ? Colors.purple[50] : Colors.deepPurple[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUnlocked ? Colors.purple : Colors.deepPurple,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isUnlocked ? Icons.lock_open : Icons.lock_outline,
                  color: isUnlocked
                      ? Colors.purple[700]
                      : Colors.deepPurple[700],
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isUnlocked
                        ? '🔓 StegoQR Payload Unlocked'
                        : '🔒 StegoQR Encrypted Payload Detected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isUnlocked
                          ? Colors.purple[900]
                          : Colors.deepPurple[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isUnlocked
                  ? 'The hidden AES-256 encrypted payload has been decrypted successfully.'
                  : 'This QR code contains a hidden, encrypted secret layer. Authenticate to view the hidden payload.',
              style: TextStyle(
                fontSize: 13,
                color: isUnlocked ? Colors.purple[900] : Colors.deepPurple[900],
              ),
            ),
            if (stegoData.error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stegoData.error!,
                        style: TextStyle(fontSize: 12, color: Colors.red[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (!isUnlocked) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Biometric Unlock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _promptForPassphraseAndUnlock(
                        context,
                        provider,
                        useBiometrics: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.key),
                      label: const Text('Passphrase'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple[900],
                        side: const BorderSide(color: Colors.deepPurple),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _promptForPassphraseAndUnlock(
                        context,
                        provider,
                        useBiometrics: false,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Display decrypted payload safely
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Secret Payload:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.purple,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _showSecretText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 20,
                            color: Colors.purple,
                          ),
                          onPressed: () {
                            setState(() {
                              _showSecretText = !_showSecretText;
                            });
                          },
                          tooltip: _showSecretText ? 'Hide' : 'Reveal',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _showSecretText
                          ? (stegoData.decryptedPayload ?? '')
                          : '••••••••••••••••••••••••••••',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(
                        _isSecretCopied ? Icons.check : Icons.content_copy,
                      ),
                      label: Text(_isSecretCopied ? 'Copied!' : 'Copy Secret'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple[900],
                        side: BorderSide(color: Colors.purple[300]!),
                      ),
                      onPressed: () => _copySecretToClipboard(
                        stegoData.decryptedPayload ?? '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('Share Secret'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple[900],
                        side: BorderSide(color: Colors.purple[300]!),
                      ),
                      onPressed: () =>
                          _shareContent(stegoData.decryptedPayload ?? ''),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _promptForPassphraseAndUnlock(
    BuildContext context,
    ScanProvider provider, {
    required bool useBiometrics,
  }) async {
    final controller = TextEditingController();
    bool obscure = true;

    final passphrase = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.key, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                useBiometrics ? 'Biometric + Passphrase' : 'Enter Passphrase',
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                useBiometrics
                    ? 'Confirm passphrase to authenticate with biometrics and decrypt payload.'
                    : 'Enter the passphrase used to encrypt the secret payload.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                obscureText: obscure,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Passphrase',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
                ),
                onSubmitted: (val) => Navigator.pop(context, val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Unlock'),
            ),
          ],
        ),
      ),
    );

    if (passphrase != null && passphrase.isNotEmpty && mounted) {
      if (useBiometrics) {
        await provider.unlockStegoWithBiometrics(passphrase: passphrase);
      } else {
        provider.unlockStegoWithPassphrase(passphrase);
      }
    }
  }

  Widget _buildRecheckButton(ScanProvider p) {
    if (!p.isUrl || p.isLoading || !p.hasNetworkError) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Re-check'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () =>
              p.checkUrlSafety(p.stegoQrData?.decoyText ?? p.scanResult!),
        ),
      ),
    );
  }

  Widget _buildContentCard(String content, {String title = 'Content:'}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHighest
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? theme.colorScheme.outline.withValues(alpha: 0.4)
                      : Colors.grey[300]!,
                ),
              ),
              child: SelectableText(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? theme.colorScheme.onSurface : Colors.black87,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyCard(ScanProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasIssues = provider.safetyChecks.any((check) => !check.passed);
    final failedChecks = provider.safetyChecks
        .where((check) => !check.passed)
        .toList();

    return Card(
      elevation: 4,
      color: isDark
          ? (provider.isLoading
                ? const Color(0xFF0D253F)
                : hasIssues
                ? const Color(0xFF3F0D0D)
                : const Color(0xFF3F2B0D))
          : (provider.isLoading
                ? Colors.blue[50]
                : hasIssues
                ? Colors.red[50]
                : Colors.orange[50]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                if (provider.isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    hasIssues ? Icons.warning : Icons.info_outline,
                    color: hasIssues ? Colors.red : Colors.orange,
                    size: 32,
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.isLoading
                            ? 'Security Check In Progress'
                            : 'URL Security Analysis',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark
                              ? (provider.isLoading
                                    ? Colors.blue[200]
                                    : hasIssues
                                    ? Colors.red[200]
                                    : Colors.orange[200])
                              : (provider.isLoading
                                    ? Colors.blue[700]
                                    : hasIssues
                                    ? Colors.red[700]
                                    : Colors.orange[700]),
                        ),
                      ),
                      if (!provider.isLoading) const SizedBox(height: 4),
                      if (!provider.isLoading)
                        Text(
                          hasIssues
                              ? '${failedChecks.length} security ${failedChecks.length == 1 ? 'issue' : 'issues'} detected'
                              : 'No issues detected',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? (hasIssues
                                      ? Colors.red[300]
                                      : Colors.orange[300])
                                : (hasIssues
                                      ? Colors.red[600]
                                      : Colors.orange[600]),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // General Warning
            if (!provider.isLoading) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3F2B0D) : Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.orange[700]! : Colors.orange[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: isDark ? Colors.orange[300] : Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Only open this URL if you trust the source',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.orange[200]
                              : Colors.orange[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Privacy / probing-mode notice
            if (!provider.isLoading) ...[
              const SizedBox(height: 12),
              _buildProbingModeBanner(provider.activeProbingEnabled),
            ],

            // Additional warning for issues
            if (!provider.isLoading && hasIssues) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3F0D0D) : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.red[700]! : Colors.red[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: isDark ? Colors.red[300] : Colors.red[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Security issues detected. Do not enter personal information or download files from this URL',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.red[200] : Colors.red[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Security checks results
            if (!provider.isLoading && provider.safetyChecks.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Security Analysis Results:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey[200] : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              ...provider.safetyChecks.map(
                (check) => _buildDetailedCheckItem(check),
              ),
            ],

            // Loading indicator message
            if (provider.isLoading) ...[
              const SizedBox(height: 12),
              Text(
                'Analyzing URL security...',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.blue[300] : Colors.blue[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProbingModeBanner(bool activeProbing) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = activeProbing ? Colors.amber : Colors.blue;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? (activeProbing
                  ? const Color(0xFF3F2E0D)
                  : const Color(0xFF0D253F))
            : color[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? (activeProbing ? Colors.amber[700]! : Colors.blue[700]!)
              : color[200]!,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            activeProbing ? Icons.public : Icons.lock_outline,
            color: isDark
                ? (activeProbing ? Colors.amber[300] : Colors.blue[300])
                : color[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              activeProbing
                  ? 'Active online checks are ON: SSL, redirect and shortener '
                        'checks contacted this site directly, exposing your IP '
                        'address to it. Turn off "Active online checks" in '
                        'Settings to check links privately.'
                  : 'Private mode: this link was analysed using local rules and '
                        'Google Safe Browsing only — the site itself was never '
                        'contacted, so your IP and device were not exposed. Enable '
                        '"Active online checks" in Settings for live SSL/redirect '
                        'verification.',
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? (activeProbing ? Colors.amber[100] : Colors.blue[100])
                    : color[900],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCheckItem(SafetyCheckResult check) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? (check.passed ? const Color(0xFF0D3F1B) : const Color(0xFF3F0D0D))
            : (check.passed ? Colors.green[50] : Colors.red[50]),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? (check.passed ? Colors.green[800]! : Colors.red[800]!)
              : (check.passed ? Colors.green[200]! : Colors.red[200]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            check.passed ? Icons.check_circle : Icons.error,
            size: 20,
            color: isDark
                ? (check.passed ? Colors.green[300] : Colors.red[300])
                : (check.passed ? Colors.green[700] : Colors.red[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  check.checkName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? (check.passed ? Colors.green[200] : Colors.red[200])
                        : (check.passed ? Colors.green[900] : Colors.red[900]),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  check.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? (check.passed ? Colors.green[300] : Colors.red[300])
                        : (check.passed ? Colors.green[800] : Colors.red[800]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ScanProvider provider,
    String displayedContent,
  ) {
    return Column(
      children: [
        if (provider.isUrl) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open in Browser'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: provider.isSafeUrl
                    ? Theme.of(context).primaryColor
                    : Colors.orange,
              ),
              onPressed: provider.isLoading
                  ? null
                  : () {
                      _showWarningDialog(context, displayedContent);
                    },
            ),
          ),
          _buildRecheckButton(provider),
          const SizedBox(height: 12),
        ],

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(_isCopied ? Icons.check : Icons.content_copy),
                label: Text(
                  _isCopied
                      ? 'Copied!'
                      : (provider.isStegoQr ? 'Copy Decoy Text' : 'Copy Text'),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _copyToClipboard(displayedContent),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share),
                label: Text(
                  provider.isStegoQr ? 'Share Decoy Text' : 'Share Text',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _shareContent(displayedContent),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              provider.clearScan();
              Navigator.pop(context);
            },
            child: const Text('Scan Another Code'),
          ),
        ),
      ],
    );
  }

  Future<void> _showWarningDialog(BuildContext context, String url) async {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final hasIssues = scanProvider.safetyChecks.any((check) => !check.passed);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              hasIssues ? Icons.warning : Icons.info_outline,
              color: hasIssues ? Colors.red : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(hasIssues ? 'Security Warning' : 'Caution'),
          ],
        ),
        content: Text(
          hasIssues
              ? 'This URL has security issues. Opening it may put your device or data at risk.\n\nAre you sure you want to proceed?'
              : 'Always verify the source before opening URLs from QR codes.\n\nDo you want to open this URL?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: hasIssues ? Colors.red : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Anyway'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      _openUrl(url);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not launch URL')));
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;

    setState(() {
      _isCopied = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  Future<void> _copySecretToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;

    setState(() {
      _isSecretCopied = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Secret copied to clipboard')));

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSecretCopied = false;
        });
      }
    });
  }

  Future<void> _shareContent(String content) async {
    await SharePlus.instance.share(ShareParams(text: content));
  }
}
