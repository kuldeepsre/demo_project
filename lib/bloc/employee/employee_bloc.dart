// employee_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';


import '../../api/employee_repository.dart';
import '../../dashboard.dart';
import '../../model/agg_group.dart';
import '../../model/employee_model.dart';

// Events
abstract class EmployeeEvent {}
class SearchEmployees extends EmployeeEvent {
  final String query;

  SearchEmployees({required this.query});
}

class FetchEmployees extends EmployeeEvent {}

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;

  EmployeeLoaded({required this.employees});
}


class EmployeeError extends EmployeeState {
  final String error;

  EmployeeError({required this.error});
}
class FilterEmployeesByAge extends EmployeeEvent {
  final AgeGroup ageGroup;

  FilterEmployeesByAge(this.ageGroup);
}
// BLoC
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc({required this.repository}) : super(EmployeeInitial()) {
    // Register the event handlers
    on<FetchEmployees>(_onFetchEmployees);
    on<SearchEmployees>(_onSearchEmployees);
    on<FilterEmployeesByAge>(_onFilterEmployeesByAge);

    // on<AggGroupEvent>(_onAggGroup);
  }

  void _onFilterEmployeesByAge(FilterEmployeesByAge event,
      Emitter<EmployeeState> emit) async {
    try {
      final List<Employee> allEmployees = await repository.fetchEmployees();


      final List<Employee> filteredEmployees = allEmployees
          .where((employee) =>
      employee.age >= event.ageGroup.minAge &&
          employee.age <= event.ageGroup.maxAge)
          .toList();

      emit(EmployeeLoaded(employees: filteredEmployees));
    } catch (e) {
      emit(EmployeeError(error: 'Failed to filter employees by age: $e'));
    }
  }

  void _onFetchEmployees(FetchEmployees event,
      Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final List<Employee> employees = await repository.fetchEmployees();
      emit(EmployeeLoaded(employees: employees));
    } catch (e) {
      emit(EmployeeError(error: 'Failed to filter employees by age: $e'));
    }
  }

  void _onSearchEmployees(SearchEmployees event,
      Emitter<EmployeeState> emit) async {
    try {
      final List<Employee> allEmployees = await repository.fetchEmployees();
      final List<Employee> searchResults = allEmployees
          .where((employee) =>
          employee.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(EmployeeLoaded(employees: searchResults));
    } catch (e) {
      emit(EmployeeError(error: 'Failed to search employees: $e'));
    }
  }
}