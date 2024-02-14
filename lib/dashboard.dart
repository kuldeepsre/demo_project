import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/employee/employee_bloc.dart';
import 'model/employee_model.dart';


class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    employeeBloc.add(FetchEmployees());
    return Scaffold(
      appBar: CustomSearchAppBar(),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            return EmployeeList(employees: state.employees);
          } else if (state is EmployeeError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class CustomSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<AgeGroup> ageGroups = getAgeGroups(); // List of age groups

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Search Employee'),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            final employees = await BlocProvider.of<EmployeeBloc>(context).repository.fetchEmployees();
            showSearch(
              context: context,
              delegate: EmployeeSearchDelegate(employees: employees, ageGroups: ageGroups),
            );
          },
        ),
        PopupMenuButton<AgeGroup>(
          icon: const Icon(Icons.filter_list),
          itemBuilder: (BuildContext context) {
            return ageGroups.map((AgeGroup ageGroup) {
              return PopupMenuItem<AgeGroup>(
                child: Text('${ageGroup.minAge}-${ageGroup.maxAge} years'),
                value: ageGroup,
              );
            }).toList();
          },
          onSelected: (AgeGroup selectedAgeGroup) {
            BlocProvider.of<EmployeeBloc>(context).add(FilterEmployeesByAge(selectedAgeGroup));
          },
        ),
      ],
    );
  }
}

class EmployeeList extends StatelessWidget {
  final List<Employee> employees;

  EmployeeList({required this.employees});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Column(
          children: [
            ListTile(
              title: Text('Employee: ${employee.name}'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Salary: ${employee.salary}'),
                  Text('Agg: ${employee.age}'),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
            ),
          ],
        );
      },
    );
  }
}

class EmployeeSearchDelegate extends SearchDelegate {
  final List<Employee> employees; // List of all employees
  final List<AgeGroup> ageGroups; // List of age groups
  AgeGroup? selectedAgeGroup;

  EmployeeSearchDelegate({
    required this.employees,
    required this.ageGroups,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = employees
        .where((employee) =>
        employee.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return EmployeeList(employees: _filterByAgeGroup(searchResults));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = employees
        .where((employee) =>
        employee.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return EmployeeList(employees: _filterByAgeGroup(searchResults));
  }

  List<Employee> _filterByAgeGroup(List<Employee> employees) {
    if (selectedAgeGroup == null) {
      return employees;
    }

    return employees
        .where((employee) =>
    employee.age >= selectedAgeGroup!.minAge &&
        employee.age <= selectedAgeGroup!.maxAge)
        .toList();
  }
}

class AgeGroup {
  final int minAge;
  final int maxAge;

  AgeGroup({required this.minAge, required this.maxAge});
}

List<AgeGroup> getAgeGroups() {
  List<AgeGroup> ageGroups = [];
  int minAge = 20;
  int maxAge = 30;

  while (maxAge <= 60) {
    ageGroups.add(AgeGroup(minAge: minAge, maxAge: maxAge));
    minAge = maxAge + 1;
    maxAge += 10;
  }

  return ageGroups;
}
