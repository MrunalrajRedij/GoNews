import 'package:flutter/material.dart';
import 'package:gonews/screens/fullNewsScreen.dart';
import 'package:gonews/utils/config/decoration.dart' as decoration;

class NewsListWidget extends StatelessWidget {
  final articleId,
      title,
      link,
      creator,
      videoUrl,
      desc,
      content,
      pubDate,
      imageUrl,
      sourceId;

  const NewsListWidget({
    Key? key,
    this.articleId,
    required this.title,
    this.link,
    this.creator,
    this.videoUrl,
    this.desc,
    this.content,
    this.pubDate,
    this.imageUrl,
    this.sourceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            imageUrl != null
                ? Hero(
                    tag: 'animation',
                    child: SizedBox(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? "",
                        style: decoration.tileHeading16TS,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        desc ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pubDate ?? "",
                  style: decoration.tileHeading12TS,
                ),
                Text(
                  sourceId ?? "",
                  style: decoration.tileHeading12TS,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 3),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullNewsScreen(
              title: title,
              link: link,
              creator: creator,
              videoUrl: videoUrl,
              desc: desc,
              content: content,
              pubDate: pubDate,
              imageUrl: imageUrl,
              sourceId: sourceId,
            ),
          ),
        );
      },
    );
  }
}
