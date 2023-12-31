import 'package:appetit/cubit/profile/account_cubit.dart';
import 'package:appetit/cubit/profile/account_state.dart';
import 'package:appetit/domain/models/account.dart';
import 'package:appetit/screens/DashboardScreen.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/Colors.dart';
import '../utils/format_utils.dart';
import '../utils/gap.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String routeName = '/update-profile';
  final Account profile;
  const UpdateProfileScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  late UpdateProfileCubit _updateProfileCubit;
  bool _phoneValidate = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name!;
    _phoneController.text = widget.profile.phone!;
    _addressController.text = widget.profile.address!;
    _updateProfileCubit = BlocProvider.of<UpdateProfileCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Cập nhật thông tin',
      ),
      body: BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (!(state is UpdateProfileLoadingState)) {
            Navigator.pop(context);
          }
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ProcessingPopup(
                  state: state,
                );
              });
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextField(
                        controller: _nameController,
                        // onChanged: (value) {
                        //   setState(() {
                        //     _campaignName = value;
                        //   });
                        // },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                          filled: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Tên*',
                          hintText: 'Nhập tên',
                        ),
                      ),
                    ),
                    Gap.k16.height,
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(15),
                    //   child: TextField(
                    //     controller: _addressController,
                    //     // onChanged: (value) {
                    //     //   setState(() {
                    //     //     _campaignName = value;
                    //     //   });
                    //     // },
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                    //       filled: true,
                    //       labelStyle: TextStyle(color: Colors.grey),
                    //       hintStyle: TextStyle(color: Colors.grey),
                    //       labelText: 'Địa chỉ*',
                    //       hintText: 'Nhập địa chỉ',
                    //     ),
                    //   ),
                    // ),
                    // Gap.k16.height,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        onChanged: (value) => setState(() {
                          _phoneValidate = FormatUtils.phoneValidate(value);
                          print(FormatUtils.phoneValidate(value));
                        }),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                          filled: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Số điện thoại*',
                          hintText: 'Nhập số điện thoại',
                        ),
                      ),
                    ),
                    Gap.k8.height,
                    !_phoneValidate && _phoneController.text != ''
                        ? Column(
                            children: [
                              Gap.k4.height,
                              Text(
                                'Số điện thoại gồm 10 số và các đầu số hợp lệ: 03, 05, 07, 08, 09',
                                style: TextStyle(color: redColor, fontSize: 10),
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                    Text(
                      '(*): Bắt buộc nhập',
                      style: TextStyle(color: grey),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: (_nameController.text != '' && _phoneController.text != '')
                      ? ElevatedButton(
                          onPressed: () {
                            _updateProfileCubit.updateProfile(name: _nameController.text, phone: _phoneController.text);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Lưu', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade600,
                            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Lưu', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade400,
                            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final UpdateProfileState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: state is UpdateProfileLoadingState
            ? Container(
                width: 150,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Gap.k16.height,
                    Text('Đang xử lý, vui lòng chờ.')
                  ],
                ))
            : state is UpdateProfileSuccessState
                ? Container(
                    width: 150,
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Cập nhật thông tin thành công'),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (_) => DashboardScreen(
                                        tabIndex: 4,
                                      )));
                            },
                            child: Text(
                              'Đóng',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    ))
                : state is UpdateProfileFailedState
                    ? Container(
                        width: 150,
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              (state as UpdateProfileFailedState).msg.replaceAll('Exception: ', ''),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Đóng'))
                          ],
                        ),
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Đã xãy ra sự cố, hãy thử lại'),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Đóng',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ));
  }
}
