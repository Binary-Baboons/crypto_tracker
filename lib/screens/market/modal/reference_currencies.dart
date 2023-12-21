import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:flutter/material.dart';

class ReferenceCurrenciesModal extends StatelessWidget {
  ReferenceCurrenciesModal(
      this.currencies, {super.key});

  late Future<(List<ReferenceCurrency>, String?)> currencies;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Search by Name'),
      content: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(hintText: 'Type here...'),
          ),
          FutureBuilder(future: currencies, builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              throw Exception();
            }

            if (snapshot.hasData) {
              if (snapshot.data!.$2 != null) {
                throw Exception();
              }

              return ListView.builder(itemCount: snapshot.data!.$1.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Text((snapshot.data!.$1[index]).name!),
                      ],
                    );
                  });
            }

            return const Center(child: CircularProgressIndicator());
          })
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            String search = _searchController.text;

            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }

}