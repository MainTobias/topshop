import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:topshop/global.dart';
import 'package:topshop/widgets/labeled_price_tag.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final int index;
  final StateProvider<Offset> magLocationProvider =
      StateProvider((ref) => const Offset(0, 0));

  ProductDetailsScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product =
        ref.watch(productsProvider.select((value) => value[index].product));

    final offset = ref.watch(magLocationProvider);
    final magDiagonal = (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) * 0.1;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            LimitedBox(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
              child: RepaintBoundary(
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onPanUpdate: (DragUpdateDetails details) {
                        ref.read(magLocationProvider.notifier).state =
                            details.localPosition;
                      },
                      child: CachedNetworkImage(
                        imageUrl: product.imgUrl,
                      ),
                    ),
                    Positioned(
                      left: offset.dx,
                      top: offset.dy,
                      child: RawMagnifier(
                        decoration: MagnifierDecoration(
                          shape: CircleBorder(
                            side: BorderSide(
                                color: Theme.of(context).indicatorColor,
                                width: 3),
                          ),
                        ),
                        size: Size(magDiagonal, magDiagonal),
                        magnificationScale: 2,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LimitedBox(
                      maxWidth: 100,
                      maxHeight: 100,
                      child: LabeledPriceTag("Price per item", product.price),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.description,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
