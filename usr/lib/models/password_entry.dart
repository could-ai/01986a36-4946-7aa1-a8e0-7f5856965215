class PasswordEntry {
  int? id;
  String title;
  String username;
  String password;

  PasswordEntry({this.id, required this.title, required this.username, required this.password});

  // 将模型转换成Map用于数据库操作
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // 从Map创建模型实例
  factory PasswordEntry.fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'] as int?,
      title: map['title'],
      username: map['username'],
      password: map['password'],
    );
  }
}
