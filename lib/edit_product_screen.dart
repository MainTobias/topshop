import 'dart:developer';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    late final Product product;
    if (ref.read(productsProvider).length == widget.index) {
      product = const Product(title: "", price: 0, description: "", imgUrl: "");
    } else {
      product = ref.read(
          productsProvider.select((value) => value[widget.index].product));
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
                final product = Product(
                    title: titleController.text,
                    price: double.parse(priceController.text),
                    description: descriptionController.text,
                    imgUrl: url);
                log(ref.read(productsProvider.notifier).contains(product).toString());
                if (!_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill out the form'),
                    ),
                  );
                } else if (ref.read(productsProvider.notifier).contains(product)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product already catalogued'),
                    ),
                  );
                } else {
                  ref
                      .read(productsProvider.notifier)
                      .setProduct(widget.index, product);
                  GoRouter.of(context).pop();
                }
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Title',
                  ),
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Can't be empty";
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Can't be empty. Enter a number like 4.99";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Description',
                  ),
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Can't be empty";
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Builder(builder: (context) {
                      if (url.isUrl) {
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
                          if (value.isUrl) {
                            ref.read(urlProvider.notifier).state = value;
                          }
                        },
                        initialValue: url,
                        keyboardType: TextInputType.url,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Image URL',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Can't be empty";
                          }
                          if (!value.isUrl) {
                            return "Has to be valid url.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
