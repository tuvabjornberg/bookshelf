import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookShelf extends StatefulWidget {
  const BookShelf({super.key});
  @override
  _BookShelfState createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  late final Map<String, dynamic> data;

  void getAllBooks() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    const source = Source.cache;

    await db
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .get(const GetOptions(source: source))
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          data[docSnapshot.id] = docSnapshot.data();
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<QuerySnapshot> getBooks() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    const source = Source.cache;

    return await db
        .collection('users')
        .doc('ArXYsUX9UaW5oORBejfd')
        .collection('books')
        .get(const GetOptions(source: source));
  }

  @override
  void initState() {
    super.initState();
    //getAllBooks();
  }

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
}
