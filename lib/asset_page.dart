// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecrypt/service.dart';
import 'package:provider/provider.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  @override
  Widget build(BuildContext context) {
    var asset = context.watch<MoneyAssets>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Text(
              "data",
              style: GoogleFonts.jua(
                fontSize: 25,
                color: Warna.font,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: asset.listAssets.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic assetsList = asset.listAssets[index];
                  int hargaCryptoAssets = 0;
                  int jumlahCryptoAssets = 1;
                  int hargaCryptoToday = 2;
                  int namaCrypto = 3;
                  int logoCrypto = 4;
                  return Card(
                    color: Warna.font,
                    child: ListTile(
                      title: Text(CurrencyFormat.convertToIdr(int.parse(assetsList[hargaCryptoAssets]))),
                      subtitle: Text(assetsList[jumlahCryptoAssets]),
                      trailing: Image.network(assetsList[logoCrypto]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
