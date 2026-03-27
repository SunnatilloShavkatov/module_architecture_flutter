import 'package:auth/src/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUserMap = {
    'id': 1,
    'email': 'test@test.com',
    'firstName': 'Test',
    'lastName': 'User',
    'role': 'CLIENT',
    'phone': '+998901234567',
    'token': 'secret_token',
    'username': 'test_user',
    'specialization': 'Developer',
  };

  group('UserModel', () {
    test('fromMap returns correct UserModel', () {
      final result = UserModel.fromMap(tUserMap);
      expect(result.id, 1);
      expect(result.email, 'test@test.com');
      expect(result.token, 'secret_token');
    });

    test('toMap returns correct Map', () {
      const tModel = UserModel(
        id: 1,
        email: 'test@test.com',
        firstName: 'Test',
        lastName: 'User',
        role: 'CLIENT',
        phone: '+998901234567',
        token: 'secret_token',
        username: 'test_user',
        specialization: 'Developer',
      );
      final result = tModel.toMap();
      // UserModel.toMap uses 'userId' for 'id' in current implementation
      expect(result['userId'], 1);
      expect(result['email'], 'test@test.com');
      expect(result['token'], 'secret_token');
    });
  });
}
