import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class SinarScreen extends StatefulWidget {
  final Future<void> Function()? onSignOut;

  const SinarScreen({super.key, this.onSignOut});

  @override
  State<SinarScreen> createState() => _SinarScreenState();
}

class _SinarScreenState extends State<SinarScreen> {
  /// Holds the last result or null if no result exists yet.
  String? _resultMessage;

  /// Holds the last error message that we've received from the server or null
  /// if no error exists yet.
  String? _errorMessage;

  final _textEditingController = TextEditingController();

  /// Calls the `hello` method of the `greeting` endpoint. Will set either the
  /// `_resultMessage` or `_errorMessage` field, depending on if the call
  /// is successful.
  void _callToResponse() async {
    try {
      // final result = await client.greeting.hello(_textEditingController.text);
      final numberSanitized = _sanitizeInput(_textEditingController.text);
      if (numberSanitized == null) {
        throw 'number cannot be null';
      }
      final result = await client.sinar.process(numberSanitized);
      setState(() {
        _errorMessage = null;
        _resultMessage = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (widget.onSignOut != null) ...[
            const Text('You are connected'),
            ElevatedButton(
              onPressed: widget.onSignOut,
              child: const Text('Sign out'),
            ),
          ],
          const SizedBox(height: 32),
          TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter whole the number only',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'([0-9]+([.,][0-9]*)?)$')),

            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _callToResponse,
            child: const Text('Send to Server'),
          ),
          const SizedBox(height: 16),
          ResultDisplay(
            resultMessage: _resultMessage,
            errorMessage: _errorMessage,
          ),
        ],
      ),
    );
  }

  String? _sanitizeInput(String input) {
    String cleanNumbers = input.replaceAll(RegExp(r'[.,]'), '');
    int? parsedValue = int.tryParse(cleanNumbers);
    return parsedValue?.toString();
  }
}

/// ResultDisplays shows the result of the call. Either the returned result
/// from the `example.greeting` endpoint method or an error message.
class ResultDisplay extends StatelessWidget {
  final String? resultMessage;
  final String? errorMessage;

  const ResultDisplay({super.key, this.resultMessage, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    String text;
    Color backgroundColor;
    if (errorMessage != null) {
      backgroundColor = Colors.red[300]!;
      text = errorMessage!;
    } else if (resultMessage != null) {
      backgroundColor = Colors.green[300]!;
      text = resultMessage!;
    } else {
      backgroundColor = Colors.grey[300]!;
      text = 'No server response yet.';
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50),
      child: Container(
        color: backgroundColor,
        child: Center(child: Text(text)),
      ),
    );
  }
}
