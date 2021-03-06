// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:package_info/package_info.dart';
// import 'package:provider/provider.dart';
// import 'package:share_product_v2/pages/mypage/loginpage.dart';
// import 'package:share_product_v2/providers/userProvider.dart';
// import 'package:share_product_v2/utils/SharedPref.dart';
// import 'package:share_product_v2/widgets/customdialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'loginpage_use_phone.dart';

// class MyPage extends StatefulWidget {
//   const MyPage({Key key}) : super(key: key);

//   @override
//   _MyPageState createState() => _MyPageState();
// }

// class _MyPageState extends State<MyPage> {
//   bool _isNotificationOn = false;

//   String appVersionstr = "";

//   @override
//   void initState() {
//     super.initState();
//     getPackageInfo();
//     SharedPreferences.getInstance().then((pref) {
//       _isNotificationOn = pref.getBool("alarm") ?? false;
//     });
//   }

//   getPackageInfo() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();

//     String appName = packageInfo.appName;
//     String packageName = packageInfo.packageName;
//     String version = packageInfo.version;
//     String buildNumber = packageInfo.buildNumber;

//     print(appName);
//     print(packageName);
//     print(version);
//     print(buildNumber);

//     setState(() {
//       appVersionstr = version;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: Scaffold(body: body(context)));
//   }

//   Widget afterLogin(BuildContext context, UserProvider user) {
//     TextStyle titleStyle = TextStyle(
//         fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black);

//     TextStyle descriptionStyle = TextStyle(
//         fontSize: 14.sp,
//         fontWeight: FontWeight.normal,
//         color: Color(0xff999999));

//     return InkWell(
//       onTap: () {
//         Navigator.of(context).pushNamed("/user");
//       },
//       child: Padding(
//         padding: EdgeInsets.only(top: 36, bottom: 0, left: 20, right: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.loginMember != null ? user.loginMember.member.name : "",
//                   style: titleStyle,
//                 ),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 Text(
//                   user.loginMember != null
//                       ? user.loginMember.member.username
//                       : "",
//                   style: descriptionStyle,
//                 ),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 // Row(
//                 //   children: [
//                 //     Text("????????????"),
//                 //     SizedBox(
//                 //       width: 8.h,
//                 //     ),
//                 //     Text("????????????"),
//                 //   ],
//                 // )
//               ],
//             ),
//             Icon(Icons.keyboard_arrow_right)
//           ],
//         ),
//       ),
//       // },
//       // child: Padding(
//       //   padding: EdgeInsets.only(top: 36, bottom: 20, left: 20, right: 20),
//       //   child: Row(
//       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //     children: [
//       //       Column(
//       //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         children: [
//       //           Text(
//       //             "Username",
//       //             style: titleStyle,
//       //           ),
//       //           SizedBox(
//       //             height: 3,
//       //           ),
//       //           Text(
//       //             "email@gmail.com",
//       //             style: descriptionStyle,
//       //           ),
//       //           SizedBox(
//       //             height: 3,
//       //           ),
//       //           Row(
//       //             children: [
//       //               Text("????????????"),
//       //               SizedBox(
//       //                 width: 8.h,
//       //               ),
//       //               Text("????????????"),
//       //             ],
//       //           )
//       //         ],
//       //       ),
//       //       Icon(Icons.keyboard_arrow_right)
//       //     ],
//       //   ),
//       // ),
//     );
//   }

//   Widget beforeLogin(BuildContext context) {
//     TextStyle titleStyle = TextStyle(
//         fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black);

//     TextStyle descriptionStyle = TextStyle(
//         fontSize: 14.sp,
//         fontWeight: FontWeight.normal,
//         color: Color(0xff999999));

//     TextStyle buttonStyle = TextStyle(
//         fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white);
//     return Padding(
//       padding: EdgeInsets.only(top: 36, bottom: 20, left: 20, right: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(bottom: 25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "???????????? ???????????????.",
//                   style: titleStyle,
//                 ),
//                 SizedBox(
//                   height: 3.h,
//                 ),
//                 Text(
//                   "????????????????????? ??????????????? ??? ????????? ???????????????.",
//                   style: descriptionStyle,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: double.infinity,
//             height: 42.h,
//             child: RaisedButton(
//               color: Theme.of(context).primaryColor,
//               child: Text(
//                 "?????????/????????????",
//                 style: buttonStyle,
//               ),
//               onPressed: () {
//                 Navigator.of(context).push(_createLoginRoute()).then((value) {
//                   UserProvider user =
//                       Provider.of<UserProvider>(context, listen: false);
//                   print('user ${user.isLoggenIn}');
//                   if (user.isLoggenIn) {
//                     user.me();
//                   }
//                 });
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget menuButtons(context, bool isLogin) {
//     const beforeLoginMenu = [
//       // {'title': '?????? ??????', 'path': '/notice'},
//       {'title': '????????????', 'path': '/center'},
//       {'title': '?????? ??? ??????', 'path': '/policy'},
//       {'title': '?????? ??????', 'path': '/'},
//       {'title': '??? ??????', 'path': '/'}
//     ];

//     const afterLoginMenu = [
//       {'title': '?????? ????????????', 'path': '/user/product'},
//       // {'title': '?????? ??????', 'path': '/notice'},
//       {'title': '????????????', 'path': '/center'},
//       {'title': '?????? ??? ??????', 'path': '/policy'},
//       {'title': '?????? ??????', 'path': '/'},
//       {'title': '??? ??????', 'path': '/'},
//       {'title': '????????????', 'path': '/'},
//     ];

//     return Padding(
//       padding: EdgeInsets.only(top: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: (isLogin ? afterLoginMenu : beforeLoginMenu)
//             .map((e) => e["title"] == "??? ??????"
//                 ? appVersion(context)
//                 : e["title"] == "?????? ??????"
//                     ? alertSetting()
//                     : e["title"] == "????????????"
//                         ? logoutItem(context)
//                         : menuItem(context, e["title"], e["path"]))
//             .toList(),
//       ),
//     );
//   }

//   Widget menuItem(context, String title, String path) {
//     TextStyle titleStyle = TextStyle(
//         fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black);
//     return InkWell(
//       child: Padding(
//         padding: EdgeInsets.only(left: 20),
//         child: SizedBox(
//           width: double.infinity,
//           height: 52.h,
//           child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 title,
//                 style: titleStyle,
//               )),
//         ),
//       ),
//       onTap: () => {Navigator.of(context).pushNamed(path)},
//     );
//   }

//   Widget logoutItem(context) {
//     TextStyle titleStyle = TextStyle(
//         fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black);
//     return InkWell(
//       child: Padding(
//         padding: EdgeInsets.only(left: 20),
//         child: SizedBox(
//           width: double.infinity,
//           height: 52.h,
//           child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "????????????",
//                 style: titleStyle,
//               )),
//         ),
//       ),
//       onTap: () {
//         _showDialog(context);
//       },
//     );
//   }

//   Widget appVersion(context) {
//     TextStyle titleStyle = TextStyle(
//         fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black);
//     TextStyle versionStyle = TextStyle(
//         fontSize: 14.sp,
//         fontWeight: FontWeight.normal,
//         color: Theme.of(context).primaryColor);
//     return Container(
//       height: 52.h,
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "??? ??????",
//             style: titleStyle,
//           ),
//           Text(
//             "v${appVersionstr}",
//             style: versionStyle,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget alertSetting() {
//     TextStyle titleStyle = TextStyle(
//         fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black);
//     return Container(
//       height: 52.h,
//       padding: EdgeInsets.only(left: 20, right: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("????????????", style: titleStyle),
//           Switch(
//             value: _isNotificationOn,
//             onChanged: (value) {
//               {
//                 setState(() {
//                   _isNotificationOn = value;
//                   SharedPref().saveBool("alarm", _isNotificationOn);
//                 });
//               }
//               ;
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget body(context) {
//     return SingleChildScrollView(
//       child: Consumer<UserProvider>(builder: (_, user, __) {
//         return user.isLoggenIn && user.loginMember != null
//             ? Column(
//                 children: [
//                   afterLogin(context, user),
//                   menuButtons(context, true),
//                 ],
//               )
//             : Column(children: [
//                 beforeLogin(context),
//                 menuButtons(context, false),
//               ]);
//       }),
//     );
//   }

//   // Page ?????? Transition
//   // Route _createLoginRoute() {
//   //   return PageRouteBuilder(
//   //     pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
//   //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//   //       var begin = Offset(0.0, 1.0);
//   //       var end = Offset.zero;
//   //       var curve = Curves.ease;

//   //       var tween =
//   //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//   //       return SlideTransition(
//   //         position: animation.drive(tween),
//   //         child: child,
//   //       );
//   //     },
//   //   );
//   // }

//   void _showDialog(context) {
//     String name =
//         Provider.of<UserProvider>(context, listen: false).loginMember != null
//             ? Provider.of<UserProvider>(context, listen: false)
//                 .loginMember
//                 .member
//                 .name
//             : "";
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CustomDialog(dialogChild(name), "??????", () {
//             Provider.of<UserProvider>(context, listen: false).logout();
//             Navigator.of(context).pop();
//           });
//         });
//   }

//   Widget dialogChild(String nickname) {
//     return Column(
//       children: [
//         Text(
//           "$nickname ???",
//           style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//               color: Color(0xff333333)),
//         ),
//         SizedBox(
//           height: 4.h,
//         ),
//         Text("???????????? ???????????????????",
//             style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff333333))),
//         SizedBox(
//           height: 20.h,
//         ),
//       ],
//     );
//   }
// }
