import 'package:colorize/colorize.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class Logging {
  static void multiline(Object? obj, Styles style, {String? startText, String? endText}) {
    if (obj == null) return;
    if (startText != null) color('\t\t$startText', front: style);
    final lines = (obj.toString().split('\n')).where((line) => line.trim().isNotEmpty);
    for (final line in lines) {
      color('\t\t$line', front: style);
    }
    if (endText != null) color('\t\t$endText', front: style);
  }

  static void setupLogging({bool isDebug = false}) {
    hierarchicalLoggingEnabled = true;

    Logger.root.level = isDebug ? Level.ALL : Level.INFO;
    Logger.root.onRecord.listen((record) {
      final level = record.level.toString();
      if (record.loggerName == 'hotreloader' && ['FINE', 'FINER', 'FINEST'].contains(level)) {
        return;
      }
      Styles front = Styles.BLACK;
      switch (level) {
        case 'SHOUT':
        case 'SEVERE':
          front = Styles.RED;
          break;
        case 'FINEST':
          front = Styles.DARK_GRAY;
          break;
        case 'FINER':
        case 'FINE':
          front = Styles.GREEN;
          break;
        case 'CONFIG':
        case 'INFO':
          front = Styles.BLUE;
          break;
        case 'WARNING':
          front = Styles.YELLOW;
          break;
      }
      final num = Colorize('[${record.sequenceNumber}]')
        ..bold()
        ..apply(front);
      final time = Colorize(DateFormat('HH:mm:ss').format(record.time))
        ..bold()
        ..apply(front);
      final name = Colorize(record.loggerName)
        ..underline()
        ..bold()
        ..apply(front);
      final message = Colorize(record.message)..apply(front);
      color('$num $time $name $message');
      multiline(record.error, front);
      multiline(record.stackTrace, front, startText: '=== STACK ===');
    });
  }
}
