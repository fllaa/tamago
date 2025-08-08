import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_boilerplate/core/errors/failures.dart';
import 'package:flutter_boilerplate/domain/entities/user.dart';
import 'package:flutter_boilerplate/domain/repositories/auth_repository.dart';

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
