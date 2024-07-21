import 'package:flutter/material.dart';

class InduvidualBook extends StatefulWidget {
  const InduvidualBook({super.key});
  @override
  _InduvidualBookState createState() => _InduvidualBookState();
}

class _InduvidualBookState extends State<InduvidualBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 246, 190, 85),
          title: Text("InduvidualBook"),
        ),
        body: const Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text('InduvidualBook MAIN'),
            ])));
  }
}
