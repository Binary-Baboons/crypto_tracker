import 'dart:async';
//phone navigation bar
import 'package:crypto_tracker/provider/reference_currency.dart';
import 'package:flutter/services.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/provider/service_provider.dart';
import 'package:crypto_tracker/screens/market/market_list.dart';
import 'package:crypto_tracker/screens/market/modal/reference_currencies.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:crypto_tracker/service/reference_currency.dart';
import 'package:flutter/material.dart';
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

  OrderBy? currentOrderBy = DefaultApiRequestConfig.orderBy;
  OrderBy? savedCurrentOrderBy;
  String? search;
  OrderBy orderBy = DefaultApiRequestConfig.orderBy;
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

    coinsService = ref.read(coinsServiceProvider);
    coins = coinsService.getCoins(CoinsRequestData(), currentReferenceCurrency);

    referenceCurrenciesService = ref.read(referenceCurrenciesServiceProvider);
    currencies = referenceCurrenciesService.getReferenceCurrencies();

    currentReferenceCurrency = ref.watch(refrenceCurrencyProvider);
  }

  void _updateCurrentOrderBy(OrderBy orderByVar) {
    savedCurrentOrderBy = orderByVar;
    if (currentOrderBy == orderByVar) {
      orderDirection = OrderDirection.asc;
      currentOrderBy = null;
    } else {
      currentOrderBy = orderByVar;
      orderBy = orderByVar;
      orderDirection = OrderDirection.desc;
    }

    setState(() {
      coins = coinsService.getCoins(
        CoinsRequestData(orderBy: orderBy, orderDirection: orderDirection),
        currentReferenceCurrency,
      );
    });
  }

  void _search(String search) {
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
                String search = _searchController.text;
                _search(search);

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
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ReferenceCurrenciesModal(currencies));
  }

  Widget sortingIconChanger(currentOrderBy, savedOrderBy, orderByFilter) {
    if (currentOrderBy == orderByFilter) {
      return Icon(
        Icons.keyboard_double_arrow_up,
        color: Colors.green,
      );
    }
    if (savedOrderBy == orderByFilter) {
      return Icon(
        Icons.keyboard_double_arrow_down,
        color: Colors.red,
      );
    } else {
      return Text('');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      coins = coinsService.getCoins(
          CoinsRequestData(
              orderBy: orderBy, orderDirection: orderDirection, search: search),
          currentReferenceCurrency);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

//phone navigation bar ONLY FOR ANDROID
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Color.fromARGB(255, 2, 32, 54), // Set your desired color here
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
                child: TextButton(
                    child: Text(currentReferenceCurrency.toString()),
                    onPressed: _showCurrencyModal),
              ),
              Container(
                child: TextButton(child: Text('Category'), onPressed: () {}),
              ),
              Container(
                child: TextButton(child: Text('Time period'), onPressed: () {}),
              ),
              IconButton(
                onPressed: () {
                  _showSearchModal(context);
                },
                icon: Icon(
                  Icons.search,
                  size: 30,
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
                          sortingIconChanger(currentOrderBy,
                              savedCurrentOrderBy, OrderBy.price)
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
                          sortingIconChanger(currentOrderBy,
                              savedCurrentOrderBy, OrderBy.change)
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
                          sortingIconChanger(currentOrderBy,
                              savedCurrentOrderBy, OrderBy.marketCap)
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
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(snapshot.error.toString())));
                }

                if (snapshot.hasData) {
                  if (snapshot.data![0].$2 != null) {
                    //ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar(content: Text(snapshot.data![0].$2!)));
                  }

                  if (snapshot.data![1].$2 != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(snapshot.data![1].$2!)));
                  }

                  if (snapshot.data![0].$2 == null &&
                      snapshot.data![1].$2 == null) {
                    currentReferenceCurrency =
                        (snapshot.data![1].$1 as List<ReferenceCurrency>)
                            .firstWhere((curr) =>
                                curr.uuid! ==
                                DefaultApiRequestConfig.referenceCurrencyUuid);
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
}
