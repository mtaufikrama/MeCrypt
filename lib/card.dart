import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:mecrypt/alertpage.dart';
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
    final int random = Random().nextInt(400);
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: title + random.toString(),
                                child: Text(
                                  title,
                                  style: Style.fontKripto,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                subtitle,
                                style: Style.fontAngka,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          kananTengah,
                          style: Style.fontAngka,
                          overflow: TextOverflow.ellipsis,
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
            onTap: () => context.pushTransparentRoute(
              AlertPage(
                name: title,
                image: logoCrypto,
                tagImage: logoCrypto + random.toString(),
                tagName: title + random.toString(),
              ),
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
            ),
            child: Hero(
              tag: logoCrypto + random.toString(),
              child: CircleAvatar(
                backgroundImage: NetworkImage(logoCrypto),
              ),
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
