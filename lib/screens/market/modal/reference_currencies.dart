import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:flutter/material.dart';

class ReferenceCurrenciesModal extends StatelessWidget {
  ReferenceCurrenciesModal(this.currencies, {super.key});

  late Future<(List<ReferenceCurrency>, String?)> currencies;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: FutureBuilder(
            future: currencies,
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                throw Exception();
              }

              if (snapshot.hasData) {
                if (snapshot.data!.$2 != null) {
                  throw Exception();
                }

                return ListView.builder(
                  itemCount: snapshot.data!.$1.length,
                  itemExtent: 90.0, // Fixed height for each item
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data!.$1[index].toString()),
                    );
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
      )
    ]);
  }
}
