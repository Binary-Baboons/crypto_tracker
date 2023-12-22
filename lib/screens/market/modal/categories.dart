import 'package:crypto_tracker/api/data/coins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesModal extends ConsumerWidget {
  CategoriesModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: ListView.builder(
        itemCount: Tags.values.length,
        itemExtent: 70.0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: TextButton(
                onPressed: () {
                },
                child: Text(Tags.values[index].getValueWithDash)),
          );
        },
      ))
    ]);
  }
}
