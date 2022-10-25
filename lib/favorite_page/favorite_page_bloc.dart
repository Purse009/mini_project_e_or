import 'dart:async';

import 'package:mini_project/model/product_item_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePageBloc {
  final StreamController<List<ProductItemData>> _itemListData =
      StreamController<List<ProductItemData>>();
  StreamController<List<ProductItemData>> get itemListData => _itemListData;

  List<ProductItemData> _favoriteItemData = [];
  List<ProductItemData> get favoriteItemData => _favoriteItemData;

  /// fetch all favorite product
  void getFavoriteList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? listString = prefs.getString('product_key');
    if (listString != null) {
      final List<ProductItemData> product = ProductItemData.decode(listString);
      _favoriteItemData = ProductItemData.decode(listString);
      _itemListData.sink.add(product);
    }
  }

  bool checkFavorite(ProductItemData data) {
    bool checkFavoriteProduct = false;

    for (var element in _favoriteItemData) {
      if (element.id == data.id) {
        checkFavoriteProduct = true;
      }
    }
    return checkFavoriteProduct;
  }
}
