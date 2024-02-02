 import 'package:intl/intl.dart';

class PriceFormatter {
   static String formatPrice(
       double price, String currencySymbol) {

       return NumberFormat.currency(
           symbol: currencySymbol,
           decimalDigits: _getDecimal(price))
           .format(price);
   }

   static double roundPrice(double price) {
     return double.parse(price.toStringAsFixed(_getDecimal(price)));
   }

   static int _getDecimal(double price) {
     if (price >= 10) {
       return 2;
     }

     if (price >= 1) {
       return 3;
     }

     var stringPrice = price.toString();
     int firstNonZeroIndex = stringPrice.indexOf(RegExp(r'[1-9]'));
     return (5 + firstNonZeroIndex - stringPrice.indexOf('.') - 1).abs();
   }
}