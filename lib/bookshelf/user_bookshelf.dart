import 'dart:math';

import 'package:bookshelf/bookshelf/bookInfoPage.dart';
import 'package:bookshelf/bookshelf/bookWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookShelf extends StatefulWidget {
  const BookShelf({super.key});
  @override
  _BookShelfState createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  List<String> bookIds = [];
  List<Color> bookshelfColors = [];

  int bookIndexDB = 0;

  void addIdsColors(String id, int color) {
    bookIds.add(id);
    bookshelfColors.add(Color(color));
  }

  void getAllBooks() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    const source = Source.cache;

    await db
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .doc('basicBookshelfInfo')
        .get() //const GetOptions(source: source)) TODO:??? Crashes if source???
        .then(
      (documentSnapshot) {
        print("Successfully completed");
        print(documentSnapshot.id);
        print(documentSnapshot.data());

        documentSnapshot.data()?.forEach((k, v) => addIdsColors(k, v));
      },
      onError: (e) => print("Error completing: $e"),
    );
/*
    await db
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .get(const GetOptions(source: source))
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          bookIds.add(docSnapshot.id);
          print(docSnapshot.data());
          //bookshelfColors.add(docSnapshot.data().entries)
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    */
    setState(() {});
  }

  //Future<QuerySnapshot?> getBooks() async {
  //  FirebaseFirestore db = FirebaseFirestore.instance;
//
  //  const source = Source.cache;
//
  //  print("Fetching from db...");
  //  return await db
  //      .collection('users')
  //      .doc('ArXYsUX9UaW5oORBejfd')
  //      .collection('books')
  //      .get(const GetOptions(source: source));
  //}

  @override
  void initState() {
    super.initState();

    _loadPreferences();
  }

  void _loadPreferences() async {
//    final prefs = await SharedPreferences.getInstance();
//
//    bookIds = prefs.getStringList('bookTitles') ?? [];
//    bookIndexDB = prefs.getInt('nBookTitles') ?? 0;
//
//    if (bookIds.length != bookIndexDB || true) {
    getAllBooks();
//      prefs.setStringList("bookTitles", bookIds);
//      prefs.setInt('nBookTitles', bookIds.length);
//    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color lightBrownEdgeShelf = const Color(0XFF8A6B4E);
    Color brownInnerShelf = const Color(0XFF664F3A);

    int maxBookIndex = bookIds.length;

    return SafeArea(
        child: Scaffold(
            body: Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightBrownEdgeShelf,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: brownInnerShelf,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 96,
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: maxBookIndex <= 11
                                ? maxBookIndex
                                : 11, //TODO: depends on nShelfs
                            itemBuilder: (context, index) {
                              return Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                      onTap: () async {
                                        final returnedColor = await Navigator.of(
                                                context,
                                                rootNavigator: true)
                                            .push(PageRouteBuilder(
                                                pageBuilder: (context, x, xx) =>
                                                    BookInfoPage(
                                                        bookTitle:
                                                            bookIds[index],
                                                        bookColor:
                                                            (bookshelfColors[
                                                                index])),
                                                transitionDuration:
                                                    Duration.zero,
                                                reverseTransitionDuration:
                                                    Duration.zero));
                                        setState(() {
                                          bookshelfColors[index] = returnedColor;
                                        });
                                      },
                                      child: Row(children: [
                                        Container(
                                            height: Random().nextInt(37) + 64,
                                            width: 26.3,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 0.5),
                                            decoration: BoxDecoration(
                                              color: bookshelfColors[index],
                                            ),
                                            child: RotatedBox(
                                                quarterTurns: 1,
                                                child: FittedBox(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  fit: BoxFit.contain,
                                                  child: Text(bookIds[index]),
                                                  //Text(snapshot.data!.docs[index].id.toString()), // Text(bookTitles.data![index]), //TODO: + 11, depends on nShelfs
                                                )))
                                      ])));
                            },
                          ),
                        ),
                        Container(
                          color: lightBrownEdgeShelf,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 8,
                          ),
                        ),
                        const SizedBox(height: 336)
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 6)
          ],
        ),
      ),
    )));
  }

  /*
                        Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(left: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(PageRouteBuilder(
                                              pageBuilder: (context, x, xx) =>
                                                  const BookInfoPage(),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero));
                                    },
                                    child: Container(
                                        height: 94,
                                        width: 24,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 0.5),
                                        decoration: BoxDecoration(
                                          color: lightPinkBook,
                                        ),
                                        child: RotatedBox(
                                            quarterTurns: 1,
                                            child: FittedBox(
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.contain,
                                              child: Text(bookIds[bookIdIndex]),
                                            ))),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 74,
                                  width: 24,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 0.5),
                                  decoration: BoxDecoration(
                                    color: darkPinkBook,
                                  ),
                                  child: const RotatedBox(
                                      quarterTurns: 1,
                                      child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.contain,
                                        child: Text('nisifhisuhfsi'),
                                      )),
                                ),
                              ),
                      
                            ],
                          ),
                        ),
                        UnconstrainedBox(
                          child: Container(
                            color: lightBrownEdgeShelf,
                            width: overflowWidth,
                            height: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        */

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 246, 190, 85),
          title: const Text("Your bookshelf"),
        ),
        body: Column(children: [
          Expanded(
            child: FutureBuilder(
                future: getBooks(),
                builder: (context, querySnapshot) {
                  if (querySnapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: querySnapshot.data?.docs.length ?? 0,
                        itemBuilder: (BuildContext context, index) {
                          return ListTile(
                              title: Text(querySnapshot.data!.docs[index]
                                  .data()
                                  .toString()));
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ]));
  }
  */
}
