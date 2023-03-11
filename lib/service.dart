import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CurrencyFormat {
  static String convertToIdr(num number) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
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
  static TextStyle? fontDialog = GoogleFonts.jua(
      fontSize: 35, fontWeight: FontWeight.bold, color: Warna.font);
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

class Storages {
  static Box dana = Hive.box('dana');
  static Box wishlist = Hive.box('wishlist');
  static Box assets = Hive.box('assets');
  static Future putDana(int value) async => await dana.put('index', value);
  static int get getDana => dana.get('index') ?? 0;
  static Future putwishlist(dynamic value) async => await wishlist.add(value);
  static Map<dynamic, dynamic> get getWishlist =>
      wishlist.toMap().isNotEmpty ? wishlist.toMap() : {};
  static Future putAssets(List<dynamic> value) async => await assets.add(value);
  static Map<dynamic, dynamic> get getAssets =>
      assets.toMap().isNotEmpty ? assets.toMap() : {};
}

// class MoneyAssets with ChangeNotifier {
//   int _asset = 0;
//   final List<dynamic> _listCrypto = [];
//   final List<List<dynamic>> _listAssets = [];

//   int get asset => _asset;
//   set asset(int value) {
//     _asset += value;
//     notifyListeners();
//   }

//   List<dynamic> get listCrypto => _listCrypto;
//   set listCrypto(dynamic index) {
//     _listCrypto.add(index);
//     notifyListeners();
//   }

//   List<List<dynamic>> get listAssets => _listAssets;
//   set listAssets(List<dynamic> listIndex) {
//     _listAssets.add(listIndex);
//     notifyListeners();
//   }

//   String get assetRp => CurrencyFormat.convertToIdr(_asset);
// }

responsive(
  BuildContext context, {
  required dynamic mobile,
  required dynamic desktop,
  dynamic tablet,
  dynamic iOS,
  dynamic macOS,
}) {
  final String orientation = MediaQuery.of(context).orientation.name;
  final double width = MediaQuery.of(context).size.width;
  if (kIsWeb || Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    if (width <= 850.0) {
      return mobile;
    } else if (width <= 1100.0) {
      return tablet ?? desktop;
    } else {
      return desktop;
    }
  } else {
    if (Platform.isAndroid) {
      if (orientation == 'landscape') {
        return tablet ?? desktop;
      } else {
        return mobile;
      }
    } else if (Platform.isIOS) {
      if (orientation == 'landscape') {
        return macOS ?? tablet ?? iOS ?? desktop;
      } else {
        return iOS ?? mobile;
      }
    }
  }
}

class FutureJson {
  String pairsUrl = "https://indodax.com/api/pairs";
  String summariesUrl = "https://indodax.com/api/summaries";

  Future<List<dynamic>> pairsDataCrypto() async {
    var response = await http.get(Uri.parse(pairsUrl));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> price24hrDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["prices_24h"];
  }

  Future<Map<String, dynamic>> tickerDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["tickers"];
  }

  Future<List<dynamic>> tradesDataCrypto(dynamic tickerid) async {
    final String tradesUrl = "https://indodax.com/api/$tickerid/trades";
    var response = await http.get(Uri.parse(tradesUrl));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> price7dDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["prices_7d"];
  }
}
