import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:topshop/global.dart';
import 'package:topshop/widgets/compact_order_tile.dart';
import 'package:topshop/widgets/labeled_price_tag.dart';
import 'package:topshop/widgets/price_tag.dart';

class CurrentOrderScreenScreen extends ConsumerStatefulWidget {
  const CurrentOrderScreenScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CurrentOrderScreenScreen> createState() =>
      _CurrentOrderScreenScreenState();
}

class _CurrentOrderScreenScreenState
    extends ConsumerState<CurrentOrderScreenScreen> {
  @override
  Widget build(BuildContext context) {
    final order = ref.watch(currentOrderProvider);
    final total = order.entries.fold(0.0, (a, b) => a + b.key.price * b.value);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              LabeledPriceTag("Total", total),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    if (order.isEmpty) return;
                    final orders = ref
                        .read(ordersProvider.notifier)
                        .state;
                    ref
                        .read(ordersProvider.notifier)
                        .state = [
                      ...orders,
                      (order: order, orderedAt: DateTime.now())
                    ];
                    ref.read(currentOrderProvider.notifier).clear();
                  },
                  child: Text(
                      "Order now (${order.values.fold(
                          0, (a, b) => a + b)} items)"),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: order.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = order.keys.toList()[index];
                    final productCount = order.values.toList()[index];
                    return Dismissible(
                      key: Key(product.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: LayoutBuilder(builder: (context, constraint) {
                          return Icon(
                            Icons.delete,
                            color: Theme
                                .of(context)
                                .scaffoldBackgroundColor,
                            size: constraint.maxHeight,
                          );
                        }),
                      ),
                      onDismissed: (direction) {
                        ref.read(currentOrderProvider.notifier).delete(product);
                      },
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirm removal"),
                              content: Text(
                                  "Are you sure you want to remove ${product
                                      .title} from your shopping list?"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                          context,
                                          false,
                                        ),
                                    child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                          context,
                                          true,
                                        ),
                                    child: const Text("Remove")),
                              ],
                            );
                          },
                        );
                      },
                      child: CompactOrderTile(product, productCount),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
