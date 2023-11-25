import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:gonews/utils/apiUtils.dart';
import 'package:gonews/widgets/menuDrawer.dart';
import 'package:gonews/widgets/newsListWidget.dart';
import 'package:gonews/utils/config/palette.dart' as palette;

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
  int nextPage = 1;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    getNews(nextPage);
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  void getNews(int page) async {
    newsLists.clear();
    setState(() {});
    dynamic newsData = await ApiUtils().getHomeScreenNews(nextPage);
    for (int i = 0; i < newsData.length; i++) {
      newsLists.add(
        NewsListWidget(
          title: newsData[i]['title'],
          link: newsData[i]['url'],
          creator: newsData[i]['author'],
          desc: newsData[i]['description'],
          content: newsData[i]['content'],
          pubDate: newsData[i]['publishedAt'],
          imageUrl: newsData[i]['urlToImage'],
          sourceId: newsData[i]['source']['name'],
        ),
      );
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
        child: RefreshIndicator(
          onRefresh: () async {
            player.play(AssetSource('audios/refresh.mp3'));
            getNews(nextPage);
          },
          child: Center(
            child: Container(
              child: newsLists.isEmpty
                  ? ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: GFShimmer(
                            child: Container(
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : ListView.builder(
                      itemCount: newsLists.length,
                      itemBuilder: (context, index) {
                        return newsLists[index];
                      }),
            ),
          ),
        ),
      ),
    );
  }
}
