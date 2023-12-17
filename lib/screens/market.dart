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

    return Container(
      child: ListView.builder(
        itemCount: cryptoItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Row(children: [
              Container(
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Text(cryptoItems[index].uuid)),
              Container(
                decoration: BoxDecoration(color: Colors.amber),
                width: screenWidth * 0.2,
                child: Column(children: [
                  Text(cryptoItems[index].iconUrl),
                  Text(cryptoItems[index].symbol)
                ]),
              ),
              Container(
                  width: screenWidth * 0.25,
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Text(cryptoItems[index].price.toString())),
              Container(
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(color: Colors.green),
                  child: Text(cryptoItems[index].price.toString())),
              Container(
                  decoration: BoxDecoration(color: Colors.green),
                  width: screenWidth * 0.15,
                  child: Text(cryptoItems[index].marketCap)),
            ]),
            onTap: () {
              print('Item clicked: ${cryptoItems[index]}');
            },
          );
        },
      ),
    );
  }
}
