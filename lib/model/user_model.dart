class usermodel {
  String id;
  String name;
  String email;
  String phoneNumber;

  usermodel(
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      };
}
