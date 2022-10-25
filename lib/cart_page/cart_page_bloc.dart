import 'dart:async';

import 'package:mini_project/model/product_item_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPageBloc {
  final StreamController<List<ProductItemData>> _itemListData =
      StreamController<List<ProductItemData>>();
  StreamController<List<ProductItemData>> get itemListData => _itemListData;

  List<ProductItemData> _itemData = [];
  List<ProductItemData> get itemData => _itemData;

  final StreamController<double> _totalPrice = StreamController<double>();
  StreamController<double> get totalPrice => _totalPrice;

  /// fetch all cart product
  Future<void> getCartProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? listString = prefs.getString('cart_key');
    if (listString != null) {
      _itemListData.sink.add((ProductItemData.decode(listString)));
      _itemData = (ProductItemData.decode(listString));
    }
  }
}
