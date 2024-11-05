class TableModel {
  final int id;
  final String number;
  final int capacity;
  final String status;

  TableModel({
    required this.id,
    required this.number,
    required this.capacity,
    required this.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      number: json['number'],
      capacity: json['capacity'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'capacity': capacity,
      'status': status,
    };
  }
}
