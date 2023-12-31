import 'package:crypto_tracker/provider/database.dart';
import 'package:crypto_tracker/view/screen/favorite/screen.dart';
import 'package:crypto_tracker/view/screen/market/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load();
  runApp(const ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CryptoTrackerApp(),
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(8, 42, 64, 1),
              brightness: Brightness.light)),
    );
  }
}

class CryptoTrackerApp extends ConsumerStatefulWidget {
  const CryptoTrackerApp({super.key});

  @override
  ConsumerState<CryptoTrackerApp> createState() => _CryptoTrackerAppState();
}

class _CryptoTrackerAppState extends ConsumerState<CryptoTrackerApp> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 30,
                width: 30,
                cacheWidth: 300,
                cacheHeight: 300,
              ),
              SizedBox(width: 10),
              Text(
                'Crypto tracker',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: getWidgetOptions().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.align_vertical_bottom),
            label: 'Market',
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        onTap: _onItemTapped,
      ),
    );
  }

  List<Widget> getWidgetOptions() {
    return <Widget>[
      const MarketScreen(),
      FavoriteScreen(),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
      Text(
        'Index 3: Settings',
        style: optionStyle,
      ),
    ];
  }
}
