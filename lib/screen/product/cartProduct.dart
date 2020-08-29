import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_prototype/model/productCartModel.dart';
import 'package:flutter_e_commerce_prototype/network/network_api.dart';
import 'package:flutter_e_commerce_prototype/screen/menu/home.dart';
import 'package:http/http.dart'as http;

class ProductCart extends StatefulWidget {
  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  getDeviceInfo()async{
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Divice Info : ${androidInfo.id}");
    setState(() {
      unikID = androidInfo.id;
    });
    _fetchData();
  }
  String unikID;
  List<ProductCartModel> list= [];
  var loading = false;
  var cekData = false;
  _fetchData()async{
    setState(() {
      loading= true;
    });
    list.clear();
    final response = await http.get(NetworkUrl.getCart(unikID));
    if (response.statusCode==200){
      if(response.contentLength ==2 ){
        setState(() {
          loading = false;
          cekData = false;
        });
      }else{
        final data = jsonDecode(response.body);
        setState(() {
          for(Map i in data){
            list.add(ProductCartModel.fromJson(i));
          }
          loading = false;
          cekData = true;
        });
        _getTotalHarga();
      }
    }else{
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

  var totalPrice = "0";
  _getTotalHarga()async{
    setState(() {
      loading = true;
    });
    final response = await http.get(NetworkUrl.getTotalHargaCart(unikID));
    if(response.statusCode == 200){
      final data = jsonDecode(response.body)[0];
      String total = data["total"];
      setState(() {
        loading = false;
        totalPrice = total;
      });
    }else{
      setState(() {
        loading = false;
      });

    }
  }

  _addQty(ProductCartModel model,String tipe)async{
    await http.post(NetworkUrl.updateQty(),body: {
      "idProduct": model.id,
      "unikID" : unikID,
      "tipe" : tipe
    });
    setState(() {
      _fetchData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ProductCart"),
        elevation: 1,
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
      body: Container(
        child: loading
            ? Center(child: CircularProgressIndicator(),)
            : cekData
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context,i){
                          final a = list[i];
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Card(
                              elevation: 2,
                              child: Container(
                              padding: EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(a.productName),
                                          Text("Price : Rp. ${price.format(a.sellingPrice)}"),
        //                            Text("Quantity ${a.qty}")
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        onPressed: (){
                                          _addQty(a, "tambah");
                                        },
                                        icon:Icon(Icons.add),
                                      ),
                                    ),
                                    Container(
                                      child: Text("${a.qty}"),
                                    ),
                                    Container(
                                      child: IconButton(
                                        onPressed: (){
                                          _addQty(a, "kurang");
                                        },
                                        icon:Icon(Icons.remove),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          },
                  ),
                ),
                totalPrice == "0"
                    ? SizedBox() :
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40),),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.tealAccent,Colors.blueAccent[100]]

                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                          icon:Icon(Icons.card_travel,color:Colors.white)
                      ),
                      Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
//                        color: Colors.orangeAccent
                          ),
                          child: Text("Rp ${price.format(int.parse(totalPrice))}",style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w300
                          ),
                          )
                      ),
                      InkWell(
                        onTap: (){

                        },
                        child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.tealAccent,Colors.blueAccent[100]]

                                )
                            ),
                            child: Text("Check Out",style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You don't have product on cart",textAlign: TextAlign.center,)
          ],
        )
      ),
    );
  }
}
