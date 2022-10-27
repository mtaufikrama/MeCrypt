import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecrypt/service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'crypto_page.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    var asset = context.watch<MoneyAssets>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<List<dynamic>>(
            future: FutureJson().pairsDataCrypto(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(
                      "Favourite Crypto",
                      style: GoogleFonts.jua(
                        color: Warna.font,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: asset.listCrypto.length,
                      itemBuilder: (BuildContext context, int index) {
                        dynamic cryptoList = asset.listCrypto[index];
                        return FutureBuilder<dynamic>(
                          future: FutureJson().price24hrDataCrypto(
                              snapshot.data[cryptoList]['id']),
                          builder: (BuildContext context,
                              AsyncSnapshot snapshot24hr) {
                            if (snapshot24hr.hasData) {
                              return FutureBuilder<dynamic>(
                                future: FutureJson().tickerDataCrypto(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshotlast) {
                                  if (snapshotlast.hasData) {
                                    double persentase = ((double.parse(
                                                snapshot24hr.data) -
                                            double.parse(snapshotlast.data[
                                                snapshot.data[cryptoList]
                                                    ['ticker_id']]["last"])) /
                                        double.parse(snapshot24hr.data) *
                                        -100);

                                    dynamic namecrypto = snapshotlast.data[
                                        snapshot.data[cryptoList]
                                            ['ticker_id']]["name"];
                                    dynamic tickerID =
                                        snapshot.data[cryptoList]['ticker_id'];
                                    dynamic idCrypto =
                                        snapshot.data[cryptoList]['id'];
                                    double hargaCrypto = double.parse(
                                      snapshotlast.data[
                                          snapshot.data[cryptoList]
                                              ['ticker_id']]["last"],
                                    );
                                    dynamic namaIDR = snapshot.data[cryptoList]
                                        ['traded_currency_unit'];
                                    dynamic logoCrypto = snapshot
                                        .data[cryptoList]['url_logo_png'];
                                    dynamic deskripsi = snapshot
                                        .data[cryptoList]["description"];

                                    return Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: CryptoPage(
                                                      tickerid: tickerID,
                                                      id: idCrypto,
                                                      namaIDR: namaIDR,
                                                      deskripsi: deskripsi,
                                                      image: logoCrypto,
                                                      name: namecrypto,
                                                    ),
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    reverseDuration:
                                                        const Duration(
                                                            milliseconds: 500),
                                                    isIos: true),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5, right: 10),
                                              child: Material(
                                                borderRadius: const BorderRadius
                                                    .horizontal(
                                                  right: Radius.circular(50),
                                                ),
                                                color: persentase < 0.0
                                                    ? Warna.turun
                                                    : persentase == 0.0
                                                        ? Colors.grey
                                                        : Warna.naik,
                                                elevation: 5,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(40),
                                                    ),
                                                    color: Warna.font,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      right: 12, bottom: 2),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              namecrypto,
                                                              style: Style
                                                                  .fontKripto,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              "${CurrencyFormat.convertToIdr(
                                                                    hargaCrypto,
                                                                  )} / " +
                                                                  namaIDR,
                                                              style: Style
                                                                  .fontAngka,
                                                            ),
                                                          ],
                                                        ),
                                                        persentase > 0
                                                            ? Text(
                                                                "+ ${persentase.toStringAsFixed(2)}%",
                                                                style: Style
                                                                    .fontAngka,
                                                              )
                                                            : persentase == 0
                                                                ? Text(
                                                                    "${persentase.abs().toStringAsFixed(0)}%",
                                                                    style: Style
                                                                        .fontAngka,
                                                                  )
                                                                : Text(
                                                                    "- ${persentase.abs().toStringAsFixed(2)}%",
                                                                    style: Style
                                                                        .fontAngka,
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
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                bottom: Radius
                                                                    .circular(
                                                                        200),
                                                                top: Radius
                                                                    .circular(
                                                                        20))),
                                                    title: Text(
                                                      namecrypto,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 40),
                                                    ),
                                                    content: Image.network(
                                                        logoCrypto),
                                                  );
                                                },
                                              );
                                            },
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(logoCrypto),
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
                                },
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
