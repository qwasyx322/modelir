import 'package:cli/cli.dart';
import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async {
  final errorLogger = initFileLogger('errors');
  
  // Тестовое сообщение для проверки
  errorLogger.info('Application started with arguments: $arguments');
  
  final app = CommandRunner(
    onOutput: (String output) async {
      await write(output);
    },
    onError: (Object error) {
      errorLogger.warning('Error caught: $error');
      if (error is Error) {
        errorLogger.severe(
          '[Error] ${error.toString()}\n${error.stackTrace}',
        );
        throw error;
      }
      if (error is Exception) {
        errorLogger.warning(error.toString());
      }
    },
  )
    ..addCommand(HelpCommand())
    ..addCommand(SearchCommand(logger: errorLogger))
    ..addCommand(GetArticleCommand(logger: errorLogger));

  app.run(arguments);
  
  // Сообщение о завершении
  errorLogger.info('Application finished');
}