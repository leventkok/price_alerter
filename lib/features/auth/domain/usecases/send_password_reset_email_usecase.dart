import 'package:dartz/dartz.dart';
import 'package:price_alert/core/error/failures.dart';
import 'package:price_alert/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmailUsecase {
  final AuthRepository repository;

  SendPasswordResetEmailUsecase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.sendPasswordResetEmail(email);
  }
}



