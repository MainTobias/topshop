import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Shop'),
              onTap: () {
                GoRouter.of(context).goNamed('shop');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Orders'),
              onTap: () {
                GoRouter.of(context).goNamed('orders');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Manage products'),
              onTap: () {
                GoRouter.of(context).goNamed('products');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}