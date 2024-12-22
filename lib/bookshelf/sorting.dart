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

List<String> sortRating(
    Map<String, dynamic> completeBookData, bool highRating) {
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

List<String> sortDate(Map<String, dynamic> completeBookData, bool dateRecent) {
  Map<String, dynamic> sortedKeys;

  if (dateRecent) {
    sortedKeys = Map.fromEntries(completeBookData.entries.toList()
      ..sort(((e1, e2) {
        List<String> e1Split = e1.value['date'].split('/');
        List<String> e2Split = e2.value['date'].split('/');

        // Obs! Compares strings
        int year = e2Split[1].compareTo(e1Split[1]);

        // If year is the same, the month is compared instead
        if (year == 0) {
          // Obs! Compares ints
          return int.tryParse(e2Split[0])!
              .compareTo(int.tryParse(e1Split[0]) as num);
        }
        return year;
      })));
  } else {
    sortedKeys = Map.fromEntries(completeBookData.entries.toList()
      ..sort(((e1, e2) {
        List<String> e1Split = e1.value['date'].split('/');
        List<String> e2Split = e2.value['date'].split('/');

        // Obs! Compares strings
        int year = e1Split[1].compareTo(e2Split[1]);

        // If year is the same, the month is compared instead
        if (year == 0) {
          // Obs! Compares ints
          return int.tryParse(e1Split[0])!
              .compareTo(int.tryParse(e2Split[0]) as num);
        }
        return year;
      })));
  }

  return sortedKeys.keys.toList();
}
