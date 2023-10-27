import 'package:appetit/domain/models/products.dart';
import 'package:appetit/screens/ProductDetailScreen.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductComponent extends StatelessWidget {
  final Product product;
  ProductComponent({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DateTime.parse(product.expiredAt!).isBefore(DateTime.now())) {
      return SizedBox.shrink();
    }
    return Container(
            width: context.width(),
            // padding: const EdgeInsets.all(8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              FadeInImage.assetNetwork(
                      image: product.thumbnailUrl.toString(),
                      placeholder: 'image/appetit/placeholder.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(8),
              8.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  product.productCategories != null
                      ? Text(
                          product.productCategories!.first.category!.name
                              .toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      : SizedBox.shrink(),
                  Text(
                    '₫' +
                        FormatUtils.formatPrice(product.price!.toDouble())
                            .toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₫' +
                            FormatUtils.formatPrice(
                                    product.promotionalPrice!.toDouble())
                                .toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Gap.k8.width,
                      Text(
                        '(-' +
                            ((1 - product.price! / product.promotionalPrice!) *
                                    100)
                                .round()
                                .toString() +
                            '%)',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ).expand(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Còn ' +
                        DateTime.parse(product.expiredAt!)
                            .difference(DateTime.now())
                            .inDays
                            .toString() +
                        ' ngày',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: DateTime.parse(product.expiredAt!)
                                    .difference(DateTime.now())
                                    .inDays <=
                                10
                            ? Colors.redAccent
                            : DateTime.parse(product.expiredAt!)
                                            .difference(DateTime.now())
                                            .inDays <=
                                        30 &&
                                    DateTime.parse(product.expiredAt!)
                                            .difference(DateTime.now())
                                            .inDays >
                                        10
                                ? Colors.orangeAccent
                                : Colors.green),
                  ),
                  Gap.k8.height,
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(width: 1, color: Colors.orangeAccent)),
                    child: Row(
                      children: [
                        Text(
                          'Mua ',
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        SvgPicture.asset(
                          'image/appetit/cart-shopping.svg',
                          width: 16,
                          color: Colors.orangeAccent,
                        )
                      ],
                    ),
                  )
                ],
              )
            ]))
        .onTap(() => Navigator.pushNamed(context, ProductDetailScreen.routeName,
            arguments: product));
  }
}