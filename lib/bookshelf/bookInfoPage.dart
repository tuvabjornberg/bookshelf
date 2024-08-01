import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookInfoPage extends StatefulWidget {
  late String bookTitle;

  BookInfoPage({super.key, required this.bookTitle});
  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 246, 190, 85),
          title: Text("InduvidualBook"),
        ),
        body: Center(
            child: SingleChildScrollView(
              child: FutureBuilder(future: getBookInfo(), builder: (context, docSnapshot) {
                if (docSnapshot.connectionState == ConnectionState.done) {
                  return Column(children: [
                    Container(child: Text(docSnapshot.data!.data()!.values.toString()),)
                  ],);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
            )
            ));
  }
}
