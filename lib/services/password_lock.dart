import 'package:encrypt/encrypt.dart';

class PasswordLock{

  static final key = Key.fromUtf8('my 32 length key................');
  static final iv = IV.fromLength(16);

  static final encrypter = Encrypter(AES(key));


   lockPassword(String plainText){
    return encrypter.encrypt(plainText, iv: iv).base64;
  }
  
  unlockPassword(String plainText){
     Encrypted encrypted = Encrypted.fromBase64(plainText);
     return encrypter.decrypt(encrypted, iv: iv);
  }
}