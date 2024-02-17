import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/view/widget/coin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/coin.dart';

class CoinScreen extends ConsumerStatefulWidget {
  CoinScreen(this.coin, {super.key});

  Coin coin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CoinScreenState();
  }
}

class _CoinScreenState extends ConsumerState<CoinScreen> {
  @override
  Widget build(BuildContext context) {
    var coin = widget.coin;

    return Scaffold(
      appBar: CoinAppBar(
        coin,
        actions: [
          IconButton(
              onPressed: () {
                _addToFavorites(coin);
              },
              icon: Icon(
                coin.favorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.tertiaryContainer
                ])
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symbol: ${coin.symbol}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: ${PriceFormatter.formatPrice(coin.price, DefaultConfig.referenceCurrency.getSignSymbol(), true)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Market Cap: ${PriceFormatter.formatPrice(coin.marketCap, DefaultConfig.referenceCurrency.getSignSymbol(), true)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Change: ${coin.change}%',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Price Trend (Sparkline)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToFavorites(Coin coin) {
    var coinService = ref.read(coinsServiceProvider);

    setState(() {
      if (coin.favorite) {
        coinService.deleteFavoriteCoin(coin.uuid);
        coin.favorite = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text("${coin.name} has been removed from favorites")));
      } else {
        coinService.addFavoriteCoin(coin.uuid);
        coin.favorite = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text("${coin.name} has been added to favorites")));
      }
    });
  }
}
