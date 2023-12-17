import 'dart:async';

import 'package:crypto_tracker/api/data/coins/request_data.dart';
import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/api/service/api_service.dart';
import 'package:crypto_tracker/provider/api_service_provider.dart';
import 'package:crypto_tracker/screens/market/market_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  void initState() {
    super.initState();
    ApiService apiService = ref.read(apiServiceProvider);
    coinsResponseData = apiService.getCoins(CoinsRequestData());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Column(
      children: [
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
                child: Center(child: Text('PRICE')),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.amber),
                width: screenWidth * 0.15,
                child: Center(child: Text('24H')),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                width: screenWidth * 0.33,
                child: Center(child: Text('MARKET CAP')),
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
