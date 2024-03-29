// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecrypt/card.dart';
import 'package:mecrypt/service.dart';
import 'package:page_transition/page_transition.dart';

import 'crypto_page.dart';

class WishList extends StatefulWidget {
  const WishList({
    super.key,
    required this.future24hr,
    required this.futureTicker,
    required this.pairsDataCrypto,
    required this.future7d,
  });
  final Future<Map<String, dynamic>> future24hr;
  final Future<Map<String, dynamic>> futureTicker;
  final Future<List<dynamic>> pairsDataCrypto;
  final Future<Map<String, dynamic>> future7d;

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    Map wishlist = Storages.getWishlist;
    return wishlist.isNotEmpty
        ? FutureBuilder<List<dynamic>>(
            future: widget.pairsDataCrypto,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState != ConnectionState.waiting &&
                  snapshot.data != null) {
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: wishlist.length,
                      itemBuilder: (context, index) {
                        dynamic cryptoList = wishlist[index];
                        return FutureBuilder<dynamic>(
                          future: widget.future24hr,
                          builder: (context, snapshot24hr) {
                            if (snapshot24hr.hasData &&
                                snapshot24hr.connectionState !=
                                    ConnectionState.waiting &&
                                snapshot24hr.data != null) {
                              String data24hr = snapshot24hr
                                      .data[snapshot.data![cryptoList]['id']] ??
                                  '0';
                              return FutureBuilder<dynamic>(
                                future: widget.futureTicker,
                                builder: (context, snapshotlast) {
                                  if (snapshotlast.hasData &&
                                      snapshotlast.connectionState !=
                                          ConnectionState.waiting &&
                                      snapshotlast.data != null) {
                                    double persentase = ((double.parse(
                                                snapshot24hr.data[
                                                    snapshot.data![cryptoList]
                                                        ['id']] as String) -
                                            double.parse(snapshotlast.data[
                                                snapshot.data![cryptoList]
                                                    ['ticker_id']]["last"] as String)) /
                                        double.parse(snapshot24hr.data[snapshot.data![cryptoList]['id']]) *
                                        -100);
                                    dynamic namecrypto = snapshotlast.data[
                                        snapshot.data![cryptoList]
                                            ['ticker_id']]["name"];
                                    dynamic tickerID =
                                        snapshot.data![cryptoList]['ticker_id'];
                                    dynamic idCrypto =
                                        snapshot.data![cryptoList]['id'];
                                    double hargaCrypto = double.parse(
                                        snapshotlast.data[
                                            snapshot.data![cryptoList]
                                                ['ticker_id']]["last"]);
                                    dynamic namaIDR = snapshot.data![cryptoList]
                                        ['traded_currency_unit'];
                                    dynamic logoCrypto = snapshot
                                        .data![cryptoList]['url_logo_png'];
                                    dynamic deskripsi = snapshot
                                        .data![cryptoList]["description"];
                                    return ListCard(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                                child: CryptoPage(
                                                  future24hr: widget.future24hr,
                                                  future7d: widget.future7d,
                                                  futureTicker:
                                                      widget.futureTicker,
                                                  tickerid: tickerID,
                                                  id: idCrypto,
                                                  namaIDR: namaIDR,
                                                  deskripsi: deskripsi,
                                                  image: logoCrypto,
                                                  name: namecrypto,
                                                  tickerIDCrypto: tickerID,
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                reverseDuration: const Duration(
                                                    milliseconds: 500),
                                                isIos: true),
                                          );
                                        },
                                        color: persentase < 0.0
                                            ? Warna.turun
                                            : persentase == 0.0
                                                ? Colors.grey
                                                : Warna.naik,
                                        title: namecrypto,
                                        subtitle:
                                            "${CurrencyFormat.convertToIdr(
                                                  hargaCrypto,
                                                )} / " +
                                                namaIDR,
                                        kananTengah: persentase > 0
                                            ? "+ ${persentase.toStringAsFixed(2)}%"
                                            : persentase == 0
                                                ? "${persentase.abs().toStringAsFixed(0)}%"
                                                : "- ${persentase.abs().toStringAsFixed(2)}%",
                                        logoCrypto: logoCrypto);
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
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        : Center(
            child: Text(
              "NO DATA",
              style: GoogleFonts.jua(
                fontSize: 30,
                color: Warna.font,
              ),
            ),
          );
  }
}
