import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gonews/utils/apiUtils.dart';
import 'package:gonews/widgets/menuDrawer.dart';
import 'package:gonews/widgets/newsListWidget.dart';
import 'package:gonews/utils/config/palette.dart' as palette;
import 'package:gonews/utils/config/decoration.dart' as decoration;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsListWidget> newsLists = [];
  TextEditingController searchController = TextEditingController();
  String nextPage = "";

  @override
  void initState() {
    super.initState();
    getNews(nextPage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getNews(String page) async {
    dynamic newsData = await ApiUtils().getHomeScreenNews(page);
    for (int i = 0; i < newsData.length; i++) {
      newsLists.add(
        NewsListWidget(
          title: newsData['results'][i]['title'],
          link: newsData['results'][i]['link'],
          creator: newsData['results'][i]['creator'],
          videoUrl: newsData['results'][i]['video_url'],
          desc: newsData['results'][i]['description'],
          content: newsData['results'][i]['content'],
          pubDate: newsData['results'][i]['pubDate'],
          imageUrl: newsData['results'][i]['image_url'],
          sourceId: newsData['results'][i]['source_id'],
        ),
      );
      nextPage = newsData['nextPage'];
      print("///////${newsData['results'][i]['video_url']}");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        titleSpacing: 5,
        iconTheme: const IconThemeData(color: palette.primaryColor),
        backgroundColor: palette.scaffoldBgColor,
        elevation: 0,
        title: const Text(
          'NEWS ON THE GO',
          style: TextStyle(color: palette.primaryColor),
        ),
        //text-field to type pattern for searching in to UserListScreen
        // title: Scrollable(
        //   viewportBuilder: (BuildContext context, ViewportOffset position) =>
        //       TypeAheadField(
        //         debounceDuration: const Duration(milliseconds: 500),
        //         textFieldConfiguration: TextFieldConfiguration(
        //           style: decoration.normal14TS,
        //           controller: searchController,
        //           decoration: InputDecoration(
        //             contentPadding: const EdgeInsets.only(top: 5),
        //             fillColor: palette.textFieldGreyColor,
        //             filled: true,
        //             prefixIcon:
        //             const Icon(Icons.search, color: palette.lightBlackColor),
        //             hintText: "Start Searching...",
        //             hintStyle: decoration.normal14TS,
        //             border: OutlineInputBorder(
        //               borderRadius: BorderRadius.circular(10),
        //               borderSide: BorderSide.none,
        //             ),
        //           ),
        //           onSubmitted: (String pattern) async {
        //
        //           },
        //         ),
        //         suggestionsCallback: (String pattern) async {
        //           return await ApiUtils().getHomeScreenNews();
        //         },
        //         itemBuilder: (context, Map<String, Object> suggestion) {
        //           return
        //         },
        //         noItemsFoundBuilder: (context) => Center(
        //           child: Text(
        //             'No Items Found!',
        //             style: decoration.normal14TS,
        //           ),
        //         ),
        //         onSuggestionSelected: (Map<String, Object> suggestion) async {
        //
        //         },
        //       ),
        // ),
      ),
      drawer: const MenuDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            child: newsLists.isEmpty
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: newsLists.length,
                    itemBuilder: (context, index) {
                      return newsLists[index];
                    }),
          ),
        ),
      ),
    );
  }
}
