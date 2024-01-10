import 'dart:io';

import 'package:http/http.dart';

import 'exception/empty_result.dart';

class ErrorHandler {
  static String internalAppError =
      "We have encountered a internal application error. Please report it to the devs.";

  static Set<Type> exceptions = {ClientException, EmptyResultException};

  static Map<Type, String> exceptionToMessage = {
    SocketException:
        "Unable to connect to the internet. Please check your network settings and try again.",
    HttpException:
        "We're having trouble connecting to the server. Please try again later.",
    FormatException:
        "We're having trouble processing the response from the server. Please try again later.",
    HandshakeException:
        "There was a problem establishing a secure connection. Please try again later.",
    IOException:
        "We encountered an issue while sending or receiving data. Please try again.",
  };

  static String getUserFriendlyMessage(Object e) {
    if (e is! Exception) {
      print(e);
      return internalAppError;
    }

    if (exceptions.contains(e.runtimeType)) {
      return e.toString();
    }

    if (exceptionToMessage[e.runtimeType] != null) {
      return exceptionToMessage[e.runtimeType]!;
    }

    for (Type type in exceptionToMessage.keys) {
      if (e.toString().contains(type.toString())) {
        return exceptionToMessage[type]!;
      }
    }

    return internalAppError;
  }
}
