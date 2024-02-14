// employee_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';


import '../../api/employee_repository.dart';
import '../../dashboard.dart';
import '../../model/employee_model.dart';

// Events
abstract class EmployeeEvent {}

class FetchEmployees extends EmployeeEvent {}

class FilterEmployeesByAge extends EmployeeEvent {
  final AgeGroup ageGroup;

  FilterEmployeesByAge(this.ageGroup);
}

class AggGroupEvent extends EmployeeEvent {
  final AgeGroup ageGroup;

  AggGroupEvent(this.ageGroup);
}

// States
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

// BLoC
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc({required this.repository}) : super(EmployeeInitial()) {
    // Register the event handlers
    on<FetchEmployees>(_onFetchEmployees);
    on<FilterEmployeesByAge>(_onFilterEmployeesByAge);
    on<AggGroupEvent>(_onAggGroup);
  }

  void _onFetchEmployees(FetchEmployees event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final List<Employee> employees = await repository.fetchEmployees();
      emit(EmployeeLoaded(employees: employees));
    } catch (e) {
      emit(EmployeeError(error: 'Failed to filter employees by age: $e'));

    }
  }

  void _onFilterEmployeesByAge(FilterEmployeesByAge event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final List<Employee> employees = await repository.fetchEmployees();
      final filteredEmployees = employees
          .where((employee) =>
      employee.age >= event.ageGroup.minAge &&
          employee.age <= event.ageGroup.maxAge)
          .toList();

      print(filteredEmployees);
      emit(EmployeeLoaded(employees: filteredEmployees));
    } catch (e) {
      emit(EmployeeError(error: 'Failed to filter employees by age'));
    }
  }

  void _onAggGroup(AggGroupEvent event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final List<Employee> employees = await repository.fetchEmployees();

      // Your logic to process AggGroupEvent
      // For example, grouping employees by age range and updating the UI
      final Map<String, List<Employee>> groupedEmployees = groupEmployeesByAgeRange(employees);

      emit(EmployeeLoaded(employees: groupedEmployees['age'] ?? []));

    } catch (e) {
      emit(EmployeeError(error: 'Failed to process AggGroupEvent'));
    }
  }

// Example function to group employees by age range
  Map<String, List<Employee>> groupEmployeesByAgeRange(List<Employee> employees) {
    // Customize this function based on your grouping logic
    Map<String, List<Employee>> groupedEmployees = {};

    for (Employee employee in employees) {
      String ageRange = getAgeRangeLabel(employee.age);

      if (!groupedEmployees.containsKey(ageRange)) {
        groupedEmployees[ageRange] = [];
      }

      groupedEmployees[ageRange]!.add(employee);
    }

    return groupedEmployees;
  }

// Example function to get age range label
  String getAgeRangeLabel(int age) {
    // Customize this function based on your age range labels
    if (age >= 20 && age <= 30) {
      return '20-30 years';
    } else if (age > 30 && age <= 40) {
      return '31-40 years';
    } else {
      return 'Unknown';
    }
  }}