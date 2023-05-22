import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mekla/widgets/common/snack_bar.dart';

extension LoggerExtension on Logger {
  void errorStackTrace(Object error, StackTrace stackTrace,
      {String method = '', String message = 'An error has occurred'}) {
    log(Level.error, message, error, stackTrace);
    CustomSnackBar.warning(message.tr);
  }
}

class LoggerService extends GetxService {
  Logger? _logger;

  static LoggerService get find => Get.find<LoggerService>();

  static Logger? get logger => Get.find<LoggerService>()._logger;

  Future<LoggerService> init({fileOutput = true}) async {
    _logger = Logger(
        output: MultiOutput([ConsoleOutput()]),
        printer: PrettyPrinter(
          printEmojis: false,
          printTime: true,
          noBoxingByDefault: true,
          methodCount: 1,
          lineLength: 50,
        ));
    return this;
  }
}
