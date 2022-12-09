class Users {
  final int userId;
  final String userName;

  const Users({
    required this.userId,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
    };
  }

  @override
  String toString() {
    return 'Tasks{userId: $userId, userName: $userName}';
  }
}