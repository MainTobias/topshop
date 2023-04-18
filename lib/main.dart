import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:topshop/current_order_screen.dart';
import 'package:topshop/edit_product_screen.dart';
import 'package:topshop/past_orders_screen.dart';
import 'package:topshop/product_details_screen.dart';
import 'package:topshop/shop_screen.dart';
import 'manage_products_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'shop',
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) => const PastOrdersScreenScreen(),
    ),
    GoRoute(
      path: '/orders/current',
      name: 'currentOrder',
      builder: (context, state) => const CurrentOrderScreenScreen(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const ManageProductsScreen(),
    ),
    GoRoute(
      path: '/products/details/:index',
      name: 'details',
      builder: (context, state) =>
          ProductDetailsScreen(
              index: int.parse(state.params['index'] ?? '')
          ),
    ),
    GoRoute(
      path: '/products/edit/:index',
      name: 'edit',
      builder: (context, state) =>
          EditProductScreen(
              index: int.parse(state.params['index'] ?? '')
          ),
    ),
  ],
);

extension ValidUrl on String {
  bool get isUrl =>
      Uri
          .tryParse(this)
          ?.hasAbsolutePath ?? false;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Top Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

