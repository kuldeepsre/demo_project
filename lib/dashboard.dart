import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/employee/employee_bloc.dart';
import 'model/agg_group.dart';
import 'model/employee_model.dart';


class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    employeeBloc.add(FetchEmployees());


    return Scaffold(

      appBar: AppBar(title: Text('Employee List')    ,
       automaticallyImplyLeading: false,

       actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EmployeeSearchDelegate(employeeBloc: employeeBloc),
              );
            },
          ),
          PopupMenuButton<AgeGroup>(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (BuildContext context) {
              final ageGroups = getAgeGroups();
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
      ),

      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            return EmployeeListWidget(employees: state.employees);
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

class EmployeeListWidget extends StatelessWidget {
  final List<Employee> employees;

  EmployeeListWidget({required this.employees});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return ListTile(
          title: Text('Employee ${employee.id}: ${employee.name}'),
          subtitle: Text('Salary: ${employee.salary}, Age: ${employee.age}'),
        );
      },
    );
  }
}List<AgeGroup> getAgeGroups() {
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
class EmployeeSearchDelegate extends SearchDelegate {
  final EmployeeBloc employeeBloc;

  EmployeeSearchDelegate({required this.employeeBloc});

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
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is EmployeeLoaded) {
          final searchResults = state.employees
              .where((employee) =>
              employee.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return EmployeeListWidget(employees: searchResults);
        } else if (state is EmployeeError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return Container();
        }
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoaded) {
          final suggestionList = state.employees
              .where((employee) =>
              employee.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              final suggestion = suggestionList[index];
              return ListTile(
                title: Text(suggestion.name),
                onTap: () {
                  query = suggestion.name;
                  showResults(context);
                },
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
