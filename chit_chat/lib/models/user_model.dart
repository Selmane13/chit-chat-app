class UserModel {
  String user_id;
  String username;
  String email;
  String? phone;
  String? registration_date;
  String? img;

  UserModel(
      {required this.user_id,
      required this.username,
      required this.email,
      this.phone,
      this.registration_date,
      this.img});
}
