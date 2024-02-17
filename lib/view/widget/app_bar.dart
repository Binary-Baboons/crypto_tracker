import 'package:flutter/material.dart';

class CryptoTrackerAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  CryptoTrackerAppBar({this.actions, super.key});

  List<Widget>? actions;

  @override
  State<StatefulWidget> createState() {
    return _CryptoTrackerAppBarState();
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _CryptoTrackerAppBarState extends State<CryptoTrackerAppBar> {
  @override
  Widget build(BuildContext context) {
    bool canPop = Navigator.canPop(context);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            height: 30,
            width: 30,
            cacheWidth: 300,
            cacheHeight: 300,
          ),
          const SizedBox(width: 10),
          Text(
            'Crypto tracker',
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
