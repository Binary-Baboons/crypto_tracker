import 'dart:io';

import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/error/handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  group('ErrorHandler', () {
    test('getUserFriendlyMessage receives a Exception', () async {
      var exception = Exception("Internal error");
      var msg = ErrorHandler.getUserFriendlyMessage(exception);
      expect(msg, ErrorHandler.internalAppError);
    });

    test('getUserFriendlyMessage receives a ClientException', () async {
      var exception = http.ClientException("No network");
      var msg = ErrorHandler.getUserFriendlyMessage(exception);
      expect(msg, "ClientException: No network");
    });

    test('getUserFriendlyMessage receives a SocketException', () async {
      var exception = SocketException("Socket exception");
      var msg = ErrorHandler.getUserFriendlyMessage(exception);
      expect(msg, ErrorHandler.exceptionToMessage[SocketException]);
    });
  });
}
