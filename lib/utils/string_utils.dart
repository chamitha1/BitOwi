class StringUtils {
  StringUtils._(); // 🔒 no instance

  static String toTitleCase(String text) {
    if (text.isEmpty) return text;

    return text
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) =>
            word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}
