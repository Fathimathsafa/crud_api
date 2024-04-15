class EmployeeModel {
  int? status;
  String? message;
  List<Employee>? employeesList;

  EmployeeModel({
    this.status,
    this.message,
    this.employeesList,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    status: json["status"],
    message: json["message"],
    employeesList: json["data"] == null ? [] : List<Employee>.from(json["data"]!.map((x) => Employee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": employeesList == null ? [] : List<dynamic>.from(employeesList!.map((x) => x.toJson())),
  };
}

class Employee {
  int? id;
  String? name;
  String? role;

  Employee({
    this.id,
    this.name,
    this.role,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    name: json["name"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "role": role,
  };
}
