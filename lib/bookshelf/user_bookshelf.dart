import 'dart:math';

import 'package:bookshelf/bookshelf/book_info_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookshelf/bookshelf/sorting.dart';
import 'package:bookshelf/bookshelf/book.dart';

class BookShelf extends StatefulWidget {
  const BookShelf({super.key});

  @override
  State<BookShelf> createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  List<String> standardBookIds = [];
  List<String> bookIds = [];
  List<Color> bookshelfColors = [];

  Map<String, dynamic> completeBookData = {};
  bool fetchedData = false;

  int bookIndexDB = 0;

  final TextEditingController sortingController = TextEditingController();
  SortingMethod selectedSortingMethod = SortingMethod.standard;

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
        .get(const GetOptions(source: source))
        .then(
      (documentSnapshot) {
        print("Successfully completed fetch basicBookshelfInfo");
        documentSnapshot.data()?.forEach((k, v) => addIdsColors(k, v));
      },
      onError: (e) => print("Error completing: $e"),
    );

    standardBookIds.addAll(bookIds);

    setState(() {});
  }

  Future<void> getAllData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    const source = Source.cache;

    await db
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .get(const GetOptions(source: source))
        .then(
      (querySnapshot) {
        print("Successfully completed fetch all data");
        for (var docSnapshot in querySnapshot.docs) {
          completeBookData[docSnapshot.id] = docSnapshot.data();
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    completeBookData.remove('basicBookshelfInfo');
    fetchedData = true;

    setState(() {});
  }

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
    int nShelves = (maxBookIndex / 11).ceil();
    double bookWidth = (MediaQuery.sizeOf(context).width - 56.5) / 11;

    return SafeArea(
        child: Scaffold(
            body: Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: DropdownButton<SortingMethod>(
                value: selectedSortingMethod,
                icon: const Icon(Icons.sort_rounded),
                onChanged: (SortingMethod? sortingMethod) async {
                  selectedSortingMethod = sortingMethod!;

                  switch (selectedSortingMethod) {
                    case SortingMethod.standard:
                      bookIds = standardBookIds;
                      break;
                    case SortingMethod.alphTitle:
                      //Alphabetical sort titles
                      bookIds.sort();
                      break;
                    case SortingMethod.alphAuthor:
                      //Alphabetical sort authors
                      if (!fetchedData) {
                        await getAllData();
                      }
                      bookIds = sortAuthor(completeBookData);
                      break;
                    case SortingMethod.dateRecent:
                      //TODO:
                      break;
                    case SortingMethod.dateOld:
                      //TODO:
                      break;
                    case SortingMethod.ratingHigh:
                      //Sort based on highest rating
                      if (!fetchedData) {
                        await getAllData();
                      }
                      bookIds = sortRating(completeBookData, true);
                      break;
                    case SortingMethod.ratingLow:
                      //Sort based on lowest rating
                      if (!fetchedData) {
                        await getAllData();
                      }
                      bookIds = sortRating(completeBookData, false);
                      break;
                    default:
                      bookIds = standardBookIds;
                      break;
                  }
                  setState(() {});
                },
                items:
                    SortingMethod.values.map<DropdownMenuItem<SortingMethod>>(
                  (SortingMethod method) {
                    return DropdownMenuItem<SortingMethod>(
                      value: method,
                      child: Text(method.label),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(),
            Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: lightBrownEdgeShelf,
                ),
                child: Column(
                  children: [
                    Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: brownInnerShelf,
                        ),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: nShelves,
                            itemBuilder: (context, shelfIndex) {
                              return Column(
                                children: [
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 96,
                                    width: double.infinity,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: maxBookIndex <= 11
                                          ? maxBookIndex
                                          : shelfIndex < nShelves - 1
                                              ? 11
                                              : maxBookIndex - 11 * shelfIndex,
                                      itemBuilder: (context, index) {
                                        return Align(
                                            alignment: Alignment.bottomLeft,
                                            child: GestureDetector(
                                                onTap: () async {
                                                  String title = bookIds[
                                                      shelfIndex * 11 + index];

                                                  final returnedColor = await Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
                                                      pageBuilder: (context, x, xx) => fetchedData
                                                          ? BookInfoPage(
                                                              book: Book(
                                                                  title: title,
                                                                  author: completeBookData[title]
                                                                      [
                                                                      'author'],
                                                                  date: completeBookData[title]
                                                                      ['date'],
                                                                  color: bookshelfColors[
                                                                      shelfIndex * 11 +
                                                                          index],
                                                                  rating: completeBookData[title]
                                                                      ['rating']))
                                                          : BookInfoPage(book: Book(title: title, color: bookshelfColors[shelfIndex * 11 + index])),
                                                      transitionDuration: Duration.zero,
                                                      reverseTransitionDuration: Duration.zero));
                                                  setState(() {
                                                    bookshelfColors[shelfIndex *
                                                            11 +
                                                        index] = returnedColor;
                                                  });
                                                },
                                                child: Row(children: [
                                                  const SizedBox(width: 0.5),
                                                  Container(
                                                      height:
                                                          Random().nextInt(37) +
                                                              64,
                                                      width: bookWidth,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5,
                                                          horizontal: 0.5),
                                                      decoration: BoxDecoration(
                                                        color: bookshelfColors[
                                                            shelfIndex * 11 +
                                                                index],
                                                      ),
                                                      child: RotatedBox(
                                                          quarterTurns: 1,
                                                          child: FittedBox(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            fit: BoxFit.contain,
                                                            child: Text(bookIds[
                                                                shelfIndex *
                                                                        11 +
                                                                    index]),
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
                                ],
                              );
                            }))
                  ],
                )),
          ],
        ),
      ),
    )));
  }
}
