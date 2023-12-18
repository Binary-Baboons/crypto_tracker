import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/model/crypto_item.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/config/default_api_params.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketListWidget extends StatelessWidget {
  const MarketListWidget(this.coinsResponseData, {super.key});

  final CoinsResponseData coinsResponseData;

  Color ChangeColorChanger(ChangeNumberInt) {
    if (ChangeNumberInt <= 0) {
      return Colors.red;
    }
    if (ChangeNumberInt == 0) {
      return Colors.grey;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<CryptoItem> coins = coinsResponseData.data;

    String CoinChangeChecker(ChangeVariable) {
      if (ChangeVariable == null) {
        return '0.00';
      } else {
        return ChangeVariable;
      }
    }

    //Function determing if the iconURL is either svg or other - MEGA SUS
    Widget imageTypeFilter(String ImageURL, int index) {
      String myString = ImageURL;
      int length = myString.length;
      String lastThreeCharacters = myString.substring(length - 3);
      print(ImageURL);

      if (lastThreeCharacters == "svg" || lastThreeCharacters == "x48") {
        return SvgPicture.network(
          coins[index].iconUrl.toString(),
          width: 50,
          height: 50,
        );
      } else {
        return Image.network(
          coins[index].iconUrl.toString(),
          width: 50,
          height: 50,
        );
      }
    }

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
                        coins[index].symbol != null ? coins[index].symbol! : "",
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
                        coins[index].change != null ? coins[index].change! : "",
                        style: TextStyle(
                            color: ChangeColorChanger(double.parse(
                                CoinChangeChecker(coins[index].change)))),
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
    );
  }
}
