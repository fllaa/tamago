import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/errors/failures.dart';
import 'package:flutter_boilerplate/domain/entities/user.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/sign_in_with_google_usecase.dart';

part 'sign_in_with_google_state.dart';

class SignInWithGoogleViewModel extends Cubit<SignInWithGoogleState> {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  SignInWithGoogleViewModel({
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  })  : _signInWithGoogleUseCase = signInWithGoogleUseCase,
        super(SignInWithGoogleInitial());

  Future<void> signInWithGoogle() async {
    emit(SignInWithGoogleLoading());

    final result =
        await _signInWithGoogleUseCase(const SignInWithGoogleParams());

    result.fold(
      (failure) => _handleFailure(failure),
      (user) => emit(SignInWithGoogleSuccess(user)),
    );
  }

  void _handleFailure(Failure failure) {
    if (failure is AuthFailure) {
      emit(SignInWithGoogleError(failure.message));
    } else if (failure is NetworkFailure) {
      emit(SignInWithGoogleError(failure.message));
    } else {
      emit(SignInWithGoogleError(failure.message));
    }
  }

  void resetState() {
    emit(SignInWithGoogleInitial());
  }
}
