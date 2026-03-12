import 'package:pr_2_dart/pr_2_dart.dart';
import 'package:test/test.dart';

void main() {
  test('otchet sobiraetsya', () {
    final text = makeGroupReport();

    expect(text.contains('1 - сводная таблица'), isTrue);
    expect(text.contains('3 - уникальные оценки'), isTrue);
    expect(text.contains('отличники:'), isTrue);
  });
}
