import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sreeraj_qr_reader/services/url_safety_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _secureStorage = const FlutterSecureStorage();

  bool _isLoading = true;
  bool _hasApiKey = false;
  bool _isObscured = true;
  bool _activeProbing = false;
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
      // Check if API key exists (don't load actual key for security)
      final apiKey = await _secureStorage.read(
        key: 'google_safe_browsing_api_key',
      );

      // Load request count and last reset date
      final prefs = await SharedPreferences.getInstance();
      final requestCount = prefs.getInt('safe_browsing_request_count') ?? 0;
      final lastReset = prefs.getString('safe_browsing_last_reset');

      // Reset counter if it's a new day
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
        _activeProbing =
            prefs.getBool(UrlSafetyService.activeProbingPrefKey) ?? false;
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading settings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveApiKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiKey = _apiKeyController.text.trim();

      // Save to secure storage
      await _secureStorage.write(
        key: 'google_safe_browsing_api_key',
        value: apiKey,
      );

      // Initialize request tracking
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
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Privacy'),
                  const SizedBox(height: 8),
                  _buildActiveProbingCard(),
                  const SizedBox(height: 32),

                  _buildSectionHeader('Google Safe Browsing API'),
                  const SizedBox(height: 8),
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

  Future<void> _setActiveProbing(bool value) async {
    setState(() => _activeProbing = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(UrlSafetyService.activeProbingPrefKey, value);
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving active probing setting: $e');
    }
  }

  Widget _buildActiveProbingCard() {
    return Card(
      color: _activeProbing ? Colors.orange[50] : Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
