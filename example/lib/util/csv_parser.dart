class CsvParser {
  static List<List<String>> parse(String rawCsvData) {
    final lines =
        rawCsvData.split('\n').where((line) => line.isNotEmpty).toList();
    final headers = _parseCsvLine(lines.first);

    return [
      headers,
      ...lines.skip(1).map((line) => _parseCsvLine(line)),
    ];
  }

  static List<String> _parseCsvLine(String line) {
    final values = <String>[];
    final buffer = StringBuffer();
    bool insideQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        if (insideQuotes && i + 1 < line.length && line[i + 1] == '"') {
          // Handle escaped quotes
          buffer.write('"');
          i++; // Skip the next quote
        } else {
          // Toggle the insideQuotes flag
          insideQuotes = !insideQuotes;
        }
      } else if (char == ',' && !insideQuotes) {
        // End of value
        values.add(buffer.toString());
        buffer.clear();
      } else {
        // Normal character
        buffer.write(char);
      }
    }

    // Add the last value
    values.add(buffer.toString());

    return values;
  }
}
