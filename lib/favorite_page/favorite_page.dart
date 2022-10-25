import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mini_project/favorite_page/favorite_page_bloc.dart';
import 'package:mini_project/model/product_item_data.dart';
import 'package:mini_project/product_detail_page/product_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _favoritePageBloc = FavoritePageBloc();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance(); 


  @override
  void initState() {
    super.initState();
    _favoritePageBloc.getFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: _favoritePageBloc.itemListData.stream,
              builder:
                  (context, AsyncSnapshot<List<ProductItemData>> snapshot) {
                if (snapshot.hasData) {
                  return _itemList(snapshot.data!);
                }
                return Container();
              }),
        ),
      ),
    );
  }

  Widget _itemList(List<ProductItemData> data) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height / 1.7),
      scrollDirection: Axis.vertical,
      children: List.generate(data.length, (index) {
        return Stack(
          children: [
            InkWell(
              onTap: (() => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        isFavorite: _favoritePageBloc.checkFavorite(data[index]),
                        itemData: data[index],
                      ),
                    ),
                  )),
              child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(100),
                        child: Image.network(
                          data[index].imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Text(data[index].name),
                      const Divider(
                        color: Colors.black,
                      ),
                      Text('\$ ${data[index].price.toString()}'),
                    ],
                  )),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () async {},
                      child: _favoritePageBloc.checkFavorite(data[index])
                          ? InkWell(
                              onTap: () async {
                                final SharedPreferences prefs = await _prefs;
                      if (_favoritePageBloc.checkFavorite(data[index])) {
                        _favoritePageBloc.favoriteItemData.removeWhere(
                            (element) => element.id == data[index].id);
                        final String encodedData = ProductItemData.encode(
                            _favoritePageBloc.favoriteItemData.toSet().toList());
                        await prefs.setString('product_key', encodedData);
                        _favoritePageBloc.itemListData.sink.add(data);

                      } else {
                        if (_favoritePageBloc.favoriteItemData.isNotEmpty == true) {
                          _favoritePageBloc.favoriteItemData.add(data[index]);
                          final String encodedData = ProductItemData.encode(
                              _favoritePageBloc.favoriteItemData.toSet().toList());
                          await prefs.setString('product_key', encodedData);
                            _favoritePageBloc.itemListData.sink.add(data);

                        } 
                      }
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30,
                              ),
                            )
                          : const Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                    )))
          ],
        );
      }),
    );
  }
}
