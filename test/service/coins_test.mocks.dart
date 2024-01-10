// Mocks generated by Mockito 5.4.4 from annotations
// in crypto_tracker/test/service/coins_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:crypto_tracker/api/client/coins.dart' as _i2;
import 'package:crypto_tracker/api/data/coin_price.dart' as _i10;
import 'package:crypto_tracker/api/data/coins.dart' as _i8;
import 'package:crypto_tracker/database/base.dart' as _i4;
import 'package:crypto_tracker/database/coins.dart' as _i3;
import 'package:crypto_tracker/model/coin.dart' as _i7;
import 'package:crypto_tracker/model/reference_currency.dart' as _i9;
import 'package:crypto_tracker/service/coins.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i11;

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

class _FakeCoinsApiClient_0 extends _i1.SmartFake
    implements _i2.CoinsApiClient {
  _FakeCoinsApiClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCoinsStore_1 extends _i1.SmartFake implements _i3.CoinsStore {
  _FakeCoinsStore_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBaseDatabase_2 extends _i1.SmartFake implements _i4.BaseDatabase {
  _FakeBaseDatabase_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CoinsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoinsService extends _i1.Mock implements _i5.CoinsService {
  MockCoinsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CoinsApiClient get coinsApiClient => (super.noSuchMethod(
        Invocation.getter(#coinsApiClient),
        returnValue: _FakeCoinsApiClient_0(
          this,
          Invocation.getter(#coinsApiClient),
        ),
      ) as _i2.CoinsApiClient);

  @override
  set coinsApiClient(_i2.CoinsApiClient? _coinsApiClient) => super.noSuchMethod(
        Invocation.setter(
          #coinsApiClient,
          _coinsApiClient,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.CoinsStore get coinsStore => (super.noSuchMethod(
        Invocation.getter(#coinsStore),
        returnValue: _FakeCoinsStore_1(
          this,
          Invocation.getter(#coinsStore),
        ),
      ) as _i3.CoinsStore);

  @override
  set coinsStore(_i3.CoinsStore? _coinsStore) => super.noSuchMethod(
        Invocation.setter(
          #coinsStore,
          _coinsStore,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i6.Future<List<_i7.Coin>> getCoins(
    _i8.CoinsRequestData? requestData,
    _i9.ReferenceCurrency? referenceCurrency,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCoins,
          [
            requestData,
            referenceCurrency,
          ],
        ),
        returnValue: _i6.Future<List<_i7.Coin>>.value(<_i7.Coin>[]),
      ) as _i6.Future<List<_i7.Coin>>);

  @override
  _i6.Future<List<_i7.Coin>> getFavoriteCoins(
          _i9.ReferenceCurrency? referenceCurrency) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFavoriteCoins,
          [referenceCurrency],
        ),
        returnValue: _i6.Future<List<_i7.Coin>>.value(<_i7.Coin>[]),
      ) as _i6.Future<List<_i7.Coin>>);

  @override
  void addFavoriteCoin(String? uuid) => super.noSuchMethod(
        Invocation.method(
          #addFavoriteCoin,
          [uuid],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void deleteFavoriteCoin(String? uuid) => super.noSuchMethod(
        Invocation.method(
          #deleteFavoriteCoin,
          [uuid],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i6.Future<String> getCoinPrice(
    _i10.CoinPriceRequestData? requestData,
    _i9.ReferenceCurrency? referenceCurrency,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCoinPrice,
          [
            requestData,
            referenceCurrency,
          ],
        ),
        returnValue: _i6.Future<String>.value(_i11.dummyValue<String>(
          this,
          Invocation.method(
            #getCoinPrice,
            [
              requestData,
              referenceCurrency,
            ],
          ),
        )),
      ) as _i6.Future<String>);
}

/// A class which mocks [CoinsStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoinsStore extends _i1.Mock implements _i3.CoinsStore {
  MockCoinsStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.BaseDatabase get baseDatabase => (super.noSuchMethod(
        Invocation.getter(#baseDatabase),
        returnValue: _FakeBaseDatabase_2(
          this,
          Invocation.getter(#baseDatabase),
        ),
      ) as _i4.BaseDatabase);

  @override
  set baseDatabase(_i4.BaseDatabase? _baseDatabase) => super.noSuchMethod(
        Invocation.setter(
          #baseDatabase,
          _baseDatabase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i6.Future<List<String>> getFavoriteCoins() => (super.noSuchMethod(
        Invocation.method(
          #getFavoriteCoins,
          [],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);

  @override
  _i6.Future<int> addFavoriteCoin(String? uuid) => (super.noSuchMethod(
        Invocation.method(
          #addFavoriteCoin,
          [uuid],
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);

  @override
  _i6.Future<int> deleteFavoriteCoin(String? uuid) => (super.noSuchMethod(
        Invocation.method(
          #deleteFavoriteCoin,
          [uuid],
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);
}
