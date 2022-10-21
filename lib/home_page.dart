import 'dart:async';
import 'dart:convert';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecrypt/crypto_page.dart';
import 'package:http/http.dart' as http;
import 'package:mecrypt/deposit_page.dart';
import 'package:mecrypt/service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String pairsUrl = "https://indodax.com/api/pairs";
  final String summariesUrl = "https://indodax.com/api/summaries";

  Future<List<dynamic>> _pairsDataCrypto() async {
    var response = await http.get(Uri.parse(pairsUrl));
    return json.decode(response.body);
  }

  Future<dynamic> _price24hrDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["prices_24h"];
  }

  Future<dynamic> _tickerDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["tickers"];
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
                child: Image.asset("assets/logocrypto.png")),
          ),
          backgroundColor: Colors.black,
          title: Text(
            "MECRYPT",
            style: GoogleFonts.jua(
              color: const Color.fromARGB(255, 33, 150, 243),
              fontSize: 20,
            ),
          ),
        ),
        body: DoubleBack(
          condition: true,
          child: Stack(
            children: [
              Container(
                color: Colors.black,
              ),
              Container(
                margin: const EdgeInsets.only(top: 200),
                decoration: BoxDecoration(
                  color: Warna.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
              ),
              Column(
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
                                    "\tMY ASSETS",
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
                                    setState(() {});
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
                                    child: DepositPage(
                                      title: Text(
                                        "DEPOSIT",
                                        style: Style.fontJudul,
                                      ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "DAFTAR KRIPTO",
                      style: Style.fontJudul,
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(
                          const Duration(seconds: 1),
                        );
                        setState(() {});
                      },
                      child: FutureBuilder<List<dynamic>>(
                        future: _pairsDataCrypto(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return FutureBuilder<dynamic>(
                                      future: _price24hrDataCrypto(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot24hr) {
                                        if (snapshot24hr.hasData) {
                                          return FutureBuilder<dynamic>(
                                              future: _tickerDataCrypto(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshotlast) {
                                                if (snapshotlast.hasData) {
                                                  double persentase = ((int.parse(
                                                              snapshot24hr.data[
                                                                  snapshot.data[index]
                                                                      ['id']]) -
                                                          int.parse(snapshotlast
                                                              .data[snapshot
                                                                  .data[index]
                                                              ['ticker_id']]["last"])) /
                                                      int.parse(snapshot24hr.data[snapshot.data[index]['id']]) *
                                                      -100);

                                                  dynamic namecrypto =
                                                      snapshotlast.data[snapshot
                                                                  .data[index]
                                                              ['ticker_id']]
                                                          ["name"];
                                                  dynamic tickerID = snapshot
                                                      .data[index]['ticker_id'];
                                                  dynamic idCrypto = snapshot
                                                      .data[index]['id'];
                                                  int hargaCrypto = int.parse(
                                                    snapshotlast.data[snapshot
                                                            .data[index]
                                                        ['ticker_id']]["last"],
                                                  );
                                                  dynamic namaIDR = snapshot
                                                          .data[index]
                                                      ['traded_currency_unit'];
                                                  dynamic logoCrypto =
                                                      snapshot.data[index]
                                                          ['url_logo_png'];
                                                  dynamic deskripsi =
                                                      snapshot.data[index]
                                                          ["description"];

                                                  return Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      CryptoPage(
                                                                    tickerid:
                                                                        tickerID,
                                                                    id: idCrypto,
                                                                    namaIDR:
                                                                        namaIDR,
                                                                    deskripsi:
                                                                        deskripsi,
                                                                    image:
                                                                        logoCrypto,
                                                                    name:
                                                                        namecrypto,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .rightToLeft,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  reverseDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              500),
                                                                  isIos: true),
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    bottom: 5,
                                                                    right: 10),
                                                            child: Material(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .horizontal(
                                                                right: Radius
                                                                    .circular(
                                                                        50),
                                                              ),
                                                              color: persentase <
                                                                      0.0
                                                                  ? Warna.turun
                                                                  : persentase ==
                                                                          0.0
                                                                      ? Colors
                                                                          .grey
                                                                      : Warna
                                                                          .naik,
                                                              elevation: 5,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .horizontal(
                                                                    right: Radius
                                                                        .circular(
                                                                            40),
                                                                  ),
                                                                  color: Warna
                                                                      .font,
                                                                ),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            12,
                                                                        bottom:
                                                                            2),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            namecrypto,
                                                                            style:
                                                                                Style.fontKripto,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                          Text(
                                                                            "${CurrencyFormat.convertToIdr(
                                                                                  hargaCrypto,
                                                                                )} / " +
                                                                                namaIDR,
                                                                            style:
                                                                                Style.fontAngka,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      persentase >
                                                                              0
                                                                          ? Text(
                                                                              "+ ${persentase.toStringAsFixed(2)}%",
                                                                              style: Style.fontAngka,
                                                                            )
                                                                          : persentase == 0
                                                                              ? Text(
                                                                                  "${persentase.abs().toStringAsFixed(0)}%",
                                                                                  style: Style.fontAngka,
                                                                                )
                                                                              : Text(
                                                                                  "- ${persentase.abs().toStringAsFixed(2)}%",
                                                                                  style: Style.fontAngka,
                                                                                ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.vertical(
                                                                          bottom: Radius.circular(
                                                                              200),
                                                                          top: Radius.circular(
                                                                              20))),
                                                                  title: Text(
                                                                    namecrypto,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            40),
                                                                  ),
                                                                  content: Image
                                                                      .network(
                                                                          logoCrypto),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    logoCrypto),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              });
                                        } else {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.grey),
                                          );
                                        }
                                      });
                                });
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
