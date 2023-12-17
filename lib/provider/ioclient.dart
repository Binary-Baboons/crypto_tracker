import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

final ioClientProvider = Provider<IOClient>((ref) {
  return IOClient();
});