class UserModel {
  final String id;
  final String name;
  final String publicKey;
  final String? avatarPath;

  UserModel({
    required this.id,
    required this.name,
    required this.publicKey,
    this.avatarPath,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'publicKey': publicKey,
    'profileImage': avatarPath,
  };

  factory UserModel.fromJson(Map<String, dynamic> map) => UserModel(
    id: map['id'],
    name: map['name'],
    publicKey: map['publicKey'],
    avatarPath: map['profileImage'],
  );
}
