import 'package:flutter/material.dart';
import 'package:gonews/utils/config/palette.dart' as palette;
import 'package:gonews/utils/config/decoration.dart' as decoration;

class FullNewsScreen extends StatefulWidget {
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

  const FullNewsScreen({
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
  State<FullNewsScreen> createState() => _FullNewsScreenState();
}

class _FullNewsScreenState extends State<FullNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: palette.scaffoldBgColor,
        foregroundColor: palette.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_add_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.imageUrl != null
                    ? Hero(
                        tag: 'animation',
                        child: SizedBox(
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: decoration.tileHeading16TS,
                ),
                const SizedBox(height: 20),
                Text(widget.desc),
                Text(widget.content),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.sourceId,
                      style: decoration.tileHeading12TS,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.pubDate,
                      style: decoration.tileHeading12TS,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
