import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_prototype/model/categoryProductModel.dart';
import 'package:flutter_e_commerce_prototype/model/productModel.dart';
import 'package:flutter_e_commerce_prototype/network/network_api.dart';
import 'package:flutter_e_commerce_prototype/screen/product/add_product.dart';
import 'package:flutter_e_commerce_prototype/screen/product/cartProduct.dart';
import 'package:flutter_e_commerce_prototype/screen/product/detailProduct.dart';
import 'package:flutter_e_commerce_prototype/screen/product/searchProduct.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:device_info/device_info.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final price = NumberFormat("#,##0",'en_US');

class _HomeState extends State<Home> {
  var loading = false;

  List<CategoryProductModel> listCategory = [];

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String deviceID;

  getDeviceInfo()async{
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Divice Info : ${androidInfo.id}");
    setState(() {
      deviceID = androidInfo.id;
    });
    getTotalCart();
  }
  getCategoryProduct()async{
    setState(() {
      loading = true;
    });
    listCategory.clear();
    final response = await http.get(NetworkUrl.getProductCategory());
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for(Map i in data){
          listCategory.add(CategoryProductModel.fromJson(i));
        }
        loading = false;
      });
    }else{
      setState(() {
        loading = false;
      });
    }
  }

  var filter = false;

  List<ProductModel> list = [];
  getProduct()async{
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(NetworkUrl.getProduct());
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for(Map i in data){
          list.add(ProductModel.fromJson(i));
        }
        loading = false;
      });
    }else{
      setState(() {
        loading = false;
      });
    }
  }



  Future<void>onRefresh()async{
//    getTotalCart();
    getProduct();
    getCategoryProduct();
    setState(() {
      filter = false;
    });
  }

  int index = 0;

  //menambahkan favorite
  addFavorite(ProductModel model)async{
    setState(() {
      loading = true;
    });
    final response = await http.post(NetworkUrl.addFavorite(),body: {
      "deviceID" : deviceID,
      "idProduct" : model.id
    });
    final data = jsonDecode(response.body);
    int value = data['vale'];
    String message = data['message'];
    if(value == 1){
      print(message);
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

  var loadingCart = false;
  var totalCart = "0";
  getTotalCart()async{
    setState(() {
      loadingCart = true;
    });
    final response = await http.get(NetworkUrl.getTotalCart(deviceID));
    if (response.statusCode == 200){
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      print("Total Cart $total");
      setState(() {
        loadingCart = false;
        totalCart = total;
      });
    }else{
      setState(() {
        loadingCart = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getTotalCart();
    getProduct();
    getCategoryProduct();
    getDeviceInfo();
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
                  "yur",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Sayur",
                  style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),
                ),
              ],
            )),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => SearchProduct()
              ));
            },
              icon:Icon(Icons.search)),
          SizedBox(
            width: 15,
          ),
          Icon(Icons.notifications_active),
          SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProductCart()
                ));
              },
              icon:Stack(
                children: <Widget>[
                  Icon(Icons.shopping_cart),
                  totalCart =="0"
                  ? SizedBox()
                  : Positioned(
                    right: 0,
                    top: -2,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration:BoxDecoration(
                        shape: BoxShape.circle,
                        color:Colors.red
                      ),
                      child: Text("$totalCart",style:TextStyle(
                        fontSize: 8,
                        color:Colors.white
                      )),
                    ),
                  )
                ],
              )),
          SizedBox(
            width: 15,
          ),
        ],
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

      floatingActionButton: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddProduct()
          ));
        },
        child: Container(
          padding: EdgeInsets.all(8),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.tealAccent,Colors.blueAccent[100]]

              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Add Product",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(),)
          : RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            // Category Product
            Container(
              height: 40,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: listCategory.length,
                  itemBuilder: (context,i){
                    final a = listCategory[i];
                    return InkWell(
                      onTap: (){
                        setState(() {
                          filter = true;
                          index = i;
                          print(filter);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8,right: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [Colors.tealAccent,Colors.blueAccent[100]]

                            )
                        ),
                        child: Text(
                          a.categoryName,
                          style:  TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            // grid product
           filter
               ? listCategory[index].product.length == 0
                ? Container(
             height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Sorry Product no This Category not Available",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,

                        ),
                      )
                    ],
                  ),
                )
               : GridView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,mainAxisSpacing: 8,crossAxisSpacing: 8
            ),
            itemCount: listCategory[index].product.length,
            itemBuilder: (context, i){
              final a = listCategory[index].product[i];
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailProduct(a, getTotalCart)
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
//                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                color: Colors.blueAccent,)
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
           )
               : GridView.builder(
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
                      builder: (context) => DetailProduct(a, getTotalCart)
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
          ],
        ),
          )

    );
  }
}
