import 'dart:convert';

class ListProductItemData {
  List<ProductItemData>? _listProductItemData;
  List<ProductItemData>? get listProductItemData => _listProductItemData;
}

class ProductItemData {
  late int _id;
  late String _name;
  late String _imageUrl;
  late double _price;

  ProductItemData.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _name = parsedJson['name'];
    _imageUrl = parsedJson['image_url'];
    _price = parsedJson['price'];
  }

  static Map<String, dynamic> toMap(ProductItemData product) => {
        'id': product.id,
        'name': product.name,
        'image_url': product.imageUrl,
        'price': product.price,
      };

  static String encode(List<ProductItemData> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => ProductItemData.toMap(music))
            .toList(),
      );

  static List<ProductItemData> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<ProductItemData>((item) => ProductItemData.fromJson(item))
          .toList();

  int get id => _id;

  String get name => _name;

  String get imageUrl => _imageUrl;

  double get price => _price;
}
