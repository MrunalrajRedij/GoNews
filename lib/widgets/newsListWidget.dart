import 'dart:io';
import 'package:gonews/utils/apiUtils.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gonews/utils/config/decoration.dart' as decoration;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gonews/utils/config/palette.dart' as palette;

class NewsListWidget extends StatefulWidget {
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
  bool? saved;

  NewsListWidget({
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
    this.saved,
  }) : super(key: key);

  @override
  State<NewsListWidget> createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  @override
  Widget build(BuildContext context) {
    final DateTime dateTime =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(widget.pubDate);

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            widget.imageUrl != null
                ? SizedBox(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
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
                        widget.title ?? "",
                        style: decoration.tileHeading20TS,
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
                  timeago.format(dateTime),
                  style: decoration.tileHeading14TS,
                ),
                Text(
                  widget.sourceId ?? "",
                  style: decoration.tileHeading14TS,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Share.share(
                        '${widget.title}\n\n${widget.desc}\n\nRead more: ${widget.link}');
                  },
                  icon: const Icon(
                    Icons.share,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 10),
                widget.saved!
                    ? IconButton(
                        onPressed: () async {
                          bool success =
                              await ApiUtils().removeNews(widget.title);
                          setState(() {
                            widget.saved = false;
                          });
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            success
                                ? const SnackBar(
                                    content: Text(
                                      "NEWS Un-saved !!!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : const SnackBar(
                                    content: Text(
                                      "Error in removing NEWS!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: palette.redColor,
                                  ),
                          );
                        },
                        icon: const Icon(
                          Icons.bookmark,
                          size: 40,
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          bool success = await ApiUtils().saveNews(
                            NewsListWidget(
                              title: widget.title,
                              articleId: widget.articleId,
                              link: widget.link,
                              creator: widget.creator,
                              videoUrl: widget.videoUrl,
                              desc: widget.desc,
                              content: widget.content,
                              pubDate: widget.pubDate,
                              imageUrl: widget.imageUrl,
                              sourceId: widget.sourceId,
                            ),
                          );
                          setState(() {
                            widget.saved = true;
                          });
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            success
                                ? const SnackBar(
                                    content: Text(
                                      "NEWS Saved !!!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : const SnackBar(
                                    content: Text(
                                      "Error in saving NEWS!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: palette.redColor,
                                  ),
                          );
                        },
                        icon: const Icon(
                          Icons.bookmark_border,
                          size: 40,
                        ),
                      )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 3),
          ],
        ),
      ),
      onTap: () async {
        if (Platform.isAndroid) {
          await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
              true);

          var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
              AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
          var swInterceptAvailable =
              await AndroidWebViewFeature.isFeatureSupported(
                  AndroidWebViewFeature
                      .SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

          if (swAvailable && swInterceptAvailable) {
            InAppBrowser().openUrlRequest(
              urlRequest: URLRequest(
                url: Uri.parse(widget.link),
              ),
              options: InAppBrowserClassOptions(
                inAppWebViewGroupOptions: InAppWebViewGroupOptions(
                  android: AndroidInAppWebViewOptions(useWideViewPort: false),
                  ios: IOSInAppWebViewOptions(enableViewportScale: true),
                ),
                android: AndroidInAppBrowserOptions(),
                ios: IOSInAppBrowserOptions(
                    presentationStyle: IOSUIModalPresentationStyle.FULL_SCREEN),
                crossPlatform: InAppBrowserOptions(
                    toolbarTopBackgroundColor: Colors.white),
              ),
            );
          }
        }
      },
    );
  }
}
