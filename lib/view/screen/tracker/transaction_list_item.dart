import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../model/transaction.dart';

class TransactionListItemWidget extends ConsumerWidget {
  TransactionListItemWidget(this.transaction, this._refreshTrackerScreen, {super.key});

  Transaction transaction;
  Function _refreshTrackerScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Dismissible(
      key: Key(transaction.transactionId),
      onDismissed: (direction) {
        ref
            .read(transactionServiceProvider)
            .deleteTransaction(transaction.transactionId);
        _refreshTrackerScreen();
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
                    Text(DateFormat('dd-MM-yyyy').format(transaction.dateTime)),
                    Text(DateFormat('HH:mm').format(transaction.dateTime)),
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
                    Text(transaction.source.getValueOnly),
                    Text(transaction.type.getValueOnly),
                  ],
                ))),
          ),
          SizedBox(
            width: screenWidth * 0.24,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(transaction.amount.toString())),
          ),
          SizedBox(
            width: screenWidth * 0.24,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(transaction.priceForAmount.toString())),
          ),
        ]),
      ),
    );
  }
}
