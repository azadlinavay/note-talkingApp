class User {
  String? name;
  int? birthYear; // 1997

  User({
    this.name,
    this.birthYear,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'birthYear': birthYear};
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      birthYear: map['birthYear'],
    );
  }
}
