// splash_event.dart

part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class InitializeApp extends SplashEvent {}
