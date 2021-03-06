import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/regUserProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:share_product_v2/widgets/loading.dart';

class LoginPageNode extends StatefulWidget {
  @override
  _LoginPageNodeState createState() => _LoginPageNodeState();
}

class _LoginPageNodeState extends State<LoginPageNode> with SingleTickerProviderStateMixin {
  TextEditingController _phNum = TextEditingController();
  TextEditingController _password = TextEditingController();
  String? phNum;

  late AnimationController _aniController;
  late Animation<Offset> _offsetAnimation;
  double _visible = 0.0;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _aniController,
      curve: Curves.fastOutSlowIn,
    ));
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _visible = 1.0;
      });
    });

  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Consumer<UserProvider>(
        builder: (context, counter, child) {
          return _body();
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      leading: Container(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
        child: Column(
          children: <Widget>[
            AnimatedOpacity(
              opacity: _visible,
              duration: Duration(milliseconds: 500),
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '?????????\n??????????????????.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            TextField(
              controller: _phNum,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "???????????? ??????",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "???????????? ??????",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();
                if (_phNum.text == '') {
                  _showDialog('??????????????? ???????????? ???????????????.');
                  return;
                } else if (_password.text == "") {
                  _showDialog('??????????????? ???????????? ???????????????.');
                } else {
                  await Provider.of<UserProvider>(context, listen: false)
                      .getAccessToken(_phNum.text, _password.text);
                  if (Provider.of<UserProvider>(context, listen: false)
                      .isLoggenIn) {
                    _showDialogLoading();
                    await Provider.of<ProductProvider>(context, listen: false).getGeolocator();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else {
                    _showDialog('???????????? ?????? ???????????? ???????????????.');
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Color(0xffff0066),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '?????????',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(text)), '??????');
        });
  }

  void _showDialogLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Loading();
        });
  }
}
