enum SortingMethod {
  standard('Standard'),
  alphTitle('A-Z Titles'),
  alphAuthor('A-Z Authors'),
  dateRecent('Date, most recent'),
  dateOld('Date, least recent'),
  ratingHigh('Highest rating'),
  ratingLow('Lowest rating');

  const SortingMethod(this.label);
  final String label;
}


List<String> sortAuthor(Map<String, dynamic> completeBookData) {
  var sortedKeys = Map.fromEntries(completeBookData.entries.toList()
    ..sort(((e1, e2) => e1.value['author'].compareTo(e2.value['author']))));

  return sortedKeys.keys.toList();
}

List<String> sortRating(Map<String, dynamic> completeBookData, bool highRating) {
  Map<String, dynamic> sortedKeys;

  if (highRating) {
    sortedKeys = Map.fromEntries(completeBookData.entries.toList()
      ..sort(((e1, e2) => e2.value['rating'].compareTo(e1.value['rating']))));
  } else {
    sortedKeys = Map.fromEntries(completeBookData.entries.toList()
      ..sort(((e1, e2) => e1.value['rating'].compareTo(e2.value['rating']))));
  }

  return sortedKeys.keys.toList();
}
