import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/provider/reference_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferenceCurrenciesModal extends ConsumerStatefulWidget {
  ReferenceCurrenciesModal({super.key});

  Future<List<ReferenceCurrency>>? currencies;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ReferenceCurrenciesModalState();
  }
}

class _ReferenceCurrenciesModalState
    extends ConsumerState<ReferenceCurrenciesModal> {
  @override
  void initState() {
    super.initState();
    widget.currencies = ref.read(referenceCurrenciesStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    var currencies = widget.currencies;

    return Column(children: [
      Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Select currency',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 20),
                  ),
                ),
                Container(
                  child: IconButton(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)),
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: FutureBuilder(
            future: currencies,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return createListTile(
                    context, ref, DefaultConfig.referenceCurrency);
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemExtent: 70.0,
                  itemBuilder: (BuildContext context, int index) {
                    return createListTile(ctx, ref, snapshot.data![index]);
                  },
                );
              } else {
                return createListTile(
                    context, ref, DefaultConfig.referenceCurrency);
              }
            }),
      )
    ]);
  }

  Widget createListTile(
      BuildContext context, WidgetRef ref, ReferenceCurrency currency) {
    return ListTile(
      title: SizedBox(
        height: 50,
        child: TextButton(
            onPressed: () {
              ref.read(selectedReferenceCurrencyStateProvider.notifier).state =
                  currency;
              Navigator.of(context).pop(currency);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currency.toString()),
                Container(
                  child: currentCurrencyMarking(ref, currency),
                )
              ],
            )),
      ),
    );
  }

  Widget? currentCurrencyMarking(
      WidgetRef ref, ReferenceCurrency currentCurrency) {
    var activeCurrency = ref.read(selectedReferenceCurrencyStateProvider);
    if (currentCurrency.uuid == activeCurrency.uuid) {
      return Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.primary,
      );
    } else {
      return null;
    }
  }
}
