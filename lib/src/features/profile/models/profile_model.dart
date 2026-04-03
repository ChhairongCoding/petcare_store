class ProfileModel {
  final String id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? createdAt;

  ProfileModel({
    required this.id,
    this.name,
    this.email,
    this.avatar,
    this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['full_name'] ?? json['name'], // <-- important fix here
      email: json['email'],
      avatar: json['avatar'],
      createdAt: json['created_at'] 
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': name,
        'email': email,
        'avatar': avatar,
        'created_at': createdAt,
      };
}
