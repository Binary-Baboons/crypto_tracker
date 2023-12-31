import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../error/handler.dart';
import '../../../model/coin.dart';
import '../../widget/coin_list.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FavoriteScreenState();
  }
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  late Future<List<Coin>> coins;

  @override
  void initState() {
    super.initState();
    coins = ref.read(coinsServiceProvider).getFavoriteCoins();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: coins,
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
            return CoinListWidget(snapshot.data!);
          } else {
            return CoinListWidget([]);
          }
        });
  }
}
