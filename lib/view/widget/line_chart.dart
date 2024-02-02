import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/model/transaction_grouping.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CryptoTrackerLineChartWidget extends StatefulWidget {
  CryptoTrackerLineChartWidget(this.transactionSparkline, this.refreshFn, {super.key});

  List<TransactionSparkline?> transactionSparkline;
  Function(String, DateTime, bool) refreshFn;

  @override
  State<StatefulWidget> createState() {
    return _CryptoTrackerLineChartWidgetState();
  }
}

class _CryptoTrackerLineChartWidgetState extends State<CryptoTrackerLineChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerUp: (sd) {
          widget.refreshFn("", DateTime.now(), true);
        },
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
              return indicators.map((index) {
                return const TouchedSpotIndicatorData(
                  FlLine(color: Colors.transparent),
                  FlDotData(
                    show: true,)
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).colorScheme.onPrimaryContainer,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  var hoveredPrice = PriceFormatter.formatPrice(barSpot.y, DefaultConfig.referenceCurrency.getSignSymbol());
                  widget.refreshFn(hoveredPrice, widget.transactionSparkline[barSpot.x.round()]!.dateTime, false);
                }).toList();
              },

            ),
          ),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: false,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              spots: _convertStringListToFlSpots(widget.transactionSparkline.map((e) => e!.value).toList()),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      )
    );
  }

  List<FlSpot> _convertStringListToFlSpots(List<double?> dataString) {
    return List.generate(dataString.length, (index) {
      double value = (dataString[index] != null) ? dataString[index]! : 0.0;
      return FlSpot(index.toDouble(), PriceFormatter.roundPrice(value));
    });
  }
}