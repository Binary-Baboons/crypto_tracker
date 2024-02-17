import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/coin.dart';

class CoinAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  CoinAppBar(this.coin, {this.actions, super.key});

  Coin coin;
  List<Widget>? actions;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CoinAppBarState();
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _CoinAppBarState extends ConsumerState<CoinAppBar> {
  @override
  Widget build(BuildContext context) {
    bool canPop = Navigator.canPop(context);
    var image = ref.read(imageServiceProvider).getImage(widget.coin.iconUrl, 20);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          const SizedBox(width: 10),
          Text(
            widget.coin.name,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ],
      ),
      actions: widget.actions,
      leading: canPop
          ? IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
          onPressed: () => Navigator.of(context).pop())
          : null,
    );
  }
}
