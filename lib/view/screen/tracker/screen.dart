import 'package:crypto_tracker/model/transaction.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/view/screen/tracker/modal/new_transaction.dart';
import 'package:crypto_tracker/view/screen/tracker/transaction_grouping_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../error/handler.dart';
import '../../../model/transaction_grouping.dart';
import '../../../service/transaction.dart';

class TrackerScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TrackerScreenState();
  }
}

class _TrackerScreenState extends ConsumerState<TrackerScreen> {
  late Future<List<TransactionGrouping>> transactionGroupings;

  late TransactionService transactionService;

  @override
  void initState() {
    super.initState();
    transactionService = ref.read(transactionServiceProvider);

    transactionGroupings = transactionService.getTransactionGroupings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
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
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TransactionGroupingListItemWidget(
                        snapshot.data![index]);
                  });
            } else {
              return Container();
            }
          },
        ),
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
}
