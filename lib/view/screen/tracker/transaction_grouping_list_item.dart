import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/model/transaction_grouping.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionGroupingListItemWidget extends ConsumerWidget {
  TransactionGroupingListItemWidget(this.transactionGrouping, {super.key});

  TransactionGrouping transactionGrouping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    var imageService = ref.read(imageServiceProvider);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: screenWidth * 0.01),
      child: Row(children: [
        SizedBox(
          width: screenWidth * 0.24,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(children: [
              imageService.getImage(transactionGrouping.coin!.iconUrl, 30)!,
              Text(
                transactionGrouping.coin!.symbol,
                style: const TextStyle(fontWeight: FontWeight.w700),
              )
            ]),
          ),
        ),
        SizedBox(
            width: screenWidth * 0.24,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(
                  child: Text(PriceFormatter.formatPrice(
                      transactionGrouping.coin!.price, DefaultConfig.referenceCurrency.getSignSymbol()))),
            )),
        SizedBox(
            width: screenWidth * 0.24,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(
                  child: Column(
                children: [
                  Text(PriceFormatter.formatPrice(
                      transactionGrouping.sumAmount, "")),
                  Text(PriceFormatter.formatPrice(
                      transactionGrouping.getCurrentGroupingValue(),
                      DefaultConfig.referenceCurrency.getSignSymbol()))
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
                  Column(
                    children: [
                      Text(
                          "${PriceFormatter.formatPrice(transactionGrouping.change!, "")}%"),
                      Text(PriceFormatter.formatPrice(
                          transactionGrouping.profitAndLoss!,
                          DefaultConfig.referenceCurrency.getSignSymbol())),
                    ],
                  )
                ],
              ))),
        ),
      ]),
    );
  }
}
