import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'global.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({required String title,
    required double price,
    required String description,
    required String imgUrl}) = _Product;


}

class ProductsNotifier
    extends StateNotifier<List<({Product product, bool liked})>> {
  ProductsNotifier

  (

  List<({Product product, bool liked})> products) : super(products);

  void addProduct(Product product) {
  if (contains(product)) {
  throw Exception("Product already catalogued.");
  }
  state = [...state, (product: product, liked: false)];
  }

  void removeProduct(int index) {
  state.removeAt(index);
  state = [...state];
  }

  bool contains(Product product) {
  return state.map((e) => e.product).contains(product);
  }

  void setProduct(int index, Product update) {
  if (index == state.length) {
  addProduct(update);
  } else {
  state[index] = (product: update, liked: state[index].liked);
  }
  state = [...state];
  }

  void toggleLiked(int index) {
  state[index] = (product: state[index].product, liked: !state[index].liked);
  state = [...state];
  }
}

class ProductsListNotifier extends StateNotifier<Map<Product, int>> {
  ProductsListNotifier(Map<Product, int> shoppingList) : super(shoppingList);

  void add(Product product, int count) {
    if (state.containsKey(product)) {
      state[product] = state[product]! + count;
    } else {
      state[product] = count;
    }
    state = {...state};
  }

  void remove(Product product, int count) {
    if (state.containsKey(product)) {
      state[product] = state[product]! - count;
      if (state[product]! < 0) {
        throw Exception("Can't have negative product count");
      }
      if (state[product]! == 0) {
        delete(product);
      }
    }
    state = {...state};
  }

  void delete(Product product) {
    state.remove(product);
    state = {...state};
  }

  void clear() {
    state = {};
  }
}

const spoon = Product(
  title: "Spoon",
  price: 2.99,
  description: "Spoon like a pro",
  imgUrl:
  "https://m.media-amazon.com/images/W/IMAGERENDERING_521856-T1/images/I/51aAu04384L._AC_SL1500_.jpg",
);
const book = Product(
  title: "The Philosophy Book: Big Ideas Simply Explained (2011)",
  price: 17.47,
  description:
  "To the complete novice learning about philosophy can be daunting - The Philosophy Book changes all that.",
  imgUrl:
  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcT1ZHI9uOHGFhh5-NmRxpJZcGMxWnGUz-oAifsXFVlxjlJCFQSS",
);

const mouse = Product(
  title: "Mouse",
  price: 45.99,
  description:
  "Offering the challenge of meaningfully binding all buttons.",
  imgUrl:
  "https://upload.wikimedia.org/wikipedia/commons/6/69/Razer_Naga_Classic.jpg",
);

const pan = Product(
  title: "Pan",
  price: 49.99,
  description: "Prepare any meal you want.",
  imgUrl:
  "https://images.immediate.co.uk/production/volatile/sites/30/2023/03/HexClad-Hybrid-frying-pan-58abba2.png",
);

final currentOrderProvider =
StateNotifierProvider<ProductsListNotifier, Map<Product, int>>(
        (ref) =>
        ProductsListNotifier({
          book: 5,
          spoon: 7,
        }));
final ordersProvider = StateProvider<
    List<({Map<Product, int> order, DateTime orderedAt})>>((ref) =>
[(order : {
  book: 5,
  spoon: 7,
}, orderedAt: DateTime.now()),
  (order : {
    book: 5,
    mouse: 3,
  }, orderedAt: DateTime.now(), ),
  (order : {
    book: 5,
    mouse: 3,
    pan: 2,
    spoon: 11
  }, orderedAt: DateTime.now())
]);


final productsProvider = StateNotifierProvider<ProductsNotifier,
    List<({Product product, bool liked})>>(
      (ref) {
    return ProductsNotifier([
      (product: spoon, liked: true, ),
      (product: book, liked: false, ),
      (product: mouse, liked: true, ),
      (product: pan, liked: false, )
    ]);
  },
);
