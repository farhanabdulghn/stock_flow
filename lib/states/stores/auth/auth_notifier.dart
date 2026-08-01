import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/auth/auth_model.dart';
import 'package:untitled/utils/enums.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  Box<AuthModel> get _box => Hive.box<AuthModel>(HiveBox.auth.name);
  static const _key = 'current_user';

  @override
  AuthModel? build() {
    return _box.get(_key);
  }

  void login(String email, String password) {
    final name = email.split('@').first;

    final user = AuthModel(email: email, name: name);

    _box.put(_key, user);

    state = user;
  }

  Future<void> logout() async {
    await _box.clear();

    if (ref.mounted) state = null;
  }
}
