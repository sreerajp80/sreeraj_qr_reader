import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/l10n/gen/app_localizations.dart';
import 'package:sreeraj_qr_reader/providers/scan_provider.dart';
import 'package:sreeraj_qr_reader/providers/theme_provider.dart';
import 'package:sreeraj_qr_reader/screens/about_screen.dart';
import 'package:sreeraj_qr_reader/services/url_safety_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _activeProbing = false;
  bool _hasApiKey = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage();
      final apiKey = await secureStorage.read(
        key: 'google_safe_browsing_api_key',
      );

      if (mounted) {
        setState(() {
          _activeProbing =
              prefs.getBool(UrlSafetyService.activeProbingPrefKey) ?? false;
          _hasApiKey = apiKey != null && apiKey.isNotEmpty;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading settings summary: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scanProvider = Provider.of<ScanProvider>(context);

    final overlayStyleName = switch (themeProvider.scanOverlayStyle) {
      ScanOverlayStyle.laserLine => l10n.overlayLaserLine,
      ScanOverlayStyle.pulsingCorners => l10n.overlayPulsingCorners,
      ScanOverlayStyle.cyberneticGrid => l10n.overlayCyberneticGrid,
      ScanOverlayStyle.subtleDotMatrix => l10n.overlaySubtleDotMatrix,
    };

    final themeModeName = switch (themeProvider.themeMode) {
      AppThemeMode.system => l10n.themeSystemDefault,
      AppThemeMode.light => l10n.themeLight,
      AppThemeMode.dark => l10n.themeDark,
      AppThemeMode.oled => l10n.themeOled,
    };

    final feedbackStatus = l10n.feedbackSummary(
      scanProvider.isVibrationEnabled ? l10n.onLabel : l10n.offLabel,
      scanProvider.isSoundEnabled ? l10n.onLabel : l10n.offLabel,
    );

    final privacyStatus = _activeProbing
        ? l10n.privacySummaryOn
        : l10n.privacySummaryOff;

    final apiStatus = _hasApiKey
        ? l10n.apiKeyConfigured
        : l10n.apiKeyNotConfigured;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.palette_outlined,
                    title: l10n.settingsAppearanceTitle,
                    subtitle: '$themeModeName • Dynamic colors',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AppearanceSettingsScreen(),
                        ),
                      );
                      _loadSummary();
                    },
                  ),
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.layers_outlined,
                    title: l10n.settingsOverlayTitle,
                    subtitle: overlayStyleName,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ScanOverlaySettingsScreen(),
                        ),
                      );
                      _loadSummary();
                    },
                  ),
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.vibration,
                    title: l10n.settingsFeedbackTitle,
                    subtitle: feedbackStatus,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ScanFeedbackSettingsScreen(),
                        ),
                      );
                      _loadSummary();
                    },
                  ),
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.security,
                    title: l10n.settingsPrivacyTitle,
                    subtitle: privacyStatus,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacySettingsScreen(),
                        ),
                      );
                      _loadSummary();
                    },
                  ),
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.shield_outlined,
                    title: l10n.settingsSafeBrowsingTitle,
                    subtitle: l10n.settingsApiKeySubtitle(apiStatus),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SafeBrowsingSettingsScreen(),
                        ),
                      );
                      _loadSummary();
                    },
                  ),
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.admin_panel_settings_outlined,
                    title: l10n.settingsPermissionsTitle,
                    subtitle: l10n.settingsPermissionsSubtitle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PermissionsSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.help_outline,
                    title: l10n.settingsHelpTitle,
                    subtitle: l10n.settingsHelpSubtitle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.info_outline,
                    title: l10n.aboutTitle,
                    subtitle: l10n.settingsAboutSubtitle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAppearanceTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.palette_outlined),
                      title: Text(
                        l10n.themeModeHeading,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _getThemeModeName(l10n, themeProvider.themeMode),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SegmentedButton<AppThemeMode>(
                        segments: [
                          ButtonSegment<AppThemeMode>(
                            value: AppThemeMode.system,
                            label: Text(l10n.themeChipSystem),
                            icon: const Icon(Icons.brightness_auto, size: 18),
                          ),
                          ButtonSegment<AppThemeMode>(
                            value: AppThemeMode.light,
                            label: Text(l10n.themeChipLight),
                            icon: const Icon(Icons.light_mode, size: 18),
                          ),
                          ButtonSegment<AppThemeMode>(
                            value: AppThemeMode.dark,
                            label: Text(l10n.themeChipDark),
                            icon: const Icon(Icons.dark_mode, size: 18),
                          ),
                          ButtonSegment<AppThemeMode>(
                            value: AppThemeMode.oled,
                            label: Text(l10n.themeChipOled),
                            icon: const Icon(
                              Icons.power_settings_new,
                              size: 18,
                            ),
                          ),
                        ],
                        selected: {themeProvider.themeMode},
                        onSelectionChanged: (newSelection) {
                          themeProvider.setThemeMode(newSelection.first);
                        },
                      ),
                    ),
                    const Divider(height: 24),
                    SwitchListTile(
                      secondary: const Icon(Icons.color_lens_outlined),
                      title: Text(l10n.themeDynamicColorsTitle),
                      subtitle: Text(l10n.themeDynamicColorsSubtitle),
                      value: themeProvider.useDynamicColor,
                      onChanged: (val) => themeProvider.setUseDynamicColor(val),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeName(AppLocalizations l10n, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return l10n.themeDescSystem;
      case AppThemeMode.light:
        return l10n.themeDescLight;
      case AppThemeMode.dark:
        return l10n.themeDescDark;
      case AppThemeMode.oled:
        return l10n.themeDescOled;
    }
  }
}

class ScanOverlaySettingsScreen extends StatelessWidget {
  const ScanOverlaySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsOverlayTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Column(
            children: [
              _buildOverlayTile(
                context: context,
                themeProvider: themeProvider,
                style: ScanOverlayStyle.laserLine,
                icon: Icons.linear_scale,
                title: l10n.overlayLaserLine,
                subtitle: l10n.overlayLaserLineDesc,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildOverlayTile(
                context: context,
                themeProvider: themeProvider,
                style: ScanOverlayStyle.pulsingCorners,
                icon: Icons.crop_free,
                title: l10n.overlayPulsingCorners,
                subtitle: l10n.overlayPulsingCornersDesc,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildOverlayTile(
                context: context,
                themeProvider: themeProvider,
                style: ScanOverlayStyle.cyberneticGrid,
                icon: Icons.grid_4x4,
                title: l10n.overlayCyberneticGrid,
                subtitle: l10n.overlayCyberneticGridDesc,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildOverlayTile(
                context: context,
                themeProvider: themeProvider,
                style: ScanOverlayStyle.subtleDotMatrix,
                icon: Icons.grain,
                title: l10n.overlaySubtleDotMatrix,
                subtitle: l10n.overlaySubtleDotMatrixDesc,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayTile({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required ScanOverlayStyle style,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = themeProvider.scanOverlayStyle == style;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(Icons.circle_outlined, color: Colors.grey),
      onTap: () => themeProvider.setScanOverlayStyle(style),
    );
  }
}

class ScanFeedbackSettingsScreen extends StatelessWidget {
  const ScanFeedbackSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scanProvider = Provider.of<ScanProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsFeedbackTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.vibration),
                title: Text(l10n.feedbackVibrationTitle),
                subtitle: Text(l10n.feedbackVibrationSubtitle),
                value: scanProvider.isVibrationEnabled,
                onChanged: (val) => scanProvider.setVibrationEnabled(val),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              SwitchListTile(
                secondary: const Icon(Icons.volume_up_outlined),
                title: Text(l10n.feedbackSoundTitle),
                subtitle: Text(l10n.feedbackSoundSubtitle),
                value: scanProvider.isSoundEnabled,
                onChanged: (val) => scanProvider.setSoundEnabled(val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _activeProbing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySetting();
  }

  Future<void> _loadPrivacySetting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _activeProbing =
              prefs.getBool(UrlSafetyService.activeProbingPrefKey) ?? false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading privacy setting: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _setActiveProbing(bool value) async {
    setState(() => _activeProbing = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(UrlSafetyService.activeProbingPrefKey, value);
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving active probing setting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyScreenTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: _activeProbing ? Colors.orange[50] : Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        value: _activeProbing,
                        onChanged: _setActiveProbing,
                        title: Text(
                          l10n.privacyActiveChecksTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(l10n.privacyActiveChecksSubtitle),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _activeProbing
                                  ? Icons.warning_amber
                                  : Icons.lock_outline,
                              size: 20,
                              color: _activeProbing
                                  ? Colors.orange[700]
                                  : Colors.blue[700],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _activeProbing
                                    ? l10n.privacyExplainerOn
                                    : l10n.privacyExplainerOff,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _activeProbing
                                      ? Colors.orange[900]
                                      : Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class SafeBrowsingSettingsScreen extends StatefulWidget {
  const SafeBrowsingSettingsScreen({super.key});

  @override
  State<SafeBrowsingSettingsScreen> createState() =>
      _SafeBrowsingSettingsScreenState();
}

class _SafeBrowsingSettingsScreenState
    extends State<SafeBrowsingSettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _secureStorage = const FlutterSecureStorage();

  bool _isLoading = true;
  bool _hasApiKey = false;
  bool _isObscured = true;
  int _requestsToday = 0;
  String? _lastResetDate;

  static const int maxRequestsPerDay = 10000;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final apiKey = await _secureStorage.read(
        key: 'google_safe_browsing_api_key',
      );

      final prefs = await SharedPreferences.getInstance();
      final requestCount = prefs.getInt('safe_browsing_request_count') ?? 0;
      final lastReset = prefs.getString('safe_browsing_last_reset');

      final today = DateTime.now().toIso8601String().split('T')[0];
      if (lastReset != today) {
        await prefs.setInt('safe_browsing_request_count', 0);
        await prefs.setString('safe_browsing_last_reset', today);
        setState(() {
          _requestsToday = 0;
          _lastResetDate = today;
        });
      } else {
        setState(() {
          _requestsToday = requestCount;
          _lastResetDate = lastReset;
        });
      }

      setState(() {
        _hasApiKey = apiKey != null && apiKey.isNotEmpty;
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading API settings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveApiKey() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiKey = _apiKeyController.text.trim();

      await _secureStorage.write(
        key: 'google_safe_browsing_api_key',
        value: apiKey,
      );

      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      await prefs.setInt('safe_browsing_request_count', 0);
      await prefs.setString('safe_browsing_last_reset', today);

      setState(() {
        _hasApiKey = true;
        _requestsToday = 0;
        _lastResetDate = today;
      });

      _apiKeyController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.apiKeySaved),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.apiKeySaveFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteApiKey() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.apiKeyDeleteTitle),
        content: Text(l10n.apiKeyDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      await _secureStorage.delete(key: 'google_safe_browsing_api_key');

      setState(() {
        _hasApiKey = false;
        _apiKeyController.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.apiKeyDeleted),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.apiKeyDeleteFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSafeBrowsingTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 20),
                  if (_hasApiKey) ...[
                    _buildApiKeyStatusCard(),
                    const SizedBox(height: 20),
                    _buildUsageCard(),
                    const SizedBox(height: 20),
                    _buildDeleteButton(),
                  ] else ...[
                    _buildApiKeyForm(),
                  ],
                  const SizedBox(height: 32),
                  _buildHowToGetApiKey(),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard() {
    final l10n = AppLocalizations.of(context);
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.apiAboutHeading,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.apiAboutBody,
              style: TextStyle(fontSize: 14, color: Colors.blue[900]),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.apiDailyLimit(maxRequestsPerDay),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[900],
                      ),
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

  Widget _buildApiKeyStatusCard() {
    final l10n = AppLocalizations.of(context);
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[700], size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.apiKeyConfiguredTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.apiKeyConfiguredSubtitle,
                    style: TextStyle(fontSize: 14, color: Colors.green[900]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageCard() {
    final l10n = AppLocalizations.of(context);
    final percentage = (_requestsToday / maxRequestsPerDay * 100).clamp(
      0.0,
      100.0,
    );
    final isNearLimit = _requestsToday >= maxRequestsPerDay * 0.8;
    final isAtLimit = _requestsToday >= maxRequestsPerDay;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.apiTodaysUsage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$_requestsToday / $maxRequestsPerDay',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAtLimit
                        ? Colors.red
                        : isNearLimit
                        ? Colors.orange
                        : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                color: isAtLimit
                    ? Colors.red
                    : isNearLimit
                    ? Colors.orange
                    : Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}% used',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (isAtLimit) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.apiLimitReached,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (isNearLimit) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.apiLimitApproaching,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              l10n.apiResets(_lastResetDate ?? l10n.unknownLabel),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyForm() {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _apiKeyController,
            obscureText: _isObscured,
            decoration: InputDecoration(
              labelText: l10n.apiKeyFieldLabel,
              hintText: l10n.apiKeyFieldHint,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _isObscured = !_isObscured);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.apiKeyRequired;
              }
              if (value.trim().length < 20) {
                return l10n.apiKeyTooShort;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveApiKey,
              icon: const Icon(Icons.save),
              label: Text(l10n.apiKeySaveButton),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _deleteApiKey,
        icon: const Icon(Icons.delete),
        label: Text(l10n.apiKeyDeleteTitle),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildHowToGetApiKey() {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline),
        title: Text(l10n.apiHowToHeading),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStep('1', l10n.apiStep1Title, l10n.apiStep1Desc),
                const SizedBox(height: 12),
                _buildStep('2', l10n.apiStep2Title, l10n.apiStep2Desc),
                const SizedBox(height: 12),
                _buildStep('3', l10n.apiStep3Title, l10n.apiStep3Desc),
                const SizedBox(height: 12),
                _buildStep('4', l10n.apiStep4Title, l10n.apiStep4Desc),
                const SizedBox(height: 12),
                _buildStep('5', l10n.apiStep5Title, l10n.apiStep5Desc),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.apiFreeTierNote,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PermissionsSettingsScreen extends StatelessWidget {
  const PermissionsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.permissionsScreenTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              title: l10n.permissionsExplicitHeading,
              icon: Icons.security_outlined,
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(
                      l10n.permissionCameraTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(l10n.permissionCameraDesc),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.fingerprint,
                      color: Colors.purple,
                    ),
                    title: Text(
                      l10n.permissionBiometricTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(l10n.permissionBiometricDesc),
                  ),
                ],
              ),
            ),
            _buildSectionHeader(
              context,
              title: l10n.permissionsImplicitHeading,
              icon: Icons.settings_suggest_outlined,
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.wifi, color: Colors.teal),
                    title: Text(
                      l10n.permissionInternetTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(l10n.permissionInternetDesc),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.vibration, color: Colors.orange),
                    title: Text(
                      l10n.permissionVibrateTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(l10n.permissionVibrateDesc),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.indigo,
                    ),
                    title: Text(
                      l10n.permissionPhotoPickerTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(l10n.permissionPhotoPickerDesc),
                  ),
                ],
              ),
            ),
            _buildSectionHeader(
              context,
              title: l10n.permissionsSettingHeading,
              icon: Icons.toggle_on_outlined,
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.travel_explore,
                      color: Colors.amber,
                    ),
                    title: Text(
                      l10n.permissionProbingTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(l10n.permissionProbingDesc),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.cloud_sync_outlined,
                      color: Colors.lightBlue,
                    ),
                    title: Text(
                      l10n.permissionSafeBrowsingTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(l10n.permissionSafeBrowsingDesc),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.touch_app_outlined,
                      color: Colors.deepOrange,
                    ),
                    title: Text(
                      l10n.permissionFeedbackTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(l10n.permissionFeedbackDesc),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpSettingsScreen extends StatelessWidget {
  const HelpSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsHelpTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHelpCard(
              context: context,
              icon: Icons.view_in_ar,
              title: l10n.arScreenTitle,
              badgeText: l10n.helpArBadge,
              description: l10n.helpArDesc,
              details: [
                l10n.helpArPoint1,
                l10n.helpArPoint2,
                l10n.helpArPoint3,
                l10n.helpArPoint4,
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              context: context,
              icon: Icons.stream,
              title: l10n.airQrReceiverTitle,
              badgeText: l10n.helpAirQrBadge,
              description: l10n.helpAirQrDesc,
              details: [
                l10n.helpAirQrPoint1,
                l10n.helpAirQrPoint2,
                l10n.helpAirQrPoint3,
                l10n.helpAirQrPoint4,
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              context: context,
              icon: Icons.qr_code_scanner,
              title: l10n.helpQuishingTitle,
              badgeText: l10n.helpQuishingBadge,
              description: l10n.helpQuishingDesc,
              details: [
                l10n.helpQuishingPoint1,
                l10n.helpQuishingPoint2,
                l10n.helpQuishingPoint3,
                l10n.helpQuishingPoint4,
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              context: context,
              icon: Icons.verified_user_outlined,
              title: l10n.helpUrlTitle,
              badgeText: l10n.helpUrlBadge,
              description: l10n.helpUrlDesc,
              details: [
                l10n.helpUrlPoint1,
                l10n.helpUrlPoint2,
                l10n.helpUrlPoint3,
                l10n.helpUrlPoint4,
                l10n.helpUrlPoint5,
                l10n.helpUrlPoint6,
                l10n.helpUrlPoint7,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String badgeText,
    required String description,
    required List<String> details,
  }) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 12),
          Text(
            l10n.helpCapabilitiesHeading,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          ...details.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
