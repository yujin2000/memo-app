import 'package:intl/intl.dart';

class MemoDataUtils {
  static String formatDate(String format, DateTime date) {
    return DateFormat(format).format(date);
  }
}
