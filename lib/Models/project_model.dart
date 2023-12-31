class Project {
  String? id;
  final double latitude;
  final double longitude;
  final String projectName;
  final String address;
  final double radius;
  bool archived;
  List<String> users;
  final String note;

  Project(
      {this.id,
      required this.latitude,
      required this.longitude,
      required this.projectName,
      required this.address,
      required this.radius,
      required this.users,
      this.note = '',
      this.archived = false});

  factory Project.fromJson(Map<String, dynamic> json) {
    List<String> users = List<String>.from(json['users'] ?? []);

    return Project(
      id: json['id'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      projectName: json['projectName'] as String,
      address: json['address'] as String,
      radius: json['radius'].toDouble() as double,
      note: json['note'] as String,
      users: users,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'projectName': projectName,
      'address': address,
      'radius': radius,
      'users': users,
      'note': note,
    };
  }
}
