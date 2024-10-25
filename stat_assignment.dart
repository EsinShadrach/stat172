import 'dart:io';
import 'dart:math' as math;

List<int> dataSet = [
  10,
  11,
  9,
  10,
  12,
  7,
  10,
  9,
  8,
  10,
  9,
  9,
  12,
  8,
  11,
  10,
  10,
  9,
  8,
  9,
  12,
  10,
  8,
  10,
  10,
  10,
  11,
  11,
  10,
  11,
  11,
  8,
  9,
  10,
  8,
  9,
  10,
  10,
  9,
  11,
  9,
  10,
  10,
  11,
  8,
  10,
  12,
  11,
  11,
  8,
  9,
  8,
  11,
  9,
  9,
  9,
  11,
  11,
  11,
  10,
  12,
  9,
  10,
  11,
  9,
  9,
  12,
  8,
  10,
  10,
  11,
  9,
  9,
  12,
  10,
  9,
  9,
  9,
  9,
  10
];

// List<int> dataSet = [
//   10,
//   11,
//   9,
//   10,
//   12,
//   7,
//   10,
//   9,
//   8,
//   10,
//   9,
//   9,
//   12,
//   8,
//   11,
//   10,
//   10,
//   9,
//   8,
//   9,
//   12,
//   10,
//   8,
//   10,
//   10,
//   10,
//   11,
//   11,
//   10,
//   11,
//   11,
//   8,
//   9,
//   10,
//   8,
//   9,
//   10,
//   10,
//   9,
//   11,
//   9,
//   10,
//   10,
//   11,
//   8,
//   10,
//   12,
//   11,
//   11,
//   8,
//   9,
//   8,
//   11,
//   9,
//   9,
//   9,
//   11,
//   11,
//   11,
//   10,
//   12,
//   9,
//   10,
//   11,
//   9,
//   9,
//   12,
//   8,
//   10,
//   10,
//   11,
//   9,
//   9,
//   12,
//   10,
//   9,
//   9,
//   9,
//   9,
//   10
// ];

int sampleSize = 32;

void main() async {
  int count = 10;

  // Create the markdown file
  final file = File('output.md');
  final sink = file.openWrite();

  for (var i = 0; i < count; i++) {
    sink.write("## SOLUTION ${i + 1}\n\n");

    final List<int> table = createTable();
    final mean = table.mean();
    final standardDeviation = table.standardDeviation();

    // Write table to file in Markdown format
    sink.write("### Data Table\n");
    sink.write(markdownTable(table));

    // Write mean and standard deviation
    sink.write("\n**Mean**: ${mean}\n");
    sink.write("**Standard Deviation**: ${standardDeviation}\n");
    sink.write("\n---\n");
  }

  await sink.close();
  print("Markdown file written as output.md");
}

/// create a table from the data set based on our unique sample set
List<int> createTable() {
  List<int> table = [];
  List<int> sampleSet = uniqueSampleSet().toList();

  for (var i = 0; i < sampleSet.length; i++) {
    int element = sampleSet[i];
    final neededIndex = dataSet[element];

    table.add(neededIndex);
  }

  return table;
}

/// we need 32 unique numbers as an array based on sampleSize
Set<int> uniqueSampleSet() {
  Set<int> uniqueNumbers = {};

  while (uniqueNumbers.length < sampleSize) {
    final int randomNum = generateRandomNumber();

    uniqueNumbers.add(randomNum);
  }

  return uniqueNumbers;
}

/// Generates a random number between 10 and 79, if number is less than 19 or greater than 79 retry
int generateRandomNumber() {
  int number = 0;

  while (number < 10 || number > dataSet.length - 1) {
    double random = math.Random().nextDouble();
    final int toMultipleOf10 = (random * 100).toInt();

    number = toMultipleOf10;
  }

  return number;
}

/// Converts a list of integers into a Markdown table format with a max of 10 columns per row
String markdownTable(List<int> data) {
  final buffer = StringBuffer();
  final int columns = 10; // Number of columns per row

  // Generate the header row with appropriate column numbers
  buffer.write('|');
  for (int i = 0; i < columns; i++) {
    buffer.write(' Value |');
  }
  buffer.writeln();

  // Generate the separator row
  buffer.write('|');
  for (int i = 0; i < columns; i++) {
    buffer.write('-------|');
  }
  buffer.writeln();

  // Populate the table with the data, 10 items per row
  for (int i = 0; i < data.length; i++) {
    if (i % columns == 0) buffer.write('|'); // Start a new row

    buffer.write(' ${data[i]} |');

    if ((i + 1) % columns == 0) buffer.writeln(); // End the row
  }

  return buffer.toString();
}

extension Statistics on List<int> {
  /// Calculates the arithmetic mean of the list
  double mean() {
    if (isEmpty) {
      throw StateError('Cannot calculate mean of empty list');
    }

    return reduce((a, b) => a + b) / length;
  }

  /// Calculates the population standard deviation
  double standardDeviation() {
    if (isEmpty) {
      throw StateError('Cannot calculate standard deviation of empty list');
    }

    if (length == 1) {
      return 0.0;
    }

    final double meanValue = mean();
    final Iterable<num> squaredDifferences = map(
      (x) => math.pow(x - meanValue, 2),
    );
    return math.sqrt(
      squaredDifferences.reduce((a, b) => a + b) / length,
    );
  }
}
