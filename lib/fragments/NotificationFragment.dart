import 'package:appetit/screens/OrderDetailsScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../cubit/notification/notification_cubit.dart';
import '../cubit/notification/notification_state.dart';
import '../domain/repositories/notification_repo.dart';

class NotificationFragment extends StatefulWidget {
  const NotificationFragment({Key? key}) : super(key: key);

  @override
  State<NotificationFragment> createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  late NotificationCubit _notificationCubit;
  @override
  void initState() {
    _notificationCubit = BlocProvider.of<NotificationCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _notificationCubit.getNotifications();
    return Scaffold(
      backgroundColor: appLayout_background,
      body: RefreshIndicator(
        onRefresh: () async {
          _notificationCubit.getNotifications();
        },
        child: BlocBuilder<NotificationCubit, NotificationState>(builder: (context, state) {
          if (state is NotificationLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is NotificationSuccessState) {
            var notifications = state.notifications.notifications;
            if (notifications!.isNotEmpty) {
              return SingleChildScrollView(
                physics: ScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text("Recent", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                      // SizedBox(height: 16),
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: notifications.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(color: notifications[index].isRead! ? appLayout_background : appetitAppContainerColor),
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                notifications[index].title == 'Hoàn tất đơn hàng'
                                    ? Image.asset(
                                        'image/appetit/recieved-noti.png',
                                        width: 36,
                                      )
                                    : notifications[index].title == 'Thanh toán thành công'
                                        ? Image.asset(
                                            'image/appetit/payment-noti.png',
                                            width: 36,
                                          )
                                        : notifications[index].title == 'Đơn hàng đã bị hủy'
                                            ? Image.asset(
                                                'image/appetit/cancel-order-noti.png',
                                                width: 36,
                                              )
                                            : Image.asset(
                                                'image/appetit/notification.png',
                                                width: 36,
                                              ),
                                Gap.k16.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // RichText(
                                      //   text: TextSpan(
                                      //     children: <TextSpan>[
                                      //       TextSpan(
                                      //         text: mynotifications[index].name.toString(),
                                      //         style: TextStyle(
                                      //           fontWeight: FontWeight.w700,
                                      //           color: context.iconColor,
                                      //         ),
                                      //       ),
                                      //       TextSpan(
                                      //         text: mynotifications[index].message.toString(),
                                      //         style: TextStyle(
                                      //           fontWeight: FontWeight.w300,
                                      //           color: context.iconColor,
                                      //         ),
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                      Text(notifications[index].message!),
                                      SizedBox(height: 8),
                                      Text(
                                          DateTime.now().difference(DateTime.parse(notifications[index].createAt!)).inHours <= 24
                                              ? DateTime.now().difference(DateTime.parse(notifications[index].createAt!)).inHours.toString() + ' giờ trước'
                                              : DateTime.now().difference(DateTime.parse(notifications[index].createAt!)).inDays.toString() + ' ngày trước',
                                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10)),
                                    ],
                                  ),
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(10),
                                //   child: Image.asset(mynotifications[index].recipeimage.toString(), height: 45, width: 45, fit: BoxFit.cover),
                                // ),
                              ],
                            ),
                          ).onTap(() async {
                            await NotificationRepo().markAsRead(notificationId: notifications[index].id!);
                            Navigator.pushNamed(context, OrderDetailsScreen.routeName, arguments: notifications[index].link!);
                            setState(() {
                              
                            });
                            //  if (notifications[index].title == 'Đơn hàng đã bị hủy') {
                            //     Navigator.pushNamed(context, OrdersCanceledScreen.routeName);
                            //   }

                            //   if (notifications[index].title == 'Hoàn tất đơn hàng') {
                            //     Navigator.pushNamed(context, OrdersCompletedScreen.routeName);
                            //   }
                            //   if (notifications[index].title == 'Thanh toán thành công') {
                            //     Navigator.pushNamed(context, OrdersWaitPickupScreen.routeName);
                            //   }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('Chưa có thông báo'),
              );
            }
          }
          return SizedBox.shrink();
        }),
      ),
    );
  }
}
