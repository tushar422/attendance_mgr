class DateFormatting {
  static String ddmmyyFormat(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String engFormat(DateTime date) {
    return '${date.day}${simpleDaySuffix(date)} ${mmmFormat(date)} ${date.year}';
  }

  static String simpleDaySuffix(DateTime date) {
    String day = date.day.toString();
    if (day.endsWith('1')) {
      return 'st'; //st
    } else if (day.endsWith('2')) {
      return 'nd'; //nd
    } else if (day.endsWith('3')) {
      return 'rd'; //rd
    } else {
      return 'th'; // th
    }
  }

  static String daySuffix(DateTime date) {
    String day = date.day.toString();
    if (day.endsWith('1')) {
      return '\u02e2\u1d57'; //st
    } else if (day.endsWith('2')) {
      return '\u207f\u1d48'; //nd
    } else if (day.endsWith('3')) {
      return '\u02b3\u1d48'; //rd
    } else {
      return '\u1d57\u02b0'; // th
    }
  }

  static String mmmFormat(DateTime date) {
    List<String> month = [
      'error',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return month[date.month];
  }
}
