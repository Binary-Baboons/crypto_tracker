import 'dart:async';

import 'package:crypto_tracker/api/data/coins/request_data.dart';
import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/api/service/api_service.dart';
import 'package:crypto_tracker/api/service/coin_ranking.dart';
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
  final TextEditingController _inputController = TextEditingController();

  var url11;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _inputController.dispose();
    super.dispose();
  }

  OrderBy orderBy = DefaultApiRequestConfig.orderBy;
  OrderDirection orderDirection = DefaultApiRequestConfig.orderDirection;
  String? search;
  void initState() {
    super.initState();
    orderByVariable = DefaultApiRequestConfig.orderBy;
    orderDirectionVariable = DefaultApiRequestConfig.orderDirection;

    ApiService apiService = ref.read(apiServiceProvider);
    coinsResponseData = apiService.getCoins(CoinsRequestData(
        orderBy: orderByVariable,
        orderDirection: orderDirectionVariable,
        search: searchVariable));
  }

  void updateVariable(orderByVar) {
    setState(() {
      if (url11 == orderByVar) {
        orderDirectionVariable = OrderDirection.asc;
        url11 = "";
      } else {
        url11 = orderByVar;
        orderByVariable = orderByVar;
        orderDirectionVariable = OrderDirection.desc;
      }

      ApiService apiService = ref.read(apiServiceProvider);
      coinsResponseData = apiService.getCoins(CoinsRequestData(
          orderBy: orderByVariable, orderDirection: orderDirectionVariable));
    });
  }

  void SearchByName(String SearchVariable) {
    setState(() {
      ApiService apiService = ref.read(apiServiceProvider);
      coinsResponseData = apiService.getCoins(CoinsRequestData(
          orderBy: OrderBy.marketCap,
          orderDirection: OrderDirection.desc,
          search: SearchVariable));
    });
  }

  void _showInputModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search by Name'),
          content: TextField(
            controller: _inputController,
            decoration: InputDecoration(hintText: 'Type here...'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                String userInput = _inputController.text;
                SearchByName(userInput);

                // Close the dialog when OK is pressed
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
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
                _showInputModal(context);
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
                color: Colors.amber,
                width: screenWidth * 0.08,
                child: Center(child: Text('#')),
              ),
              Container(
                color: Colors.amber,
                width: screenWidth * 0.15,
                child: Center(child: Text('COIN')),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                width: screenWidth * 0.25,
                child: Center(
                    child: TextButton(
                  child: Text('PRICE'),
                  onPressed: () {
                    updateVariable(OrderBy.price);
                  },
                )),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.amber),
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
                decoration: BoxDecoration(color: Colors.green),
                width: screenWidth * 0.33,
                child: Center(
                    child: TextButton(
                  child: Text('MARKET CAP'),
                  onPressed: () {
                    updateVariable(OrderBy.marketCap);
                  },
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
    );
  }
}
