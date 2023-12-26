import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketListWidget extends StatelessWidget {
  const MarketListWidget(this.coins, {super.key});

  final List<Coin> coins;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: coins.length,
      itemExtent: 90.0,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          contentPadding: EdgeInsets.only(
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
              top: 0,
              bottom: 0),
          dense: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: Row(children: [
                  Container(
                      width: screenWidth * 0.08,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(
                            child: Text(
                          coins[index].rank!.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w200, fontSize: 10),
                        )),
                      )),
                  Container(
                    width: screenWidth * 0.15,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(children: [
                        if (_imageTypeFilter(coins[index].iconUrl, index) !=
                            null)
                          _imageTypeFilter(coins[index].iconUrl, index)!,
                        Text(
                          coins[index].symbol!,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ]),
                    ),
                  ),
                  Container(
                      width: screenWidth * 0.25,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(child: Text(coins[index].price!)),
                      )),
                  SizedBox(
                    width: screenWidth * 0.01,
                  ),
                  Container(
                      width: screenWidth * 0.17,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(
                            child: Text(
                          "${coins[index].change} %",
                          style: TextStyle(
                              color: _getChangeColor(
                                  double.parse(coins[index].change!))),
                        )),
                      )),
                  SizedBox(
                    width: screenWidth * 0.01,
                  ),
                  Container(
                    width: screenWidth * 0.29,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(child: Text(coins[index].marketCap!))),
                  ),
                ]),
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.2,
                height: 0,
                indent: 10,
                endIndent: 10,
              ),
            ],
          ),
        );
      },
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

  Widget? _imageTypeFilter(String? iconUrl, int index) {
    if (iconUrl == null) {
      return null;
    }

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
}
