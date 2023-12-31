import 'package:crypto_tracker/error/handler.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/screens/market/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketListWidget extends ConsumerStatefulWidget {
  MarketListWidget(this.futureCoins, {super.key});

  final Future<List<Coin>> futureCoins;
  late List<bool> favorites;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MarketListWidgetState();
  }
}

class _MarketListWidgetState extends ConsumerState<MarketListWidget> {
  final Map<int, double> _swipePositions = {};
  final double _swipeThreshold = 100.0;
  late List<bool> _favorites;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.futureCoins,
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
            _favorites = coins.map((c) => c.favorite).toList();

            return ListView.builder(
              itemCount: coins.length,
              itemBuilder: (BuildContext context, int index) {
                final swipePosition = _swipePositions[index] ?? 0;
                final isSwipedEnough = swipePosition.abs() > _swipeThreshold;

                return Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                        GestureDetector(
                          onTap: () {},
                          onHorizontalDragUpdate: (details) {
                            if ((details.primaryDelta! < 0)) {
                            setState(() {
                              _swipePositions[index] = (_swipePositions[index] ?? 0) + details.primaryDelta!;
                            });}
                          },
                          onHorizontalDragEnd: (details) => _handleSwipeEnd(index, coins[index]),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Opacity(
                                      opacity: (swipePosition.abs() / _swipeThreshold).clamp(0.0, 1.0),
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 20.0),
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 300),
                                          child: Icon(
                                            color: Theme.of(context).colorScheme.primary,
                                            !_favorites[index] ? (isSwipedEnough ? Icons.favorite : Icons.favorite_border) : isSwipedEnough ? Icons.favorite_border : Icons.favorite,
                                            key: ValueKey<bool>(isSwipedEnough),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(swipePosition, 0),
                                  child: ListItemWidget(coins[index]),
                                ),
                            ],
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

  void _handleSwipeEnd(int index, Coin coin) {
    if ((_swipePositions[index] ?? 0).abs() > _swipeThreshold) {
      setState(() {
        if (_favorites[index]) {
          ref.read(coinsDatabaseProvider).deleteFavoriteCoin(coin.uuid!);
          _favorites[index] = false;
        } else {
          ref.read(coinsDatabaseProvider).addFavoriteCoin(coin.uuid!);
          _favorites[index] = true;
        }
      });
    }
    setState(() {
      _swipePositions[index] = 0;
    });
  }

}