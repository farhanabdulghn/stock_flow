import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:untitled/models/auth/auth_model.dart';
import 'package:untitled/storage/secure_storage/secure_storage.dart';
import 'package:untitled/utils/enums.dart';

class HiveStorage {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AuthModelAdapter());

    String? encryptionKeyString = await SecureStorage.read(K.hive);
    late List<int> encryptionKeyUint8List;

    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();

      await SecureStorage.write(key: K.hive, value: base64UrlEncode(key));
      encryptionKeyUint8List = key;
    } else {
      encryptionKeyUint8List = base64Url.decode(encryptionKeyString);
    }

    await Hive.openBox<AuthModel>(
      HiveBox.auth.name,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );
  }
}
