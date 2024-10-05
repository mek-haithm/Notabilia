class Folder {
  final int? id;
  final String name;
  final String password;
  final String? updatedAt;

  Folder({
    this.id,
    required this.name,
    this.password = '',
    this.updatedAt,
  });

  // Factory constructor to create a Folder from a map
  factory Folder.fromMap(Map<String, dynamic> json) => Folder(
    id: json["folder_id"],
    name: json["folder_name"],
    password: json["password"],
    updatedAt: json["updated_at"],
  );
}
