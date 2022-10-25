import 'package:mini_project/model/product_item_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPageBloc {
  List<ProductItemData> _cartData = [];
  List<ProductItemData> get favoriteItemData => _cartData;

  /// fetch all cart product
  Future<void> getCartProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? listString = prefs.getString('cart_key');
    if (listString != null) {
      _cartData = (ProductItemData.decode(listString));
    }
  }

  bool checkFavorite(ProductItemData data) {
    bool checkFavoriteProduct = false;
    for (var element in _cartData) {
      if (element.id == data.id) {
        checkFavoriteProduct = true;
      }
    }
    return checkFavoriteProduct;
  }

  /// add product to cart
  Future<void> addToCart(ProductItemData data) async {
    _cartData.add(data);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData =
        ProductItemData.encode(_cartData.isNotEmpty ? _cartData : [data]);
    await prefs.setString('cart_key', encodedData);
  }
}
