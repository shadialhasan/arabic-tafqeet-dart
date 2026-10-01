/**
 * High Accuracy Arabic Number-to-Words Converter (Tafqeet)
 * Author: Eng. MHD. Shadi AL-Hasan <mhd.shadi.alhasan@gmail.com>
 * Phone: +963934005922
 * Copyright (c) 2026 MHD. Shadi AL-Hasan
 */

class ArabicTafqeet {
  static final List<String> _ones = [
    "", "واحد", "اثنان", "ثلاثة", "أربعة", "خمسة", "ستة", "سبعة", "ثمانية", "تسعة", "عشرة"
  ];

  static final List<String> _tens = [
    "", "عشرة", "عشرون", "ثلاثون", "أربعون", "خمسون", "ستون", "سبعون", "ثمانون", "تسعون"
  ];

  static final List<String> _hundreds = [
    "", "مائة", "مائتان", "ثلاثمائة", "أربعمائة", "خمسمائة", "ستمائة", "سبعمائة", "ثمانمائة", "تسعمائة"
  ];

  static String convert(int number, {String currency = "ليرة سورية"}) {
    if (number == 0) return "صفر $currency";
    if (number < 0) return "سالب ${convert(-number, currency: currency)}";

    List<String> parts = [];
    if (number >= 1000) {
      int thousands = number ~/ 1000;
      if (thousands == 1) {
        parts.add("ألف");
      } else if (thousands == 2) {
        parts.add("ألفان");
      } else if (thousands >= 3 && thousands <= 10) {
        parts.add("${_ones[thousands]} آلاف");
      } else {
        parts.add("${_convertSubThousand(thousands)} ألف");
      }
      number %= 1000;
    }

    if (number > 0) {
      parts.add(_convertSubThousand(number));
    }

    return "فقط ${parts.join(' و ')} $currency لا غير";
  }

  static String _convertSubThousand(int number) {
    List<String> sub = [];
    int h = number ~/ 100;
    int rem = number % 100;

    if (h > 0) sub.add(_hundreds[h]);

    if (rem > 0) {
      if (rem <= 10) {
        sub.add(_ones[rem]);
      } else if (rem < 20) {
        if (rem == 11) sub.add("أحد عشر");
        else if (rem == 12) sub.add("اثنا عشر");
        else sub.add("${_ones[rem - 10]} عشر");
      } else {
        int t = rem ~/ 10;
        int o = rem % 10;
        if (o > 0) sub.add("${_ones[o]} و ${_tens[t]}");
        else sub.add(_tens[t]);
      }
    }
    return sub.join(" و ");
  }
}
