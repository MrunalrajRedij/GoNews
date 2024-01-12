import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:gonews/utils/config/palette.dart' as palette;
import 'package:gonews/utils/config/decoration.dart' as decoration;
import 'package:gonews/widgets/menuDrawer.dart';
import 'package:gonews/widgets/newsListWidget.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<NewsListWidget> newsLists = [];
  TextEditingController searchController = TextEditingController();
  int nextPage = 1;
  final player = AudioPlayer();
  final user = FirebaseAuth.instance.currentUser;

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
          'SAVED NEWS',
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
      backgroundColor: palette.scaffoldBgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            player.play(AssetSource('audios/refresh.mp3'));
          },
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(user?.phoneNumber)
                  .collection("Saved")
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
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
                    : snapshot.data?.size == 0
                        ? Center(
                            child: Text(
                              'No Saved News',
                              style: decoration.blueBold18TS,
                            ),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot newsData = snapshot
                                  .data?.docs[index] as DocumentSnapshot;
                              return NewsListWidget(
                                title: newsData['title'],
                                link: newsData['link'],
                                creator: newsData['creator'],
                                desc: newsData['desc'],
                                content: newsData['content'],
                                pubDate: newsData['pubDate'],
                                imageUrl: newsData['imageUrl'],
                                sourceId: newsData['sourceId'],
                                saved: true,
                              );
                            },
                          );
              }),
        ),
      ),
    );
  }
}
