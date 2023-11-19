import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gonews/utils/config/values.dart' as values;
class ApiUtils {

  Future getHomeScreenNews(int page) async {
    String homeScreenNewsUrl = "";
    homeScreenNewsUrl = "https://newsapi.org/v2/everything?q=india"
        "&language=en"
        "&page=$page"
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
