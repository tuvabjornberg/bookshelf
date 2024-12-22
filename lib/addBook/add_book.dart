import 'package:bookshelf/main.dart';
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
                          key: const ValueKey('in_title_field'),
                          decoration: const InputDecoration(labelText: 'Title'),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: authorController,
                          key: const ValueKey('in_author_field'),
                          decoration:
                              const InputDecoration(labelText: 'Author'),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              author = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an author';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: monthController,
                                key: const ValueKey('in_month_field'),
                                decoration: const InputDecoration(
                                    labelText: 'Month', hintText: '1-12'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    month = int.tryParse(value) ?? month;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a month';
                                  }
                                  if (int.tryParse(value)! > 12 ||
                                      int.tryParse(value)! < 1) {
                                    return 'Enter a valid month 1-12';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: yearController,
                                key: const ValueKey('in_year_field'),
                                decoration:
                                    const InputDecoration(labelText: 'Year'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    year = int.tryParse(value) ?? year;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a year';
                                  }
                                  int? intValue = int.tryParse(value);
                                  if (intValue! > DATENOW.year ||
                                      intValue < 1900 ||
                                      (intValue < DATENOW.year &&
                                          month > DATENOW.month)) {
                                    return 'Enter a valid year';
                                  }
                                  return null;
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
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Adding book'),
                                  backgroundColor:
                                      Color.fromARGB(255, 241, 135, 70),
                                ),
                              );

                              _submit();
                              titleController.clear();
                              authorController.clear();
                              monthController.clear();
                              yearController.clear();
                            }
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
