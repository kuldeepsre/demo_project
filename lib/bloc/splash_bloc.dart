// splash_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final _splashSubject = BehaviorSubject<SplashState>();

  SplashBloc() : super(SplashInitial()); // Call super constructor with initial state




  @override
  SplashState get initialState => SplashInitial();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is InitializeApp) {
      // Simulate initialization process
      await Future.delayed(Duration(seconds: 3));
      _splashSubject.add(SplashComplete());
    }
  }

  @override
  Future<void> close() {
    _splashSubject.close();
    return super.close();
  }

  BehaviorSubject<SplashState> get splashSubject => _splashSubject;
}
