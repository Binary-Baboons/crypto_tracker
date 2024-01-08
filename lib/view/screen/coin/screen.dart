import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:fl_chart/fl_chart.dart';
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
    var imageService = ref.read(imageServiceProvider);
    List<FlSpot> spots = _convertStringListToFlSpots(coin.sparkline);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          coin.name,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _addToFavorites(coin);
              },
              icon: Icon(
                coin.favorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.onPrimary,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: imageService.getImage(coin.iconUrl, 100)),
                  SizedBox(height: 16),
                  Text(
                    coin.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Symbol: ${coin.symbol}',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Price: ${PriceFormatter.formatPrice(coin.price, DefaultConfig.referenceCurrency.getSignSymbol())}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Market Cap: ${PriceFormatter.formatPrice(coin.marketCap, DefaultConfig.referenceCurrency.getSignSymbol())}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Change: ${coin.change}%',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Price Trend (Sparkline)',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                            spots: spots,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _convertStringListToFlSpots(List<double?> dataString) {
    return List.generate(dataString.length, (index) {
      double value =
          (dataString[index] != null) ? dataString[index]! : 0.0;
      return FlSpot(index.toDouble(), value);
    });
  }

  void _addToFavorites(Coin coin) {
    var coinService = ref.read(coinsServiceProvider);

    setState(() {
      if (coin.favorite) {
        coinService.deleteFavoriteCoin(coin.uuid!);
        coin.favorite = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text("${coin.name} has been removed from favorites")));
      } else {
        coinService.addFavoriteCoin(coin.uuid!);
        coin.favorite = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text("${coin.name} has been added to favorites")));
      }
    });
  }
}
