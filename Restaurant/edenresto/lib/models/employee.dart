class Employee {
  final String id; // Ensure the id field is declared here
  final String name;
  final String position;
  final DateTime hireDate;
  final double performanceRating;

  Employee({
    required this.id, // Include id in the constructor
    required this.name,
    required this.position,
    required this.hireDate,
    required this.performanceRating,
  });

  // Method to create an Employee from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'], // Extract id from JSON
      name: json['name'],
      position: json['position'],
      hireDate: DateTime.parse(json['hireDate']),
      performanceRating: json['performanceRating'],
    );
  }

  // Method to convert Employee to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include id in the JSON output
      'name': name,
      'position': position,
      'hireDate': hireDate.toIso8601String(),
      'performanceRating': performanceRating,
    };
  }
}
