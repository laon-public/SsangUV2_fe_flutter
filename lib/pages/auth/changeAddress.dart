import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/loading.dart';

class ChangeAddress extends StatefulWidget {
  final num la;
  final num lo;
  final String address;
  final String addressDetail;

  ChangeAddress(this.la, this.lo, this.address, this.addressDetail);

  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> with SingleTickerProviderStateMixin{
  TextEditingController _addressDetail = TextEditingController();

  late AnimationController _aniController;
  late Animation<Offset> _offsetAnimation;
  double _visible = 0.0;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )
      ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return Consumer<UserProvider>(
      builder: (_, _myInfo, __) {
        return Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10.0, bottom: 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    AnimatedOpacity(
                      opacity: _visible,
                      duration: Duration(milliseconds: 500),
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: Text(
                          '?????? ?????????\n??????????????????.',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      "${this.widget.address} ${this.widget.addressDetail}",
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: _addressDetail,
                  decoration: InputDecoration(
                    labelText: "????????? ?????? ??????",
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: Color(0xff999999),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    if (_addressDetail.text == "") {
                      return;
                    } else {
                      _showLoading();
                      await _myInfo.changeAddress(
                        this.widget.address,
                        "${this.widget.addressDetail} ${this._addressDetail.text}",
                        this.widget.la,
                        this.widget.lo,
                      );
                      await Provider.of<ProductProvider>(context, listen: false)
                          .changeUserPosition(
                        Provider.of<UserProvider>(context, listen: false).userLocationX,
                        Provider.of<UserProvider>(context, listen: false).userLocationY,
                      );
                      await Provider.of<ProductProvider>(context, listen: false).getGeolocator();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: _addressDetail.text != ""
                          ? Color(0xffff0066)
                          : Color(0xff999999),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "??????",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
  void _showLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Loading();
        });
  }
}
