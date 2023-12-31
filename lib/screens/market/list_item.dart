import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/coin.dart';

class ListItemWidget extends StatelessWidget {
  ListItemWidget(this.coin, {super.key});

  Coin coin;

  @override
  Widget build(BuildContext context) {
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
              if (_imageTypeFilter(coin) != null) _imageTypeFilter(coin)!,
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

  Widget? _imageTypeFilter(Coin coin) {
    if (coin.iconUrl == null) {
      return null;
    }

    var url = coin.iconUrl!.split('?');
    int length = url[0].length;
    String lastThreeCharacters = url[0].substring(length - 3);

    if (lastThreeCharacters == "svg") {
      return SvgPicture.network(
        coin.iconUrl.toString(),
        width: 20,
        height: 20,
        fit: BoxFit.scaleDown,
      );
    } else {
      return Image.network(
        coin.iconUrl.toString(),
        width: 20,
        cacheHeight: 100,
        cacheWidth: 100,
        height: 20,
        fit: BoxFit.scaleDown,
      );
    }
  }
}
