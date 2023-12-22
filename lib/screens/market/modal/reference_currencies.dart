import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/screens/market/market_screen.dart';
import "package:riverpod/riverpod.dart";

class ReferenceCurrenciesModal extends StatelessWidget {
  ReferenceCurrenciesModal(this.currencies, {super.key});

  late Future<(List<ReferenceCurrency>, String?)> currencies;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Color.fromARGB(255, 2, 32, 54),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                )
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
                throw Exception();
              }

              if (snapshot.hasData) {
                if (snapshot.data!.$2 != null) {
                  throw Exception();
                }

                return ListView.builder(
                  itemCount: snapshot.data!.$1.length,
                  itemExtent: 70.0, // Fixed height for each item
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: TextButton(
                          onPressed: () {},
                          child: Text(snapshot.data!.$1[index].toString())),
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
