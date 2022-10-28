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
import 'package:provider/provider.dart';

import 'assets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? timeString;

  @override
  void initState() {
    timeString = DateFormat.jm().format(DateTime.now());
    Timer.periodic(const Duration(seconds: 20), (timer) {
      setState(() {
        timeString = DateFormat.jm().format(DateTime.now());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var asset = context.watch<MoneyAssets>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
              child: Column(
                children: [
                  Card(
                    color: Warna.card,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
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
                                      asset.asset = -asset.asset;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          asset.assetRp,
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
                                    reverseDuration:
                                        const Duration(milliseconds: 500),
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
                  ),
                  Expanded(
                    child: Container(
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
                                  FutureBuilder<List<dynamic>>(
                                    future: FutureJson().pairsDataCrypto(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: snapshot.data.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return FutureBuilder<dynamic>(
                                                    future: FutureJson()
                                                        .price24hrDataCrypto(
                                                            snapshot.data[index]
                                                                ['id']),
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot
                                                                snapshot24hr) {
                                                      if (snapshot24hr
                                                          .hasData) {
                                                        return FutureBuilder<
                                                            dynamic>(
                                                          future: FutureJson()
                                                              .tickerDataCrypto(),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot
                                                                  snapshotlast) {
                                                            if (snapshotlast
                                                                .hasData) {
                                                              dynamic
                                                                  namecrypto =
                                                                  snapshotlast
                                                                      .data[snapshot
                                                                              .data[
                                                                          index]
                                                                      [
                                                                      'ticker_id']]["name"];
                                                              dynamic tickerID =
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'ticker_id'];
                                                              dynamic idCrypto =
                                                                  snapshot.data[
                                                                          index]
                                                                      ['id'];
                                                              double
                                                                  hargaCrypto =
                                                                  double.parse(
                                                                snapshotlast
                                                                    .data[snapshot
                                                                            .data[
                                                                        index][
                                                                    'ticker_id']]["last"],
                                                              );
                                                              dynamic namaIDR =
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'traded_currency_unit'];
                                                              dynamic
                                                                  logoCrypto =
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'url_logo_png'];
                                                              dynamic
                                                                  deskripsi =
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      "description"];
                                                              double persentase = ((double.parse(
                                                                          snapshot24hr
                                                                              .data) -
                                                                      double.parse(
                                                                          snapshotlast.data[tickerID]
                                                                              [
                                                                              "last"])) /
                                                                  double.parse(
                                                                      snapshot24hr
                                                                          .data) *
                                                                  -100);

                                                              return Column(
                                                                children: [
                                                                  ListCard(
                                                                      onTap:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: CryptoPage(
                                                                                tickerid: tickerID,
                                                                                id: idCrypto,
                                                                                namaIDR: namaIDR,
                                                                                deskripsi: deskripsi,
                                                                                image: logoCrypto,
                                                                                name: namecrypto,
                                                                                tickerIDCrypto: tickerID,
                                                                              ),
                                                                              type: PageTransitionType.rightToLeft,
                                                                              duration: const Duration(milliseconds: 500),
                                                                              reverseDuration: const Duration(milliseconds: 500),
                                                                              isIos: true),
                                                                        );
                                                                      },
                                                                      onDoubleTap:
                                                                          () {
                                                                        asset.listCrypto =
                                                                            index;
                                                                      },
                                                                      color: persentase <
                                                                              0.0
                                                                          ? Warna
                                                                              .turun
                                                                          : persentase ==
                                                                                  0.0
                                                                              ? Colors
                                                                                  .grey
                                                                              : Warna
                                                                                  .naik,
                                                                      title:
                                                                          namecrypto,
                                                                      subtitle:
                                                                          "${CurrencyFormat.convertToIdr(
                                                                                hargaCrypto,
                                                                              )} / " +
                                                                              namaIDR,
                                                                      kananTengah: persentase >
                                                                              0
                                                                          ? "+ ${persentase.toStringAsFixed(2)}%"
                                                                          : persentase ==
                                                                                  0
                                                                              ? "${persentase.abs().toStringAsFixed(0)}%"
                                                                              : "- ${persentase.abs().toStringAsFixed(2)}%",
                                                                      logoCrypto:
                                                                          logoCrypto),
                                                                ],
                                                              );
                                                            } else {
                                                              return Container();
                                                            }
                                                          },
                                                        );
                                                      } else {
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      10),
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  Colors.grey),
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                  const WishList(),
                                  const Assets(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
