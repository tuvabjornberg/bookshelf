import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  final String date;
  final Color color;
  final double rating;

  Book({
    required this.title, 
    this.author = '',
    this.date = '',
    required this.color,
    this.rating = 0
  });
}
