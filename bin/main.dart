import 'dart:io';

void main(
  List<String> args,
) {
  if (args.isEmpty || args.length != 2) {
    stdout.writeln('Usage: dart bin/main.dart <year> <day>.');
    exit(1);
  }

  final [year, day] = args;

  final file = File('lib/$year/day_$day.dart');
  if (!file.existsSync()) {
    stderr.writeln('File at path: ${file.path} not found.');
    exit(1);
  }

  final result = Process.runSync('dart', [file.path]);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(1);
  }

  // Print the result of the script.
  stdout.write(result.stdout);
  exit(0);
}
