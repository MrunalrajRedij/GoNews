import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiUtils {
  Future getHomeScreenNews(String page) async {
    String homeScreenNewsUrl = "";
    if (page == "") {
      homeScreenNewsUrl = "https://newsdata.io/api/1/news?"
          "apikey=pub_28954d8170804bdab99bcfd4903c8d6267e77"
          "&country=in"
          "&language=en";
    } else {
      homeScreenNewsUrl = "https://newsdata.io/api/1/news?"
          "apikey=pub_28954d8170804bdab99bcfd4903c8d6267e77"
          "&country=in"
          "&language=en"
          "&page=$page";
    }
    try {
      var url = Uri.parse(homeScreenNewsUrl);
      var response = await http.get(
        url,
      );
      return json.decode(response.body);
    } catch (_) {}
  }
}
