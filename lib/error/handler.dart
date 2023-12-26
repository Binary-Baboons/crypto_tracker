import 'dart:io';

class ErrorHandler {

  static Map<Type, String> exceptionToMessage = {
    SocketException: "Unable to connect to the internet. Please check your network settings and try again.",
    HttpException: "We're having trouble connecting to the server. Please try again later.",
    FormatException: "We're having trouble processing the response from the server. Please try again later.",
    HandshakeException: "There was a problem establishing a secure connection. Please try again later.",
    IOException: "We encountered an issue while sending or receiving data. Please try again.",
  };

  static String internalAppError = "We have encountered a internal application error. Please report it to the devs.";

  static String getUserFriendlyMessage(Object e) {
    for (Type type in exceptionToMessage.keys) {
      if (type == e.runtimeType || e.toString().contains(type.toString())) {
        return exceptionToMessage[type]!;
      }
    }

    return internalAppError;
  }
}