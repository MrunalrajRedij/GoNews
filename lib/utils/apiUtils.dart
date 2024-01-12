import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gonews/widgets/newsListWidget.dart';
import 'package:http/http.dart' as http;
import 'package:gonews/utils/config/values.dart' as values;
import 'package:intl/intl.dart';

class ApiUtils {
  Future getHomeScreenNews(int page) async {
    DateTime date = DateTime.now().subtract(const Duration(days: 1));
    String homeScreenNewsUrl = "";
    homeScreenNewsUrl = "https://newsapi.org/v2/everything?q=india"
        "&language=en"
        "&from=${DateFormat("yyyy-MM-dd").format(date)}"
        "&page=$page"
        "sortBy=publishedAt"
        "&apiKey=${values.apiKey}";
    try {
      var url = Uri.parse(homeScreenNewsUrl);
      var response = await http.get(
        url,
      );
      return json.decode(response.body)["articles"];
    } catch (_) {}
  }

  Future<bool> saveNews(NewsListWidget newsListWidget) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.phoneNumber)
          .collection('Saved')
          .doc(newsListWidget.title)
          .set({
        'title': newsListWidget.title,
        'articleId': newsListWidget.articleId,
        'link': newsListWidget.link,
        'creator': newsListWidget.creator,
        'videoUrl': newsListWidget.videoUrl,
        'desc': newsListWidget.desc,
        'content': newsListWidget.content,
        'pubDate': newsListWidget.pubDate,
        'imageUrl': newsListWidget.imageUrl,
        'sourceId': newsListWidget.sourceId,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeNews(String title) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.phoneNumber)
          .collection('Saved')
          .doc(title)
          .delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
