import 'package:flutter_test/flutter_test.dart';
import 'package:sreeraj_qr_reader/services/totp_service.dart';

void main() {
  group('TotpService', () {
    late TotpService totpService;

    setUp(() {
      totpService = TotpService();
    });

    test('decodeBase32 decodes valid base32 string correctly', () {
      final bytes = TotpService.decodeBase32('JBSWY3DP'); // "Hello"
      expect(bytes.isNotEmpty, isTrue);
      expect(String.fromCharCodes(bytes), equals('Hello'));
    });

    test('generateTotp calculates 6-digit TOTP token for secret', () {
      const secret = 'JBSWY3DPEHPK3PXP';
      final token = totpService.generateTotp(
        secret: secret,
        timeMs: 1600000000000,
      );

      expect(token.length, equals(6));
      expect(RegExp(r'^\d{6}$').hasMatch(token), isTrue);
    });

    test('getRemainingSeconds returns valid countdown range (1..30)', () {
      final rem = totpService.getRemainingSeconds();
      expect(rem, greaterThanOrEqualTo(1));
      expect(rem, lessThanOrEqualTo(30));
    });
  });
}
