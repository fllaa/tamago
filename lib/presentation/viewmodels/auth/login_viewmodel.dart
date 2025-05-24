import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/errors/failures.dart';
import 'package:flutter_boilerplate/domain/entities/user.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/login_usecase.dart';

part 'login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginViewModel({
    required LoginUseCase loginUseCase,
  })  : _loginUseCase = loginUseCase,
        super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    emit(LoginLoading());

    final result = await _loginUseCase(
      LoginParams(
        email: email,
        password: password,
        rememberMe: rememberMe,
      ),
    );

    result.fold(
      (failure) => _handleFailure(failure),
      (user) => emit(LoginSuccess(user)),
    );
  }

  void _handleFailure(Failure failure) {
    if (failure is ValidationFailure) {
      emit(LoginValidationError(
        message: failure.message,
        fieldErrors: failure.fieldErrors,
      ));
    } else if (failure is AuthFailure) {
      emit(LoginError(failure.message));
    } else if (failure is NetworkFailure) {
      emit(LoginError(failure.message));
    } else {
      emit(LoginError(failure.message));
    }
  }

  void resetState() {
    emit(LoginInitial());
  }
}
