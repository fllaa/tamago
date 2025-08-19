import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tamago/core/errors/failures.dart';
import 'package:tamago/domain/entities/user.dart';
import 'package:tamago/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<Either<Failure, User>> call(SignInWithGoogleParams params) async {
    return await repository.signInWithGoogle();
  }
}

class SignInWithGoogleParams extends Equatable {
  const SignInWithGoogleParams();

  @override
  List<Object?> get props => [];
}
