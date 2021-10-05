import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/auth/myPage.dart';
import 'package:share_product_v2/providers/myPageProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/CustomDropdown.dart';
import 'package:share_product_v2/widgets/CustomDropdownMain.dart';
import 'package:share_product_v2/widgets/WantItemMainPage.dart';
import 'package:share_product_v2/widgets/WantItemMyAct.dart';
import 'package:share_product_v2/widgets/lendItem.dart';
import 'package:share_product_v2/widgets/lendItemMyAct.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:share_product_v2/widgets/loading2.dart';
import 'package:share_product_v2/widgets/rentItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../product/ProductDetail.dart';

//futureBuilder 제작 해야함.

class Category0 extends StatefulWidget {
  @override
  _Category1State createState() => _Category1State();
}

class _Category1State extends State<Category0> {


  final List<String> itemKind = ["빌려드려요", "빌려주세요"];

  late int page;
  int category = 1;
  late int totalCount;

  String _currentItem = '';

  @override
  void initState() {
    _currentItem = itemKind.first;
    super.initState();
  }

  Future<bool>_loadingProduct() async {
    int userIdx = Provider.of<UserProvider>(context, listen: false).userIdx!;
    await Provider.of<MyPageProvider>(context, listen: false).getProWant(userIdx, page, category);
    await Provider.of<MyPageProvider>(context, listen: false).getProRent(userIdx, page, category);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }


  _body() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  CustomDropdown(
                    items: itemKind,
                    value: _currentItem,
                    onChange: (value) {
                      if(value == "거래요청해요"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetail()),
                        );
                      }else{
                        setState(() {
                          _currentItem = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: FutureBuilder(
                future: _loadingProduct(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return Container(
                      height: 300.h,
                      color: Colors.white,
                      child: Center(
                        // child: Image.asset("assets/loading1.gif", width: 48.0, height: 48.0,),
                        child: Loading2(),
                      ),
                    );
                  }else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    return _toItem();
                  }
                },
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  _toItem() {
    return Consumer<UserProvider>(
      builder: (__, _myInfo, _) {
        return Consumer<MyPageProvider>(
          builder: (_, _myActHistory, __) {
            return ListView.separated(
              itemCount: _currentItem == '빌려드려요'
                  ? _myActHistory.proRent.length
                  : _myActHistory.proWant.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, idx) {
                if (_currentItem == "빌려드려요") {
                  return LendItemMyAct(
                    category: '전체',
                    title: '${_myActHistory.proRent[idx].title}',
                    name: _myActHistory.proRent[idx].name,
                    price: _moneyFormat("${_myActHistory.proRent[idx].price}"),
                    status: _myActHistory.proRent[idx].status,
                    idx: _myActHistory.proRent[idx].id,
                    picFile: _myActHistory.proRent[idx].productFiles[0].path,
                    arrayNum: idx,
                    token: _myInfo.accessToken!,
                  );
                } else if (_currentItem == '빌려주세요') {
                    return WantItemMyAct(
                      idx: _myActHistory.proWant[idx].id,
                      category:
                      "전체",
                      title: "${_myActHistory.proWant[idx].title}",
                      name: "${_myActHistory.proWant[idx].name}",
                      minPrice: "${_moneyFormat("${_myActHistory.proWant[idx].minPrice}")}원",
                      maxPrice: "${_moneyFormat("${_myActHistory.proWant[idx].maxPrice}")}원",
                      startDate: _dateFormat(_myActHistory.proWant[idx].startDate),
                      endDate: _dateFormat(_myActHistory.proWant[idx].endDate),
                      picture: _myActHistory.proWant[idx].productFiles[0].path,
                    );
                }
                else{
                  return Container();
                }
              },
              separatorBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Divider(),
                );
              },
            );
          },
        );
      },
    );
  }

  _moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }else{
      return price;
    }
  }

  _dateFormat(String date) {
    String formatDate(DateTime date) => new DateFormat("MM/dd").format(date);
    return formatDate(DateTime.parse(date));
  }
}
