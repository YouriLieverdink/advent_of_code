import 'dart:io';

Future<void> main(
  List<String> args,
) async {
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

  // Run the process, and time.
  final stopwatch = Stopwatch();
  stopwatch.start();

  final process = await Process.start('dart', [file.path]);

  // Pipe the stdout and stderr.
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  // Wait for the process to exit.
  final exitCode = await process.exitCode;

  stopwatch.stop();
  stdout.writeln('Time: ${stopwatch.elapsedMilliseconds}ms');

  exit(exitCode);
}
