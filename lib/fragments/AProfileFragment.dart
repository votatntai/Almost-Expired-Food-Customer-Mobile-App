import 'package:appetit/cubit/profile/account_cubit.dart';
import 'package:appetit/cubit/profile/account_state.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AProfileFragment extends StatefulWidget {
  const AProfileFragment({Key? key}) : super(key: key);

  @override
  State<AProfileFragment> createState() => _AProfileFragmentState();
}

class _AProfileFragmentState extends State<AProfileFragment>
    with TickerProviderStateMixin {
  List profileOption = ["Food Recipes", "Live"];
  var selectedItem = 0;
  late PageController myPageController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    myPageController = PageController(initialPage: selectedItem);
    tabController = new TabController(length: 2, vsync: this);
  }

  void onTapFunction(value) => setState(() => selectedItem = value);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountCubit>(
      create: (context) => AccountCubit(),
      child: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
        if (state is AccountLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AccountSuccessState) {
          var account = state.account;
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //1st content (Fixed height: 350)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                            child: Image.asset(
                                'image/appetit/backgroundprofile.jpg',
                                width: MediaQuery.of(context).size.width,
                                height: 220,
                                fit: BoxFit.cover),
                          ),
                        ),
                        // Positioned(
                        //   top: 16 + MediaQuery.of(context).viewPadding.top,
                        //   right: 16,
                        //   child: ClipRRect(
                        //     // clipBehavior: Clip.antiAlias,
                        //     borderRadius: BorderRadius.circular(25),
                        //     child: Container(
                        //       color: Colors.black.withOpacity(0.5),
                        //       height: 50,
                        //       width: 50,
                        //       child: InkWell(
                        //           onTap: () {},
                        //           child: Icon(Icons.share_outlined,
                        //               color: Colors.white)),
                        //     ),
                        //   ),
                        // ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: FadeInImage.assetNetwork(
                                  placeholder:
                                      'image/appetit/backgroundprofile.jpg',
                                  image: account.avatarUrl!,
                                  width: 120,
                                  height: 140,
                                  fit: BoxFit.cover),
                            ),
                            Gap.k8.height,
                            Text(account.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20)),
                            Text(account.email!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //2nd content (Social information)
                  // Gap.k16.height,
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 16),
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(15)),
                  //     color: appStore.isDarkModeOn
                  //         ? context.cardColor
                  //         : appetitAppContainerColor,
                  //   ),
                  //   height: 100,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text('24',
                  //               style: TextStyle(
                  //                   fontSize: 25,
                  //                   fontWeight: FontWeight.w800,
                  //                   color: context.iconColor)),
                  //           Text('Recipes',
                  //               style: TextStyle(
                  //                   fontSize: 13,
                  //                   fontWeight: FontWeight.w400,
                  //                   color: context.iconColor)),
                  //         ],
                  //       ),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text('432',
                  //               style: TextStyle(
                  //                   fontSize: 25,
                  //                   fontWeight: FontWeight.w800,
                  //                   color: context.iconColor)),
                  //           Text('Following',
                  //               style: TextStyle(
                  //                   fontSize: 13,
                  //                   fontWeight: FontWeight.w400,
                  //                   color: context.iconColor)),
                  //         ],
                  //       ),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text('643',
                  //               style: TextStyle(
                  //                   fontSize: 25,
                  //                   fontWeight: FontWeight.w800,
                  //                   color: context.iconColor)),
                  //           Text('Follow',
                  //               style: TextStyle(
                  //                   fontSize: 13,
                  //                   fontWeight: FontWeight.w400,
                  //                   color: context.iconColor)),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ).onTap(() {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => AFollowersScreen()));
                  // },
                  //     highlightColor: Colors.transparent,
                  //     splashColor: Colors.transparent),
                  // SizedBox(height: 32),
                  // APopularRecipesComponent(),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      }),
    );
  }
}
