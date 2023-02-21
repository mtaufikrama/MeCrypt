import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecrypt/alertpage.dart';
import 'package:mecrypt/deposit_page.dart';

import 'package:mecrypt/service.dart';

class CryptoPage extends StatefulWidget {
  final String tickerid;
  final String id;
  final String namaIDR;
  final String deskripsi;
  final String name;
  final String image;
  final String tickerIDCrypto;

  const CryptoPage({
    Key? key,
    required this.tickerid,
    required this.id,
    required this.namaIDR,
    required this.deskripsi,
    required this.name,
    required this.image,
    required this.tickerIDCrypto,
  }) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  Color? warna24jam = Warna.font;
  Color? warna7hari = Warna.font;
  Color? warnaTeks7hari = Warna.background;
  Color? warnaTeks24jam = Warna.background;
  int random = Random().nextInt(400);
  String persentase = "nothink";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => context.pushTransparentRoute(
              AlertPage(
                name: widget.name,
                image: widget.image,
                tagImage: widget.image + random.toString(),
                tagName: widget.name + random.toString(),
              ),
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Hero(
                tag: widget.image + random.toString(),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(widget.image),
                  ),
                ),
              ),
            ),
          ),
          title: Hero(
            tag: widget.name + random.toString(),
            child: Text(
              widget.name,
              style: GoogleFonts.jua(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Warna.font,
              ),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            FutureBuilder<dynamic>(
              future: FutureJson().price24hrDataCrypto(),
              builder: (BuildContext context, AsyncSnapshot snapshot24hr) {
                if (snapshot24hr.hasData) {
                  return FutureBuilder<dynamic>(
                    future: FutureJson().tickerDataCrypto(),
                    builder:
                        (BuildContext context, AsyncSnapshot snapshotTicker) {
                      if (snapshotTicker.hasData) {
                        return FutureBuilder<dynamic>(
                          future: FutureJson().price7dDataCrypto(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot7d) {
                            if (snapshot7d.hasData) {
                              dynamic dataTicker =
                                  snapshotTicker.data[widget.tickerid];
                              double persen24hr = (double.parse(
                                          snapshot24hr.data[widget.id]) -
                                      double.parse(
                                        dataTicker["last"],
                                      )) /
                                  double.parse(snapshot24hr.data[widget.id]) *
                                  -100;
                              double persen7d =
                                  (double.parse(snapshot7d.data[widget.id]) -
                                          double.parse(
                                            dataTicker["last"],
                                          )) /
                                      double.parse(snapshot7d.data[widget.id]) *
                                      -100;
                              return Column(
                                children: [
                                  Card(
                                    color: Warna.card,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                              top: 20,
                                              left: 10,
                                              right: 10,
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Warna.font,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  CurrencyFormat.convertToIdr(
                                                      double.parse(
                                                          dataTicker["last"])),
                                                  style: GoogleFonts.jua(
                                                      fontSize: 25,
                                                      color: Warna.card,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Divider(
                                                  thickness: 3,
                                                  color: Warna.background,
                                                ),
                                                IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "1D AGO",
                                                            style: GoogleFonts.jua(
                                                                color: Warna
                                                                    .background),
                                                          ),
                                                          Text(
                                                            CurrencyFormat.convertToIdr(
                                                                double.parse(
                                                                    snapshot24hr
                                                                            .data[
                                                                        widget
                                                                            .id])),
                                                            style:
                                                                GoogleFonts.jua(
                                                              color: Warna.card,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      VerticalDivider(
                                                        color: Warna.background,
                                                        thickness: 2,
                                                        endIndent: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "1W AGO",
                                                            style:
                                                                GoogleFonts.jua(
                                                              color: Warna
                                                                  .background,
                                                            ),
                                                          ),
                                                          Text(
                                                            CurrencyFormat.convertToIdr(
                                                                double.parse(
                                                                    snapshot7d
                                                                            .data[
                                                                        widget
                                                                            .id])),
                                                            style:
                                                                GoogleFonts.jua(
                                                              color: Warna.card,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      warna24jam =
                                                          Warna.background;
                                                      warna7hari = Warna.font;
                                                      warnaTeks24jam =
                                                          Warna.font;
                                                      warnaTeks7hari =
                                                          Warna.background;
                                                      persentase = persen24hr >
                                                              0
                                                          ? "+ ${persen24hr.toStringAsFixed(2)}%"
                                                          : persen24hr == 0
                                                              ? "${persen24hr.abs().toStringAsFixed(0)}%"
                                                              : "- ${persen24hr.abs().toStringAsFixed(2)}%";
                                                    },
                                                  );
                                                },
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.horizontal(
                                                    left: Radius.circular(10),
                                                  ),
                                                ),
                                                elevation: 5,
                                                color: warna24jam,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    "1D",
                                                    style: GoogleFonts.jua(
                                                        color: warnaTeks24jam,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              MaterialButton(
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      warna24jam = Warna.font;
                                                      warna7hari =
                                                          Warna.background;
                                                      warnaTeks24jam =
                                                          Warna.background;
                                                      warnaTeks7hari =
                                                          Warna.font;
                                                      persentase = persen7d > 0
                                                          ? "+ ${persen7d.toStringAsFixed(2)}%"
                                                          : persen7d == 0
                                                              ? "${persen7d.abs().toStringAsFixed(0)}%"
                                                              : "- ${persen7d.abs().toStringAsFixed(2)}%";
                                                    },
                                                  );
                                                },
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.horizontal(
                                                    right: Radius.circular(10),
                                                  ),
                                                ),
                                                elevation: 5,
                                                color: warna7hari,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  child: Text(
                                                    "1W",
                                                    style: GoogleFonts.jua(
                                                        color: warnaTeks7hari,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Warna.background,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    child: Text(
                                                      persentase,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts
                                                          .staatliches(
                                                              color: Warna.font,
                                                              fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: FutureBuilder<List<dynamic>>(
                                      future: FutureJson()
                                          .tradesDataCrypto(widget.tickerid),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                ),
                                                color: Warna.background),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "HARGA",
                                                        style: GoogleFonts.jua(
                                                          color: Warna.font,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "TRADES",
                                                        style: Style.fontJudul,
                                                      ),
                                                      Text(
                                                        "JUMLAH",
                                                        style: GoogleFonts.jua(
                                                          color: Warna.font,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      String harga =
                                                          CurrencyFormat
                                                              .convertToIdr(
                                                        double.parse(
                                                          snapshot.data[index]
                                                              ["price"],
                                                        ),
                                                      );
                                                      String jumlah =
                                                          snapshot.data[index]
                                                              ["amount"];
                                                      dynamic type = snapshot
                                                          .data[index]["type"];
                                                      return Container(
                                                        height: 40,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 1,
                                                            horizontal: 5),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: type == "buy"
                                                              ? Warna.naik
                                                              : Warna.turun,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "$harga/${widget.namaIDR}",
                                                              style: GoogleFonts
                                                                  .jua(
                                                                color: type ==
                                                                        "buy"
                                                                    ? Colors
                                                                        .black
                                                                    : Warna
                                                                        .font,
                                                              ),
                                                            ),
                                                            Text(
                                                              "$jumlah ${widget.namaIDR}",
                                                              style: GoogleFonts
                                                                  .jua(
                                                                color: type ==
                                                                        "buy"
                                                                    ? Colors
                                                                        .black
                                                                    : Warna
                                                                        .font,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Warna.font,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          flex: 8,
                                          child: SizedBox(),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            color: Warna.background,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DepositPage(
                                                    title:
                                                        "Pembelian ${widget.name}",
                                                    hargaCrypto:
                                                        dataTicker["last"],
                                                    namaIDR: widget.namaIDR,
                                                    nama: widget.name,
                                                    logoCrypto: widget.image,
                                                    tickerIDCrypto:
                                                        widget.tickerIDCrypto,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "BELI",
                                              style:
                                                  TextStyle(color: Warna.font),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
