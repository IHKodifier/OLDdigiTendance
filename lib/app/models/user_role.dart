class UserRole {
  const UserRole(this.roleName);

  final String roleName;
    static const   UserRole admin =  UserRole('admin');
  static const UserRole teacher = UserRole('teacher');
//  static UserRole demo = UserRole('demo');
  @override
  String toString() {
    return roleName;
  }
}
