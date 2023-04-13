import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:topshop/widgets/price_tag.dart';

import '../global.dart';

class CompactOrderTile extends StatelessWidget {
  final Product product;
  final int productCount;

  const CompactOrderTile(this.product, this.productCount, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(product.imgUrl),
      ),
      title: Text(product.title),
      trailing: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${productCount}x"),
            ],
          ),
          const SizedBox(
            width: 20,
            height: 0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LimitedBox(
                maxWidth: 100,
                maxHeight: 100,
                child: PriceTag(product.price),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
