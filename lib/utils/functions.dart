import 'package:untitled/utils/enums.dart';

class Functions {
  static UserRole? userRoleFromValue(String? value) {
    if (value == null) return null;

    final normalizedValue = value.trim().toLowerCase();

    for (final role in UserRole.values) {
      if (role.name.toLowerCase() == normalizedValue) {
        return role;
      }
    }

    return null;
  }
}
