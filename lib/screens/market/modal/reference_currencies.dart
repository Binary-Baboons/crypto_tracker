import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_tracker/provider/reference_currency.dart';

class ReferenceCurrenciesModal extends ConsumerWidget {
  ReferenceCurrenciesModal(this.currencies, {super.key});

  late Future<(List<ReferenceCurrency>, String?)> currencies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Container(
        color: Color.fromARGB(255, 2, 32, 54),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Select currency',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Container(
                  child: IconButton(
                      color: Colors.white,
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
              if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text(snapshot.error.toString())));
                });
              }

              if (snapshot.hasData) {
                if (snapshot.data!.$2 != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text(snapshot.data!.$2!)));
                  });
                }

                return ListView.builder(
                  itemCount: snapshot.data!.$1.length,
                  itemExtent: 70.0,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Container(
                          child: TextButton(
                              onPressed: () {
                                var selectedCurrency = snapshot.data!.$1[index];
                                ref
                                    .read(
                                        referenceCurrencyStateProvider.notifier)
                                    .state = selectedCurrency;
                                Navigator.of(context).pop(selectedCurrency);
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                          snapshot.data!.$1[index].toString()),
                                    ),
                                    Container(
                                      child: currentCurrencyMarking(
                                          ref, snapshot.data!.$1[index]),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                    );
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
      )
    ]);
  }

  Widget? currentCurrencyMarking(
      WidgetRef ref, ReferenceCurrency currentCurrency) {
    var activeCurrency = ref.read(referenceCurrencyStateProvider);
    if (currentCurrency.uuid == activeCurrency.uuid) {
      return const Icon(
        Icons.check_circle,
        color: Color.fromARGB(255, 2, 32, 54),
      );
    } else {
      return null;
    }
  }
}
