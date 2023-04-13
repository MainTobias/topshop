import 'package:flutter/material.dart';
import 'package:topshop/widgets/price_tag.dart';

class LabeledPriceTag extends StatelessWidget {
  final String label;
  final double price;
  final double space;
  final FontWeight labelWeight;

  const LabeledPriceTag(this.label, this.price,
      {Key? key, this.space = 20.0, this.labelWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              height: 1,
              fontWeight: labelWeight,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: space,
          height: 0,
        ),
        Expanded(child: PriceTag(price)),
      ],
    );
  }
}
