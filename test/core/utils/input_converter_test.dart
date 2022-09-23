import 'package:clean_architecture_project/core/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  InputConverter inputConverter = InputConverter();

  group('stringToUnsignInt', () {
    test(
      "should return an integer when the string represents an unsigned integer",
      () async {
        const str = '40';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, const Right(40));
      },
    );

    test(
      "should return a failure when the string is not an integer",
      () async {
        const str = 'nova';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result,
            const Left(InvalidInputFailure(message: 'Input not an integer')));
      },
    );

    test(
      "should return a failure when the string is a negatif integer",
      () async {
        const str = '-123';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result,
            const Left(InvalidInputFailure(message: 'Input not an integer')));
      },
    );
  });
}
