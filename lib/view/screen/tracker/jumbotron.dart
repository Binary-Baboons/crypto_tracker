import 'package:crypto_tracker/model/transaction_grouping.dart';
import 'package:crypto_tracker/view/widget/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class TrackerJumbotronWidget extends StatefulWidget {
  final String price;
  final String subPrice;
  final Color subPriceColor;
  final List<TransactionSparkline?>? transactionSparkline;
  late String displayPrice;
  late String displaySubPrice;
  late Color displaySubPriceColor;

  TrackerJumbotronWidget(
    this.price,
    this.subPrice,
    this.subPriceColor,
    this.transactionSparkline,
  {super.key}
  ) {displayPrice = price; displaySubPrice = subPrice; displaySubPriceColor = subPriceColor;}

  @override
  State<StatefulWidget> createState() {
    return _TrackerJumbotronWidgetState();
  }
}

class _TrackerJumbotronWidgetState extends State<TrackerJumbotronWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.tertiaryContainer
          ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text(
              widget.displayPrice,
              style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
            Center(
              child: Text(
                widget.displaySubPrice,
                style: TextStyle(
                    fontSize: 18,
                    color: widget.displaySubPriceColor),
              ),
            ),
          const SizedBox(height: 20),
            SizedBox(
                height: 100,
                child: CryptoTrackerLineChartWidget(
                    widget.transactionSparkline!, _updateTitleWhenHovered))
        ],
      ),
    );
  }

  void _updateTitleWhenHovered(String hoveredPrice, DateTime dateTime, bool setToCurrentPrice) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (setToCurrentPrice) {
          widget.displayPrice = widget.price;
          widget.displaySubPrice = widget.subPrice;
          widget.displaySubPriceColor = widget.subPriceColor;
        } else {
          widget.displayPrice = hoveredPrice;
          widget.displaySubPrice = DateFormat("dd-MM-yyyy").format(dateTime);
          widget.displaySubPriceColor = Theme.of(context).colorScheme.onPrimaryContainer;
        }
      });
    });
  }
}
