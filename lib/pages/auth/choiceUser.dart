import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/fcm_model.dart';
import 'package:share_product_v2/providers/mapProvider.dart';
import 'package:share_product_v2/providers/regUserProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';

import '../../main.dart';
import '../KakaoMap.dart';
import 'changeAddress.dart';
import 'changeAddressReg.dart';

TextEditingController name = TextEditingController();
TextEditingController pwd = TextEditingController();
TextEditingController chkPwd = TextEditingController();
TextEditingController comNum = TextEditingController();
bool _company = false;
File? regimage;

String userType = "NOMAL";

class ChoiceUser extends StatefulWidget {
  @override
  _ChoiceUserState createState() => _ChoiceUserState();
}

class _ChoiceUserState extends State<ChoiceUser> with TickerProviderStateMixin {
  var maskComNumFomatter = new MaskTextInputFormatter(
      mask: '###-##-#####', filter: {'#': RegExp(r'[0-9]')});
  final ImagePicker _picker = ImagePicker();



  Future _getImage() async {
    PickedFile? image;
    setState(() {
      image = null;
    });
    image = (await _picker.getImage(source: ImageSource.gallery, imageQuality: 100))!;
    setState(() {
      regimage = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Consumer<RegUserProvider>(
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
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Text(
                          '????????????',
                          style: TextStyle(
                            color: !_company ? Colors.black : Color(0xff999999),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _company = false;
                            userType = "NOMAL";
                          });
                        },
                      ),
                      Text(
                        '|',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _company = true;
                            userType = "BUSINESS";
                          });
                        },
                        child: Text(
                          '????????????',
                          style: TextStyle(
                            color: _company ? Colors.black : Color(0xff999999),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Text(
                        '??????????????? ??????????????????.',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _company
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 30.h),
                      _formField('?????????', name, false),
                      SizedBox(height: 18.h),
                      _formField('????????????', pwd, true),
                      SizedBox(height: 10.h),
                      Text(
                        '??????????????? ?????????, ??????, ??????????????? ????????? 10??? ??????????????? ?????????.',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      _formField('???????????? ??????', chkPwd, true),
                      SizedBox(height: 18.h),
                      _companyField(comNum),
                      SizedBox(height: 30.h),
                      _regComDone(),
                      SizedBox(height: 30.h),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(height: 30.h),
                      _formField('?????????', name, false),
                      SizedBox(height: 18.h),
                      _formField('????????????', pwd, true),
                      SizedBox(height: 10.h),
                      Text(
                        '??????????????? ?????????, ??????, ??????????????? ????????? 10??? ??????????????? ?????????.',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      _formField('???????????? ??????', chkPwd, true),
                      SizedBox(height: 60.h),
                      _regDone(),
                      SizedBox(height: 30.h),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  _regDone() {
    return InkWell(
      onTap: () async {
        bool validatePassword = _validatePassword(pwd.text);
        if (name.text == '') {
          _showDialog('????????? ???????????? ???????????????.');
          return;
        }
        if (pwd.text == '') {
          _showDialog('??????????????? ???????????? ???????????????.');
          return;
        }
        if (chkPwd.text == '') {
          _showDialog('???????????????????????? ???????????? ???????????????.');
          return;
        }
        if (chkPwd.text != pwd.text) {
          _showDialog('??????????????? ?????? ???????????? ????????????.');
          return;
        } if(validatePassword == false){
          _showDialog('??????????????? ????????? ???????????? ????????????.');
          return;
        } else {
          // await Provider.of<RegUserProvider>(context, listen: false)
          //     .regUserForm(
          //   pwd.text,
          //   name.text,
          //   userType,
          //   '1',
          //   comNum.text,
          //   regimage,
          //   Provider.of<FCMModel>(context, listen: false).mbToken,
          // );
          // await Provider.of<UserProvider>(context, listen: false).getAccessTokenReg(
          //   Provider.of<RegUserProvider>(context, listen: false).phNum,
          //   pwd.text,
          // );
          // if (Provider.of<RegUserProvider>(context, listen: false)
          //     .regUserTruth) {
            await localhostServer.close();
            await localhostServer.start();
            KopoModel model =
            await Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  KakaoMap(),
            ));
            String position =
            await Provider.of<MapProvider>(context, listen: false)
                .getPosition(model.address);
            List<String> positionSplit = position.split(',');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeAddressReg(
                      double.parse(positionSplit[0]),
                      double.parse(positionSplit[1]),
                      "${model.sido} ${model.sigungu} ${model.bname}",
                      "${model.buildingName.replaceAll('Y','').replaceAll('N', '')}${model.apartment.replaceAll('Y','').replaceAll('N', '')}"),
                ));
            // _showDialogSuccess('??????????????? ?????????????????????.');
            // Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
          // }else {
          //   _showDialogSuccess('?????? ??????????????? ?????? ???????????? ???????????????.');
          // }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50.h,
        decoration: BoxDecoration(
          color: Color(0xffff0066),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(
          '??????',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
          ),
        )),
      ),
    );
  }

  _regComDone() {
    return InkWell(
      onTap: () async {
        bool validatePassword = _validatePassword(pwd.text);
        if (name.text == '') {
          _showDialog('????????? ???????????? ???????????????.');
          return;
        }
        if (pwd.text == '') {
          _showDialog('??????????????? ???????????? ???????????????.');
          return;
        }
        if (chkPwd.text == '') {
          _showDialog('???????????????????????? ???????????? ???????????????.');
          return;
        } if (chkPwd.text != pwd.text) {
          _showDialog('??????????????? ?????? ???????????? ????????????.');
          return;
        }
        if(validatePassword == false){
          _showDialog("??????????????? ????????? ???????????? ????????????.");
          return;
        }
        if (regimage == null) {
          _showDialog('????????? ????????? ????????? ????????? ?????? ???????????????.');
          return;
        }
        if (regimage == null) {
          _showDialog('????????? ????????? ????????? ????????? ?????? ???????????????.');
          return;
        }
        if (comNum.text == '') {
          _showDialog('????????? ??????????????? ?????? ????????????.');
          return;
        } else {
          await Provider.of<RegUserProvider>(context, listen: false).regUserForm(
            pwd.text,
            name.text,
            userType,
            '1',
            comNum.text,
            regimage == null ? File('') : regimage!,
            Provider.of<UserProvider>(context, listen: false).userFBtoken!,
          );
          if (Provider.of<RegUserProvider>(context, listen: false).regUserTruth) {
            await localhostServer.close();
            await localhostServer.start();

            KopoModel model =
            await Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  KakaoMap(),
            ));
            String position =
            await Provider.of<MapProvider>(context, listen: false)
                .getPosition(model.address);
            List<String> positionSplit = position.split(',');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeAddressReg(
                      double.parse(positionSplit[0]),
                      double.parse(positionSplit[1]),
                      "${model.sido} ${model.sigungu} ${model.bname}",
                      "${model.buildingName.replaceAll('Y','').replaceAll('N', '')}${model.apartment.replaceAll('Y','').replaceAll('N', '')}"),
                ));
          } else {
            _showDialogSuccess('?????? ??????????????? ?????? ???????????? ???????????????.');
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
          '??????',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
          ),
        )),
      ),
    );
  }

  _companyField(TextEditingController _comNum) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (regimage == null) {
                        _getImage();
                      } else {
                        setState(() {
                          regimage = null;
                        });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xffdddddd), width: 1.0)),
                      child: Center(
                        child: Text(
                          regimage == null ? '????????????' : '?????? ??????',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        regimage == null
                            ? '????????? ????????? ????????? ???????????? ?????????.'
                            : '????????? ???????????? ????????? ???????????????.',
                        style: TextStyle(
                          fontSize: 13,
                          color: regimage == null
                              ? Color(0xff999999)
                              : Colors.green[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Column(
                children: [
                  TextField(
                    inputFormatters: [maskComNumFomatter],
                    keyboardType: TextInputType.number,
                    controller: _comNum,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffdddddd)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffdddddd)),
                        ),
                        isDense: true, // ????????????
                        contentPadding: EdgeInsets.all(13) //????????????,
                        ),
                  ),
                  Row(
                    children: [
                      Text(
                        '????????? ?????? ????????? ???????????????.',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff999999)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _formField(
      String title, TextEditingController _controller, bool passwordType) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          TextField(
            obscureText: passwordType,
            controller: _controller,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Color(0xffdddddd)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Color(0xffdddddd)),
                ),
                isDense: true, // ????????????
                contentPadding: EdgeInsets.all(13) //????????????,
                ),
          ),
        ],
      ),
    );
  }

  bool _validatePassword(String value){
    String pattern = r'^(?=.*?[a-z)(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(text)), '??????');
        });
  }

  void _showDialogSuccess(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApplyReg(Center(child: Text(text)), '??????');
        });
  }
}
