import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:topshop/global.dart';
import 'package:topshop/main.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final int index;

  const EditProductScreen({Key? key, required this.index}) : super(key: key);

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  late final StateProvider<String> urlProvider;
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    late final Product product;
    if (ref.read(productsProvider).length == widget.index) {
      product = const Product(title: "", price: 0, description: "", imgUrl: "");
    } else {
      product =
          ref.read(productsProvider.select((value) => value[widget.index].product));
    }
    urlProvider = StateProvider((ref) => product.imgUrl);
    titleController.text = product.title;
    priceController.text = product.price.toString();
    descriptionController.text = product.description;
  }

  @override
  Widget build(BuildContext context) {
    final url = ref.watch(urlProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit product"),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(productsProvider.notifier).setProduct(
                    widget.index,
                    Product(
                        title: titleController.text,
                        price: double.parse(priceController.text),
                        description: descriptionController.text,
                        imgUrl: url));
                GoRouter.of(context).pop();
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Title',
                ),
                controller: titleController,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Price',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'(\d|\.)')),
                ],
                controller: priceController,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Description',
                ),
                controller: descriptionController,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Builder(builder: (context) {
                    if (url.isValidUrl()) {
                      return Container(
                        decoration: BoxDecoration(border: Border.all()),
                        width: 100,
                        height: 100,
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return const Text("Couldn't load image");
                          },
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(border: Border.all()),
                      width: 100,
                      height: 100,
                      child: const Text('Enter a URL'),
                    );
                  }),
                  Flexible(
                    child: TextFormField(
                      onChanged: (String value) {
                        if (value.isValidUrl()) {
                          ref.read(urlProvider.notifier).state = value;
                        }
                      },
                      initialValue: url,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Image URL',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
