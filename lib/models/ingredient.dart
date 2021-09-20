class Ingredient {
  late String name;
  double? quantity;
  String? measuring;
  String? size;
  String? method;
  late bool selected;

  Ingredient(
      {required this.name,
      this.quantity,
      this.measuring,
      this.size,
      this.method,
      this.selected = false});

  Ingredient.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['quantity'] != null) {
      quantity = json['quantity']!.runtimeType == double
          ? json['quantity']
          : json['quantity']!.toDouble();
    }
    measuring = json['measuring'];
    size = json['size'];
    method = json['method'];
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['measuring'] = measuring;
    data['size'] = size;
    data['method'] = size;
    return data;
  }

  String? getQuantity(int servings) {
    String result = "";
    if (quantity != null) {
      double resultQuantity = (quantity! * servings);
      if (resultQuantity % 1 == 0) {
        result += (quantity! * servings).toInt().toString() + " ";
      } else {
        result += (quantity! * servings).toString() + " ";
      }
    }
    if (size != null) {
      result += size! + " ";
    }
    if (measuring != null) {
      result += measuring! + " ";
    }
    return result == "" ? null : result;
  }
}
