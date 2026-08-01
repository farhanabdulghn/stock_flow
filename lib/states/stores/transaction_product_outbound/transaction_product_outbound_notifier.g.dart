// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_product_outbound_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionProductOutboundNotifier)
final transactionProductOutboundProvider =
    TransactionProductOutboundNotifierProvider._();

final class TransactionProductOutboundNotifierProvider
    extends
        $NotifierProvider<
          TransactionProductOutboundNotifier,
          List<TransactionProductOutboundModel>
        > {
  TransactionProductOutboundNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionProductOutboundProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$transactionProductOutboundNotifierHash();

  @$internal
  @override
  TransactionProductOutboundNotifier create() =>
      TransactionProductOutboundNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TransactionProductOutboundModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<List<TransactionProductOutboundModel>>(value),
    );
  }
}

String _$transactionProductOutboundNotifierHash() =>
    r'b7007b11c664e84a8f449c4ad5351b34cc76428b';

abstract class _$TransactionProductOutboundNotifier
    extends $Notifier<List<TransactionProductOutboundModel>> {
  List<TransactionProductOutboundModel> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              List<TransactionProductOutboundModel>,
              List<TransactionProductOutboundModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<TransactionProductOutboundModel>,
                List<TransactionProductOutboundModel>
              >,
              List<TransactionProductOutboundModel>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
