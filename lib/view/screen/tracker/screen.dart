import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/plColor.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/model/transaction.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/view/screen/tracker/modal/new_transaction.dart';
import 'package:crypto_tracker/view/screen/tracker/transaction_grouping_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../error/handler.dart';
import '../../../model/transaction_grouping.dart';
import '../../../service/transaction.dart';
import 'jumbotron.dart';

class TrackerScreen extends ConsumerStatefulWidget {
  const TrackerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TrackerScreenState();
  }
}

class _TrackerScreenState extends ConsumerState<TrackerScreen> {
  late Future<List<TransactionGrouping>> transactionGroupings;

  late TransactionService transactionService;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    transactionService = ref.read(transactionServiceProvider);
    transactionGroupings = transactionService.getTransactionGroupings();

    return Scaffold(
      body: FutureBuilder(
        future: transactionGroupings,
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
            double totalValue = snapshot.data!
                .map((tg) => tg.groupingValue!)
                .fold(0.0, (value, element) => value + element);
            double totalProfitAndLoss = snapshot.data!
                .map((tg) => tg.profitAndLoss!)
                .fold(0.0, (value, element) => value + element);
            double totalSpent = snapshot.data!
                .map((tg) => tg.totalSpent)
                .fold(0.0, (value, element) => value + element);
            double totalChange =
                totalSpent != 0 ? (totalProfitAndLoss / totalSpent) * 100 : 0;

            List<List<TransactionSparkline>?> listOfSparklines = snapshot.data!
                .map((tg) => tg.transactionSparkline)
                .toList();

            List<TransactionSparkline> sumSparkline = [];
            for (int i = 0; i < listOfSparklines.first!.length; i++) {
              double sum = 0;
              for (int j = 0; j < listOfSparklines.length; j++) {
                sum += listOfSparklines[j]![i].value;
              }
              sumSparkline.add(TransactionSparkline(listOfSparklines.first![i].dateTime, sum));
            }

            return Column(
              children: [
                TrackerJumbotronWidget(
                  PriceFormatter.formatPrice(totalValue,
                      DefaultConfig.referenceCurrency.getSignSymbol()),
                  "${PriceFormatter.formatPrice(totalProfitAndLoss, DefaultConfig.referenceCurrency.getSignSymbol())} (${PriceFormatter.roundPrice(totalChange)}%)",
                  PLColorFormatter.getColor(totalProfitAndLoss, context),
                  sumSparkline,
                ),
                Container(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: screenWidth * 0.01),
                    child: Row(children: [
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: Center(
                            child: Text('COIN',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer))),
                      ),
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: Center(
                            child: Text('PRICE',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer))),
                      ),
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: Center(
                            child: Text('HOLDINGS',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer))),
                      ),
                      SizedBox(
                        width: screenWidth * 0.24,
                        child: Center(
                            child: Text('P&L',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer))),
                      )
                    ])),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,

                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            TransactionGroupingListItemWidget(
                                snapshot.data![index], _refreshTrackerScreen),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future<void> futureVoid = showModalBottomSheet<Transaction>(
              isScrollControlled: true,
              context: context,
              builder: (ctx) => const NewTransactionModal());
          futureVoid.then((value) => setState(() {
                transactionGroupings =
                    transactionService.getTransactionGroupings();
              }));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  void _refreshTrackerScreen() {
    setState(() {

    });
  }
}
