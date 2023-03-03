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
          child: InkWell(
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
                                flightShuttleBuilder: (flightContext,
                                        animation,
                                        flightDirection,
                                        fromHeroContext,
                                        toHeroContext) =>
                                    DefaultTextStyle(
                                  style:
                                      DefaultTextStyle.of(toHeroContext).style,
                                  child: toHeroContext.widget,
                                ),
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
        SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: () => context.pushTransparentRoute(
              ImagePage(
                name: title,
                image: logoCrypto,
                tagImage: logoCrypto + random.toString(),
                tagName: title + random.toString(),
              ),
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
            ),
            child: Hero(
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                      fromHeroContext, toHeroContext) =>
                  DefaultTextStyle(
                style: DefaultTextStyle.of(toHeroContext).style,
                child: toHeroContext.widget,
              ),
              tag: logoCrypto + random.toString(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  logoCrypto,
                  fit: BoxFit.contain,
                ),
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
