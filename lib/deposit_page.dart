import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecrypt/service.dart';
import 'package:provider/provider.dart';

class DepositPage extends StatefulWidget {
  final Widget? title;
  const DepositPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController depoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var asset = context.watch<MoneyAssets>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: widget.title,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 200),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        color: Warna.background),
                  ),
                )
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(20),
                    color: Warna.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "MY ASSETS\n${asset.assetRp}",
                            textAlign: TextAlign.center,
                            style: Style.fontJudul,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    validator: ValidationBuilder()
                                        .minLength(5, "Minimal Rp 10.000")
                                        .build(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "DEPOSIT",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jua(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ListDepo.text.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                asset.asset = int.parse(depoController.text);
                              });
                              depoController.text = "";
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      ListDepo.text[index],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40),
                                    ),
                                    content: Image.asset(
                                      "assets/bank/${ListDepo.image[index]}",
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
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
                                    "assets/bank/${ListDepo.image[index]}",
                                    width: 100,
                                  ),
                                  title: Text(
                                    ListDepo.text[index],
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
          ],
        ),
      ),
    );
  }
}
