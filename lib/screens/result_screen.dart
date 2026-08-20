import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/encrypted_payload_data.dart';
import 'package:sreeraj_qr_reader/models/safety_check_result.dart';
import 'package:sreeraj_qr_reader/l10n/app_message_text.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final scanProvider = Provider.of<ScanProvider>(context);
    final isUrl = scanProvider.isUrl;
    final isStego = scanProvider.isStegoQr;

    final displayedContent = isStego
        ? (scanProvider.stegoQrData?.decoyText ?? scanProvider.scanResult ?? '')
        : (scanProvider.scanResult ?? l10n.resultNoResult);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultScreenTitle),
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
            tooltip: l10n.historyScreenTitle,
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
              title: isStego
                  ? l10n.resultDecoyContentLabel
                  : l10n.resultContentLabel,
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
    final l10n = AppLocalizations.of(context);
    final isStego = provider.isStegoQr;
    final payload = provider.parsedPayload;

    final typeLabel = isStego
        ? l10n.resultTypeStego
        : (payload != null && payload is! GenericPayload)
        ? payload.type.name.toUpperCase()
        : provider.scanType?.name.toUpperCase() ?? l10n.resultTypeTextFallback;

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
                    l10n.resultDetectedType,
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
    final l10n = AppLocalizations.of(context);
    final encryptedData = provider.encryptedPayloadData;
    final stegoData = provider.stegoQrData;
    if (encryptedData == null && stegoData == null) return const SizedBox();

    final isUnlocked =
        encryptedData?.isUnlocked ?? stegoData?.isUnlocked ?? false;
    final decryptedPayload =
        encryptedData?.decryptedPayload ?? stegoData?.decryptedPayload ?? '';
    final error = encryptedData?.error ?? stegoData?.error;

    String cardTitle;
    String cardSubtitle;

    if (encryptedData?.containerType == EncryptedContainerType.airQr) {
      cardTitle = isUnlocked
          ? '🔓 AirQR Payload Unlocked'
          : '🔒 ${l10n.airQrDetectedTitle}';
      cardSubtitle = isUnlocked
          ? l10n.stegoUnlockedMessage
          : l10n.airQrDetectedSubtitle;
    } else if (encryptedData?.containerType ==
        EncryptedContainerType.jsonEnvelope) {
      cardTitle = isUnlocked
          ? '🔓 JSON Payload Unlocked'
          : '🔒 ${l10n.jsonEnvelopeDetectedTitle}';
      cardSubtitle = isUnlocked
          ? l10n.stegoUnlockedMessage
          : l10n.jsonEnvelopeDetectedSubtitle;
    } else {
      cardTitle = isUnlocked
          ? '🔓 StegoQR Payload Unlocked'
          : '🔒 StegoQR Encrypted Payload Detected';
      cardSubtitle = isUnlocked
          ? l10n.stegoUnlockedMessage
          : l10n.stegoLockedMessage;
    }

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
                    cardTitle,
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
              cardSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: isUnlocked ? Colors.purple[900] : Colors.deepPurple[900],
              ),
            ),
            if (encryptedData?.fileName != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.description,
                      size: 14,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${encryptedData!.fileName} (${encryptedData.mimeType ?? 'text/plain'})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (error != null) ...[
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
                        appMessageText(l10n, error),
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
                      label: Text(l10n.stegoBiometricUnlock),
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
                      label: Text(
                        encryptedData?.containerType ==
                                EncryptedContainerType.airQr
                            ? l10n.airQrCodeLabel
                            : l10n.stegoPassphrase,
                      ),
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
                        Text(
                          l10n.stegoSecretPayload,
                          style: const TextStyle(
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
                          tooltip: _showSecretText
                              ? l10n.hideAction
                              : l10n.revealAction,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _showSecretText
                          ? decryptedPayload
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
                      label: Text(
                        _isSecretCopied
                            ? l10n.copiedLabel
                            : l10n.stegoCopySecret,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple[900],
                        side: BorderSide(color: Colors.purple[300]!),
                      ),
                      onPressed: () => _copySecretToClipboard(decryptedPayload),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: Text(l10n.stegoShareSecret),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple[900],
                        side: BorderSide(color: Colors.purple[300]!),
                      ),
                      onPressed: () => _shareContent(decryptedPayload),
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
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    bool obscure = true;
    final isAirQr =
        provider.encryptedPayloadData?.containerType ==
        EncryptedContainerType.airQr;

    final passphrase = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.key, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                useBiometrics
                    ? l10n.stegoDialogTitleBiometric
                    : (isAirQr
                          ? l10n.airQrCodeLabel
                          : l10n.stegoDialogTitlePassphrase),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                useBiometrics
                    ? l10n.stegoDialogMessageBiometric
                    : (isAirQr
                          ? l10n.airQrDetectedSubtitle
                          : l10n.stegoDialogMessagePassphrase),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                obscureText: obscure,
                autofocus: true,
                textCapitalization: isAirQr
                    ? TextCapitalization.characters
                    : TextCapitalization.none,
                decoration: InputDecoration(
                  labelText: isAirQr
                      ? l10n.airQrCodeLabel
                      : l10n.stegoPassphrase,
                  hintText: isAirQr ? l10n.airQrCodeHint : null,
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
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(l10n.stegoUnlockButton),
            ),
          ],
        ),
      ),
    );

    if (passphrase != null && passphrase.isNotEmpty && mounted) {
      if (useBiometrics) {
        await provider.unlockStegoWithBiometrics(
          passphrase: passphrase,
          biometricReason: l10n.stegoBiometricReason,
        );
      } else {
        provider.unlockStegoWithPassphrase(passphrase);
      }
    }
  }

  Widget _buildRecheckButton(ScanProvider p) {
    final l10n = AppLocalizations.of(context);
    if (!p.isUrl || p.isLoading || !p.hasNetworkError) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.refresh),
          label: Text(l10n.resultRecheckButton),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () =>
              p.checkUrlSafety(p.stegoQrData?.decoyText ?? p.scanResult!),
        ),
      ),
    );
  }

  Widget _buildContentCard(String content, {String? title}) {
    final l10n = AppLocalizations.of(context);
    final cardTitle = title ?? l10n.resultContentLabel;
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
              cardTitle,
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
    final l10n = AppLocalizations.of(context);
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
                            ? l10n.safetyCheckInProgress
                            : l10n.safetyAnalysisTitle,
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
                              ? l10n.safetyIssuesDetected(failedChecks.length)
                              : l10n.safetyNoIssues,
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
                        l10n.safetyTrustSourceHint,
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
                        l10n.safetyIssuesWarning,
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
                l10n.safetyResultsHeading,
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
                l10n.safetyAnalyzing,
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
    final l10n = AppLocalizations.of(context);
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
                  ? l10n.probingBannerActive
                  : l10n.probingBannerPrivate,
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
    final l10n = AppLocalizations.of(context);
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
                  appMessageText(l10n, check.checkName),
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
                  appMessageText(l10n, check.message),
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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        if (provider.isUrl) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.open_in_browser),
              label: Text(l10n.resultOpenInBrowser),
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
                      ? l10n.copiedLabel
                      : (provider.isStegoQr
                            ? l10n.resultCopyDecoyText
                            : l10n.resultCopyText),
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
                  provider.isStegoQr
                      ? l10n.resultShareDecoyText
                      : l10n.resultShareText,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _shareContent(displayedContent),
              ),
            ),
          ],
        ),

        if (!provider.isStegoQr ||
            !(provider.encryptedPayloadData?.isUnlocked ??
                provider.stegoQrData?.isUnlocked ??
                false)) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(
                Icons.vpn_key_outlined,
                color: Colors.deepPurple,
              ),
              label: Text(
                l10n.decryptPayloadAction,
                style: const TextStyle(color: Colors.deepPurple),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.deepPurple),
              ),
              onPressed: () => _showManualDecryptionDialog(context, provider),
            ),
          ),
        ],

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
            child: Text(l10n.resultScanAnother),
          ),
        ),
      ],
    );
  }

  Future<void> _showManualDecryptionDialog(
    BuildContext context,
    ScanProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context);
    final keyController = TextEditingController();
    final saltController = TextEditingController();
    final ivController = TextEditingController();
    String selectedMode = 'auto';
    bool showAdvanced = false;
    String? decryptedResult;
    String? errorText;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lock_open, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        l10n.decryptPayloadTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.decryptPayloadDescription,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mode selector
                  DropdownButtonFormField<String>(
                    initialValue: selectedMode,
                    decoration: InputDecoration(
                      labelText: l10n.cipherModeLabel,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'auto',
                        child: Text(l10n.cipherModeAuto),
                      ),
                      DropdownMenuItem(
                        value: 'gcm',
                        child: Text(l10n.cipherModeAesGcm),
                      ),
                      DropdownMenuItem(
                        value: 'cbc',
                        child: Text(l10n.cipherModeAesCbc),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setSheetState(() => selectedMode = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Passphrase field
                  TextField(
                    controller: keyController,
                    decoration: InputDecoration(
                      labelText: l10n.stegoPassphrase,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Advanced toggle
                  TextButton.icon(
                    icon: Icon(
                      showAdvanced
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                    label: Text(
                      showAdvanced
                          ? 'Hide Advanced'
                          : 'Show Advanced (Salt / IV)',
                    ),
                    onPressed: () {
                      setSheetState(() => showAdvanced = !showAdvanced);
                    },
                  ),

                  if (showAdvanced) ...[
                    TextField(
                      controller: saltController,
                      decoration: const InputDecoration(
                        labelText: 'Salt (Base64 / Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: ivController,
                      decoration: const InputDecoration(
                        labelText: 'IV / Nonce (Base64 / Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],

                  if (decryptedResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.decryptedContentLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            decryptedResult!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        final key = keyController.text.trim();
                        if (key.isEmpty) return;

                        final salt = saltController.text.trim().isNotEmpty
                            ? saltController.text.trim()
                            : null;
                        final iv = ivController.text.trim().isNotEmpty
                            ? ivController.text.trim()
                            : null;

                        final res = provider.decryptManualCipher(
                          passphrase: key,
                          mode: selectedMode == 'auto' ? null : selectedMode,
                          salt: salt,
                          iv: iv,
                        );

                        setSheetState(() {
                          if (res != null) {
                            decryptedResult = res;
                            errorText = null;
                          } else {
                            decryptedResult = null;
                            errorText = l10n.manualDecryptionFailed;
                          }
                        });
                      },
                      child: Text(l10n.stegoUnlockButton),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showWarningDialog(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context);
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
            Text(hasIssues ? l10n.warningDialogTitle : l10n.cautionDialogTitle),
          ],
        ),
        content: Text(
          hasIssues ? l10n.warningDialogMessage : l10n.cautionDialogMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: hasIssues ? Colors.red : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.openAnywayButton),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).resultLaunchFailed),
        ),
      );
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;

    setState(() {
      _isCopied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).copiedToClipboard)),
    );

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).stegoSecretCopied)),
    );

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
