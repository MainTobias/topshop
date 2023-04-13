import 'package:flutter/cupertino.dart';

class PriceTag extends StatelessWidget {
  final double price;
  const PriceTag(this.price, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Flexible(
          child: Text(
            "€",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          child: Text(
            "${price.toInt()}",
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, height: 1),
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          child: Text(
            "${((price - price.toInt()) * 100).toInt()}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
