import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:crypto_tracker/view/screen/enum.dart';
import 'package:crypto_tracker/view/widget/coin_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoinListWidget extends ConsumerStatefulWidget {
  CoinListWidget(this.coins, this.screen, {super.key});

  List<Coin> coins;
  Screen screen;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MarketListWidgetState();
  }
}

class _MarketListWidgetState extends ConsumerState<CoinListWidget> {
  final Map<int, double> _swipePositions = {};
  final double _swipeThreshold = 100.0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.coins.length,
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
                      _swipePositions[index] =
                          (_swipePositions[index] ?? 0) + details.primaryDelta!;
                    });
                  }
                },
                onHorizontalDragEnd: (details) =>
                    _handleSwipeEnd(index, widget.coins[index]),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Opacity(
                            opacity: (swipePosition.abs() / _swipeThreshold)
                                .clamp(0.0, 1.0),
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: Icon(
                                  color: Theme.of(context).colorScheme.primary,
                                  !widget.coins[index].favorite
                                      ? (isSwipedEnough
                                          ? Icons.favorite
                                          : Icons.favorite_border)
                                      : isSwipedEnough
                                          ? Icons.favorite_border
                                          : Icons.favorite,
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
                      child: CoinListItemWidget(widget.coins[index]),
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
  }

  void _handleSwipeEnd(int index, Coin coin) {
    if ((_swipePositions[index] ?? 0).abs() > _swipeThreshold) {
      setState(() {
        if (widget.coins[index].favorite) {
          ref.read(coinsDatabaseProvider).deleteFavoriteCoin(coin.uuid!);
          widget.coins[index].favorite = false;
          if (widget.screen == Screen.Favorites) {
            widget.coins.removeAt(index);
          }
        } else {
          ref.read(coinsDatabaseProvider).addFavoriteCoin(coin.uuid!);
          widget.coins[index].favorite = true;
        }
      });
    }
    setState(() {
      _swipePositions[index] = 0;
    });
  }
}
