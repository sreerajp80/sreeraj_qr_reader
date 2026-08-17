import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sreeraj_qr_reader/core/config/app_config.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/core/config/config_service.dart';

class AboutScreen extends StatefulWidget {
  final ConfigService? configService;

  const AboutScreen({super.key, this.configService});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final ConfigService _service;
  AppConfig _config = AppConfig.fallback;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = widget.configService ?? ConfigService();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final loaded = await _service.loadAndVerify();
    if (mounted) {
      setState(() {
        _config = loaded;
        _isLoading = false;
      });
    }
  }

  Future<void> _openMail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  IconData _getIconForKey(String key) {
    final lowerKey = key.trim().toLowerCase();
    if (lowerKey.contains('author') || lowerKey.contains('developer')) {
      return Icons.person;
    }
    if (lowerKey.contains('email')) {
      return Icons.email;
    }
    if (lowerKey.contains('build') || lowerKey.contains('date')) {
      return Icons.calendar_today;
    }
    if (lowerKey.contains('ai')) {
      return Icons.psychology;
    }
    if (lowerKey.contains('ide')) {
      return Icons.code;
    }
    if (lowerKey.contains('license')) {
      return Icons.gavel;
    }
    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // App Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App Name
                  Text(
                    _config.appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _config.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Version Info
                  Text(
                    l10n.aboutVersion(_config.version, _config.build),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 32),

                  // Dynamic Info Cards from details map
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        for (final entry in _config.details.entries)
                          if (entry.key.trim().isNotEmpty &&
                              entry.value.trim().isNotEmpty) ...[
                            _buildInfoCard(
                              context,
                              icon: _getIconForKey(entry.key),
                              title: entry.key,
                              content: entry.value,
                              onTap: entry.key.trim().toLowerCase() == 'email'
                                  ? () => _openMail(entry.value)
                                  : null,
                            ),
                            const SizedBox(height: 12),
                          ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Copyright & Made with love
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '© ${DateTime.now().year} Sreeraj P. All rights reserved.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      l10n.aboutMadeWithLove,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onTap != null
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
