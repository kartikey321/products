import 'package:intl/intl.dart';

extension IntIndianFormat on double {
  String formatIndianCurrency({int? decimalDigits}) {
    var format = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u{20B9} ',
      decimalDigits: decimalDigits,
    );
    return '${format.format(this)}/-';
  }
}
