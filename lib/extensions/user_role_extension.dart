part of 'extensions.dart';

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.operator:
        return 'Operator';
    }
  }

  bool get isAdmin => this == UserRole.admin;

  bool get isOperator => this == UserRole.operator;
}
