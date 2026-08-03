import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scanProvider = Provider.of<ScanProvider>(context);

    final overlayStyleName = switch (themeProvider.scanOverlayStyle) {
      ScanOverlayStyle.laserLine => 'Laser Line',
      ScanOverlayStyle.pulsingCorners => 'Pulsing Corners',
      ScanOverlayStyle.cyberneticGrid => 'Cybernetic Grid',
      ScanOverlayStyle.subtleDotMatrix => 'Subtle Dot Matrix',
    };

    final themeModeName = switch (themeProvider.themeMode) {
      AppThemeMode.system => 'System Default',
      AppThemeMode.light => 'Light Theme',
      AppThemeMode.dark => 'Dark Theme',
      AppThemeMode.oled => 'OLED Pure Black',
    };

    final feedbackStatus =
        'Vibration: ${scanProvider.isVibrationEnabled ? 'On' : 'Off'} • '
        'Sound: ${scanProvider.isSoundEnabled ? 'On' : 'Off'}';

    final privacyStatus = _activeProbing
        ? 'Active online checks enabled'
        : 'Private offline checks only';

    final apiStatus = _hasApiKey ? 'Configured' : 'Not configured';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSettingsCard(
                    context: context,
                    icon: Icons.palette_outlined,
                    title: 'Appearance & Theme',
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
                    title: 'Customizable Scan Overlay',
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
                    title: 'Scan Feedback & Alerts',
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
                    title: 'Privacy & Online Probing',
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
                    title: 'Google Safe Browsing API',
                    subtitle: 'API Key: $apiStatus',
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
                    title: 'Permissions',
                    subtitle: 'Explicit, implicit & setting-dependent details',
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
                    title: 'Help & Feature Guides',
                    subtitle:
                        'AR CodeVision, AirQR, Quishing Guard & URL Safety',
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
                    title: 'About',
                    subtitle: 'App version, developer & license details',
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance & Theme')),
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
                      title: const Text(
                        'Theme Mode',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _getThemeModeName(themeProvider.themeMode),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SegmentedButton<AppThemeMode>(
                        segments: const [
                          ButtonSegment<AppThemeMode>(
                            value: AppThemeMode.system,
                            label: Text('System'),
                            icon: Icon(Icons.brightness_auto, size: 18),
                          ),
                          ButtonSegment<AppThemeMode>(
                            value: AppThemeMode.light,
                            label: Text('Light'),
                            icon: Icon(Icons.light_mode, size: 18),
                          ),
                          ButtonSegment<AppThemeMode>(
                            value: AppThemeMode.dark,
                            label: Text('Dark'),
                            icon: Icon(Icons.dark_mode, size: 18),
                          ),
                          ButtonSegment<AppThemeMode>(
                            value: AppThemeMode.oled,
                            label: Text('OLED'),
                            icon: Icon(Icons.power_settings_new, size: 18),
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
                      title: const Text('Material You Dynamic Colors'),
                      subtitle: const Text(
                        'Sample system wallpaper colors on Android 12+ (Monet engine)',
                      ),
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

  String _getThemeModeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 'Follow System Settings';
      case AppThemeMode.light:
        return 'Standard Light Mode';
      case AppThemeMode.dark:
        return 'Standard Dark Mode';
      case AppThemeMode.oled:
        return 'True OLED Pure Black (Battery Saving)';
    }
  }
}

class ScanOverlaySettingsScreen extends StatelessWidget {
  const ScanOverlaySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Customizable Scan Overlay')),
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
                title: 'Laser Line',
                subtitle:
                    'Scanning box with an animated vertical laser beam and glow line',
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildOverlayTile(
                context: context,
                themeProvider: themeProvider,
                style: ScanOverlayStyle.pulsingCorners,
                icon: Icons.crop_free,
                title: 'Pulsing Corners',
                subtitle:
                    'Breathing corner reticles with color glow and scale animation',
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildOverlayTile(
                context: context,
                themeProvider: themeProvider,
                style: ScanOverlayStyle.cyberneticGrid,
                icon: Icons.grid_4x4,
                title: 'Cybernetic Grid',
                subtitle:
                    'Sci-fi grid overlay pattern with target crosshair reticle',
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildOverlayTile(
                context: context,
                themeProvider: themeProvider,
                style: ScanOverlayStyle.subtleDotMatrix,
                icon: Icons.grain,
                title: 'Subtle Dot Matrix',
                subtitle:
                    'Minimalist corner dot matrix pattern with pulsing accents',
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
    final scanProvider = Provider.of<ScanProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Feedback & Alerts')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.vibration),
                title: const Text('Vibration Feedback'),
                subtitle: const Text(
                  'Vibrate phone upon successful barcode recognition',
                ),
                value: scanProvider.isVibrationEnabled,
                onChanged: (val) => scanProvider.setVibrationEnabled(val),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              SwitchListTile(
                secondary: const Icon(Icons.volume_up_outlined),
                title: const Text('Audible Beep Sound'),
                subtitle: const Text(
                  'Play audio beep signal upon successful code recognition',
                ),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Network Probing')),
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
                        title: const Text(
                          'Active online checks',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'Off: scanned links are checked privately — the destination '
                          'server is never contacted.',
                        ),
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
                                    ? 'When on, the SSL, redirect and shortener checks '
                                          'connect directly to the scanned site. This '
                                          'exposes your IP address (and therefore your '
                                          'approximate location and mobile carrier) to that '
                                          'server before you open the link.'
                                    : 'SSL, redirect and shortener checks run from local '
                                          'rules only. Malicious-content lookup still uses '
                                          'Google Safe Browsing (the link is sent only to '
                                          'Google, never to the scanned site).',
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
          const SnackBar(
            content: Text('API key saved securely'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving API key: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteApiKey() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete API Key'),
        content: const Text(
          'Are you sure you want to delete your Google Safe Browsing API key? '
          'URL malicious content checking will be disabled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
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
          const SnackBar(
            content: Text('API key deleted'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting API key: $e'),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Google Safe Browsing API')),
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
                    'About Safe Browsing API',
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
              'The Google Safe Browsing API helps detect malicious URLs including '
              'phishing, malware, and unwanted software. Your API key is stored '
              'securely and encrypted on your device.',
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
                      'Daily Limit: $maxRequestsPerDay requests per day',
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
                    'API Key Configured',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Malicious URL checking is enabled',
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
                  'Today\'s Usage',
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
                        'Daily limit reached. Resets tomorrow.',
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
                        'Approaching daily limit',
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
              'Resets: ${_lastResetDate ?? 'Unknown'}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _apiKeyController,
            obscureText: _isObscured,
            decoration: InputDecoration(
              labelText: 'API Key',
              hintText: 'Enter your Google Safe Browsing API key',
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
                return 'Please enter an API key';
              }
              if (value.trim().length < 20) {
                return 'API key appears to be too short';
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
              label: const Text('Save API Key'),
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
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _deleteApiKey,
        icon: const Icon(Icons.delete),
        label: const Text('Delete API Key'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildHowToGetApiKey() {
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline),
        title: const Text('How to get an API key'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStep(
                  '1',
                  'Go to Google Cloud Console',
                  'Visit console.cloud.google.com',
                ),
                const SizedBox(height: 12),
                _buildStep(
                  '2',
                  'Create or select a project',
                  'Choose an existing project or create a new one',
                ),
                const SizedBox(height: 12),
                _buildStep(
                  '3',
                  'Enable Safe Browsing API',
                  'Search for "Safe Browsing API" and enable it',
                ),
                const SizedBox(height: 12),
                _buildStep(
                  '4',
                  'Create credentials',
                  'Go to Credentials → Create Credentials → API Key',
                ),
                const SizedBox(height: 12),
                _buildStep(
                  '5',
                  'Copy and paste',
                  'Copy the generated API key and paste it above',
                ),
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
                          'Free tier includes 10,000 requests per day',
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
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions Overview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              title: 'Explicit Permissions (Runtime / Manifest)',
              icon: Icons.security_outlined,
            ),
            const Card(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt_outlined, color: Colors.blue),
                    title: Text(
                      'Camera Access (android.permission.CAMERA)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Requested on-demand at point of use. Required for live scanning, AR CodeVision HUD overlay, and AirQR optical stream decoding.',
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.fingerprint, color: Colors.purple),
                    title: Text(
                      'Biometric Authentication (android.permission.USE_BIOMETRIC)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Requested when unlocking biometric secure vaults or encrypted QR code payloads.',
                    ),
                  ),
                ],
              ),
            ),
            _buildSectionHeader(
              context,
              title: 'Implicit & System Permissions',
              icon: Icons.settings_suggest_outlined,
            ),
            const Card(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.wifi, color: Colors.teal),
                    title: Text(
                      'Internet Access (android.permission.INTERNET)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Declared in Android Manifest. Used only when Active Online Probing or Google Safe Browsing API lookup is enabled.',
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.vibration, color: Colors.orange),
                    title: Text(
                      'Vibration & Haptics (android.permission.VIBRATE)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'System permission. Triggers haptic vibration feedback during scan alerts and button taps.',
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.photo_library_outlined, color: Colors.indigo),
                    title: Text(
                      'Scoped Media Photo Picker',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'System photo picker access. Allows selecting QR images or videos from gallery without requesting full storage access.',
                    ),
                  ),
                ],
              ),
            ),
            _buildSectionHeader(
              context,
              title: 'Setting-Dependent Permissions',
              icon: Icons.toggle_on_outlined,
            ),
            const Card(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.travel_explore, color: Colors.amber),
                    title: Text(
                      'Active Online Probing (Privacy Setting)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Active only when enabled. Performs outbound HTTP HEAD requests to follow URL redirects and check SSL certificates. When disabled, checks are 100% offline.',
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.cloud_sync_outlined, color: Colors.lightBlue),
                    title: Text(
                      'Google Safe Browsing API (API Key Setting)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Active only when API key is configured. Queries Google Threat API for malware & phishing checks.',
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.touch_app_outlined, color: Colors.deepOrange),
                    title: Text(
                      'Scan Feedback Vibrations (Alert Setting)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Active only when Vibration is enabled in Scan Feedback & Alerts settings.',
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
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Feature Guides')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHelpCard(
              context: context,
              icon: Icons.view_in_ar,
              title: 'AR CodeVision HUD',
              badgeText: 'Augmented Reality',
              description:
                  'Real-time camera overlay feature that highlights and visualizes barcode and QR code data directly within the 3D viewfinder.',
              details: [
                'Multi-Target Detection: Automatically detects, indexes, and tracks multiple barcodes simultaneously in real time.',
                'Spatial Bounding Boxes: Overlays dynamic AR reticles and interactive floating chips above each detected code.',
                'Interactive Action Sheet: Tap any detected AR chip to inspect payload details, copy data, or execute smart actions without exiting the camera.',
                'Camera Viewport Suite: Built-in torch toggle, front/rear camera switching, and pinch-to-zoom controls.',
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              context: context,
              icon: Icons.stream,
              title: 'AirQR Stream Receiver',
              badgeText: 'Optical Data Protocol',
              description:
                  'High-speed optical data transfer receiver designed to reconstruct large multi-part payloads serialized across animated QR code loops.',
              details: [
                'Sequential Frame Assembly: Scans animated QR streams (AirQR format) frame-by-frame and stitches chunks back into complete files or text.',
                'Real-Time Live Progress: Interactive progress indicator displaying completed percentage, total payload size, missing chunk count, and decoding speed.',
                'Dual Input Modes: Supports live scanning through the camera feed or offline processing by importing saved video recordings/images from gallery.',
                'AirQR Transmitter: Reverse mode allowing payload generation and animated QR stream transmission to other devices.',
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              context: context,
              icon: Icons.qr_code_scanner,
              title: 'Quishing Guard (Physical QR Sticker Tamper Check)',
              badgeText: 'On-Device Computer Vision',
              description:
                  'On-device computer vision engine that detects physical QR code sticker tampering, fake code overlays, and print alterations before processing payloads.',
              details: [
                '100% Offline & Private Guarantee: Operates entirely on-device using local camera frame computer vision with zero internet connection required.',
                'Physical Sticker & Overlay Detection: Identifies physical stickers pasted over legitimate printed QR codes.',
                'Edge & Alignment Anomaly Analysis: Checks for suspicious boundaries, cutouts, and alignment discrepancies.',
                'Print Texture & Contrast Verification: Analyzes visual print artifacts, reflectivity shifts, and paper texture inconsistencies.',
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              context: context,
              icon: Icons.verified_user_outlined,
              title: 'URL Safety & Link Tamper Engine',
              badgeText: '6-Layer Digital Safety',
              description:
                  'Comprehensive digital link analysis suite protecting against malicious web links, phishing (Quishing), and URL payload tampering.',
              details: [
                'Homograph & IDN Attack Detection: Identifies spoofed domain names using mixed-script Cyrillic or lookalike Unicode characters.',
                'Zero-Width Space & Character Tamper Detector: Detects hidden zero-width spaces, non-printable control characters, or obfuscated payloads embedded in links.',
                'IP Literal & Userinfo Verification: Flags suspicious IP address hostnames and dangerous embedded credentials (e.g. user:pass@host).',
                'Suspicious TLD & Pattern Analysis: Scans for risky top-level domains, excessive subdomains, and unencrypted HTTP connections carrying login/payment data.',
                'URL Shortener Unrolling & Redirect Tracing: Identifies shortened links (bit.ly, t.co) and traces redirect chains (Active Probing required for live HTTP inspection).',
                'Google Safe Browsing Cloud Lookup: Optional cloud check against Google threat database when configured with an API key.',
                'Privacy First Guarantee: Core 5 pattern checks run 100% offline on your device without sending URLs anywhere.',
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
          Text(
            description,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Key Capabilities:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

