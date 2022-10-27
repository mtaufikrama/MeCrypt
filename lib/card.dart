import 'package:flutter/material.dart';
import 'package:mecrypt/service.dart';

class ListCard extends StatelessWidget {
  final Function()? onTap;
  final Function()? onDoubleTap;
  final Color? color;
  final String title;
  final String subtitle;
  final String kananTengah;
  final String logoCrypto;
  const ListCard({
    super.key,
    this.onTap,
    this.onDoubleTap,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.kananTengah,
    required this.logoCrypto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: GestureDetector(
            onDoubleTap: onDoubleTap,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
              child: Material(
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(50),
                ),
                color: color,
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(40),
                    ),
                    color: Warna.font,
                  ),
                  margin: const EdgeInsets.only(right: 12, bottom: 2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Style.fontKripto,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              subtitle,
                              style: Style.fontAngka,
                            ),
                          ],
                        ),
                        Text(
                                kananTengah,
                                style: Style.fontAngka,
                              )
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
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(200),
                            top: Radius.circular(20))),
                    title: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                    content: Image.network(logoCrypto),
                  );
                },
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(logoCrypto),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
