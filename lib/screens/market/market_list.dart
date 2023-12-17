import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/model/crypto_item.dart';
import 'package:flutter/material.dart';

class MarketListWidget extends StatelessWidget {
  const MarketListWidget(this.coinsResponseData, {super.key});

  final CoinsResponseData coinsResponseData;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    List<CryptoItem> coins = coinsResponseData.data;

    return ListView.builder(
      itemCount: coins.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            contentPadding: EdgeInsets.only(
                left: screenWidth * 0.02, right: screenWidth * 0.02),
            title: Column(
              children: [
                Row(children: [
                  Container(
                      width: screenWidth * 0.08,
                      decoration: const BoxDecoration(color: Colors.amber),
                      child: Center(
                          child: Text(
                            coins[index].rank != null ? coins[index].rank!.toString() : "",
                            style: const TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 10),
                          ))),
                  Container(
                    decoration: const BoxDecoration(color: Colors.amber),
                    width: screenWidth * 0.15,
                    child: Column(children: [
                      Text(
                        coins[index].iconUrl != null
                            ? coins[index].iconUrl!
                            : "",
                      ),
                      Text(
                        coins[index].symbol != null ? coins[index].symbol! : "",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      )
                    ]),
                  ),
                  Container(
                      width: screenWidth * 0.25,
                      decoration: const BoxDecoration(color: Colors.amber),
                      child:
                      Center(child: Text(coins[index].price.toString()))),
                  Container(
                      width: screenWidth * 0.15,
                      decoration: const BoxDecoration(color: Colors.green),
                      child: Center(
                          child: Text(coins[index].price != null
                              ? coins[index].price!
                              : ""))),
                  Container(
                      decoration: const BoxDecoration(color: Colors.green),
                      width: screenWidth * 0.33,
                      child: Center(
                          child: Text(
                            coins[index].marketCap != null
                                ? coins[index].marketCap!
                                : "",
                          ))),
                ]),
                const Divider(
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
    );
  }
}
