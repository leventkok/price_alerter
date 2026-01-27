import 'package:dartz/dartz.dart';
import 'package:price_alert/core/error/failures.dart';
import 'package:price_alert/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
