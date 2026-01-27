import 'package:dartz/dartz.dart';
import 'package:price_alert/core/error/failures.dart';
import 'package:price_alert/features/auth/domain/entities/user_entity.dart';
import 'package:price_alert/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
