import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:topshop/global.dart';
import 'package:topshop/main.dart';
import 'package:topshop/widgets/compact_order_tile.dart';
import 'package:topshop/widgets/price_tag.dart';

import 'drawer.dart';

class PastOrdersScreenScreen extends ConsumerStatefulWidget {
  const PastOrdersScreenScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PastOrdersScreenScreen> createState() =>
      _PastOrdersScreenScreenState();
}

class _PastOrdersScreenScreenState
    extends ConsumerState<PastOrdersScreenScreen> {
  late List<bool> isExpandedList;

  @override
  void initState() {
    super.initState();
    isExpandedList =
        List.generate(ref.read(ordersProvider).length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past orders"),
      ),
      drawer: const MyDrawer(),
      body: ListView(
        children: [
          ExpansionPanelList(
            children: List.generate(
              orders.length,
              (index) => ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  final total = orders[index]
                      .order
                      .entries
                      .fold(0.0, (a, b) => a + b.key.price * b.value);
                  return ListTile(
                    title: PriceTag(total),
                    subtitle: Text(
                        "Ordered on ${DateFormat.yMMMd().format(orders[index].orderedAt)} at ${DateFormat.Hm().format(orders[index].orderedAt)}"),
                  );
                },
                body: IgnorePointer(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: orders[index].order.length,
                    itemBuilder: (context, productIndex) {
                      final entry = orders[index].order.entries.toList()[productIndex];
                      return CompactOrderTile(entry.key, entry.value);
                    },
                  ),
                ),
                isExpanded: isExpandedList[index],
                canTapOnHeader: true,
              ),
            ),
            expansionCallback: (index, isOpen) {
              setState(() {
                isExpandedList[index] = !isExpandedList[index];
              });
            },
          ),
        ],
      ),
    );
  }
}
