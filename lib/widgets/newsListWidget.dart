import 'package:flutter/material.dart';
import 'package:gonews/screens/fullNewsScreen.dart';

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
    required this.content,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title ?? ""),
                      const SizedBox(height: 10),
                      Text(
                        desc ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                imageUrl != null
                    ? SizedBox(
                        width: 150,
                        height: 100,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(pubDate),
                Text(sourceId),
              ],
            ),
            const Divider(),
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
