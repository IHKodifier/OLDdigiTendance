class UserRole {
  UserRole(this.roleName);

  final String roleName;
  static  UserRole admin = UserRole('admin');
  static UserRole teacher = UserRole('teacher');
//  static UserRole demo = UserRole('demo');
  @override
  String toString() {
    return roleName;
  }
}
