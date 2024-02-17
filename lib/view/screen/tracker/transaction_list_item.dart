import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../model/transaction.dart';

class TransactionListItemWidget extends ConsumerStatefulWidget {
  TransactionListItemWidget(this.transaction, this._refreshTrackerScreen, {super.key});

  Transaction transaction;
  final Function _refreshTrackerScreen;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TransactionListItemWidgetState();
  }
}

class _TransactionListItemWidgetState extends ConsumerState<TransactionListItemWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Dismissible(
      key: Key(widget.transaction.transactionId),
      onDismissed: (direction) {
        ref
            .read(transactionServiceProvider)
            .deleteTransaction(widget.transaction.transactionId);
        widget._refreshTrackerScreen();
      },
      child: Padding(
        padding:
        EdgeInsets.symmetric(vertical: 10, horizontal: screenWidth * 0.01),
        child: Row(children: [
          SizedBox(
              width: screenWidth * 0.24,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Center(
                    child: Column(
                      children: [
                        Text(DateFormat('dd-MM-yyyy').format(widget.transaction.dateTime)),
                        Text(DateFormat('HH:mm').format(widget.transaction.dateTime)),
                      ],
                    )),
              )),
          SizedBox(
            width: screenWidth * 0.24,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Center(
                    child: Column(
                      children: [
                        Text(widget.transaction.source.getValueOnly),
                        Text(widget.transaction.type.getValueOnly),
                      ],
                    ))),
          ),
          SizedBox(
            width: screenWidth * 0.24,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(widget.transaction.amount.toString())),
          ),
          SizedBox(
              width: screenWidth * 0.24,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(PriceFormatter.formatPrice(widget.transaction.priceForAmount, DefaultConfig.referenceCurrency.getSignSymbol(), true)))
          ),
        ]),
      ),
    );
  }

}