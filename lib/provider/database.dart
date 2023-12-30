import 'package:crypto_tracker/database/coins.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinsDatabaseProvider = Provider<CoinsDatabase>((ref) {
  return CoinsDatabase();
});