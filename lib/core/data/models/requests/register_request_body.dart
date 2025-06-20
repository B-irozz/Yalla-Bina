class RegisterRequestBody {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phone;
  String? city;

  RegisterRequestBody({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phone,
    this.city,
  });

  RegisterRequestBody.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    phone = json['mobileNumber'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['password'] = password;
    map['mobileNumber'] = phone;
    map['city'] = city;
    return map;
  }
}
