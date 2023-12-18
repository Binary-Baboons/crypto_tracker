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

  @override
  late OrderBy orderByVariable;
  late OrderDirection OrderDirectionVariable;
  void initState() {
    super.initState();
    orderByVariable = DefaultApiRequestConfig.orderBy;
    OrderDirectionVariable = DefaultApiRequestConfig.orderDirection;

    ApiService apiService = ref.read(apiServiceProvider);
    coinsResponseData = apiService.getCoins(CoinsRequestData(
      orderBy: orderByVariable,
      orderDirection: OrderDirectionVariable,
    ));
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Variable Value: ',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Call the function to update the variable

                  // Close the bottom sheet
                  Navigator.pop(context);
                },
                child: Text('Update Variable'),
              ),
            ],
          ),
        );
      },
    );
  }

  void updateVariable(num1) {
    setState(() {
      orderByVariable = num1;
      OrderDirectionVariable = OrderDirection.desc;
      ApiService apiService = ref.read(apiServiceProvider);
      coinsResponseData = apiService.getCoins(CoinsRequestData(
          orderBy: orderByVariable, orderDirection: OrderDirectionVariable));
    });
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
                  child: Text('%'),
                  onPressed: () {
                    updateVariable(OrderBy.values);
                  },
                )),
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
