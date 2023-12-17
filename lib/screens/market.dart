import 'package:crypto_tracker/api/data/coins/request_data.dart';
import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/api/service/api_service.dart';
import 'package:crypto_tracker/model/crypto_item.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/provider/api_service_provider.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void poyiva() {}

class CryptoListPage extends ConsumerStatefulWidget {
  const CryptoListPage({super.key});

  @override
  ConsumerState<CryptoListPage> createState() {
    return _CryptoListPageState();
  }
}

class _CryptoListPageState extends ConsumerState<CryptoListPage> {
  ApiService? apiService;
  CoinsResponseData? crupzo;

  @override
  void initState() async {
    super.initState();
    apiService = ref.read(apiServiceProvider);
    crupzo = await apiService!.getCoins(CoinsRequestData());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Text('data'),
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
          child: ListView.builder(
            itemCount: crupzo?.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  contentPadding: EdgeInsets.only(
                      left: screenWidth * 0.02, right: screenWidth * 0.02),
                  title: Column(
                    children: [
                      Row(children: [
                        Container(
                            width: screenWidth * 0.08,
                            decoration: BoxDecoration(color: Colors.amber),
                            child: Center(
                                child: Text(
                              crupzo!.data[index].uuid,
                              style: TextStyle(
                                  fontWeight: FontWeight.w200, fontSize: 10),
                            ))),
                        Container(
                          decoration: BoxDecoration(color: Colors.amber),
                          width: screenWidth * 0.15,
                          child: Column(children: [
                            Text(crupzo!.data[index].iconUrl),
                            Text(
                              crupzo!.data[index].symbol,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )
                          ]),
                        ),
                        Container(
                            width: screenWidth * 0.25,
                            decoration: BoxDecoration(color: Colors.amber),
                            child: Center(
                                child: Text(
                                    crupzo!.data[index].price.toString()))),
                        Container(
                            width: screenWidth * 0.15,
                            decoration: BoxDecoration(color: Colors.green),
                            child: Center(
                                child: Text(
                                    crupzo!.data[index].price.toString()))),
                        Container(
                            decoration: BoxDecoration(color: Colors.green),
                            width: screenWidth * 0.33,
                            child: Center(
                                child: Text(crupzo!.data[index].marketCap))),
                      ]),
                      Divider(
                        color: Colors.black,
                        thickness: 0.5,
                        height: 20,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ],
                  ),
                  onTap: () {},
                  dense: true);
            },
          ),
        ),
      ],
    );
  }
}
