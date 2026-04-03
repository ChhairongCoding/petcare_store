class PetModel {
  final String id;
  final String owner;
  final String name;
  final String? type;
  final String? breed;
  final int? age;
  final String? gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? avatar;
  final String? lat;
  final String? long;

  PetModel({
    required this.id,
    required this.owner,
    required this.name,
    this.type,
    this.breed,
    this.age,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.avatar,
    this.lat,
    this.long,
  });

  /// Create a PetModel from a database map (e.g. Supabase row)
  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'],
      owner: map['owner'],
      name: map['name'],
      type: map['type'],
      breed: map['breed'],
      age: map['age'],
      gender: map['gender'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      avatar: map['avatar'],
      lat: map['lat'],
      long: map['long'],
    );
  }

  /// Convert PetModel to a map (for inserting/updating in Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner': owner,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'gender': gender,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'avatar': avatar,
      'lat': lat,
      'long': long,
    };
  }

  /// Optional helper to copy and modify the object
  PetModel copyWith({
    String? id,
    String? owner,
    String? name,
    String? type,
    String? breed,
    int? age,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? avatar,
    String? lat,
    String? long,
  }) {
    return PetModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatar: avatar ?? this.avatar,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }
}
