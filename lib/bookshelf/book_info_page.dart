import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BookInfoPage extends StatefulWidget {
  final String bookTitle;
  final Color bookColor;

  const BookInfoPage(
      {super.key, required this.bookTitle, required this.bookColor});

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  Map<String, dynamic> bookInfo = {};
  late DocumentSnapshot<Map<String, dynamic>> cachedBookInfo;

  bool colorChangeFlag = false;
  late Color pickerColor = widget.bookColor;

  Future<DocumentSnapshot<Map<String, dynamic>>> getBookInfo() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    const source = Source.cache;

    print("Fetching from db...");
    cachedBookInfo = await db
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .doc(widget.bookTitle)
        .get(const GetOptions(source: source));

    return cachedBookInfo;
  }

  void updateDBColor() {
    DocumentReference updateBook = FirebaseFirestore.instance
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .doc(widget.bookTitle);

    updateBook
        .update({'color': pickerColor.value})
        .then((value) => print("Book color updated"))
        .catchError((error) => print("Failed to update book color: $error"));

    DocumentReference updateBasicColor = FirebaseFirestore.instance
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .doc('basicBookshelfInfo');

    updateBasicColor
        .update({widget.bookTitle: pickerColor.value})
        .then((value) => print("basicBookshelfInfo color updated"))
        .catchError((error) =>
            print("Failed to update color in basicBookshelfInfo: $error"));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (colorChangeFlag) {
      updateDBColor();
    }

    print("Back To old Screen");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void changeColor(Color color) {
      pickerColor = color;
      colorChangeFlag = true;
    }

    Future showPicker() {
      return showDialog(
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        context: context,
      );
    }

    Future<DocumentSnapshot<Map<String, dynamic>>> fetchCachedBooks() async {
      return cachedBookInfo;
    }

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(pickerColor),
          ),
          backgroundColor: const Color.fromARGB(255, 246, 190, 85),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: colorChangeFlag ? fetchCachedBooks() : getBookInfo(),
                builder: (context, docSnapshot) {
                  if (docSnapshot.connectionState == ConnectionState.done) {
                    bookInfo.addEntries(docSnapshot.data!.data()!.entries);

                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: pickerColor, width: 20)),
                          child: Column(children: [
                            Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(bookInfo['title'].toString(),
                                  textScaler: const TextScaler.linear(3.0),
                                  style: const TextStyle(
                                      fontFamily: 'StratfordRegular')),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(bookInfo['author'].toString(),
                                  textScaler: const TextScaler.linear(1.5),
                                  style: const TextStyle(
                                      fontFamily: 'StratfordRegular')),
                            ),
                          ]),
                        ),
                        StarRating(
                          rating: bookInfo['rating'],
                          allowHalfRating: false,
                          size: 50,
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(top: 15, bottom: 30),
                          child: Text('Read: ${bookInfo['date'].toString()}',
                              textScaler: const TextScaler.linear(1.0),
                              style: const TextStyle(
                                  fontFamily: 'StratfordRegular')),
                        ),
                        FloatingActionButton.extended(
                          backgroundColor:
                              const Color.fromARGB(255, 246, 190, 85),
                          foregroundColor:
                              const Color.fromARGB(255, 241, 135, 70),
                          label: const Text('Change color'),
                          onPressed: () => showPicker(),
                        )
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })));
  }
}
