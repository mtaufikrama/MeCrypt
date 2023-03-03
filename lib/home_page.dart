// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mecrypt/card.dart';
import 'package:mecrypt/crypto_page.dart';
import 'package:mecrypt/deposit_page.dart';
import 'package:mecrypt/wishlist.dart';
import 'package:mecrypt/service.dart';
import 'package:page_transition/page_transition.dart';

import 'assets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? timeString;
  Future<Map<String, dynamic>>? futureTicker;
  Future<Map<String, dynamic>>? future24hr;
  Future<Map<String, dynamic>>? future7d;
  Future<List<dynamic>>? futurePairs;

  void freeze() {
    timeString = DateFormat.jm().format(DateTime.now());
    futurePairs = FutureJson().pairsDataCrypto();
    futureTicker = FutureJson().tickerDataCrypto();
    future24hr = FutureJson().price24hrDataCrypto();
    future7d = FutureJson().price7dDataCrypto();
  }

  @override
  void initState() {
    timeString = DateFormat.jm().format(DateTime.now());
    futurePairs = FutureJson().pairsDataCrypto();
    futureTicker = FutureJson().tickerDataCrypto();
    future24hr = FutureJson().price24hrDataCrypto();
    future7d = FutureJson().price7dDataCrypto();
    Timer.periodic(const Duration(seconds: 20), (timer) {
      setState(() {
        freeze();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int dana = Storages.getDana;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            child: Image.asset(
              "assets/logocrypto.png",
              color: Warna.font,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "MeCrypt",
              style: GoogleFonts.jua(
                color: Warna.font,
                fontSize: 20,
              ),
            ),
            Text(
              "$timeString",
              style: GoogleFonts.jua(
                color: Warna.font,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
          ),
          DoubleBack(
            message: "Tekan kembali untuk keluar",
            child: responsive(
              context,
              mobile: Column(
                children: [
                  cardHomePage(dana, context),
                  Expanded(
                    child: isiListCrypto(),
                  ),
                ],
              ),
              desktop: Row(
                children: [
                  Expanded(child: cardHomePage(dana, context)),
                  Expanded(child: isiListCrypto()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container isiListCrypto() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        color: Warna.background,
      ),
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Warna.background,
              labelStyle: GoogleFonts.jua(fontSize: 18),
              tabs: const [
                Tab(text: "Lists"),
                Tab(text: "Wishlist"),
                Tab(text: "Assets"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  listCrypto(),
                  WishList(
                    future7d: future7d!,
                    future24hr: future24hr!,
                    futureTicker: futureTicker!,
                    pairsDataCrypto: futurePairs!,
                  ),
                  Assets(tickerDataCrypto: futureTicker!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card cardHomePage(int dana, BuildContext context) {
    return Card(
      color: Warna.card,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "     MY ASSETS",
                      style: Style.fontJudul,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: Colors.white,
                    tooltip: "update nilai",
                    iconSize: 30,
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        int jumlah = dana - dana;
                        Storages.putDana(jumlah);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Text(
            CurrencyFormat.convertToIdr(dana),
            style: GoogleFonts.jua(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                height: 50,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const DepositPage(
                        title: "DEPOSIT",
                        hargaCrypto: "0",
                        namaIDR: "",
                        nama: "",
                        logoCrypto: "",
                        tickerIDCrypto: "",
                      ),
                      type: PageTransitionType.bottomToTop,
                      duration: const Duration(milliseconds: 500),
                      reverseDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                color: Warna.font,
                child: Text(
                  "DEPOSIT",
                  style: GoogleFonts.jua(
                    color: Warna.card,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<dynamic>> listCrypto() {
    return FutureBuilder<List<dynamic>>(
      future: futurePairs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> dataPairs = snapshot.data!;
          return ListView(
            shrinkWrap: true,
            children: [
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataPairs.length,
                itemBuilder: (context, index) {
                  final pairsIndex = dataPairs[index];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: future24hr,
                    builder: (context, snapshot24hr) {
                      return FutureBuilder<Map<String, dynamic>>(
                        future: futureTicker,
                        builder: (context, snapshotTicker) {
                          if (snapshotTicker.hasData && snapshot24hr.hasData) {
                            final String idCrypto = pairsIndex['id'] as String;
                            final String data24hr =
                                snapshot24hr.data![idCrypto] ?? '0';
                            final Map<String, dynamic> dataTicker =
                                snapshotTicker.data!;
                            final String tickerID = pairsIndex['ticker_id'];
                            final String namecrypto =
                                dataTicker[tickerID]!["name"];
                            final double hargaCrypto = double.parse(
                                dataTicker[tickerID]!["last"] as String);
                            final String namaIDR =
                                pairsIndex['traded_currency_unit'];
                            final String logoCrypto =
                                pairsIndex['url_logo_png'];
                            final String deskripsi = pairsIndex["description"];
                            final double persentase = ((double.parse(data24hr) -
                                    double.parse(dataTicker[tickerID]!["last"]
                                        as String)) /
                                double.parse(data24hr) *
                                -100);
                            return Column(
                              children: [
                                ListCard(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          child: CryptoPage(
                                            future7d: future7d!,
                                            futureTicker: futureTicker!,
                                            future24hr: future24hr!,
                                            tickerid: tickerID,
                                            id: idCrypto,
                                            namaIDR: namaIDR,
                                            deskripsi: deskripsi,
                                            image: logoCrypto,
                                            name: namecrypto,
                                            tickerIDCrypto: tickerID,
                                          ),
                                          type: PageTransitionType.rightToLeft,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          reverseDuration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          isIos: true),
                                    );
                                  },
                                  onDoubleTap: () {
                                    Storages.putwishlist(index);
                                  },
                                  color: persentase < 0.0
                                      ? Warna.turun
                                      : persentase == 0.0
                                          ? Colors.grey
                                          : Warna.naik,
                                  title: namecrypto,
                                  subtitle: "${CurrencyFormat.convertToIdr(
                                    hargaCrypto,
                                  )} / $namaIDR",
                                  kananTengah: persentase > 0
                                      ? "+ ${persentase.toStringAsFixed(2)}%"
                                      : persentase == 0
                                          ? "${persentase.abs().toStringAsFixed(0)}%"
                                          : "- ${persentase.abs().toStringAsFixed(2)}%",
                                  logoCrypto: logoCrypto,
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey,
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
