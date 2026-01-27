import 'package:auth/src/data/models/auth_model.dart';
import 'package:core/core.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthModel> login({required String username, required String password});
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<AuthModel> login({required String username, required String password}) async {
    try {
      // In a real app, this would be a network call
      final result = await _networkProvider.fetchMethod<dynamic>(
        ApiPaths.login,
        methodType: RMethodTypes.post,
        data: {'username': username, 'password': password},
      );
      return AuthModel.fromMap(result.data ?? {});
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
