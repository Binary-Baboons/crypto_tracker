import 'package:crypto_tracker/error/handler.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketListWidget extends ConsumerWidget {
  const MarketListWidget(this.futureCoins, {super.key});

  final Future<List<Coin>> futureCoins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: futureCoins,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                    content: Text(
                        ErrorHandler.getUserFriendlyMessage(snapshot.error!),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error))));
            });
            return Container();
          } else if (snapshot.hasData) {
            List<Coin> coins = snapshot.data!;
            return ListView.builder(
              itemCount: coins.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () => ref.read(coinsServiceProvider).addFavoriteCoin(coins[index].uuid!),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(children: [
                              SizedBox(
                                  width: screenWidth * 0.08,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Center(
                                        child: Text(
                                      coins[index].rank!.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 10),
                                    )),
                                  )),
                              SizedBox(
                                width: screenWidth * 0.15,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(children: [
                                    if (_imageTypeFilter(coins[index].iconUrl,
                                            index, coins) !=
                                        null)
                                      _imageTypeFilter(
                                          coins[index].iconUrl, index, coins)!,
                                    Text(
                                      coins[index].symbol!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    )
                                  ]),
                                ),
                              ),
                              SizedBox(
                                  width: screenWidth * 0.25,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Center(
                                        child: Text(coins[index].price!)),
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
                                      "${coins[index].change} %",
                                      style: TextStyle(
                                          color: _getChangeColor(double.parse(
                                              coins[index].change!))),
                                    )),
                                  )),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              SizedBox(
                                width: screenWidth * 0.29,
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Center(
                                        child: Text(coins[index].marketCap!))),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        height: 0,
                        indent: 0,
                        endIndent: 0,
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        });
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

  Widget? _imageTypeFilter(String? iconUrl, int index, List<Coin> coins) {
    if (iconUrl == null) {
      return null;
    }

    var url = iconUrl.split('?');
    int length = url[0].length;
    String lastThreeCharacters = url[0].substring(length - 3);

    if (lastThreeCharacters == "svg") {
      return SvgPicture.network(
        coins[index].iconUrl.toString(),
        width: 20,
        height: 20,
        fit: BoxFit.scaleDown,
      );
    } else {
      return Image.network(
        coins[index].iconUrl.toString(),
        width: 20,
        cacheHeight: 20,
        cacheWidth: 20,
        height: 20,
        fit: BoxFit.scaleDown,
      );
    }
  }
}
