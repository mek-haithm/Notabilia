class Note {
  final int? id;
  final String title;
  final String content;
  final int colorIndex;
  final String? password;
  final String? createdAt;
  final String? updatedAt;
  final int? folderId;
  bool isFavorite;
  bool isTrash;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.colorIndex,
    this.password = '',
    this.createdAt,
    this.updatedAt,
    this.folderId,
    this.isFavorite = false,
    this.isTrash = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'note_id': id,
      'note_title': title,
      'note_content': content,
      'note_color_index': colorIndex,
      'password': password,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'folder_id': folderId,
      'is_favorite': isFavorite ? 1 : 0,
      'is_trash': isTrash ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['note_id'],
      title: map['note_title'],
      content: map['note_content'],
      colorIndex: map['note_color_index'],
      password: map['password'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      folderId: map['folder_id'],
      isFavorite: map['is_favorite'] == 1,
      isTrash: map['is_trash'] == 1,
    );
  }
}
