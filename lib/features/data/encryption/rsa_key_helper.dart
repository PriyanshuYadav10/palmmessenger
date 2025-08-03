import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:asn1lib/asn1lib.dart';

class RSAKeyHelper {
  /// Generates a 2048-bit RSA key pair
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateKeyPair() {
    final keyGen = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12),
          _secureRandom(),
        ),
      );

    final pair = keyGen.generateKeyPair();
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      pair.publicKey as RSAPublicKey,
      pair.privateKey as RSAPrivateKey,
    );
  }

  /// Helper: Create secure random
  static SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Uint8List.fromList(
      List.generate(32, (_) => DateTime.now().microsecond % 256),
    );
    secureRandom.seed(KeyParameter(seedSource));
    return secureRandom;
  }

  /// Convert RSAPublicKey to PEM string
  static String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
    final asn1Seq = ASN1Sequence()
      ..add(ASN1Integer(publicKey.modulus!))
      ..add(ASN1Integer(publicKey.exponent!));

    final dataBase64 = base64.encode(asn1Seq.encodedBytes);
    return _formatPem(dataBase64, 'RSA PUBLIC KEY');
  }

  /// Convert RSAPrivateKey to PEM string (PKCS#1)
  static String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
    if (privateKey.p == null || privateKey.q == null) {
      throw ArgumentError('Private key must contain p and q');
    }

    final qInv = privateKey.q!.modInverse(privateKey.p!);

    final asn1Seq = ASN1Sequence()
      ..add(ASN1Integer(BigInt.zero))                   // Version
      ..add(ASN1Integer(privateKey.n!))                 // Modulus
      ..add(ASN1Integer(privateKey.exponent!))          // Public exponent
      ..add(ASN1Integer(privateKey.privateExponent!))   // Private exponent
      ..add(ASN1Integer(privateKey.p!))                 // p
      ..add(ASN1Integer(privateKey.q!))                 // q
      ..add(ASN1Integer(privateKey.privateExponent! % (privateKey.p! - BigInt.one))) // d mod (p-1)
      ..add(ASN1Integer(privateKey.privateExponent! % (privateKey.q! - BigInt.one))) // d mod (q-1)
      ..add(ASN1Integer(qInv));                         // qInv

    final dataBase64 = base64.encode(asn1Seq.encodedBytes);
    return _formatPem(dataBase64, 'RSA PRIVATE KEY');
  }

  /// Helper: Format PEM string
  static String _formatPem(String base64String, String type) {
    final chunks = RegExp('.{1,64}').allMatches(base64String).map((m) => m.group(0)).join('\n');
    return '-----BEGIN $type-----\n$chunks\n-----END $type-----';
  }
}
