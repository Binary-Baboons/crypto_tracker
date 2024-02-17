import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/plColor.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/model/transaction_grouping.dart';
import 'package:crypto_tracker/provider/general.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/view/screen/tracker/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionGroupingListItemWidget extends ConsumerWidget {
  TransactionGroupingListItemWidget(this.transactionGrouping, this._refreshTrackerScreen, {super.key});

  TransactionGrouping transactionGrouping;
  final Function _refreshTrackerScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    var imageService = ref.read(imageServiceProvider);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransactionScreen(transactionGrouping, _refreshTrackerScreen)),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: screenWidth * 0.01),
        child: Row(children: [
          SizedBox(
            width: screenWidth * 0.24,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(children: [
                imageService.getImage(transactionGrouping.coin!.iconUrl, 30),
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
                        transactionGrouping.coin!.price, DefaultConfig.referenceCurrency.getSignSymbol(), true))),
              )),
          SizedBox(
              width: screenWidth * 0.24,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Center(
                    child: Column(
                  children: [
                    Text(PriceFormatter.roundPrice(
                        transactionGrouping.sumAmount).toString()),
                    Text(PriceFormatter.formatPrice(
                        transactionGrouping.groupingValue!,
                        DefaultConfig.referenceCurrency.getSignSymbol(), true))
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
                        Text(PriceFormatter.formatPrice(
                            transactionGrouping.profitAndLoss!,
                            DefaultConfig.referenceCurrency.getSignSymbol(), true), style: TextStyle(color: PLColorFormatter.getColor(transactionGrouping.profitAndLoss!, context))),
                        Text(
                            PriceFormatter.formatPrice(transactionGrouping.change!, "%", true), style: TextStyle(color: PLColorFormatter.getColor(transactionGrouping.change!, context))),
                      ],
                    )
                  ],
                ))),
          ),
        ]),
      ),
    );
  }
}
