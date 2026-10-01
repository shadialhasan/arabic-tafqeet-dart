/**
 * Automated Test Suite for arabic_tafqeet
 * Author: Eng. MHD. Shadi AL-Hasan <mhd.shadi.alhasan@gmail.com>
 */

import 'package:test/test.dart';
import 'package:arabic_tafqeet/arabic_tafqeet.dart';

void main() {
  group('ArabicTafqeet Unit Tests', () {
    test('Converts original benchmark sample 15420', () {
      final result = ArabicTafqeet.convert(15420, currency: "ليرة سورية");
      expect(result, equals("فقط خمسة عشر ألف و أربعمائة و عشرون ليرة سورية لا غير"));
    });

    test('Converts zero and negative amounts', () {
      final zeroResult = ArabicTafqeet.convert(0, currency: "ريال");
      expect(zeroResult, contains("صفر ريال"));

      final negativeResult = ArabicTafqeet.convert(-500, currency: "دينار");
      expect(negativeResult, startsWith("سالب"));
      expect(negativeResult, contains("خمسمائة دينار"));
    });

    test('Converts basic numbers 1 to 20', () {
      expect(ArabicTafqeet.convertNumber(1), equals("واحد"));
      expect(ArabicTafqeet.convertNumber(2), equals("اثنان"));
      expect(ArabicTafqeet.convertNumber(10), equals("عشرة"));
      expect(ArabicTafqeet.convertNumber(11), equals("أحد عشر"));
      expect(ArabicTafqeet.convertNumber(12), equals("اثنا عشر"));
      expect(ArabicTafqeet.convertNumber(17), equals("سبعة عشر"));
    });

    test('Converts tens and compound tens', () {
      expect(ArabicTafqeet.convertNumber(20), equals("عشرون"));
      expect(ArabicTafqeet.convertNumber(45), equals("خمسة و أربعون"));
      expect(ArabicTafqeet.convertNumber(99), equals("تسعة و تسعون"));
    });

    test('Converts hundreds', () {
      expect(ArabicTafqeet.convertNumber(100), equals("مائة"));
      expect(ArabicTafqeet.convertNumber(200), equals("مائتان"));
      expect(ArabicTafqeet.convertNumber(350), equals("ثلاثمائة و خمسون"));
      expect(ArabicTafqeet.convertNumber(999), equals("تسعمائة و تسعة و تسعون"));
    });

    test('Converts thousands with proper dual and plural grammar', () {
      expect(ArabicTafqeet.convertNumber(1000), equals("ألف"));
      expect(ArabicTafqeet.convertNumber(2000), equals("ألفان"));
      expect(ArabicTafqeet.convertNumber(5000), equals("خمسة آلاف"));
      expect(ArabicTafqeet.convertNumber(25000), equals("خمسة و عشرون ألف"));
    });

    test('Converts millions, billions, and trillions', () {
      expect(ArabicTafqeet.convertNumber(1000000), equals("مليون"));
      expect(ArabicTafqeet.convertNumber(2000000), equals("مليونان"));
      expect(ArabicTafqeet.convertNumber(5000000), equals("خمسة ملايين"));
      expect(ArabicTafqeet.convertNumber(1000000000), equals("مليار"));
      expect(ArabicTafqeet.convertNumber(2000000000), equals("ملياران"));
      expect(ArabicTafqeet.convertNumber(1000000000000), equals("تريليون"));
    });

    test('Custom prefix and postfix', () {
      final custom = ArabicTafqeet.convert(
        100,
        currency: "درهم إماراتي",
        prefix: "المبلغ المحسوب:",
        postfix: "فحسب",
      );
      expect(custom, equals("المبلغ المحسوب: مائة درهم إماراتي فحسب"));
    });

    test('Floating-point / Decimal conversion (convertDouble)', () {
      final doubleResult = ArabicTafqeet.convertDouble(
        150.75,
        currency: "ريال سعودي",
        subUnit: "هللة",
      );
      expect(doubleResult, contains("مائة و خمسون ريال سعودي"));
      expect(doubleResult, contains("خمسة و سبعون هللة"));
      expect(doubleResult, startsWith("فقط"));
      expect(doubleResult, endsWith("لا غير"));
    });

    test('Validation of illegal double inputs', () {
      expect(() => ArabicTafqeet.convertDouble(double.nan), throwsArgumentError);
      expect(() => ArabicTafqeet.convertDouble(double.infinity), throwsArgumentError);
      expect(() => ArabicTafqeet.convertDouble(10.5, precision: -1), throwsArgumentError);
      expect(() => ArabicTafqeet.convertDouble(10.5, precision: 10), throwsArgumentError);
    });
  });
}
