import 'package:bookshelf/bookshelf/user_bookshelf.dart';
import 'package:flutter/material.dart';

class BookWidget extends StatefulWidget {
  late String bookId;
  late double height;
  late double width;

  BookWidget(
      {super.key,
      required this.bookId,
      required this.height,
      required this.width});
  @override
  _BookWidgetState createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  Color lightBrownEdgeShelf = const Color(0XFF8A6B4E);
  Color brownInnerShelf = const Color(0XFF664F3A);
  Color lightPinkBook = const Color(0XFFF1B4B4);
  Color darkPinkBook = const Color(0X9ECE9696);

  @override
  Widget build(BuildContext context) {
    return 
    //Expanded(
    //  child: 
      Container(
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0.5),
        decoration: BoxDecoration(
          color: darkPinkBook,
        ),
        child: RotatedBox(
            quarterTurns: 1,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.contain,
              child: Text(widget.bookId),
            )),
      //),
    );
  }
}
