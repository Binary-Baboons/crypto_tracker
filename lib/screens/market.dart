import 'package:flutter/material.dart';
import 'package:crypto_tracker/data/crypto_items.dart';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  State<CryptoListPage> createState() {
    return _CryptoListPageState();
  }
}

class _CryptoListPageState extends State<CryptoListPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: cryptoItems.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Column(
            children: [
              Row(children: [
                Container(
                    width: screenWidth * 0.08,
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Center(
                        child: Text(
                      cryptoItems[index].uuid,
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 10),
                    ))),
                Container(
                  decoration: BoxDecoration(color: Colors.amber),
                  width: screenWidth * 0.15,
                  child: Column(children: [
                    Text(cryptoItems[index].iconUrl),
                    Text(
                      cryptoItems[index].symbol,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )
                  ]),
                ),
                Container(
                    width: screenWidth * 0.25,
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Center(
                        child: Text(cryptoItems[index].price.toString()))),
                Container(
                    width: screenWidth * 0.15,
                    decoration: BoxDecoration(color: Colors.green),
                    child: Center(
                        child: Text(cryptoItems[index].price.toString()))),
                Container(
                    decoration: BoxDecoration(color: Colors.green),
                    width: screenWidth * 0.26,
                    child: Center(child: Text(cryptoItems[index].marketCap))),
              ]),
              Divider(
                color: Colors.black,
                thickness: 0.5,
                height: 20,
                indent: 20,
                endIndent: 20,
              ),
            ],
          ),
          onTap: () {
            print('Item clicked: ${cryptoItems[index]}');
          },
        );
      },
    );
  }
}
