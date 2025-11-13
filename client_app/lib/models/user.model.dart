class User{
  final String userName;
  final String email;
  final String password;
  final DateTime bod;
  final String gender;

  User(this.userName, this.email, this.password, this.bod, this.gender);
  @override
  String toString() {
    return 'User(userName: $userName, email: $email, BOD: $bod, gender: $gender)';
  }
}