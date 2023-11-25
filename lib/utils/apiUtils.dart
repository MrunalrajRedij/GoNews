import 'dart:convert';
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
        // "&from=2023-11-10"
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
}
