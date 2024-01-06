import 'package:crypto_tracker/model/transaction_grouping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionGroupingListItemWidget extends ConsumerWidget {
  TransactionGroupingListItemWidget(this.transactionGrouping, {super.key});

  TransactionGrouping transactionGrouping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        SizedBox(
            width: screenWidth * 0.25,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(child: Text(transactionGrouping.coinUuid)),
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
                    transactionGrouping.sumAmount.toString(),
                  )),
            )),
        SizedBox(
          width: screenWidth * 0.29,
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(child: Text(transactionGrouping.averagePrice.toString()))),
        ),
      ]),
    );
  }

}