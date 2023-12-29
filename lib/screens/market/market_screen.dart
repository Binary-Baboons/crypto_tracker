import 'dart:async';

import 'package:crypto_tracker/error/handler.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/provider/reference_currency.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/screens/market/market_list.dart';
import 'package:crypto_tracker/screens/market/modal/categories.dart';
import 'package:crypto_tracker/screens/market/modal/reference_currencies.dart';
import 'package:crypto_tracker/screens/market/modal/time_period.dart';
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
  late Future<List<Coin>> coins;

  final TextEditingController _searchController = TextEditingController();
  late CoinsService coinsService;
  late ReferenceCurrenciesService referenceCurrenciesService;
  late ReferenceCurrency selectedReferenceCurrency;

  OrderBy? currentOrderBy = DefaultApiRequestConfig.orderBy;
  OrderBy? savedCurrentOrderBy;
  OrderBy orderBy = DefaultApiRequestConfig.orderBy;

  String? search;
  OrderDirection orderDirection = DefaultApiRequestConfig.orderDirection;
  Set<CategoryTag> selectedCategoryTags = {};
  TimePeriod selectedTimePeriod = DefaultApiRequestConfig.timePeriod;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    coinsService = ref.read(coinsServiceProvider);
    referenceCurrenciesService = ref.read(referenceCurrenciesServiceProvider);

    selectedReferenceCurrency =
        ref.read(selectedReferenceCurrencyStateProvider);
    coins =
        coinsService.getCoins(CoinsRequestData(), selectedReferenceCurrency);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).colorScheme.primary,
    ));

    return RefreshIndicator(
      onRefresh: _refreshCoins,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TextButton(
                          onPressed: _showCurrencyModal,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary),
                                key: const Key("referenceCurrencyFilterText"),
                                selectedReferenceCurrency.toString()),
                          )),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            onPressed: _showCategoriesModal,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Category'),
                            ))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            onPressed: _showTimePeriodModal,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Time period'),
                            ))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: IconButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
                        onPressed: () {
                          _showSearchModal(context);
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              )),
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.08,
                  child: Center(
                      child: Text('#',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer))),
                ),
                Container(
                  width: screenWidth * 0.15,
                  child: const Center(child: Text('COIN')),
                ),
                Container(
                  width: screenWidth * 0.25,
                  child: Center(
                      child: TextButton(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          const Text('PRICE'),
                          if (sortingIconChanger(OrderBy.price) != null)
                            sortingIconChanger(OrderBy.price)!
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
                          Text(
                              key: const Key("changeSortText"),
                              selectedTimePeriod.getTimePeriod.toString()),
                          if (sortingIconChanger(OrderBy.change) != null)
                            sortingIconChanger(OrderBy.change)!
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
                          if (sortingIconChanger(OrderBy.marketCap) != null)
                            sortingIconChanger(OrderBy.marketCap)!
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
              future: coins,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                          content: Text(ErrorHandler.getUserFriendlyMessage(
                              snapshot.error!))));
                  });
                  return Container();
                } else if (snapshot.hasData) {
                  return MarketListWidget(snapshot.data!);
                } else {
                  return const MarketListWidget([]);
                }
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

    _refreshCoins();
  }

  void _showSearchModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search by Name'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Type here...'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                search = _searchController.text;
                _refreshCoins();

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
            builder: (ctx) => ReferenceCurrenciesModal());
    futureCurrency.then((selectedCurrency) {
      if (selectedCurrency == null) {
        return;
      }
      selectedReferenceCurrency = selectedCurrency;
      _refreshCoins();
    });
  }

  void _showCategoriesModal() {
    Future<Set<CategoryTag>?> futureTags =
        showModalBottomSheet<Set<CategoryTag>>(
            isScrollControlled: true,
            context: context,
            builder: (ctx) => CategoriesModal(selectedCategoryTags));
    futureTags.then((selectedTags) {
      if (selectedTags != null) {
        selectedCategoryTags = selectedTags;
      } else {
        selectedCategoryTags = {};
      }
      _refreshCoins();
    });
  }

  void _showTimePeriodModal() {
    Future<TimePeriod?> futureTimePeriod = showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => TimePeriodModal(selectedTimePeriod));
    futureTimePeriod.then((timePeriod) {
      if (timePeriod != null) {
        selectedTimePeriod = timePeriod;
      }
      _refreshCoins();
    });
  }

  Widget? sortingIconChanger(orderByFilter) {
    if (currentOrderBy == orderByFilter) {
      return const Icon(
        Icons.keyboard_double_arrow_down,
      );
    } else if (savedCurrentOrderBy == orderByFilter) {
      return const Icon(
        Icons.keyboard_double_arrow_up,
      );
    } else {
      return null;
    }
  }

  Future<void> _refreshCoins() async {
    setState(() {
      coins = coinsService.getCoins(
          CoinsRequestData(
              orderBy: orderBy,
              orderDirection: orderDirection,
              search: search,
              tags: selectedCategoryTags,
              timePeriod: selectedTimePeriod),
          selectedReferenceCurrency);
    });
  }
}
