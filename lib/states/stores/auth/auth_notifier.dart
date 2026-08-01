import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/models/auth/auth_model.dart';
import 'package:untitled/utils/enums.dart';
import 'package:untitled/utils/functions.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  Box<AuthModel> get _box {
    return Hive.box<AuthModel>(HiveBox.auth.name);
  }

  static const _key = 'current_user';

  static const _accounts = [
    _LoginAccount(
      id: 1,
      name: 'Admin Gudang',
      email: 'admin@stockflow.com',
      password: 'admin123',
      role: UserRole.admin,
    ),
    _LoginAccount(
      id: 2,
      name: 'Operator Gudang',
      email: 'operator@stockflow.com',
      password: 'operator123',
      role: UserRole.operator,
    ),
  ];

  @override
  AuthModel? build() {
    final storedUser = _box.get(_key);

    if (storedUser == null) {
      return null;
    }

    final storedRole = Functions.userRoleFromValue(storedUser.role);

    if (storedRole == null) return null;

    return storedUser;
  }

  Future<void> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    _LoginAccount? selectedAccount;

    for (final account in _accounts) {
      if (account.email.toLowerCase() == normalizedEmail) {
        selectedAccount = account;
        break;
      }
    }

    if (selectedAccount == null || selectedAccount.password != password) {
      throw StateError('Email atau password salah');
    }

    final user = AuthModel(
      id: selectedAccount.id,
      name: selectedAccount.name,
      email: selectedAccount.email,
      role: selectedAccount.role.name,
    );

    await _box.put(_key, user);

    if (ref.mounted) state = user;
  }

  Future<void> logout() async {
    await _box.delete(_key);

    if (ref.mounted) state = null;
  }
}

class _LoginAccount {
  const _LoginAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
}
