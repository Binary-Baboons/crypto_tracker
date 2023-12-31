import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SwipeToToggleFavorites(),
    );
  }
}

class SwipeToToggleFavorites extends StatefulWidget {
  @override
  _SwipeToToggleFavoritesState createState() => _SwipeToToggleFavoritesState();
}

class _SwipeToToggleFavoritesState extends State<SwipeToToggleFavorites> {
  final List<bool> _favorites = List.generate(20, (_) => false);
  final Map<int, double> _swipePositions = {};
  final double _swipeThreshold = 100.0;

  void _handleSwipeEnd(int index) {
    if ((_swipePositions[index] ?? 0).abs() > _swipeThreshold) {
      setState(() {
        _favorites[index] = !_favorites[index];
      });
    }
    setState(() {
      _swipePositions[index] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Swipe to Toggle Favorites')),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final swipePosition = _swipePositions[index] ?? 0;
          final isSwipedEnough = swipePosition.abs() > _swipeThreshold;

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _swipePositions[index] = (_swipePositions[index] ?? 0) + details.primaryDelta!;
              });
            },
            onHorizontalDragEnd: (details) => _handleSwipeEnd(index),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: (swipePosition.abs() / _swipeThreshold).clamp(0.0, 1.0),
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Icon(
                              !_favorites[index] ? (isSwipedEnough ? Icons.favorite : Icons.favorite_border) : isSwipedEnough ? Icons.favorite_border : Icons.favorite,
                              key: ValueKey<bool>(isSwipedEnough),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(swipePosition, 0),
                  child: ListTile(
                    title: Text('Item ${index + 1}'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
