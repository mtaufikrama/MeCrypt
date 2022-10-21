import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mecrypt/service.dart';

class CryptoPage extends StatefulWidget {
  final String tickerid;
  final String id;
  final String namaIDR;
  final String deskripsi;
  final String name;
  final String image;

  const CryptoPage({
    Key? key,
    required this.tickerid,
    required this.id,
    required this.namaIDR,
    required this.deskripsi,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  final String summariesUrl = "https://indodax.com/api/summaries";

  Future<dynamic> _tickerDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["tickers"][widget.tickerid];
  }

  Future<dynamic> _price24hrDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["prices_24h"][widget.id];
  }

  Future<dynamic> _price7dDataCrypto() async {
    var response = await http.get(Uri.parse(summariesUrl));
    return json.decode(response.body)["prices_7d"][widget.id];
  }

  Future<List<dynamic>> _tradesDataCrypto() async {
    final String tradesUrl =
        "https://indodax.com/api/${widget.tickerid}/trades";
    var response = await http.get(Uri.parse(tradesUrl));
    return json.decode(response.body);
  }

  Color? warna24jam = Warna.font;
  Color? warna7hari = Warna.font;
  Color? warnaTeks7hari = Warna.background;
  Color? warnaTeks24jam = Warna.background;

  String persentase = "nothink";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(200),
                            top: Radius.circular(20))),
                    title: Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                    content: Image.network(
                      widget.image,
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.image),
              ),
            ),
          ),
          title: Text(
            widget.name,
            style: GoogleFonts.jua(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Warna.font,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(
                Icons.refresh,
                color: Warna.font,
              ),
            ),
          ],
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            Container(
              margin: const EdgeInsets.only(top: 223),
              decoration: BoxDecoration(
                color: Warna.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
            ),
            FutureBuilder<dynamic>(
              future: _price24hrDataCrypto(),
              builder: (BuildContext context, AsyncSnapshot snapshot24hr) {
                if (snapshot24hr.hasData) {
                  return FutureBuilder<dynamic>(
                    future: _tickerDataCrypto(),
                    builder:
                        (BuildContext context, AsyncSnapshot snapshotTicker) {
                      if (snapshotTicker.hasData) {
                        return FutureBuilder<dynamic>(
                          future: _price7dDataCrypto(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot7d) {
                            if (snapshot7d.hasData) {
                              double persen24hr =
                                  (int.parse(snapshot24hr.data) -
                                          int.parse(
                                            snapshotTicker.data["last"],
                                          )) /
                                      int.parse(snapshot24hr.data) *
                                      -100;
                              double persen7d = (int.parse(snapshot7d.data) -
                                      int.parse(
                                        snapshotTicker.data["last"],
                                      )) /
                                  int.parse(snapshot7d.data) *
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
                                                      int.parse(snapshotTicker
                                                          .data["last"])),
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
                                                                int.parse(
                                                                    snapshot24hr
                                                                        .data)),
                                                            style: GoogleFonts.jua(
                                                                color: Warna
                                                                    .card, fontSize: 18,),
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
                                                            CurrencyFormat
                                                                .convertToIdr(
                                                                    int.parse(
                                                                        snapshot7d
                                                                            .data)),
                                                            style:
                                                                GoogleFonts.jua(
                                                              color: Warna
                                                                  .card, fontSize: 18,
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
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: FutureBuilder<List<dynamic>>(
                                      future: _tradesDataCrypto(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                      int.parse(
                                                        snapshot.data[index]
                                                            ["price"],
                                                      ),
                                                    );
                                                    String jumlah = snapshot
                                                        .data[index]["amount"];
                                                    dynamic type = snapshot
                                                        .data[index]["type"];
                                                    return Container(
                                                      height: 40,
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 1,
                                                          horizontal: 5),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      decoration: BoxDecoration(
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
                                                            style:
                                                                GoogleFonts.jua(
                                                              color: type ==
                                                                      "buy"
                                                                  ? Colors.black
                                                                  : Warna.font,
                                                            ),
                                                          ),
                                                          Text(
                                                            "$jumlah ${widget.namaIDR}",
                                                            style:
                                                                GoogleFonts.jua(
                                                              color: type ==
                                                                      "buy"
                                                                  ? Colors.black
                                                                  : Warna.font,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const Align(
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator());
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
                                            onPressed: () {},
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
