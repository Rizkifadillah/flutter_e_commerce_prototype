import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_prototype/model/productModel.dart';
import 'package:flutter_e_commerce_prototype/network/network_api.dart';
import 'package:flutter_e_commerce_prototype/screen/menu/home.dart';
import 'package:flutter_e_commerce_prototype/screen/product/detailProduct.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Favorit extends StatefulWidget {
  @override
  _FavoritState createState() => _FavoritState();
}

//final price = NumberFormat("#,##0",'en_US');

class _FavoritState extends State<Favorit> {

  var loading = false;
  var cekData = false;
  List<ProductModel> list = [];
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String deviceID;

  getDeviceInfo()async{
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Divice Info : ${androidInfo.id}");
    setState(() {
      deviceID = androidInfo.id;
    });
    getProduct();
  }
  getProduct()async{
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(NetworkUrl.getFavorite(deviceID));
    if(response.statusCode == 200){
      if(response.contentLength == 2){
        setState(() {
          loading = false;
          cekData = false;
        });
      }else{
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          for(Map i in data){
            list.add(ProductModel.fromJson(i));
          }
          loading = false;
          cekData = true;
        });
      }
    }else{
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

  addFavorite(ProductModel model)async{
    setState(() {
      loading = true;
    });
    final response = await http.post(NetworkUrl.addFavorite(),body: {
      "deviceID" : deviceID,
      "idProduct" : model.id
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if(value == 1){
      print(message);
      getProduct();
      setState(() {
        loading = false;
      });
    }else{
      print(message);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> onRefresh()async{
    getDeviceInfo();
//    getProduct();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceInfo();
//    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
//          height: 50,
//            width: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 50,
                      width: 50,
                      child: Image.asset("././assets/stand.png", fit: BoxFit.cover)),
                  SizedBox(
                    width: 25,
                  ),

                  Text(
                    "Favorite",
                    style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),
                  ),
                ],
              )),

          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.tealAccent,Colors.blueAccent[100]]
                ),
                boxShadow: [BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 10,
                    spreadRadius: 1
                )]
            ),
          ),
        ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[
            loading
                ? Container(
              height: 600,
              child: Center(child: CircularProgressIndicator()),)
                : cekData
                ? Container(
                  child: GridView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,mainAxisSpacing: 8,crossAxisSpacing: 8
              ),
              itemCount: list.length,
              itemBuilder: (context, i){
                  final a = list[i];
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DetailProduct(a, getProduct)
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: Colors.grey[200]
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow:[
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.white
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Image.network(
                                "http://192.168.43.205/Ecommerce/product/${a.cover}",
                                fit: BoxFit.cover,
                                height: 120,
                              ),
                            ),
//                        SizedBox(
//                          height: 10,
//                        ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${a.productName}"),
                                    Text("Rp ${price.format(a.sellingPrice)}")
                                  ],
                                ),
                                IconButton(
                                    onPressed: (){
                                      addFavorite(a);
                                    },
                                    icon:Icon(Icons.favorite_border,
                                      color: Colors.black87,)
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              },
            ),
                )
                : Container(
              height: 600,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("You don't have product favorit yet",textAlign: TextAlign.center,)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
