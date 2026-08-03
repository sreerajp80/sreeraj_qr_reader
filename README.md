# Sreeraj P QR Reader

A comprehensive Flutter application for scanning QR codes and barcodes with advanced features including URL safety verification, clipboard integration, and content sharing.

## Features

### Core Functionality
- **QR Code Scanner**: High-performance QR code scanning with camera preview
- **Barcode Scanner**: Support for multiple barcode formats including Code128, Code39, EAN, UPC, and more
- **Scanning Rectangle**: Visual scanning area with animated scanning line and corner indicators

### Content Handling
- **URL Detection**: Automatically detects URLs in scanned content
- **URL Safety Verification**: Checks URLs against known safe and suspicious domains
- **Safety Alerts**: Visual indicators for safe and potentially unsafe URLs
- **Content Display**: Clean, readable display of scanned content

### Integration Features
- **Clipboard Integration**: One-tap copy to Android clipboard with visual feedback
- **Browser Integration**: Open detected URLs in the default Android browser
- **Share Integration**: Share scanned content with other Android apps
- **Multiple Content Types**: Support for URLs, plain text, WiFi credentials, and email addresses

### User Interface
- **Modern Material Design**: Clean, intuitive interface following Material Design 3 guidelines
- **Responsive Layout**: Optimized for various Android screen sizes
- **Visual Feedback**: Animated scanning indicators and action confirmations
- **Permission Handling**: Proper camera permission requests and handling

## Supported Barcode Formats

- QR Code
- Code 128
- Code 39
- Code 93
- EAN-8
- EAN-13
- UPC-A
- UPC-E
- PDF417
- Data Matrix

## Technical Specifications

### Flutter SDK
- **Flutter Version**: 3.44.8+
- **Dart SDK**: 3.12.2+
- **Material Design**: Version 3
- **Null Safety**: Fully enabled

### Dependencies
- `mobile_scanner`: ^7.2.0 - QR/Barcode scanning
- `provider`: ^6.1.5 - State management
- `http`: ^1.6.0 - HTTP requests for URL safety checks
- `url_launcher`: ^6.3.2 - URL launching in external browser
- `share_plus`: ^12.0.1 - Content sharing
- `permission_handler`: ^12.0.1 - Camera permission handling
- `flutter_secure_storage`: ^10.0.0 - Encrypted storage for API key
- `shared_preferences`: ^2.5.5 - Non-sensitive preferences
- `package_info_plus`: ^9.0.0 - App version info

### Android Requirements
- **Min SDK**: 24 (Android 7.0)
- **Target SDK**: Latest Android version
- **Permissions**: Camera, Internet
- **Architecture**: ARM64, x86_64

## Installation & Setup

### Prerequisites
1. **Flutter SDK**: Install the latest Flutter SDK
2. **Android Studio**: Install Android Studio with Android SDK
3. **Visual Studio Code**: Install VS Code with Flutter extension
4. **Android Emulator**: Set up Android Emulator for testing

### Setup Steps

1. **Clone the Project**
   ```bash
   git clone <repository-url>
   cd sreeraj_qr_reader
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Setup**
   ```bash
   flutter doctor
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

### Building for Release

1. **Build APK**
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle**
   ```bash
   flutter build appbundle --release
   ```

## Usage Guide

### Scanning Codes
1. Launch the app and grant camera permission
2. Position the QR code or barcode within the scanning rectangle
3. The app will automatically detect and process the code
4. View the results on the result screen

### Handling URLs
1. When a URL is detected, the app automatically checks its safety
2. Green indicator: Safe URL
3. Red indicator: Potentially unsafe URL
4. Tap "Open in Browser" to launch in default browser

### Copying Content
1. On the result screen, tap "Copy to Clipboard"
2. The content is copied to your Android clipboard
3. Visual feedback confirms the copy action

### Sharing Content
1. On the result screen, tap "Share"
2. Select the app you want to share with
3. The content is shared in plain text format

## Development

### Project Structure
```
sreeraj_qr_reader/
├── assets/
│   └── config/
│       └── app_config.json        # About screen data (single source of truth)
├── lib/
│   ├── main.dart                  # App entry point
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_config.dart    # Typed About model & fallback
│   │   │   └── config_service.dart# Config asset loader
│   │   └── constants/
│   │       └── app_constants.dart # Technical constants
│   ├── models/
│   │   └── safety_check_result.dart # Immutable result model
│   ├── providers/
│   │   └── scan_provider.dart     # State management (ChangeNotifier)
│   ├── screens/
│   │   ├── scanner_screen.dart    # QR/Barcode scanner UI
│   │   ├── result_screen.dart     # Result display and actions
│   │   ├── settings_screen.dart   # API key management
│   │   └── about_screen.dart      # Data-driven App info screen
│   └── services/
│       └── url_safety_service.dart# Six URL safety check algorithms
└── test/
    └── core/
        └── config/
            └── app_config_test.dart
```

### Key Classes
- `ScannerScreen`: Main scanning interface with camera preview
- `ResultScreen`: Display and interaction with scan results
- `ScanProvider`: State management for scan data and URL safety
- `UrlSafetyService`: Six URL safety checks (SSL, redirects, patterns, shorteners, homographs, Safe Browsing API)

### Customization
- Modify `ThemeData` in `main.dart` to change app theme
- Update scanning rectangle in `scanner_screen.dart`
- Add new barcode formats in the scanner controller
- Extend URL safety checks in `scan_provider.dart`

## Testing

### Manual Testing
1. Test with various QR codes and barcodes
2. Verify URL safety detection
3. Test clipboard and sharing functionality
4. Check permission handling
5. Test on different Android devices

### Test Scenarios
- **Valid QR codes**: URLs, plain text, WiFi credentials
- **Invalid codes**: Damaged, blurry, or unsupported formats
- **URL safety**: Safe URLs, suspicious URLs, shortened URLs
- **Permissions**: Camera permission granted/denied
- **Sharing**: Various target apps and content types

## Troubleshooting

### Common Issues
1. **Camera not working**: Check camera permission
2. **Scanning not detecting**: Ensure good lighting and focus
3. **URL not opening**: Check internet connection
4. **App crashing**: Run `flutter clean` and rebuild

### Debug Tips
- Use `flutter logs` to view device logs
- Enable debug mode in Flutter for detailed error messages
- Check Android Studio Logcat for native errors

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is created for Sreeraj P as a personal QR Reader application.

## Support

For issues, feature requests, or questions:
1. Check the troubleshooting section
2. Review the code documentation
3. Create an issue in the repository

---

**Built with Flutter ❤️ for Android**