import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:topshop/drawer.dart';
import 'package:topshop/global.dart';
import 'package:topshop/main.dart';
import 'package:badges/badges.dart' as badges;

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

enum Filter {
  none,
  liked,
}

final filterProvider = StateProvider((ref) => Filter.none);

final filteredProductsProvider = Provider<
    List<({Product product, bool liked})>>((ref) {
  final filter = ref.watch(filterProvider);
  final products = ref.watch(productsProvider);

  switch (filter) {
    case Filter.none:
      return products;
    case Filter.liked:
      return products.where((p) => p.liked).toList();
  }
});

class _ShopScreenState extends ConsumerState<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductsProvider);
    final currentOrder = ref.watch(currentOrderProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          PopupMenuButton<Filter>(
            initialValue: ref.read(filterProvider),
            onSelected: (Filter f) {
              ref
                  .read(filterProvider.notifier)
                  .state = f;
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<Filter>>[
              const PopupMenuItem<Filter>(
                value: Filter.none,
                child: Text('All'),
              ),
              const PopupMenuItem<Filter>(
                value: Filter.liked,
                child: Text('Favorites only'),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              GoRouter.of(context).pushNamed("currentOrder");
            },
            icon: badges.Badge(
              badgeContent: Text(currentOrder.length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: GridView.count(
        primary: true,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          for (final indexedProduct in products.enumerate())
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pushNamed(
                  'details',
                  params: {
                    "index": indexedProduct.index.toString(),
                  },
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: GridTile(
                  footer: GridTileBar(
                    leading: IconButton(
                      onPressed: () {
                        ref
                            .read(productsProvider.notifier)
                            .toggleLiked(indexedProduct.index);
                      },
                      icon: Icon(indexedProduct.item.liked
                          ? Icons.favorite
                          : Icons.favorite_border),
                    ),
                    backgroundColor: Colors.black38,
                    title: Text(indexedProduct.item.product.title),
                    trailing: IconButton(
                      onPressed: () {
                        ref.read(currentOrderProvider.notifier).add(
                            indexedProduct.item.product, 1);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${indexedProduct.item.product
                                .title} added"),
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () {
                                ref.read(currentOrderProvider.notifier).remove(
                                    indexedProduct.item.product, 1);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: indexedProduct.item.product.imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
