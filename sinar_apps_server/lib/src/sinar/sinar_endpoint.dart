import 'package:serverpod/serverpod.dart';

class SinarEndpoint extends Endpoint {
  Future<String> process(Session session, String value) async {
    final reversedValue = value.split('').reversed.join('');
    final intValue = int.parse(value);
    final reversedIntValue = int.parse(reversedValue);
    final reversedIntValueWithoutZeroLeading = int.parse(reversedValue.replaceAll(RegExp(r'^0+'), ''));
    final diffAlwaysBePositive = (intValue - reversedIntValueWithoutZeroLeading).abs();


    final message = 'value is $value and reversed value is $reversedIntValueWithoutZeroLeading\nthe difference is $diffAlwaysBePositive';
    return message;
  }
}