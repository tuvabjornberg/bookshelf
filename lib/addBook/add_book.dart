import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String title = "";
  String author = "";
  int month = 0;
  int year = 0;
  double rating = 0;

  final controller = TextEditingController();

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
            'rating': rating
          })
          .then((value) => print("Book Added"))
          .catchError((error) => print("Failed to add book: $error"));
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
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(labelText: 'Title'),
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                    ),
                    TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(labelText: 'Author'),
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        setState(() {
                          author = value;
                          controller.clear();
                        });
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
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
                            controller: controller,
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
                      backgroundColor: const Color.fromARGB(255, 246, 190, 85),
                      foregroundColor: const Color.fromARGB(255, 241, 135, 70),
                      onPressed: () {
                        _submit();
                        controller.clear();
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
