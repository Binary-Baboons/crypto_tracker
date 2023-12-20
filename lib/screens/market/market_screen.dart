import 'dart:async';

import 'package:crypto_tracker/api/data/coins/request_data.dart';
import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/api/service/api_service.dart';
import 'package:crypto_tracker/provider/api_service_provider.dart';
import 'package:crypto_tracker/screens/market/market_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_tracker/config/default_api_params.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() {
    return _MarketScreenState();
  }
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  late Future<CoinsResponseData> coinsResponseData;
  final TextEditingController _searchController = TextEditingController();

  OrderBy? currentOrderBy;
  String? search;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  OrderBy orderBy = DefaultApiRequestConfig.orderBy;
  OrderDirection orderDirection = DefaultApiRequestConfig.orderDirection;

  void initState() {
    super.initState();

    ApiService apiService = ref.read(apiServiceProvider);
    coinsResponseData = apiService.getCoins(CoinsRequestData(search: search));
  }

  void _updateCurrentOrderBy(OrderBy orderByVar) {
    if (currentOrderBy == orderByVar) {
      orderDirection = OrderDirection.asc;
      currentOrderBy = null;
    } else {
      currentOrderBy = orderByVar;
      orderBy = orderByVar;
      orderDirection = OrderDirection.desc;
    }

    ApiService apiService = ref.read(apiServiceProvider);
    setState(() {
      coinsResponseData = apiService.getCoins(
          CoinsRequestData(orderBy: orderBy, orderDirection: orderDirection));
    });
  }

  void _search(String search) {
    ApiService apiService = ref.read(apiServiceProvider);
    setState(() {
      coinsResponseData = apiService.getCoins(CoinsRequestData(
          orderBy: OrderBy.marketCap,
          orderDirection: OrderDirection.desc,
          search: search));
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

  Future<void> _refresh() async {
    // Simulate a delay
    await Future.delayed(Duration(seconds: 1));
    ApiService apiService = ref.read(apiServiceProvider);

    setState(() {
      coinsResponseData = apiService.getCoins(CoinsRequestData(
          orderBy: orderBy, orderDirection: orderDirection, search: search));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: TextButton(child: Text('\$currency'), onPressed: () {}),
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
            color: Colors.grey,
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
                    child: Row(
                      children: [
                        Text('PRICE'),
                      ],
                    ),
                    onPressed: () => _updateCurrentOrderBy(OrderBy.price),
                  )),
                ),
                Container(
                  width: screenWidth * 0.15,
                  child: Center(
                    child: TextButton(
                      child: Text('24H'),
                      onPressed: () {
                        //BABOON TREBA NAPRAVI;
                      },
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.33,
                  child: Center(
                      child: TextButton(
                    child: Text('MARKET CAP'),
                    onPressed: () => _updateCurrentOrderBy(OrderBy.marketCap),
                  )),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<CoinsResponseData>(
              future: coinsResponseData,
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snapshot.error.toString())));
                }

                if (snapshot.hasData) {
                  if (snapshot.data!.statusCode == 200) {
                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(coins.message!)));
                  }

                  return MarketListWidget(snapshot.data!);
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
