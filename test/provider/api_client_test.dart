import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:http/testing.dart';

final mockIoClientProvider = Provider<IOClient>((ref) {
  return MockClient((request) async {return Response("[]", 200);}) as IOClient;
});