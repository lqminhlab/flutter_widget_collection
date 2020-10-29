import 'dart:core';

class DateUtil {
  static String day(int length) {
    List<String> day = [
      "Saturday",
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday"
    ];

    int count = 0;
    String resultDay;

    for (int counter = 1; counter <= length; counter++) {
      bool check = ((counter > 639798) && (counter < 639811));
      if (check == true) {
      } else {
        if (count >= 7) {
          if (count % 7 == 0) count = 0;
        }

        resultDay = day[count];

        count++;
      }
    }
    return resultDay;
  }

  static String month(int monthNum) {
    List<String> month = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return month[monthNum - 1];
  }

  static daysInMonth(int monthNum, int year) {
    List<int> monthLength = new List(12);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true)
      monthLength[1] = 29;
    else
      monthLength[1] = 28;

    return monthLength[monthNum - 1];
  }

  static bool leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true)
      leapYear = false;
    else if (year % 4 == 0) leapYear = true;

    return leapYear;
  }
}
