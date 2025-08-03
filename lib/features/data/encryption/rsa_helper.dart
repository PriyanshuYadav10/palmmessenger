import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';
import 'package:encrypt/encrypt.dart' as encrypt_pkg;

/// Helper for RSA encryption/decryption
class RSAHelper {
  final _parser = RSAKeyParser();

  /// Encrypt a message using a PEM public key
  String encryptWithPublicKey(String plainText, String publicKeyString) {
    final parsedKey = _parser.parse(publicKeyString);

    if (parsedKey is! RSAPublicKey) {
      throw ArgumentError('Provided public key is not a valid RSAPublicKey');
    }

    final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.RSA(
      publicKey: parsedKey,
      encoding: RSAEncoding.OAEP, // recommended for modern RSA
    ));

    return encrypter.encrypt(plainText).base64;
  }

  /// Decrypt a message using a PEM private key
  String decryptWithPrivateKey(String encryptedText, String privateKeyString) {
    final parsedKey = _parser.parse(privateKeyString);

    if (parsedKey is! RSAPrivateKey) {
      throw ArgumentError('Provided private key is not a valid RSAPrivateKey');
    }

    final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.RSA(
      privateKey: parsedKey,
      encoding: RSAEncoding.OAEP, // consistent with encryption
    ));

    return encrypter.decrypt(encrypt_pkg.Encrypted.fromBase64(encryptedText));
  }
}



const STREAM_API_KEY = "6d9kgfjpb6wz";
const STREAM_API_SECRET= "m98rsrk2afc5x598u58xqj5bp7pp5dswapb6qmp2868qu4r7jk9hmkxw987b4duj";