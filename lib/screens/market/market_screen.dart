import 'dart:async';

import 'package:crypto_tracker/model/reference_currency.dart';

//phone navigation bar
import 'package:crypto_tracker/provider/reference_currency.dart';
import 'package:crypto_tracker/provider/service_provider.dart';
import 'package:crypto_tracker/screens/market/market_list.dart';
import 'package:crypto_tracker/screens/market/modal/reference_currencies.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:crypto_tracker/service/reference_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/data/coins.dart';
import '../../config/default_config.dart';
import '../../model/coin.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() {
    return _MarketScreenState();
  }
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  late Future<(List<Coin>, String?)> coins;
  late Future<(List<ReferenceCurrency>, String?)> currencies;

  final TextEditingController _searchController = TextEditingController();
  late CoinsService coinsService;
  late ReferenceCurrenciesService referenceCurrenciesService;

  // Baboon code
  TimePeriod? timePeriod = DefaultApiRequestConfig.timePeriod;
  OrderBy? currentOrderBy = DefaultApiRequestConfig.orderBy;
  OrderBy? savedCurrentOrderBy;
  OrderBy orderBy = DefaultApiRequestConfig.orderBy;
  String? search;
  OrderDirection orderDirection = DefaultApiRequestConfig.orderDirection;
  late ReferenceCurrency currentReferenceCurrency;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();

    currentReferenceCurrency = ref.read(referenceCurrencyProvider);
    coinsService = ref.read(coinsServiceProvider);
    referenceCurrenciesService = ref.read(referenceCurrenciesServiceProvider);

    currencies = referenceCurrenciesService.getReferenceCurrencies();
    coins = coinsService.getCoins(CoinsRequestData(), currentReferenceCurrency);
  }

  @override
  Widget build(BuildContext context) {
    currentReferenceCurrency = ref.watch(referenceCurrencyProvider);

    double screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(255, 2, 32, 54),
    ));

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TextButton(
                      child: Text(currentReferenceCurrency.toString()),
                      onPressed: _showCurrencyModal),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child:
                        TextButton(child: Text('Category'), onPressed: () {})),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TextButton(
                        child: Text('Time period'), onPressed: () {})),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: IconButton(
                    onPressed: () {
                      _showSearchModal(context);
                    },
                    icon: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              )
            ],
          )),
          Container(
            color: Color.fromARGB(255, 240, 239, 239),
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.08,
                  child: Center(child: Text('#')),
                ),
                Container(
                  width: screenWidth * 0.15,
                  child: Center(child: Text('COIN')),
                ),
                Container(
                  width: screenWidth * 0.25,
                  child: Center(
                      child: TextButton(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text('PRICE'),
                          sortingIconChanger(OrderBy.price)
                        ],
                      ),
                    ),
                    onPressed: () {
                      _updateCurrentOrderBy(OrderBy.price);
                    },
                  )),
                ),
                Container(
                  width: screenWidth * 0.17,
                  child: Center(
                      child: TextButton(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text('24H'),
                          sortingIconChanger(OrderBy.change)
                        ],
                      ),
                    ),
                    onPressed: () {
                      _updateCurrentOrderBy(OrderBy.change);
                    },
                  )),
                ),
                Container(
                  width: screenWidth * 0.31,
                  child: Center(
                      child: TextButton(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text('MARKET CAP'),
                          sortingIconChanger(OrderBy.marketCap)
                        ],
                      ),
                    ),
                    onPressed: () {
                      _updateCurrentOrderBy(OrderBy.marketCap);
                    },
                  )),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Future.wait([coins, currencies]),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text(snapshot.error.toString())));
                  });
                  return Container();
                }

                if (snapshot.hasData) {
                  if (snapshot.data![0].$2 != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text(snapshot.data![0].$2!)));
                    });
                    return Container();
                  }

                  if (snapshot.data![1].$2 != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text(snapshot.data![1].$2!)));
                    });
                    return Container();
                  }

                  if (snapshot.data![0].$2 == null &&
                      snapshot.data![1].$2 == null) {
                    return MarketListWidget(snapshot.data![0].$1 as List<Coin>);
                  } else {
                    return const MarketListWidget([]);
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateCurrentOrderBy(OrderBy selectedOrderBy) {
    savedCurrentOrderBy = selectedOrderBy;

    if (currentOrderBy == selectedOrderBy) {
      orderDirection = OrderDirection.asc;
      currentOrderBy = null;
    } else {
      currentOrderBy = selectedOrderBy;
      orderBy = selectedOrderBy;
      orderDirection = OrderDirection.desc;
    }

    setState(() {
      coins = coinsService.getCoins(
        CoinsRequestData(
            orderBy: orderBy, orderDirection: orderDirection, search: search),
        currentReferenceCurrency,
      );
    });
  }

  void _search() {
    setState(() {
      coins = coinsService.getCoins(
          CoinsRequestData(
              orderBy: OrderBy.marketCap,
              orderDirection: OrderDirection.desc,
              search: search),
          currentReferenceCurrency);
    });
  }

  void _showSearchModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search by Name'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(hintText: 'Type here...'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                search = _searchController.text;
                _search();

                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencyModal() {
    Future<ReferenceCurrency?> futureCurrency =
        showModalBottomSheet<ReferenceCurrency>(
            isScrollControlled: true,
            context: context,
            builder: (ctx) => ReferenceCurrenciesModal(currencies));
    futureCurrency.then((selectedCurrency) {
      currentReferenceCurrency = selectedCurrency!;
      _refresh();
    });
  }

  Widget sortingIconChanger(orderByFilter) {
    if (currentOrderBy == orderByFilter) {
      return const Icon(
        Icons.keyboard_double_arrow_down,
      );
    } else if (savedCurrentOrderBy == orderByFilter) {
      return const Icon(
        Icons.keyboard_double_arrow_up,
      );
    } else {
      return const Text('');
    }
  }

  Future<void> _refresh() {
    return coins = coinsService.getCoins(
        CoinsRequestData(
            orderBy: orderBy, orderDirection: orderDirection, search: search),
        currentReferenceCurrency);
  }
}
