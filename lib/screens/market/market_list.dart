import 'dart:ffi';

import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketListWidget extends StatelessWidget {
  const MarketListWidget(this.coins, {super.key});

  final List<Coin> coins;

  Color _getChangeColor(double change) {
    if (change <= 0) {
      return Colors.red;
    } else if (change == 0) {
      return Colors.grey;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Widget imageTypeFilter(String iconUrl, int index) {
      var url = iconUrl.split('?');
      int length = url[0].length;
      String lastThreeCharacters = url[0].substring(length - 3);

      if (lastThreeCharacters == "svg") {
        return SvgPicture.network(
          coins[index].iconUrl.toString(),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(
          coins[index].iconUrl.toString(),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      }
    }

    return Container(
      child: ListView.builder(
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
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Center(
                            child: Text(
                          coins[index].rank != null
                              ? coins[index].rank!.toString()
                              : "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w200, fontSize: 10),
                        ))),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      width: screenWidth * 0.15,
                      child: Column(children: [
                        imageTypeFilter(
                            coins[index].iconUrl != null
                                ? coins[index].iconUrl!
                                : "",
                            index),
                        Text(
                          coins[index].symbol != null
                              ? coins[index].symbol!
                              : "",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ]),
                    ),
                    Container(
                        width: screenWidth * 0.25,
                        decoration: const BoxDecoration(color: Colors.white),
                        child:
                            Center(child: Text(coins[index].price.toString()))),
                    Container(
                        width: screenWidth * 0.15,
                        child: Center(
                            child: Text(
                          "${coins[index].change} %",
                          style: TextStyle(
                              color: _getChangeColor(double.parse(coins[index].change!))),
                        ))),
                    Container(
                        decoration: const BoxDecoration(color: Colors.white),
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
      ),
    );
  }
}
