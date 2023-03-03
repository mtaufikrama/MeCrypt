import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:mecrypt/service.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({
    Key? key,
    required this.name,
    required this.image,
    required this.tagImage,
    required this.tagName,
  }) : super(key: key);

  final String name;
  final String image;
  final String tagImage;
  final String tagName;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      startingOpacity: 0.7,
      isFullScreen: false,
      backgroundColor: Colors.black,
      direction: DismissiblePageDismissDirection.multi,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                flightShuttleBuilder: (flightContext, animation,
                        flightDirection, fromHeroContext, toHeroContext) =>
                    DefaultTextStyle(
                  style: DefaultTextStyle.of(toHeroContext).style,
                  child: toHeroContext.widget,
                ),
                tag: tagName,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Style.fontDialog,
                ),
              ),
              Hero(
                tag: tagImage,
                child: SizedBox(
                  width: responsive(
                    context,
                    mobile: MediaQuery.of(context).size.width * 0.8,
                    desktop: null,
                  ),
                  height: responsive(
                    context,
                    mobile: null,
                    desktop: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: Image.network(
                    image,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
