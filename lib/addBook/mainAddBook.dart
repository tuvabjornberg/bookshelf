import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

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
  int score = 0;
  double rating = 0;

  void _submit() {}

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
                      decoration: const InputDecoration(labelText: 'Title'),
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Author'),
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) {
                        setState(() {
                          author = value;
                        });
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Month'),
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (value) {
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
                            decoration:
                                const InputDecoration(labelText: 'Year'),
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (value) {
                              setState(() {
                                year = int.tryParse(value) ?? year;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StarRating(
                      rating: rating,
                      allowHalfRating: false,
                      size: 50,
                      onRatingChanged: (rating) =>
                          setState(() => this.rating = rating),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton(
                      backgroundColor: const Color.fromARGB(255, 246, 190, 85),
                      foregroundColor: const Color.fromARGB(255, 241, 135, 70),
                      onPressed: () {
                        _submit();
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
