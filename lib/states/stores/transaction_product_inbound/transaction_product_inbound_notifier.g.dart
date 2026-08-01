// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_product_inbound_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionProductInboundNotifier)
final transactionProductInboundProvider =
    TransactionProductInboundNotifierProvider._();

final class TransactionProductInboundNotifierProvider
    extends
        $NotifierProvider<
          TransactionProductInboundNotifier,
          List<TransactionProductInboundModel>
        > {
  TransactionProductInboundNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionProductInboundProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$transactionProductInboundNotifierHash();

  @$internal
  @override
  TransactionProductInboundNotifier create() =>
      TransactionProductInboundNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TransactionProductInboundModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<List<TransactionProductInboundModel>>(value),
    );
  }
}

String _$transactionProductInboundNotifierHash() =>
    r'4ae14db424b0c65f976dd224ccb60edf64d1bed9';

abstract class _$TransactionProductInboundNotifier
    extends $Notifier<List<TransactionProductInboundModel>> {
  List<TransactionProductInboundModel> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              List<TransactionProductInboundModel>,
              List<TransactionProductInboundModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<TransactionProductInboundModel>,
                List<TransactionProductInboundModel>
              >,
              List<TransactionProductInboundModel>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
