import 'dart:async';
import 'dart:io';

import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

class GetArticleCommand extends Command {
  GetArticleCommand({required this.logger});

  final Logger logger;

  @override
  String get description => 'Read an article from Wikipedia';

  @override
  String get name => 'article';

  @override
  String get help => 'Gets an article by exact canonical wikipedia title.';

  @override
  String get defaultValue => 'cat';

  @override
  String get valueHelp => 'STRING';

  @override
  bool get requiresArgument => false;

  @override
  FutureOr<String> run(ArgResults args) async {
    try {
      var title = args.commandArg ?? defaultValue;
      final List<Article> articles = await getArticleByTitle(title);
      final article = articles.first;
      final buffer = StringBuffer('\n=== ${article.title} ===\n\n');
      final extractWords = article.extract.split(' ');
      final trimmedExtract = extractWords.take(500).join(' ');
      buffer.write(trimmedExtract);
      if (extractWords.length > 500) {
        buffer.write('\n\n... (truncated)');
      }
      return buffer.toString();
    } on HttpException catch (e) {
      logger
        ..warning(e.message)
        ..info(usage);
      return 'Error: ${e.message}';
    } on FormatException catch (e) {
      logger
        ..warning(e.message)
        ..info(usage);
      return 'Error: ${e.message}';
    }
  }
}