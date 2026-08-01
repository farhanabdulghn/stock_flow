// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AuthModel?> {
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthModel?>(value),
    );
  }
}

String _$authNotifierHash() => r'803f17f238939560d85fd21602079d92520b9295';

abstract class _$AuthNotifier extends $Notifier<AuthModel?> {
  AuthModel? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthModel?, AuthModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthModel?, AuthModel?>,
              AuthModel?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
