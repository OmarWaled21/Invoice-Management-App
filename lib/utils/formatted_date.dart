import 'package:intl/intl.dart';

class FormattedDate{
  final DateTime dateTime;

  FormattedDate(this.dateTime);

  // Factory constructor to create from a string
  factory FormattedDate.fromString(String dateString, {String format = 'yyyy-MM-dd'}) {
    return FormattedDate(DateFormat(format).parse(dateString));
  }

  // Format date as '15 October'
  String get formattedDayFullMonth {
    return DateFormat('d MMMM').format(dateTime);
  }

  // Format date as '15 Oct'
  String get formattedDayShortMonth {
    return DateFormat('d MMM. yyyy').format(dateTime);
  }

  // Format date as '06 octobre' in French
  String get formattedDayFullMonthFrench {
    return DateFormat('dd MMMM', 'fr').format(dateTime);
  }

  // Format date as '06/10/24' in French
  String get originalFormattedDaySlash {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  // Format date as '06-10-24' in French
  String get originalFormattedDayLine {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  // Calculate the duration between this date and another date in days
  int daysBetween(DateTime otherDate) {
    return dateTime.difference(otherDate).inDays.abs();
  }
}