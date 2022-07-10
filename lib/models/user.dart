class User {
  String? email;
  String? password;
  String? name;
  String? phoneNumber;
  String? homeAddress;
  String? cart;

  User(
      {this.email,
      this.password,
      this.name,
      this.phoneNumber,
      this.homeAddress,
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    homeAddress = json['homeAddress'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['homeAddress'] = homeAddress;
    data['cart'] = cart.toString();
    return data;
  }
}
