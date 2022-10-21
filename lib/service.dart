import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }
}

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    String newText = NumberFormat.currency(
      locale: 'id',
      symbol: "",
      decimalDigits: 0,
    ).format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class Warna {
  static Color? font = const Color.fromARGB(255, 220, 220, 255);
  static Color? naik = const Color.fromARGB(255, 30, 220, 30);
  static Color? turun = const Color.fromARGB(255, 255, 0, 0);
  static Color? card = const Color.fromARGB(255, 0, 6, 183);
  static Color? background = const Color.fromARGB(255, 0, 16, 71);
}

class Style {
  static TextStyle? fontAngka = GoogleFonts.jua();
  static TextStyle? fontKripto =
      GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle? fontTeks = GoogleFonts.jua();
  static TextStyle? fontJudul = GoogleFonts.jua(
      fontSize: 25, fontWeight: FontWeight.bold, color: Warna.font);
}

class MyAsset {
  static int asset = 0;
  static int nilaiAsset = asset;
  static String tampilAsset = CurrencyFormat.convertToIdr(nilaiAsset);
}

class ListDepo {
  static List<String> image = [
    "bca.png",
    "bni.png",
    "bri.webp",
    "mandiri.png",
    "permata.png",
    "sea.png",
    "bjb.png",
    "btn.png",
    "cimb.png",
    "hsbc.png",
    "ocbc.png",
  ];
  static List<String> text = [
    "BANK BCA",
    "BANK BNI",
    "BANK BRI",
    "BANK MANDIRI",
    "BANK PERMATA",
    "SEABANK",
    "BANK BJB",
    "BANK BTN",
    "BANK CIMB",
    "BANK HSBC",
    "BANK OCBC",
  ];
}

class MoneyAssets with ChangeNotifier {
  int _asset = 0;

  int get asset => _asset;
  set asset(int value) {
    _asset = _asset + value;
    notifyListeners();
  }

  String get assetRp => CurrencyFormat.convertToIdr(_asset);
}
