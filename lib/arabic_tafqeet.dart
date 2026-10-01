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

  static final List<Map<String, dynamic>> _scales = [
    {
      "value": 1000000000000,
      "single": "تريليون",
      "dual": "تريليونان",
      "plural": "تريليونات"
    },
    {
      "value": 1000000000,
      "single": "مليار",
      "dual": "ملياران",
      "plural": "مليارات"
    },
    {
      "value": 1000000,
      "single": "مليون",
      "dual": "مليونان",
      "plural": "ملايين"
    },
    {
      "value": 1000,
      "single": "ألف",
      "dual": "ألفان",
      "plural": "آلاف"
    }
  ];

  /// Converts an integer into raw Arabic words without currency or prefix/postfix
  static String convertNumber(int number) {
    if (number == 0) return "صفر";
    if (number < 0) return "سالب ${convertNumber(-number)}";

    List<String> parts = [];
    int remainder = number;

    for (final scale in _scales) {
      int scaleValue = scale["value"] as int;
      if (remainder >= scaleValue) {
        int count = remainder ~/ scaleValue;
        remainder %= scaleValue;

        if (count == 1) {
          parts.add(scale["single"] as String);
        } else if (count == 2) {
          parts.add(scale["dual"] as String);
        } else if (count >= 3 && count <= 10) {
          parts.add("${_ones[count]} ${scale['plural']}");
        } else {
          parts.add("${_convertSubThousand(count)} ${scale['single']}");
        }
      }
    }

    if (remainder > 0) {
      parts.add(_convertSubThousand(remainder));
    }

    return parts.join(" و ");
  }

  /// Converts an integer monetary amount into full Arabic Tafqeet text
  static String convert(
    int number, {
    String currency = "ليرة سورية",
    String prefix = "فقط",
    String postfix = "لا غير",
  }) {
    if (number == 0) {
      String base = "صفر $currency";
      if (prefix.isNotEmpty) base = "$prefix $base";
      if (postfix.isNotEmpty) base = "$base $postfix";
      return base.trim();
    }

    if (number < 0) {
      return "سالب ${convert(-number, currency: currency, prefix: prefix, postfix: postfix)}";
    }

    String words = convertNumber(number);
    List<String> resultSegments = [];

    if (prefix.trim().isNotEmpty) {
      resultSegments.add(prefix.trim());
    }

    resultSegments.add(words);

    if (currency.trim().isNotEmpty) {
      resultSegments.add(currency.trim());
    }

    if (postfix.trim().isNotEmpty) {
      resultSegments.add(postfix.trim());
    }

    return resultSegments.join(" ");
  }

  /// Converts a floating-point monetary amount (with fractional units like cents/halalas)
  static String convertDouble(
    double number, {
    String currency = "ليرة سورية",
    String subUnit = "قرش",
    int precision = 2,
    String prefix = "فقط",
    String postfix = "لا غير",
  }) {
    if (number.isNaN || number.isInfinite) {
      throw ArgumentError("Number must be a finite numeric value.");
    }
    if (precision < 0 || precision > 6) {
      throw ArgumentError("Precision must be between 0 and 6.");
    }

    if (number < 0) {
      return "سالب ${convertDouble(-number, currency: currency, subUnit: subUnit, precision: precision, prefix: prefix, postfix: postfix)}";
    }

    int integerPart = number.truncate();
    double fractionalPart = number - integerPart;

    int factor = 1;
    for (int i = 0; i < precision; i++) {
      factor *= 10;
    }
    int fractionAsInt = (fractionalPart * factor).round();

    if (fractionAsInt >= factor) {
      integerPart += 1;
      fractionAsInt = 0;
    }

    String integerWords = convertNumber(integerPart);
    String result = "";

    if (prefix.trim().isNotEmpty) {
      result += "${prefix.trim()} ";
    }

    result += "$integerWords $currency";

    if (fractionAsInt > 0 && subUnit.trim().isNotEmpty) {
      String fracWords = convertNumber(fractionAsInt);
      result += " و $fracWords $subUnit";
    }

    if (postfix.trim().isNotEmpty) {
      result += " ${postfix.trim()}";
    }

    return result.trim();
  }

  static String _convertSubThousand(int number) {
    if (number <= 0) return "";
    List<String> sub = [];
    int h = number ~/ 100;
    int rem = number % 100;

    if (h > 0) sub.add(_hundreds[h]);

    if (rem > 0) {
      if (rem <= 10) {
        sub.add(_ones[rem]);
      } else if (rem < 20) {
        if (rem == 11) {
          sub.add("أحد عشر");
        } else if (rem == 12) {
          sub.add("اثنا عشر");
        } else {
          sub.add("${_ones[rem - 10]} عشر");
        }
      } else {
        int t = rem ~/ 10;
        int o = rem % 10;
        if (o > 0) {
          sub.add("${_ones[o]} و ${_tens[t]}");
        } else {
          sub.add(_tens[t]);
        }
      }
    }
    return sub.join(" و ");
  }
}
