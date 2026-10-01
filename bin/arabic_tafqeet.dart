/**
 * CLI Entrypoint for arabic_tafqeet
 * Author: Eng. MHD. Shadi AL-Hasan <mhd.shadi.alhasan@gmail.com>
 * Phone: +963934005922
 * Copyright (c) 2026 MHD. Shadi AL-Hasan
 */

import 'dart:io';
import 'package:arabic_tafqeet/arabic_tafqeet.dart';

void main(List<String> args) {
  if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
    print('''
Arabic Tafqeet (تفقيط الأرقام) CLI
Usage: dart run bin/arabic_tafqeet.dart <number> [options]

Options:
  --currency, -c <name>   Main currency name (default: "ليرة سورية")
  --sub-unit, -s <name>   Sub-unit / fractional currency (default: "قرش")
  --prefix <text>         Prefix text (default: "فقط")
  --postfix <text>        Postfix text (default: "لا غير")
  --no-prefix             Omit prefix
  --no-postfix            Omit postfix
  --raw                   Output only the converted Arabic text
  --help, -h              Show this help message

Examples:
  dart run bin/arabic_tafqeet.dart 15420
  dart run bin/arabic_tafqeet.dart 2500000 --currency "ريال سعودي"
  dart run bin/arabic_tafqeet.dart 1250.75 --currency "دولار أمريكي" --sub-unit "سنت"
''');
    exit(args.isEmpty ? 1 : 0);
  }

  String rawNumberStr = args[0];
  String currency = "ليرة سورية";
  String subUnit = "قرش";
  String prefix = "فقط";
  String postfix = "لا غير";
  bool rawOutput = false;

  for (int i = 1; i < args.length; i++) {
    if ((args[i] == '--currency' || args[i] == '-c') && i + 1 < args.length) {
      currency = args[++i];
    } else if ((args[i] == '--sub-unit' || args[i] == '-s') && i + 1 < args.length) {
      subUnit = args[++i];
    } else if (args[i] == '--prefix' && i + 1 < args.length) {
      prefix = args[++i];
    } else if (args[i] == '--postfix' && i + 1 < args.length) {
      postfix = args[++i];
    } else if (args[i] == '--no-prefix') {
      prefix = "";
    } else if (args[i] == '--no-postfix') {
      postfix = "";
    } else if (args[i] == '--raw') {
      rawOutput = true;
    }
  }

  num? parsedNum = num.tryParse(rawNumberStr.replaceAll(',', ''));
  if (parsedNum == null) {
    stderr.writeln('[!] Error: Invalid numeric input "$rawNumberStr".');
    exit(1);
  }

  String result;
  if (parsedNum is int || parsedNum == parsedNum.truncateToDouble()) {
    result = ArabicTafqeet.convert(
      parsedNum.toInt(),
      currency: currency,
      prefix: prefix,
      postfix: postfix,
    );
  } else {
    result = ArabicTafqeet.convertDouble(
      parsedNum.toDouble(),
      currency: currency,
      subUnit: subUnit,
      prefix: prefix,
      postfix: postfix,
    );
  }

  if (rawOutput) {
    print(result);
  } else {
    print('\n╔════════════════════════════════════════════════════════════════╗');
    print('║          🔠 Arabic Tafqeet Engine (تفقيط المبالغ)             ║');
    print('╚════════════════════════════════════════════════════════════════╝');
    print(' • Input Value : $rawNumberStr');
    print(' • Currency    : $currency ($subUnit)');
    print(' • Output Text : $result');
    print('════════════════════════════════════════════════════════════════\n');
  }
}
