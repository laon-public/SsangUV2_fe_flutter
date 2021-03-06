import 'dart:convert';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/CategoryPageRent.dart';
import 'package:share_product_v2/model/CategoryPageWant.dart';
import 'package:share_product_v2/model/Geolocation.dart';
import 'package:share_product_v2/model/MainPageRent.dart';
import 'package:share_product_v2/model/MainPageWant.dart';
import 'package:share_product_v2/model/PrivateRent.dart';
import 'package:share_product_v2/model/ProductDetailWant.dart';
import 'package:share_product_v2/model/ProductReview.dart';
import 'package:share_product_v2/model/ProductReview.dart';
import 'package:share_product_v2/model/Reviewpaging.dart';
import 'package:share_product_v2/model/UserLocationModel.dart';
import 'package:share_product_v2/model/chatListModel.dart';
import 'package:share_product_v2/model/paging.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/model/searchDataProduct.dart';
import 'package:share_product_v2/model/specialProduct.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/pages/search/searchData.dart';
import 'package:share_product_v2/providers/mainProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';

import 'package:share_product_v2/services/policyService.dart';
import 'package:share_product_v2/services/productService.dart';
import 'package:share_product_v2/utils/APIUtil.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService productService = ProductService();

  late Paging paging;
  late ReviewPaging reviewPaging;

  Product? product;

  List<Product> products = [];

  List<MainPageRent> mainProducts = [];
  List<MainPageWant> mainProductsWant = [];
  List<CategoryPageRent> categoryProducts = [];
  List<CategoryPageWant> categoryProductsWant = [];
  List<String> myLocation = ["?????????", "????????????", "?????? ?????? ??????"];
  String currentLocation = "";
  List<Geolocation> geoLocation = [];
  List<Geolocation> geoUserLocation = [];
  productDetailWant? productDetail;
  List<productReview>? productReviewnot;
  List<PrivateRent> privateRentList = [];
  late Paging privateRentCounter;

  List<ChatListModel> chatListItem = [];
  late Paging chatListCounter;
  List<ChatListModel> rentListItem = [];
  List<ChatListModel> rentListItemRent = [];
  late Paging rentListCounter;
  late String productStart;

  String firstAddress = '?????? ????????? ?????????';
  String secondAddress = '?????? ?????? ??????';
  late num firstLa;
  late num firstLo;
  late num secondLa;
  late num secondLo;

  late String searchingWord;
  late num la;
  late num lo;
  late num laDefault = 37.4869535;
  late num loDefault = 126.8956429;
  late num laSecondDefault;
  late num loSecondDefault;
  num? laUser;
  late num loUser;

  List<SpecialProduct> specialProduct = [];

  //?????? ???????????? 1
  List<SearchDataProduct> searchDataProduct = [];
  List<SearchDataProduct> searchDataProductWant = [];
  late Paging searchPaging;

  //?????? ???????????? 2
  List<SearchDataProduct> searchDataProductCa2 = [];
  List<SearchDataProduct> searchDataProductWantCa2 = [];
  late Paging searchPagingCa2;

  //?????? ???????????? 3
  List<SearchDataProduct> searchDataProductCa3 = [];
  List<SearchDataProduct> searchDataProductWantCa3 = [];
  late Paging searchPagingCa3;

  //?????? ???????????? 4
  List<SearchDataProduct> searchDataProductCa4 = [];
  List<SearchDataProduct> searchDataProductWantCa4 = [];
  late Paging searchPagingCa4;

  //?????? ???????????? 5
  List<SearchDataProduct> searchDataProductCa5 = [];
  List<SearchDataProduct> searchDataProductWantCa5 = [];
  late Paging searchPagingCa5;

  //?????? ???????????? 6
  List<SearchDataProduct> searchDataProductCa6 = [];
  List<SearchDataProduct> searchDataProductWantCa6 = [];
  late Paging searchPagingCa6;

  //?????? ???????????? 7
  List<SearchDataProduct> searchDataProductCa7 = [];
  List<SearchDataProduct> searchDataProductWantCa7 = [];
  late Paging searchPagingCa7;

  //?????? ???????????? 8
  List<SearchDataProduct> searchDataProductCa8 = [];
  List<SearchDataProduct> searchDataProductWantCa8 = [];
  late Paging searchPagingCa8;

  //?????? ???????????? 9
  List<SearchDataProduct> searchDataProductCa9 = [];
  List<SearchDataProduct> searchDataProductWantCa9 = [];
  late Paging searchPagingCa9;

  //?????? ???????????? 10
  List<SearchDataProduct> searchDataProductCa10 = [];
  List<SearchDataProduct> searchDataProductWantCa10 = [];
  late Paging searchPagingCa10;


  Future<void> resetAddress() async {
    this.firstAddress = '?????? ?????? ??????';
    this.secondAddress = '?????? ?????? ??????';
    this.firstLa = 0;
    this.firstLo = 0;
    this.secondLa = 0;
    this.secondLo = 0;
    this.laUser = 0;
    this.loUser = 0;
    notifyListeners();
  }

  Future<void> changeUserPosition(num la, num lo) async {
    print("$la, $lo");
    this.laUser = la;
    this.loUser = lo;
    notifyListeners();
  }

  Future<void> changeAddress(String type, num la, num lo, String address) async {
    print(type);
    if (type == "lend1") {
      this.firstAddress = address;
      this.firstLa = la;
      this.firstLo = lo;
    } else if (type == "lend2") {
      this.secondAddress = address;
      this.secondLa = la;
      this.secondLo = lo;
    } else {
      this.firstAddress = address;
      this.firstLa = la;
      this.firstLo = lo;
    }
    notifyListeners();
  }

  Future<void> getGeolocator() async {
    this.currentLocation = myLocation.first;
    int page = 0;
    var currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    await getGeo(currentPosition.latitude, currentPosition.longitude);
    if (this.laUser != null) {
      await getUserGeo( this.laUser!, this.loUser);
    }
    print("la ??????${currentPosition.latitude}");
    print("lo ??????${currentPosition.longitude}");
    await getMainRent(page);
    await getMainWant(page);
    await getGeoDrop();
    await getUserGeoDrop();
    notifyListeners();
  }

  Future<void> getGeoDrop() async {
    try {
      myLocation[0] = geoLocation[1].depth3;
      this.currentLocation = myLocation.first;
    } catch (e) {
      print('geodrop' + e.toString());
    }
    notifyListeners();
  }

  Future<void> getUserGeoDrop() async {
    try {
      if(myLocation[0] != geoUserLocation[1].depth3){
        myLocation[1] = geoUserLocation[1].depth3;
      }
    } catch (e) {
      print('usergeodrop' + e.toString());
    }
    notifyListeners();
  }

  // TODO: point ????????? (??????) ????????? ?????? ??????
  void getProductByCategory(
      double lati, double longti, int page, String type, int category) async {
    if (page == 0) {
      this.products = [];
    }

    final response = (await productService.getProductByCategory(
        lati, longti, page, category));
    Map<String, dynamic> json = jsonDecode(response.toString());

    try {
      List<Product> list = (json['data']['content'] as List)
          .map((e) => Product.fromJson(e))
          .toList();

      Paging paging = Paging.fromJson(json['data']['paging']);

      this.paging = paging;

      if (paging.currentPage == null || paging.currentPage == 0) {
        this.products = list;
      } else {
        for (var e in list) {
          this.products.add(e);
        }
      }
      notifyListeners();
    } catch (e) {
      print("getProductByCategory Exception : $e");
    }
  }

  // TODO: point ????????? (??????) ????????? ?????? ??????
  void getSearch(
      String keyword, int page, double latitude, double longitude) async {
    if (page == 0) {
      this.products = [];
    }
    final response =
        (await productService.getSearch(keyword, page, latitude, longitude));
    Map<String, dynamic> json = jsonDecode(response.toString());

    try {
      List<Product> list = (json['data']['content'] as List)
          .map((e) => Product.fromJson(e))
          .toList();

      Paging paging = Paging.fromJson(json['data']['paging']);

      this.paging = paging;

      // this.products = list;

      if (paging.currentPage == null || paging.currentPage == 0) {
        this.products = list;
      } else {
        for (var e in list) {
          this.products.add(e);
        }
      }

      notifyListeners();
    } catch (e) {
      print('getSearch' + e.toString());
    }
  }

  void getProduct(int id, BuildContext context) async {
    print("id = ${id}");
    this.product = null;

    final response = await productService.getProduct(id);
    Map<String, dynamic> json = jsonDecode(response.toString());
    print("json = ${json}");
    try {
      Product product = Product.fromJson(json['data']);
      this.product = product;


      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      latestProduct(product!.id.toString(), product!, context);
    }
  }

  void getMyProduct(int page) async {
    if (page == 0) {
      this.products = [];
    }

    final response = await productService.getMyProduct(page);
    Map<String, dynamic> json = jsonDecode(response.toString());

    print(json);

    try {
      List<Product> list = (json['data']['content'] as List)
          .map((e) => Product.fromJson(e))
          .toList();

      Paging paging = Paging.fromJson(json['data']['paging']);

      this.paging = paging;

      // this.products = list;

      if (paging.currentPage == null || paging.currentPage == 0) {
        this.products = list;
      } else {
        for (var e in list) {
          this.products.add(e);
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void postProduct(context, String categoryName, String title,
      String description, int price, List<Asset> files) async {
    FormData formData;
    List<MultipartFile> fileList = [];

    var isLoading = true;
    try {
      // showDialog(
      //     context: context,
      //     barrierColor: Colors.black.withOpacity(0.0),
      //     builder: (BuildContext context) {
      //       return Loading();
      //     });

      formData = FormData.fromMap({});
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
        MapEntry<String, MultipartFile> entry =
            new MapEntry("files", multipartFile);
        formData.files.add(entry);
      }

      // formData = FormData.fromMap({"files": fileList});

      print(formData.files);

      // formData.files.add(fileList);
      Navigator.of(context).pop();
      Response? response = await productService.postProduct(categoryName, title, description, price, formData);

      print(response!.statusCode);

      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> productApplyRent(
      String userPh,
      int userIdx,
      int categoryIdx,
      String title,
      String description,
      int price,
      List<Asset> files,
      String startDate,
      String endDate,
      String address,
      String addressDetail,
      num la,
      num lo,
      String token,
      bool otherLocation,
  ) async {
    print("?????????????????? ????????????");
    print(address);
    print(addressDetail);
    print(la);
    print(lo);
    try {
      List<MultipartFile> fileList = [];
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
      }
      final res = await productService.productAddRent(
        userPh,
        userIdx,
        categoryIdx,
        title,
        description,
        price,
        startDate,
        endDate,
        address,
        addressDetail,
        la,
        lo,
        token,
        fileList,
      );
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> productApplyHelp(
      String userPh,
      int userIdx,
      int categoryIdx,
      String title,
      String description,
      int price,
      List<Asset> files,
      String startDate,
      String endDate,
      String address,
      String addressDetail,
      num la,
      num lo,
      String token,
      bool otherLocation,
      ) async {
    print("??????????????? ??? ??????");
    print(address);
    print(addressDetail);
    try {
      List<MultipartFile> fileList = [];
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
        MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
      }
      final res = await productService.productAddHelp(
        userPh,
        userIdx,
        categoryIdx,
        title,
        description,
        price,
        startDate,
        endDate,
        address,
        addressDetail,
        la,
        lo,
        token,
        fileList,
      );
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> productApplyPrivate(
    String userPh,
    int userIdx,
    int categoryIdx,
    int productIdx,
    String title,
    String description,
    int price,
    List<Asset> files,
    String startDate,
    String endDate,
    String address,
    String addressDetail,
    String token,
    num la,
    num lo,
  ) async {
    print("?????????????????? ????????????");
    try {
      FormData formData;
      List<MultipartFile> fileList = [];
      formData = FormData.fromMap({});
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
        // MapEntry<String, MultipartFile> entry =
        // new MapEntry("files", multipartFile);
        // formData.files.add(entry);
      }
      final res = await productService.productAddpri(
        userPh,
        userIdx,
        categoryIdx,
        productIdx,
        title,
        description,
        price,
        startDate,
        endDate,
        address,
        addressDetail,
        la,
        lo,
        token,
        fileList,
      );
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> productApplyWant(
    String userPh,
    int userIdx,
    int categoryIdx,
    String title,
    String description,
    int minPrice,
    int maxPrice,
    List<Asset> files,
    String startDate,
    String endDate,
    String address,
    String addressDetail,
    num la,
    num lo,
    String token,
    bool otherLocation,
  ) async {
    print("?????????????????? ???????????????.");
    print("$address     $addressDetail");
    try {
      List<MultipartFile> fileList = [];
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
      }
      final res = await productService.productAddWant(
        userPh,
        userIdx,
        categoryIdx,
        title,
        description,
        minPrice,
        maxPrice,
        startDate,
        endDate,
        otherLocation == false
            ? "${this.geoLocation[1].depth1} ${this.geoLocation[1].depth2} ${this.geoLocation[1].depth3} ${this.geoLocation[1].depth4}"
            : address,
        addressDetail,
        la,
        lo,
        token,
        fileList,
      );
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> productModified(
      int productIdx,
      int categoryIdx,
      String title,
      String description,
      int price,
      int minPrice,
      int maxPrice,
      List<Asset> files,
      List<int> delFiles,
      String startDate,
      String endDate,
      String address,
      String addressDetail,
      num la,
      num lo,
      String token,
      ) async {
    print("??????????????????");
    try {
      if(files.length == 0 && delFiles.length == 0) {
        final res = await productService.productModifiedText(
          productIdx,
          categoryIdx,
          title,
          description,
          price,
          maxPrice,
          minPrice,
          startDate,
          endDate,
          address,
          addressDetail,
          la,
          lo,
          token,
        );
        Map<String, dynamic> jsonMap = json.decode(res.toString());
        print(jsonMap);
      }else if(files.length > 0 && delFiles.length > 0){
        final res = await productService.productModifiedText(
          productIdx,
          categoryIdx,
          title,
          description,
          price,
          maxPrice,
          minPrice,
          startDate,
          endDate,
          address,
          addressDetail,
          la,
          lo,
          token,
        );
        for(var file in delFiles){
          final resDelPic = await productService.productModifiedDelPic(file, token);
          Map<String, dynamic> jsonMap = json.decode(resDelPic.toString());
          print(jsonMap);
        }
        List<MultipartFile> fileList = [];
        for (var file in files) {
          ByteData byteData = await file.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();
          MultipartFile multipartFile =
          MultipartFile.fromBytes(imageData, filename: file.name);
          fileList.add(multipartFile);
        }
        for(var file in fileList) {
          final resAddPic = await productService.productModifiedAddPic(productIdx, file, token);
          Map<String, dynamic> addPicMap = json.decode(resAddPic.toString());
          print(addPicMap);
        }
        Map<String, dynamic> jsonMap = json.decode(res.toString());
        print(jsonMap);
      }else if(files.length > 0) {
        final res = await productService.productModifiedText(
          productIdx,
          categoryIdx,
          title,
          description,
          price,
          maxPrice,
          minPrice,
          startDate,
          endDate,
          address,
          addressDetail,
          la,
          lo,
          token,
        );
        List<MultipartFile> fileList = [];
        for (var file in files) {
          ByteData byteData = await file.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();
          MultipartFile multipartFile =
          MultipartFile.fromBytes(imageData, filename: file.name);
          fileList.add(multipartFile);
        }
        for(var file in fileList) {
          final resAddPic = await productService.productModifiedAddPic(productIdx, file, token);
          Map<String, dynamic> addPicMap = json.decode(resAddPic.toString());
          print(addPicMap);
        }
        Map<String, dynamic> jsonMap = json.decode(res.toString());
        print(jsonMap);

      }else if(delFiles.length > 0){
        final res = await productService.productModifiedText(
          productIdx,
          categoryIdx,
          title,
          description,
          price,
          maxPrice,
          minPrice,
          startDate,
          endDate,
          address,
          addressDetail,
          la,
          lo,
          token,
        );
        for(var file in delFiles){
          final resDelPic = await productService.productModifiedDelPic(file, token);
          Map<String, dynamic> jsonMap = json.decode(resDelPic.toString());
          print(jsonMap);
        }
        Map<String, dynamic> jsonMap = json.decode(res.toString());
        print(jsonMap);
      }
    } catch (e) {
      print(e);
    }
  }

  void putProduct(
      context,
      int id,
      String categoryName,
      String title,
      String description,
      int price,
      List<Asset> files,
      List<int> deleteFiles) async {
    FormData formData;
    List<MultipartFile> fileList = [];

    var isLoading = true;
    try {
      showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.0),
          builder: (BuildContext context) {
            return Loading();
          });

      formData = FormData.fromMap({});
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
        MapEntry<String, MultipartFile> entry =
            new MapEntry("files", multipartFile);
        formData.files.add(entry);
      }

      print(formData.files);
      Navigator.of(context).pop();

      Response? response = await productService.putProduct(
          id, categoryName, title, description, price, formData, deleteFiles);

      print(response!.statusCode);
      Navigator.of(context).pop();

      Map<String, dynamic> json = jsonDecode(response.toString());

      Product product = Product.fromJson(json['data']);

      this.product = product;

      notifyListeners();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void getSpecialProduct() async {
    final response = (await productService.getSpecialProduct());
    Map<String, dynamic> json = jsonDecode(response.toString());
    try {
      // print("json = $json");
      List<SpecialProduct> list = (json['data'] as List)
          .map((e) => SpecialProduct.fromJson(e))
          .toList();
      this.specialProduct = list;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void deleteProduct(context, int id) async {
    try {
      await productService.deleteProduct(id);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print(e);
    }
  }

  latestProduct(String idx, Product product, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? idxList = pref.getStringList("idx");
    if (idxList == null) idxList = [];

    if (idxList.contains(idx)) {
      idxList.remove(idx);
      pref.remove(idx);
    }
    if (idxList.length >= 8) {
      String deleteIdx = idxList.removeLast();
      pref.remove(deleteIdx);
    }

    idxList.insert(0, idx);
    String encode = json.encode(product.toJson());

    pref.setString(idx, encode);
    pref.setStringList("idxs", idxList);

    Provider.of<MainProvider>(context, listen: false).notify();
  }

  // renting(int id) async {
  //   await productService.rentingProduct(id);
  //   getMyProduct(0);
  //   notifyListeners();
  // }
  //
  // rentable(int id) async {
  //   await productService.rentableProduct(id);
  //   getMyProduct(0);
  //   notifyListeners();
  // }
  //
  // stop(int id) async {
  //   await productService.stopProduct(id);
  //   getMyProduct(0);
  //   notifyListeners();
  // }

  Future<void> getMainRent(int page) async {
    if (page == 0) {
      this.mainProducts = [];
    }
    print("??????????????? ?????? ??????");
    final res = await productService.getMainRent(this.la.toDouble(), this.lo.toDouble(), page);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    try {
      print(jsonMap);
      print("????????????");
      List<MainPageRent> list = (jsonMap['data'] as List)
          .map((e) => MainPageRent.fromJson(e))
          .toList();
      print("????????????");
      Paging paging = Paging.fromJson(jsonMap);
      this.paging = paging;
      if (paging.currentPage == null || paging.currentPage == 0) {
        this.mainProducts = list;
      } else {
        for (var e in list) {
          this.mainProducts.add(e);
        }
      }
    } catch (e) {
      print('mainrent ' + e.toString());
    }
    notifyListeners();
  }

  Future<void> getMainWant(int page) async {
    if (page == 0) {
      this.mainProductsWant = [];
    }
    print("??????????????? ?????? ?????? ???????????????.");
    final res = await productService.getMainWant(this.la.toDouble(), this.lo.toDouble(), page);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    try {
      print("????????????");
      List<MainPageWant> list = (jsonMap['data'] as List)
          .map((e) => MainPageWant.fromJson(e))
          .toList();
      print("????????????");
      Paging paging = Paging.fromJson(jsonMap);
      this.paging = paging;
      if (paging.currentPage == null || paging.currentPage == 0) {
        this.mainProductsWant = list;
      } else {
        for (var e in list) {
          this.mainProductsWant.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void categoryRent(String category, int page, String type) async {
    print(category);
    print(page);
    print(type);
    print(la);
    print(lo);
    if (page == 0) {
      this.categoryProducts = [];
    }
    print("???????????? ?????? ??????");
    final res = await productService.getCategoryProducts(
        category, page, type, la.toDouble(), lo.toDouble());
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap.toString());
    try {
      List<CategoryPageRent> list = (jsonMap['data'] as List)
          .map((e) => CategoryPageRent.fromJson(e))
          .toList();
      Paging paging = Paging.fromJson(jsonMap);
      this.paging = paging;
      if (this.paging.currentPage == null || this.paging.currentPage == 0) {
        this.categoryProducts = list;
        print(this.categoryProducts);
      } else {
        for (var e in list) {
          this.categoryProducts.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void categoryWant(
      String category, int page, String type) async {
    if (page == 0) {
      this.categoryProductsWant = [];
    }
    print("???????????? ?????? ??????");
    final res = await productService.getCategoryProducts(
        category, page, type, la.toDouble(), lo.toDouble());
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap.toString());
    try {
      List<CategoryPageWant> list = (jsonMap['data'] as List)
          .map((e) => CategoryPageWant.fromJson(e))
          .toList();
      Paging paging = Paging.fromJson(jsonMap);
      this.paging = paging;
      if (this.paging.currentPage == null || this.paging.currentPage == 0) {
        this.categoryProductsWant = list;
        print(this.categoryProducts);
      } else {
        for (var e in list) {
          this.categoryProductsWant.add(e);
        }
      }
    } catch (e) {
      print('categotyWant' + e.toString());
    }
    notifyListeners();
  }

  Future<void> getproductDetail(int productIdx) async {
    print(productIdx);
    print("?????? ???????????? ??????");
    this.productDetail = null;
    final res = await productService.productDetail(productIdx, la, lo);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    try {
      productDetailWant list = productDetailWant.fromJson(jsonMap['data']);
      this.productDetail = list;
    } catch (e) {
      print('getproductDetail $e');
    }
    notifyListeners();
  }

  Future<void> getProductReviewFive(int productIdx, int page) async {
    print("?????? ?????? ????????????");
    if (page == 0) {
      this.productReviewnot = null;
    }
    final res = await productService.productReview(productIdx, page);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    try {
      print("????????????");
      List<productReview> list = (jsonMap['data'] as List)
          .map((e) => productReview.fromJson(e))
          .toList();
      print("????????????");
      ReviewPaging paging = ReviewPaging.fromJson(jsonMap);
      this.reviewPaging = paging;
      if (this.reviewPaging.currentPage == null ||
          this.reviewPaging.currentPage == 0) {
        this.productReviewnot = list;
        print(list[0].createAt);
      } else {
        for (var e in list) {
          this.productReviewnot!.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> sendReview(int userIdx, int productIdx, String description,
      int grade, String token) async {
    print("???????????????");
    final res = await productService.sendReview(
        userIdx, productIdx, description, grade, token);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
  }

  Future<void> getGeoSearch(num la, num long) async {
    print("????????? ?????? ??????");
    int page = 0;
    this.laSecondDefault = la;
    this.loSecondDefault = long;
    final res = await productService.getGeo(la, long);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    List<Geolocation> list = (jsonMap['documents'] as List)
        .map((e) => Geolocation.fromJson(e))
        .toList();
    if(this.myLocation[1] == "${list[1].depth3}"){
      Fluttertoast.showToast(
          msg: "???????????? ????????? ????????? ???????????????.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xffff0066),
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      if (this.myLocation[2] == "?????? ?????? ??????") {
        this.myLocation.add('?????? ?????? ??????');
      }
      this.myLocation[2] = "${list[1].depth3}";
      this.currentLocation = "${list[1].depth3}";
      this.la = la;
      this.lo = long;
      await getMainRent(page);
      await getMainWant(page);
    }
    notifyListeners();
  }

  Future<void> getGeoChange(String value) async {
    try {
      int page = 0;
      if (this.myLocation[0] == value) {
        Fluttertoast.showToast(
            msg: "????????? '$value'??? ?????????????????????.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xffff0066),
            textColor: Colors.white,
            fontSize: 16.0
        );
        this.la = this.laDefault;
        this.lo = this.loDefault;
        this.currentLocation = value;
        await getMainRent(page);
        await getMainWant(page);
      } else if (this.myLocation[1] == value) {
        Fluttertoast.showToast(
            msg: "????????? '$value'??? ?????????????????????.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xffff0066),
            textColor: Colors.white,
            fontSize: 16.0
        );
        this.myLocation[1] = value;
        this.currentLocation = value;
        this.la = this.loUser;
        this.lo = this.laUser!;
        await getMainRent(page);
        await getMainWant(page);
      } else {
        Fluttertoast.showToast(
            msg: "????????? '$value'??? ?????????????????????.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xffff0066),
            textColor: Colors.white,
            fontSize: 16.0
        );
        this.myLocation[2] = value;
        this.currentLocation = value;
        this.la = this.laSecondDefault;
        this.lo = this.loSecondDefault;
        await getMainRent(page);
        await getMainWant(page);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> getGeo(num la, num long) async {
    print('?????? ?????? ??????');
    this.la = la;
    this.lo = long;
    this.laDefault = la;
    this.loDefault = long;
    final res = await productService.getGeo(la, long);
    print(res.toString());
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    List<Geolocation> list = (jsonMap['documents'] as List)
        .map((e) => Geolocation.fromJson(e))
        .toList();
    this.geoLocation = list;
    notifyListeners();
  }

  Future<void> getUserGeo(num la, num long) async {
    print('?????? ?????? ?????? ??????');
    final res = await productService.getGeo(long, la);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    List<Geolocation> list = (jsonMap['documents'] as List)
        .map((e) => Geolocation.fromJson(e))
        .toList();
    this.geoUserLocation = list;
    notifyListeners();
  }

  Future<void> SearchingDataProduct(
      int page, String searchData, int category, String type) async {
    switch(category){
      //???????????? 1
      case 2 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProduct = [];
          this.searchDataProductWant = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPaging = paging;
            if (this.searchPaging.currentPage == null ||
                this.searchPaging.currentPage == 0) {
              this.searchDataProduct = list;
            } else {
              for (var e in list) {
                this.searchDataProduct.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPaging = paging;
            if (this.searchPaging.currentPage == null ||
                this.searchPaging.currentPage == 0) {
              this.searchDataProductWant = list;
            } else {
              for (var e in list) {
                this.searchDataProductWant.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
       //???????????? 2
      case 3 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa2 = [];
          this.searchDataProductWantCa2 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa2 = paging;
            if (this.searchPagingCa2.currentPage == null ||
                this.searchPagingCa2.currentPage == 0) {
              this.searchDataProductCa2 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa2.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa2 = paging;
            if (this.searchPagingCa2.currentPage == null ||
                this.searchPagingCa2.currentPage == 0) {
              this.searchDataProductWantCa2 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa2.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      //???????????? 3
      case 4 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa3 = [];
          this.searchDataProductWantCa3 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa3 = paging;
            if (this.searchPagingCa3.currentPage == null ||
                this.searchPagingCa3.currentPage == 0) {
              this.searchDataProductCa3 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa3.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa3 = paging;
            if (this.searchPagingCa3.currentPage == null ||
                this.searchPagingCa3.currentPage == 0) {
              this.searchDataProductWantCa3 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa3.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      //???????????? 4
      case 5 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa4 = [];
          this.searchDataProductWantCa4 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa4 = paging;
            if (this.searchPagingCa4.currentPage == null ||
                this.searchPagingCa4.currentPage == 0) {
              this.searchDataProductCa4 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa4.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa4 = paging;
            if (this.searchPagingCa4.currentPage == null ||
                this.searchPagingCa4.currentPage == 0) {
              this.searchDataProductWantCa4 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa4.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      //???????????? 5
      case 6 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa5 = [];
          this.searchDataProductWantCa5 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa5 = paging;
            if (this.searchPagingCa5.currentPage == null ||
                this.searchPagingCa5.currentPage == 0) {
              this.searchDataProductCa5 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa5.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa5 = paging;
            if (this.searchPagingCa5.currentPage == null ||
                this.searchPagingCa5.currentPage == 0) {
              this.searchDataProductWantCa5 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa5.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      //???????????? 6
      case 7:
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa6 = [];
          this.searchDataProductWantCa6 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa6 = paging;
            if (this.searchPagingCa6.currentPage == null ||
                this.searchPagingCa6.currentPage == 0) {
              this.searchDataProductCa6 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa6.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa6 = paging;
            if (this.searchPagingCa6.currentPage == null ||
                this.searchPagingCa6.currentPage == 0) {
              this.searchDataProductWantCa6 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa6.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      //???????????? 7
      case 8 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa7 = [];
          this.searchDataProductWantCa7 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa7 = paging;
            if (this.searchPagingCa7.currentPage == null ||
                this.searchPagingCa7.currentPage == 0) {
              this.searchDataProductCa7 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa7.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if (type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa7 = paging;
            if (this.searchPagingCa7.currentPage == null ||
                this.searchPagingCa7.currentPage == 0) {
              this.searchDataProductWantCa7 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa7.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      //???????????? 8
      case 9 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa8 = [];
          this.searchDataProductWantCa8 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa8 = paging;
            if (this.searchPagingCa8.currentPage == null ||
                this.searchPagingCa8.currentPage == 0) {
              this.searchDataProductCa8 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa8.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa8 = paging;
            if (this.searchPagingCa8.currentPage == null ||
                this.searchPagingCa8.currentPage == 0) {
              this.searchDataProductWantCa8 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa8.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      //???????????? 9
      case 10 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa9 = [];
          this.searchDataProductWantCa9 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa9 = paging;
            if (this.searchPagingCa9.currentPage == null ||
                this.searchPagingCa9.currentPage == 0) {
              this.searchDataProductCa9 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa9.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa9 = paging;
            if (this.searchPagingCa9.currentPage == null ||
                this.searchPagingCa9.currentPage == 0) {
              this.searchDataProductWantCa9 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa9.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      //???????????? 10
      case 11 :
        print(page);
        print(searchData);
        print(category);
        print(type);
        print('?????? ?????? ??????????????? ?????????');
        if (page == 0) {
          this.searchDataProductCa10 = [];
          this.searchDataProductWantCa10 = [];
        }
        if(type == "RENT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa10 = paging;
            if (this.searchPagingCa10.currentPage == null ||
                this.searchPagingCa10.currentPage == 0) {
              this.searchDataProductCa10 = list;
            } else {
              for (var e in list) {
                this.searchDataProductCa10.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        else if(type == "WANT"){
          try {
            final res = await productService.searchProduct(
                page, searchData, la, lo, category, type);
            Map<String, dynamic> jsonMap = json.decode(res.toString());
            List<SearchDataProduct> list = (jsonMap['data'] as List)
                .map((e) => SearchDataProduct.fromJson(e))
                .toList();
            print(list);
            Paging paging = Paging.fromJson(jsonMap);
            this.searchPagingCa10 = paging;
            if (this.searchPagingCa10.currentPage == null ||
                this.searchPagingCa10.currentPage == 0) {
              this.searchDataProductWantCa10 = list;
            } else {
              for (var e in list) {
                this.searchDataProductWantCa10.add(e);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        break;
    }
    notifyListeners();
  }

  Future<void> delProduct(int productIdx, String token) async {
    print("?????? ?????? ???????????????");
    try {
      final res = await productService.delProduct(productIdx, token);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
      mainProducts.removeWhere((item) => item.idx == productIdx);
    } catch (e) {
      print(e);
    }
  }

  Future<void> privateList(int productIdx, int page, String token) async {
    print("?????? ?????? ???????????????");
    try {
      final res =
          await productService.privateList(productIdx, la, lo, page, token);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<PrivateRent> list = (jsonMap['data'] as List)
          .map((e) => PrivateRent.fromJson(e))
          .toList();
      print(list);
      Paging paging = Paging.fromJson(jsonMap);
      this.privateRentCounter = paging;
      if (this.privateRentCounter.currentPage == null ||
          this.privateRentCounter.currentPage == 0) {
        this.privateRentList = list;
      } else {
        for (var e in list) {
          this.privateRentList.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> chatList(int userIdx, int page, String token) async {
    print("??? ????????? ???????????????");
    try {
      final res = await productService.chatList(userIdx, page, token);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<ChatListModel> list = (jsonMap['data'] as List)
          .map((e) => ChatListModel.fromJson(e))
          .toList();
      Paging paging = Paging.fromJson(jsonMap);
      print(list);
      this.chatListCounter = paging;
      if(this.chatListCounter.currentPage == null || this.chatListCounter.currentPage == 0) {
        this.chatListItem = list;
      }else {
        for(var e in list) {
          this.chatListItem.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> rentHistory(int userIdx, int page, String token) async{
    print("?????? ???????????? ????????????");
    print(userIdx);
    try{
      final res = await productService.rentHistory(userIdx, page, token, "WANT");
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<ChatListModel> list = (jsonMap['data'] as List)
          .map((e) => ChatListModel.fromJson(e))
          .toList();
      print(list);
      Paging paging = Paging.fromJson(jsonMap);
      this.rentListCounter = paging;
      if(this.rentListCounter.currentPage == null || this.rentListCounter.currentPage == 0) {
        this.rentListItem = list;
      }else {
        for(var e in list) {
          this.rentListItem.add(e);
        }
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> rentHistoryRent(int userIdx, int page, String token) async{
    print("?????? ???????????? ???????????????");
    print(userIdx);
    try{
      final res = await productService.rentHistory(userIdx, page, token, "RENT");
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<ChatListModel> list = (jsonMap['data'] as List)
          .map((e) => ChatListModel.fromJson(e))
          .toList();
      print(list);
      Paging paging = Paging.fromJson(jsonMap);
      this.rentListCounter = paging;
      if(this.rentListCounter.currentPage == null || this.rentListCounter.currentPage == 0) {
        this.rentListItemRent = list;
      }else {
        for(var e in list) {
          this.rentListItemRent.add(e);
        }
      }
    }catch(e){
      print(e);
    }
    notifyListeners();
  }

  Future<String> rentInit(int senderIdx, int receiverIdx, int productIdx, String token) async {
    print("???????????? ??????");
    try {
      print("${senderIdx}, ${receiverIdx}, ${productIdx}, ${token}");
      final res = await productService.productInit(senderIdx, receiverIdx, productIdx, token);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
      this.productStart = jsonMap['data'];
      return jsonMap['data'];
    } catch(e){
      print(e);
      notifyListeners();
      return '';
    }
  }

  Future<void> rentStatus(String token, int sender, int receiver, int productIdx, String status, String uuid) async {
    print("???????????? ??? ?????? ???????????? ???????????????");
    try{
      print("$token, $sender, $receiver, $productIdx, $status, $uuid");
      var rentStartRes;
      var rentFinishRes;
      switch(status){
        case "INIT" :
          rentStartRes = await productService.historyStart(token, sender, receiver, productIdx, status, uuid);
          break;
        case "START" :
          rentFinishRes = await productService.historyFinish(token, productIdx, uuid);
          break;
      }
      Map<String, dynamic> startMap = json.decode(rentStartRes.toString());
      Map<String, dynamic> finishMap = json.decode(rentFinishRes.toString());
      print(startMap);
      print(finishMap);
    }catch(e){
      print(e);
    }
    notifyListeners();
  }
}
