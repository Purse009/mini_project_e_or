import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mini_project/cart_page/cart_page_bloc.dart';
import 'package:mini_project/model/product_item_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cartPageBloc = CartPageBloc();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _cartPageBloc.getCartProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: _cartPageBloc.itemListData.stream,
            builder: (context, AsyncSnapshot<List<ProductItemData>> snapshot) {
              if (snapshot.hasData) {
                return _itemList(snapshot.data!);
              }
              return Container();
            }),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Text('Total Price'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Colors.amber),
                child: const Text('Check out'),
              )
            ],
          )),
    );
  }

  Widget _itemList(List<ProductItemData> list) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(list.length.toString()),
            onDismissed: (value) async {
              final SharedPreferences prefs = await _prefs;
              _cartPageBloc.itemData
                  .removeWhere((element) => element.id == list[index].id);
              final String encodedData = ProductItemData.encode(
                  _cartPageBloc.itemData.toSet().toList());
              await prefs.setString('cart_key', encodedData);
              _cartPageBloc.getCartProduct();
            },
            background: Container(color: Colors.red),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SizedBox(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(100),
                    child: Image.network(
                      list[index].imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list[index].name),
                        SizedBox(
                          height: ScreenUtil().setHeight(10),
                        ),
                        Text('\$ ${list[index].price.toString()}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
