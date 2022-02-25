import 'package:flutter/material.dart';
import 'package:project_app/routes/searchnews.dart';
import 'package:project_app/utils/styles.dart';
import 'categorySearch.dart';
import 'package:flutter/cupertino.dart';

class SearchPageAnnon extends StatefulWidget {
  const SearchPageAnnon({Key? key}) : super(key: key);

  @override
  _SearchPageAnnonState createState() => _SearchPageAnnonState();
}

class _SearchPageAnnonState extends State<SearchPageAnnon> {
  final List genres = [
    "Technology",
    "Politics",
    "Sports",
    "Magazine",
    "Gaming",
    "Science"
  ];

  int idx = 1;

  List appbarsTitles = [
    "/FeedPageAnnon",
    "/SearchPageAnnon",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PageColors.appBarColor,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: PageColors.buttonColor),
                      onPressed: () async {
                        final finalResult = await showSearch(
                            context: context, delegate: NewsSearchPage());
                      },
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                            child: Text("Search via title"),
                          )
                        ],
                      ))),
                ),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: genres
                        .map((e) => Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: PageColors.buttonColor),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CategorySearch(genre: e)));
                              },
                              child: Center(child: Text(e)),
                            )))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            // elevation: 20.0,

            shape: CircularNotchedRectangle(),
            child: Container(
              height: 75,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0),
                    icon: Icon(Icons.home),
                    onPressed: () {
                      setState(() {
                        idx = 0;
                        Navigator.of(context).pushNamed(appbarsTitles[idx]);
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(right: 28.0),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        idx = 1;
                        Navigator.of(context).pushNamed(appbarsTitles[idx]);
                      });
                    },
                  ),
                ],
              ),
            )));
  }
}

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PageColors.appBarColor,
    );
  }
}

/*

*/
