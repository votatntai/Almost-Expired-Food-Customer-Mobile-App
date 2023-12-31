import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../cubit/orders/orders_cubit.dart';
import '../cubit/orders/orders_state.dart';
import '../utils/format_utils.dart';
import '../utils/gap.dart';
import 'OrderDetailsScreen.dart';

class OrdersCanceledScreen extends StatelessWidget {
  static const String routeName = '/canceled';

  const OrdersCanceledScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersCubit = BlocProvider.of<OrdersCubit>(context);
    ordersCubit.getOrdersList(status: 'Canceled');
    return Scaffold(
      appBar: MyAppBar(title: 'Đơn đã hủy'),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is OrdersSuccessState) {
            var orders = state.orders.orders;
            if (orders!.isNotEmpty) {
              return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (context, index) {
                    var orderItem = orders[index].orderDetails!.first.product!;
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: white),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: 'image/appetit/placeholder.png',
                                  image: orderItem.thumbnailUrl.toString(),
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                                Gap.k8.width,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(orderItem.name.toString()),
                                    Text(
                                      'Số lượng: ' + orders[index].orderDetails!.first.quantity.toString(),
                                      style: TextStyle(color: grey, fontSize: 12),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '₫' + FormatUtils.formatPrice(orderItem.price!.toDouble()).toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Gap.k8.width,
                                        Text(
                                          '₫' + FormatUtils.formatPrice(orderItem.promotionalPrice!.toDouble()).toString(),
                                          style: TextStyle(
                                            color: Colors.orange.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ).paddingSymmetric(horizontal: 16),
                          ),
                          orders[index].orderDetails!.length > 1
                              ? Column(
                                  children: [
                                    Divider(),
                                    Text(
                                      'Xem thêm sản phẩm',
                                      style: TextStyle(color: grey, fontSize: 12),
                                    )
                                  ],
                                )
                              : SizedBox.shrink(),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                orders[index].orderDetails!.length.toString() + ' sản phẩm',
                                style: TextStyle(fontSize: 12, color: grey),
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(text: 'Tổng tiền: ', style: TextStyle(color: context.iconColor, fontSize: 14)),
                                TextSpan(text: '₫' + FormatUtils.formatPrice(orders[index].amount!.toDouble()).toString(), style: TextStyle(color: Colors.orange.shade700, fontSize: 14))
                              ]))
                            ],
                          ).paddingSymmetric(horizontal: 16),
                        ],
                      ),
                    ).onTap(() {
                      Navigator.pushNamed(context, OrderDetailsScreen.routeName, arguments: orders[index].id);
                    });
                  },
                  separatorBuilder: (context, index) => Gap.k8.height,
                  itemCount: orders.length);
            } else {
              return Center(
                child: Text('Chưa có đơn hàng.'),
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
