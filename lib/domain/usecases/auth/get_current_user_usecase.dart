import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tamago/core/errors/failures.dart';
import 'package:tamago/domain/entities/user.dart';
import 'package:tamago/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, User?>> call(GetCurrentUserParams params) async {
    return await repository.getCurrentUser();
  }
}

class GetCurrentUserParams extends Equatable {
  const GetCurrentUserParams();

  @override
  List<Object?> get props => [];
}
