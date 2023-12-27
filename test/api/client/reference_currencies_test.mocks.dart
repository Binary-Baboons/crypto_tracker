// Mocks generated by Mockito 5.4.4 from annotations
// in crypto_tracker/test/api/client/reference_currencies_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:crypto_tracker/api/client/reference_currencies.dart' as _i3;
import 'package:crypto_tracker/model/reference_currency.dart' as _i5;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBaseClient_0 extends _i1.SmartFake implements _i2.BaseClient {
  _FakeBaseClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ReferenceCurrenciesApiClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockReferenceCurrenciesApiClient<T> extends _i1.Mock
    implements _i3.ReferenceCurrenciesApiClient<T> {
  MockReferenceCurrenciesApiClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.BaseClient get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakeBaseClient_0(
          this,
          Invocation.getter(#client),
        ),
      ) as _i2.BaseClient);

  @override
  set client(_i2.BaseClient? _client) => super.noSuchMethod(
        Invocation.setter(
          #client,
          _client,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<List<_i5.ReferenceCurrency>> getReferenceCurrencies() =>
      (super.noSuchMethod(
        Invocation.method(
          #getReferenceCurrencies,
          [],
        ),
        returnValue: _i4.Future<List<_i5.ReferenceCurrency>>.value(
            <_i5.ReferenceCurrency>[]),
      ) as _i4.Future<List<_i5.ReferenceCurrency>>);
}
