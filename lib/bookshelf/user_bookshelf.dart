import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookShelf extends StatefulWidget {
  const BookShelf({super.key});
  @override
  _BookShelfState createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  void getAllBooks() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    const source = Source.cache;

    db
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .get(const GetOptions(source: source))
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 246, 190, 85),
          title: const Text("Your bookshelf"),
        ),
        body: const Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text('MAIN BOOK SHELF'),
            ])));
  }
}
