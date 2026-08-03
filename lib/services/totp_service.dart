import 'dart:typed_data';
import 'package:pointycastle/digests/sha1.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/macs/hmac.dart';

/// Pure Dart RFC 6238 / RFC 4226 TOTP token engine.
class TotpService {
  /// Base32 alphabet map
  static const String _base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  /// Decodes a base32 string into bytes.
  static Uint8List decodeBase32(String input) {
    final cleaned = input.toUpperCase().replaceAll(RegExp(r'[^A-Z2-7]'), '');
    if (cleaned.isEmpty) return Uint8List(0);

    final List<int> bytes = [];
    int buffer = 0;
    int bitsLeft = 0;

    for (int i = 0; i < cleaned.length; i++) {
      final val = _base32Chars.indexOf(cleaned[i]);
      if (val < 0) continue;

      buffer = (buffer << 5) | val;
      bitsLeft += 5;

      if (bitsLeft >= 8) {
        bytes.add((buffer >> (bitsLeft - 8)) & 0xFF);
        bitsLeft -= 8;
      }
    }

    return Uint8List.fromList(bytes);
  }

  /// Generates the current TOTP token for a given base32 secret.
  String generateTotp({
    required String secret,
    int? timeMs,
    int period = 30,
    int digits = 6,
    String algorithm = 'SHA1',
  }) {
    if (secret.isEmpty) return '000000';

    final secretBytes = decodeBase32(secret);
    if (secretBytes.isEmpty) return '000000';

    final nowSeconds =
        ((timeMs ?? DateTime.now().millisecondsSinceEpoch) / 1000).floor();
    final timeStep = (nowSeconds / period).floor();

    final counterBytes = Uint8List(8);
    var temp = timeStep;
    for (int i = 7; i >= 0; i--) {
      counterBytes[i] = temp & 0xFF;
      temp >>= 8;
    }

    final hmac = _getHmac(algorithm, secretBytes);
    hmac.init(KeyParameter(secretBytes));
    final mac = Uint8List(hmac.macSize);
    hmac.update(counterBytes, 0, counterBytes.length);
    hmac.doFinal(mac, 0);

    final offset = mac[mac.length - 1] & 0x0F;
    final binary =
        ((mac[offset] & 0x7F) << 24) |
        ((mac[offset + 1] & 0xFF) << 16) |
        ((mac[offset + 2] & 0xFF) << 8) |
        (mac[offset + 3] & 0xFF);

    final modulo = _pow10(digits);
    final otp = binary % modulo;

    return otp.toString().padLeft(digits, '0');
  }

  /// Returns remaining seconds in the current 30-second TOTP window.
  int getRemainingSeconds({int? timeMs, int period = 30}) {
    final nowSeconds =
        ((timeMs ?? DateTime.now().millisecondsSinceEpoch) / 1000).floor();
    final rem = period - (nowSeconds % period);
    return rem == 0 ? period : rem;
  }

  Digest _getDigest(String algo) {
    switch (algo.toUpperCase()) {
      case 'SHA256':
        return SHA256Digest();
      case 'SHA512':
        return SHA512Digest();
      case 'SHA1':
      default:
        return SHA1Digest();
    }
  }

  HMac _getHmac(String algo, Uint8List secretKey) {
    return HMac(_getDigest(algo), 64);
  }

  int _pow10(int digits) {
    int res = 1;
    for (int i = 0; i < digits; i++) {
      res *= 10;
    }
    return res;
  }
}
