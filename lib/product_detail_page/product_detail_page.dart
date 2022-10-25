import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mini_project/model/product_item_data.dart';
import 'package:mini_project/product_detail_page/product_detail_page_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage(
      {Key? key, required this.itemData, required this.isFavorite})
      : super(key: key);

  final ProductItemData itemData;
  final bool isFavorite;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _detailPageBloc = ProductDetailPageBloc();

  @override
  void initState() {
    super.initState();
    _detailPageBloc.getCartProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Product Detail')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    widget.itemData.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  children: [
                    Text(
                      widget.itemData.name,
                      style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                    ),
                    const Spacer(),
                    widget.isFavorite
                        ? InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            ),
                          )
                        : InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Text(
                  '\$ ${widget.itemData.price}',
                  style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: _addCartButton(widget.itemData),
      ),
    );
  }

  Widget _addCartButton(ProductItemData itemData) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40)),
        onPressed: () {
          _detailPageBloc.addToCart(itemData);
        },
        child: const Text('Add to Cart'));
  }
}
