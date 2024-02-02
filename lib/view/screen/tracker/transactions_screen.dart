import 'package:crypto_tracker/model/transaction.dart';
import 'package:crypto_tracker/model/transaction_grouping.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/view/screen/tracker/transaction_list_item.dart';
import 'package:crypto_tracker/view/widget/coin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/default.dart';
import '../../../error/handler.dart';
import '../../../formatter/plColor.dart';
import '../../../formatter/price.dart';
import '../../../service/transaction.dart';
import 'jumbotron.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  TransactionScreen(this.transactionGrouping, this._refreshTrackerScreen, {super.key});

  TransactionGrouping transactionGrouping;
  Function _refreshTrackerScreen;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TransactionScreenState();
  }
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  late Future<List<Transaction>> transactions;

  late TransactionService transactionService;

  @override
  void initState() {
    super.initState();
    transactionService = ref.read(transactionServiceProvider);

    transactions = transactionService.getTransactions(widget.transactionGrouping.coin!.uuid);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CoinAppBar(widget.transactionGrouping.coin!, actions: [IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.onPrimaryContainer))]),
      body: FutureBuilder(
        future: transactions,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    backgroundColor:
                    Theme.of(context).colorScheme.errorContainer,
                    content: Text(
                        ErrorHandler.getUserFriendlyMessage(snapshot.error!),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error))));
            });
            return Container();
          } else if (snapshot.hasData) {

            return Column(
              children: [
                TrackerJumbotronWidget(
                  PriceFormatter.formatPrice(widget.transactionGrouping.groupingValue!,
                      DefaultConfig.referenceCurrency.getSignSymbol()),
                  "${PriceFormatter.formatPrice(widget.transactionGrouping.profitAndLoss!, DefaultConfig.referenceCurrency.getSignSymbol())} (${PriceFormatter.roundPrice(widget.transactionGrouping.change!)}%)",
                  PLColorFormatter.getColor(widget.transactionGrouping.profitAndLoss!, context),
                  widget.transactionGrouping.transactionSparkline,
                ),
                Container(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: screenWidth * 0.01),
                    child: Row(children: [
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: Center(
                            child: Text('DATE',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer))),
                      ),
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: Center(child: Text('TYPE', style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer))),
                      ),
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: Center(child: Text('AMOUNT', style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer))),
                      ),
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: Center(child: Text('SPENT', style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer))),
                      )
                    ])),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            TransactionListItemWidget(
                                snapshot.data![index], widget._refreshTrackerScreen),
                            Divider(
                              color: Theme.of(context).colorScheme.outline,
                              height: 1,
                              indent: 0,
                              endIndent: 0,
                            ),
                          ],
                        );
                      }),
                )
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
