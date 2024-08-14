import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class AddBook extends StatefulWidget {
  const AddBook({super.key});
  
  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String title = "";
  String author = "";
  int month = 0;
  int year = 0;
  double rating = 0;

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  void resetEntries() {
    title = "";
    author = "";
    month = 0;
    year = 0;
    rating = 0;
    setState(() {});
  }

  void _submit() {
    if (title.isNotEmpty) {
      int randomGeneratedColor = Color.fromARGB(
        255,
        Random().nextInt(70) + 150,
        Random().nextInt(100) + 100,
        Random().nextInt(130) + 50,
      ).value;

      DocumentReference newBook = FirebaseFirestore.instance
          .collection('users')
          .doc('ArXYsUX9UaW5oORBejfd')
          .collection('books')
          .doc(title);

      newBook
          .set({
            'title': title,
            'author': author,
            'date': '$month/$year',
            'rating': rating,
            'color': randomGeneratedColor
          })
          .then((value) => print("Book Added"))
          .catchError((error) => print("Failed to add book: $error"));

      DocumentReference newTitleColorReference = FirebaseFirestore.instance
          .collection('users')
          .doc('ArXYsUX9UaW5oORBejfd')
          .collection('books')
          .doc('basicBookshelfInfo');

      newTitleColorReference
          .update({title: randomGeneratedColor})
          .then((value) => print("basicBookshelfInfo item Added"))
          .catchError(
              (error) => print("Failed to add to basicBookshelfInfo: $error"));

      resetEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 246, 190, 85),
          title: const Text("Add book"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                        ),
                        TextFormField(
                          controller: authorController,
                          decoration:
                              const InputDecoration(labelText: 'Author'),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              author = value;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: monthController,
                                decoration:
                                    const InputDecoration(labelText: 'Month'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    month = int.tryParse(value) ?? month;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: yearController,
                                decoration:
                                    const InputDecoration(labelText: 'Year'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    year = int.tryParse(value) ?? year;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        //const SizedBox(
                        //  height: 20,
                        //),
                        StarRating(
                          rating: rating,
                          allowHalfRating: false,
                          size: 50,
                          onRatingChanged: (rating) =>
                              setState(() => this.rating = rating),
                        ),
                        //const SizedBox(
                        //  height: 20,
                        //),
                        FloatingActionButton(
                          backgroundColor:
                              const Color.fromARGB(255, 246, 190, 85),
                          foregroundColor:
                              const Color.fromARGB(255, 241, 135, 70),
                          onPressed: () {
                            _submit();
                            titleController.clear();
                            authorController.clear();
                            monthController.clear();
                            yearController.clear();
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
