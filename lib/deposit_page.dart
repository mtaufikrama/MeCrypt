import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecrypt/service.dart';
import 'package:provider/provider.dart';

class DepositPage extends StatefulWidget {
  final String title;
  final String hargaCrypto;
  final String namaIDR;
  const DepositPage({
    Key? key,
    required this.title,
    required this.hargaCrypto,
    required this.namaIDR,
  }) : super(key: key);

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  int counter = 1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController depoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var asset = context.watch<MoneyAssets>();
    int hargaUpdate = int.parse(widget.hargaCrypto) * counter;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.title,
            style: Style.fontJudul,
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              children: [
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Warna.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: widget.title == "DEPOSIT"
                        ? const EdgeInsets.all(10)
                        : const EdgeInsets.symmetric(
                            vertical: 28, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "MY ASSETS\n${asset.assetRp}",
                            textAlign: TextAlign.center,
                            style: Style.fontJudul,
                          ),
                        ),
                        widget.title == "DEPOSIT"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Isi Nominal :",
                                    style: GoogleFonts.jua(
                                        color: Warna.font, fontSize: 18),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Warna.font,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Rp ",
                                          style: Style.fontTeks,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            autofocus: true,
                                            controller: depoController,
                                            style: GoogleFonts.jua(
                                              color: Warna.background,
                                              fontSize: 20,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (counter > 0) {
                                            setState(() {
                                              counter--;
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: Warna.font,
                                        ),
                                      ),
                                      Text(
                                        counter.toString(),
                                        style: GoogleFonts.jua(
                                            color: Warna.font, fontSize: 20),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            counter++;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Warna.font,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${CurrencyFormat.convertToIdr(hargaUpdate)}\t",
                                    style: GoogleFonts.jua(
                                        color: Warna.font, fontSize: 20),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        color: Warna.background),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "DAFTAR BANK",
                            style: Style.fontJudul,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: listBank.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (widget.title == "DEPOSIT") {
                                    if (int.parse(depoController.text) >=
                                        10000) {
                                      setState(() {
                                        asset.asset =
                                            int.parse(depoController.text);
                                      });
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.scale,
                                        title: "BERHASIL DEPOSIT",
                                        desc:
                                            "Deposit sebesar ${CurrencyFormat.convertToIdr(int.parse(depoController.text))} menggunakan ${listBank[index][1]}",
                                        btnOkOnPress: () {},
                                      ).show();
                                      depoController.text = "";
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.scale,
                                        title: "GAGAL DEPOSIT",
                                        desc: "Minimal deposit Rp 10.000",
                                        btnOkOnPress: () {},
                                      ).show();
                                    }
                                  } else {
                                    if (hargaUpdate == 0) {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.infoReverse,
                                        animType: AnimType.scale,
                                        desc: "Kamu tidak melakukan pembelian",
                                        btnOkOnPress: () {},
                                      ).show();
                                    } else if (hargaUpdate < asset.asset) {
                                      setState(() {
                                        asset.asset = -hargaUpdate;
                                      });
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.scale,
                                        title: "PEMBELIAN BERHASIL",
                                        desc:
                                            "${widget.title} sebanyak $counter ${widget.namaIDR} \nSebesar ${CurrencyFormat.convertToIdr(hargaUpdate)}",
                                        btnOkOnPress: () {},
                                      ).show();
                                      counter = 0;
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.scale,
                                        title: "PEMBELIAN GAGAL",
                                        desc:
                                            "Asset kamu tidak cukup untuk pembelian",
                                        btnOkOnPress: () {},
                                      ).show();
                                    }
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1),
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 5,
                                      ),
                                      child: ListTile(
                                        leading: Image.asset(
                                          "assets/bank/${listBank[index][0]}",
                                          width: 100,
                                        ),
                                        title: Text(
                                          listBank[index][1],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Image.asset(
                                          "assets/bank/arrow.png",
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
