import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/coin.dart';

class CoinListItemWidget extends ConsumerWidget {
  CoinListItemWidget(this.coin, {super.key});

  Coin coin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var imageService = ref.read(imageServiceProvider);
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        SizedBox(
            width: screenWidth * 0.08,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(
                  child: Text(
                coin.rank!.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w200, fontSize: 10),
              )),
            )),
        SizedBox(
          width: screenWidth * 0.15,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(children: [
              imageService.getImage(coin.iconUrl, 30)!,
              Text(
                coin.symbol!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              )
            ]),
          ),
        ),
        SizedBox(
            width: screenWidth * 0.25,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(child: Text(coin.price!)),
            )),
        SizedBox(
          width: screenWidth * 0.01,
        ),
        SizedBox(
            width: screenWidth * 0.17,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(
                  child: Text(
                "${coin.change} %",
                style: TextStyle(
                    color: _getChangeColor(double.parse(coin.change!))),
              )),
            )),
        SizedBox(
          width: screenWidth * 0.01,
        ),
        SizedBox(
          width: screenWidth * 0.29,
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(child: Text(coin.marketCap!))),
        ),
      ]),
    );
  }

  Color _getChangeColor(double change) {
    if (change <= 0) {
      return Colors.red;
    } else if (change == 0) {
      return Colors.grey;
    } else {
      return Colors.green;
    }
  }
}
