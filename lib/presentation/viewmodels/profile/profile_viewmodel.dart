import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/errors/failures.dart';
import 'package:flutter_boilerplate/domain/entities/user.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/logout_usecase.dart';

part 'profile_state.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  ProfileViewModel({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase,
        super(ProfileInitial());
  Future<void> loadUserProfile() async {
    emit(ProfileLoading());

    final result = await _getCurrentUserUseCase(const GetCurrentUserParams());

    result.fold(
      (failure) => _handleFailure(failure),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  void _handleFailure(Failure failure) {
    emit(ProfileError(failure.message));
  }

  void resetState() {
    emit(ProfileInitial());
  }

  Future<void> logout() async {
    emit(ProfileLoading());
    final result = await _logoutUseCase(LogoutParams());
    result.fold(
      (failure) => _handleFailure(failure),
      (_) => emit(ProfileInitial()),
    );
  }
}
