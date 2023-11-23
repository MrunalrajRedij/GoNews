import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gonews/utils/config/decoration.dart' as decoration;
import 'package:share_plus/share_plus.dart';

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
                  pubDate ?? "",
                  style: decoration.tileHeading14TS,
                ),
                Text(
                  sourceId ?? "",
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
                    Share.share('Check out this NEWS:\n'
                        '$link');
                  },
                  icon: const Icon(
                    Icons.share,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
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
                url: Uri.parse(link),
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
