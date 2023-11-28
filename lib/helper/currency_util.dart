import 'package:intl/intl.dart';

class CurrencyUtil {
  static String toIdr(double? value) {
    NumberFormat formatter = NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
    if (value != null) {
      int mod = (value % 1 == 0)
          ? 0
          : ((value * 10) % 1 == 0)
              ? 1
              : ((value * 100) % 1 == 0)
                  ? 2
                  : ((value * 1000) % 1 == 0)
                      ? 3
                      : 4;
      formatter = NumberFormat.currency(locale: 'id', decimalDigits: mod, symbol: 'Rp. ');
      return formatter.format(value);
    }
    return "-";
  }

  static String stringToIdr(String value) {
    double parsed = 0;
    if (value.isNotEmpty) {
      try {
        parsed = double.parse(value);
      } catch (e) {
        return 'invalid format';
      }

      return toIdr(parsed);
    }
    return 'Rp. 0';
  }
}
