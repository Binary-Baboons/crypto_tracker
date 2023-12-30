import 'dart:async';

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
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/data/coins.dart';
import '../../config/default_config.dart';
import '../../model/coin.dart';

class MarketScreenWidget extends ConsumerStatefulWidget {
  const MarketScreenWidget({super.key});

  @override
  ConsumerState<MarketScreenWidget> createState() {
    return _MarketScreenWidgetState();
  }
}

class _MarketScreenWidgetState extends ConsumerState<MarketScreenWidget> {
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

    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 10),
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _showCurrencyModal,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          child: SizedBox(
                            child: Text(
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                key: const Key("referenceCurrencyFilterText"),
                                selectedReferenceCurrency.toString()),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 50,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          onPressed: _showCategoriesModal,
                          child: Text('Category'),
                        ),
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 50,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          onPressed: _showTimePeriodModal,
                          child: Text('Time period'),
                        ),
                      )),
                ),
                SizedBox(
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
                        size: 20,
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
              SizedBox(
                width: screenWidth * 0.08,
                child: Center(
                    child: Text('#',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer))),
              ),
              SizedBox(
                width: screenWidth * 0.15,
                child: const Center(child: Text('COIN')),
              ),
              SizedBox(
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
              SizedBox(
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
              SizedBox(
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
          child: RefreshIndicator(
              onRefresh: _refreshCoins,
                child: MarketListWidget(coins),
              ),
        )
      ],
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
          title: const Text('Search'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Type here...'),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer),
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
