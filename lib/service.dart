import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
  @override
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

List<List<String>> listBank = [
  ["bca.png", "BANK BCA"],
  ["bni.png", "BANK BNI"],
  ["bri.webp", "BANK BRI"],
  ["mandiri.png", "BANK MANDIRI"],
  ["permata.png", " BANK PERMATA"],
  ["sea.png", "SEABANK"],
  ["bjb.png", "BANK BJB"],
  ["btn.png", "BANK BTN"],
  ["cimb.png", "BANK CIMB"],
  ["hsbc.png", "BANK HSBC"],
  ["ocbc.png", "BANK OCBC"],
];

class MoneyAssets with ChangeNotifier {
  int _asset = 0;

  int get asset => _asset;
  set asset(int value) {
    _asset = _asset + value;
    notifyListeners();
  }

  String get assetRp => CurrencyFormat.convertToIdr(_asset);
}

class FutureJson {
  String pairsUrl = "https://indodax.com/api/pairs";
  String summariesUrl = "https://indodax.com/api/summaries";

  Future<List<dynamic>> pairsDataCrypto() async {
    var response = await http.get(Uri.parse(pairsUrl));
    return json.decode(response.body);
  }

  Future<dynamic> price24hrDataCrypto(String id) async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["prices_24h"][id];
  }

  Future<dynamic> tickerDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["tickers"];
  }

  Future<List<dynamic>> tradesDataCrypto(dynamic tickerid) async {
    final String tradesUrl = "https://indodax.com/api/$tickerid/trades";
    var response = await http.get(Uri.parse(tradesUrl));
    return json.decode(response.body);
  }

  Future<dynamic> price7dDataCrypto(String id) async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["prices_7d"][id];
  }
}
