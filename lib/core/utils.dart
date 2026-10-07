/// Extension to convert a string to title case.
extension StringTitleCase on String {
  String toTitleCase() {
    if (isEmpty) return '';
    return split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}
