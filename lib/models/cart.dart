class Cart {
  String? cartid;
  String? subjectName;
  String? subjectPrice;
  String? cartqty;
  String? subjectId;

  Cart(
      {this.cartid,
      this.subjectName,
      this.subjectPrice,
      this.subjectId,
      this.cartqty});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cart_id'];
    subjectName = json['subject_name'];
    subjectPrice = json['subject_price'];
    cartqty = json['cart_qty'];
    subjectId = json['subject_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartid;
    data['subject_name'] = subjectName;
    data['subject_price'] = subjectPrice;
    data['cart_qty'] = cartqty;
    data['subject_id'] = subjectId;
    return data;
  }
}
