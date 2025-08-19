import 'package:dartz/dartz.dart';
import 'package:tamago/core/errors/failures.dart';
import 'package:tamago/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class LogoutParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call(LogoutParams params) async {
    return await repository.logout();
  }
}
