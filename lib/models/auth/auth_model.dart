import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:untitled/storage/hive/hive_id.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
@HiveType(typeId: HiveId.user)
abstract class AuthModel with _$AuthModel {
  const factory AuthModel({
    @HiveField(0) int? id,
    @HiveField(1) String? name,
    @HiveField(2) String? email,
    @HiveField(3) String? phone,
    @HiveField(4) String? role,
    @HiveField(5) String? profileImage,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}
