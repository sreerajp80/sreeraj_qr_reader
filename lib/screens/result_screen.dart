import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sreeraj_qr_reader/models/safety_check_result.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isCopied = false;

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final result = scanProvider.scanResult;
    final isUrl = scanProvider.isUrl;

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result type indicator
            _buildResultTypeCard(scanProvider),
            const SizedBox(height: 20),

            // Content display
            _buildContentCard(result ?? 'No result'),
            const SizedBox(height: 20),

            // URL safety indicator (if URL)
            if (isUrl) _buildSafetyCard(scanProvider),
            const SizedBox(height: 20),

            // Action buttons
            _buildActionButtons(context, scanProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTypeCard(ScanProvider provider) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              provider.scanType == BarcodeType.url
                  ? Icons.link
                  : provider.scanType == BarcodeType.wifi
                  ? Icons.wifi
                  : provider.scanType == BarcodeType.email
                  ? Icons.email
                  : Icons.qr_code,
              size: 32,
              color: Theme.of(context).primaryColor,
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
                    provider.scanType?.name.toUpperCase() ?? 'TEXT',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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
          onPressed: () => p.checkUrlSafety(p.scanResult!),
        ),
      ),
    );
  }

  Widget _buildContentCard(String content) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyCard(ScanProvider provider) {
    final hasIssues = provider.safetyChecks.any((check) => !check.passed);
    final failedChecks = provider.safetyChecks
        .where((check) => !check.passed)
        .toList();

    return Card(
      elevation: 4,
      color: provider.isLoading
          ? Colors.blue[50]
          : hasIssues
          ? Colors.red[50]
          : Colors.orange[50],
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
                          color: provider.isLoading
                              ? Colors.blue[700]
                              : hasIssues
                              ? Colors.red[700]
                              : Colors.orange[700],
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
                            color: hasIssues
                                ? Colors.red[600]
                                : Colors.orange[600],
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
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Only open this URL if you trust the source',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange[700],
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
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Security issues detected. Do not enter personal information or download files from this URL',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red[700],
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
                  color: Colors.grey[800],
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
                style: TextStyle(fontSize: 13, color: Colors.blue[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProbingModeBanner(bool activeProbing) {
    final color = activeProbing ? Colors.amber : Colors.blue;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            activeProbing ? Icons.public : Icons.lock_outline,
            color: color[700],
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
                color: color[900],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCheckItem(SafetyCheckResult check) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: check.passed ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: check.passed ? Colors.green[200]! : Colors.red[200]!,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            check.passed ? Icons.check_circle : Icons.error,
            size: 20,
            color: check.passed ? Colors.green[700] : Colors.red[700],
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
                    color: check.passed ? Colors.green[900] : Colors.red[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  check.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: check.passed ? Colors.green[800] : Colors.red[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ScanProvider provider) {
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
                      _showWarningDialog(context, provider.scanResult!);
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
                label: Text(_isCopied ? 'Copied!' : 'Copy'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _copyToClipboard(provider.scanResult!),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _shareContent(provider.scanResult!),
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

  Future<void> _shareContent(String content) async {
    await SharePlus.instance.share(ShareParams(text: content));
  }
}
