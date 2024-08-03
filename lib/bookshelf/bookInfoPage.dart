import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BookInfoPage extends StatefulWidget {
  late String bookTitle;
  late Color bookColor;

  BookInfoPage({super.key, required this.bookTitle, required this.bookColor});
  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  Map<String, dynamic> bookInfo = {};

  Future<DocumentSnapshot<Map<String, dynamic>>> getBookInfo() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    const source = Source.cache;

    print("Fetching from db...");
    return await db
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .doc(widget.bookTitle)
        .get(const GetOptions(source: source));
  }

  @override
  Widget build(BuildContext context) {
    Color pickerColor = Color(0xff443a49);

    void changeColor(Color color) {
      pickerColor = color;
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
                setState(() => widget.bookColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        context: context,
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 246, 190, 85),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: getBookInfo(),
                builder: (context, docSnapshot) {
                  if (docSnapshot.connectionState == ConnectionState.done) {
                    bookInfo.addEntries(docSnapshot.data!.data()!.entries);

                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: bookInfo['color'] ?? widget.bookColor,
                                  width: 20)),
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
