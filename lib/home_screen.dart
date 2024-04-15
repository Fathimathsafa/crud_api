import 'package:flutter/material.dart';

import 'api_helper.dart';
import 'model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  List<Employee> _employees = [];
  bool isLoading = false;

// bottom sheet for add employee details
//
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Employee Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _designationController,
                    decoration: InputDecoration(
                      labelText: 'Designation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    addEmployeedata(
                        name: _nameController.text,
                        designation: _designationController.text);

                    _nameController.clear();
                    _designationController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // bottom sheet for update employee details
//

  void _updateBottomSheet({required String id}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Employee Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _designationController,
                    decoration: InputDecoration(
                      labelText: 'Designation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    patchEmployeedata(
                        id: id.toString(),
                        name: _nameController.text,
                        designation: _designationController.text);

                    Navigator.pop(context);
                  },
                  child: Text('Update data'),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }

// function for get employee

  Future<void> fetchdata() async {
    setState(() {
      isLoading = true;
    });
    final response = await ApiHelper.get(endpoint: "employees/");

    if (response != null) {
      final employeeRes = EmployeeModel.fromJson(response);
      _employees =
          employeeRes.employeesList ?? [];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch employee list")));
    }
    setState(() {
      isLoading = false;
    });
  }

// function for add employee

  Future<void> addEmployeedata({required String name, required String designation}) async {
    setState(() {
      isLoading = true;
    });
    final response = await ApiHelper.post(
        endpoint: "employees/create/",
        data: {'name': name, "role": designation});

    if (response != null) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Sccessfully added")));
      });
      await fetchdata();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to add data")));

      throw Exception('Failed to load album');
    }
    setState(() {
      isLoading = false;
    });
  }

// function for update employee

  Future<void> patchEmployeedata(
      {required String id,
        required String name,
        required String designation}) async {
    setState(() {
      isLoading = true;
    });
    final response = await ApiHelper.put(
        endpoint: "employees/update/$id/",
        data: {"name": name, "role": designation});

    if (response != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sccessfully Updated")));
      await fetchdata();
    } else {
      print(response);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to update")));

      throw Exception('Failed to load album');
    }
    setState(() {
      isLoading = false;
    });
  }

  // code for delete employee

  Future<void> deleteEmployee({
    required String id,
  }) async {
    setState(() {
      isLoading = true;
    });
    final response = await ApiHelper.delete(
      endpoint: "/employees/$id/",
    );

    if (response != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sccessfully Deleted")));
      await fetchdata();
    } else {
      print(response);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to delete")));
    }
    setState(() {
      isLoading = false;
    });
  }

  // function for update employee

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
      ),
      body: (_employees.isEmpty || _employees.length == 0)
          ? Center(
        child: Text(
          'No employees added yet.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          fetchdata();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _employees.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_employees[index].name ??""),
              subtitle: Text(_employees[index].role ??""
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        //to update values inside text controllers to show values

                        _nameController.text =
                            _employees[index].name ??"";
                        _designationController.text =
                            _employees[index].role ??"";
                        _updateBottomSheet(
                            id: _employees[index].id.toString());
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteEmployee(
                          id: _employees[index].id.toString(),
                        );
                      }),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheet,
        tooltip: 'Add Employee',
        child: Icon(Icons.add),
      ),
    );
  }
}