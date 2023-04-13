import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:topshop/global.dart';
import 'drawer.dart';

class ManageProductsScreen extends ConsumerStatefulWidget {
  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ManageProductsScreen> createState() =>
      _ManageProductsScreenState();
}

class _ManageProductsScreenState extends ConsumerState<ManageProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My products"),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).pushNamed(
                'edit',
                params: {
                  "index": products.length.toString(),
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          final product = products[index].product;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(product.imgUrl),
            ),
            title: Text(product.title),
            trailing: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(
                      'edit',
                      params: {
                        "index": index.toString(),
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  onPressed: () {
                    ref.read(productsProvider.notifier).removeProduct(index);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
