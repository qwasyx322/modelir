import 'dart:collection';
import 'dart:io';
import 'arguments.dart';

class CommandRunner {
  final Map<String, Command> _commands = <String, Command>{};

  UnmodifiableSetView<Command> get commands =>
      UnmodifiableSetView<Command>(<Command>{..._commands.values});

  Future<void> run(List<String> input) async {
    if (input.isEmpty) {
      print(usage);
      return;
    }
    
    final ArgResults results = parse(input);
    if (results.command != null) {
      Object? output = await results.command!.run(results);
      if (output != null) {
        print(output.toString());
      }
    } else {
      print('Unknown command: ${input.first}');
      print(usage);
    }
  }

  void addCommand(Command command) {
    _commands[command.name] = command;
    command.runner = this;
  }

  ArgResults parse(List<String> input) {
    var results = ArgResults();
    results.command = _commands[input.first];
    return results;
  }

  String get usage {
    final exeFile = Platform.script.path.split('/').last;
    return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
  }
}