import 'package:clean_architecture_project/core/network/network_info.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
void main() {
  MockDataConnectionChecker mockDataConnectionChecker =
      MockDataConnectionChecker();
  NetworkInfoImpl networkInfoImpl =
      NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      final result = await networkInfoImpl.isconnected;

      expect(result, true);
    });
  });
}
