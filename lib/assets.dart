// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecrypt/card.dart';
import 'package:mecrypt/service.dart';
import 'package:provider/provider.dart';

class Assets extends StatefulWidget {
  const Assets({super.key});

  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  @override
  Widget build(BuildContext context) {
    var asset = context.watch<MoneyAssets>();
    return asset.listAssets.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: asset.listAssets.length,
            itemBuilder: (BuildContext context, int index) {
              dynamic assetsList = asset.listAssets[index];
              int hargaCryptoAssets = 0;
              int jumlahCryptoAssets = 1;
              int hargaCryptoToday = 2;
              int namaCrypto = 3;
              int logoCrypto = 4;
              int tickerIDCrypto = 5;
              return FutureBuilder<dynamic>(
                  future: FutureJson().tickerDataCrypto(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var persentase =
                          (double.parse(assetsList[hargaCryptoToday]) -
                                  double.parse(
                                      snapshot.data[assetsList[tickerIDCrypto]]
                                          ["last"])) /
                              double.parse(assetsList[hargaCryptoToday]) *
                              -100;
                      return ListCard(
                        color: persentase < 0.0
                            ? Warna.turun
                            : persentase == 0.0
                                ? Colors.grey
                                : Warna.naik,
                        title:
                            "${CurrencyFormat.convertToIdr(int.parse(assetsList[hargaCryptoAssets]))} → ${CurrencyFormat.convertToIdr(double.parse(assetsList[hargaCryptoAssets]) + (double.parse(assetsList[hargaCryptoAssets]) * persentase / 100))}",
                        subtitle: assetsList[jumlahCryptoAssets],
                        kananTengah: persentase > 0
                            ? "+ ${persentase.toStringAsFixed(2)}%"
                            : persentase == 0
                                ? "${persentase.abs().toStringAsFixed(0)}%"
                                : "- ${persentase.abs().toStringAsFixed(2)}%",
                        logoCrypto: assetsList[logoCrypto],
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
                  });
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
