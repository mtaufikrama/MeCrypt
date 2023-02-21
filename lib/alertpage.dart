import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({
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
                tag: tagName,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Hero(
                tag: tagImage,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.network(
                    image,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // await downloadImage(imageUrl);
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // AlertDialog(
        //   shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(
        //           bottom: Radius.circular(200), top: Radius.circular(20))),
        //   title: Text(
        //     name,
        //     textAlign: TextAlign.center,
        //     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        //   ),
        //   content: Hero(
        //     tag: tag,
        //     child: Image.network(
        //       image,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
