import 'dart:io';

List<String> readFileAsLinesSync(
  String path,
) {
  final file = File(path);
  final lines = file.readAsLinesSync();

  return lines;
}
