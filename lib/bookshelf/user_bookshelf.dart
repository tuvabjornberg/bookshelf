import 'dart:math';

import 'package:bookshelf/bookshelf/induvidual_book.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookShelf extends StatefulWidget {
  const BookShelf({super.key});
  @override
  _BookShelfState createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  late final Map<String, dynamic> data;
  List<String> bookIds = [];

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
          bookIds.add(docSnapshot.id);
          //print('${docSnapshot.id} => ');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {});
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
    getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            //appBar: AppBar(
            //  backgroundColor: const Color.fromARGB(255, 246, 190, 85),
            //  title: const Text("Your bookshelf"),
            //),
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
              decoration: const BoxDecoration(
                color: Color(0XFF8A6B4E),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0XFF664F3A),
                    ),
                    child: Column(
                      children: [
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
                                                  const InduvidualBook(),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero));
                                    },
                                    child: Container(
                                        height: 94,
                                        width: 24,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 0.5),
                                        decoration: const BoxDecoration(
                                          color: Color(0XFFF1B4B4),
                                        ),
                                        child: RotatedBox(
                                            quarterTurns: 1,
                                            child: FittedBox(
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.contain,
                                              child: Text(bookIds[0]),
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
                                  decoration: const BoxDecoration(
                                    color: Color(0X9ECE9696),
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
                              Expanded(
                                child: Container(
                                  height: 86,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0XFFF1B4B4),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 58,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0X9ECE9696),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 74,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0XFFF1B4B4),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 94,
                                    width: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0X9ECE9696),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 86,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0XFFF1B4B4),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 58,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0X9ECE9696),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 94,
                                    width: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0XFFF1B4B4),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 80,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0X9ECE9696),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 94,
                                    width: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0XFFF1B4B4),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 38),
                        Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(left: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 74,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0X9ECE9696),
                                  ),
                                ),
                              ),
                              Container(
                                height: 86,
                                width: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0XFFF1B4B4),
                                ),
                              )
                            ],
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
