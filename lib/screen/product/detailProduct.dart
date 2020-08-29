import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_prototype/model/productModel.dart';
import 'package:flutter_e_commerce_prototype/network/network_api.dart';
import 'package:flutter_e_commerce_prototype/screen/menu/home.dart';
import 'package:http/http.dart'as http;

class DetailProduct extends StatefulWidget {
  final ProductModel model;
  final VoidCallback reload;
  DetailProduct(this.model,this.reload);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String deviceID;

  getDeviceInfo()async{
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Divice Info : ${androidInfo.id}");
    setState(() {
      deviceID = androidInfo.id;
    });
  }

  addCart()async{
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Processing...."),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Loading...")
                ],
              ),
            ),
          );
        }
    );
    final response = await http.post(NetworkUrl.addCart(), body:{
      "unikID" : deviceID,
      "idProduct" : widget.model.id
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data ['message'];
    if(value ==1){
      Navigator.pop(context);
      showDialog(context: context,builder: (context){
        return AlertDialog(
          title: Text("Information"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  setState(() {
                    Navigator.pop(context);
                    widget.reload();
                  });
                },
                child: Text("OK"))
          ],
        );
      });
    }else{
      Navigator.pop(context);
      showDialog(context: context,builder: (context){
        return AlertDialog(
          title: Text("Warning"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                onPressed: ()=> Navigator.pop(context),
                child: Text("OK"))
          ],
        );
      });
    }
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
        title: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.tealAccent,Colors.blueAccent[100]]

                )                    ),
            child: Text("${widget.model.productName}",style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
            )
        ),
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
        bottomNavigationBar: BottomAppBar(
//        color: Colors.blue,
          child: Container(
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
                    child: Text("Rp ${price.format(widget.model.sellingPrice)}",style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w300
                    ),
                    )
                ),
                InkWell(
                  onTap: (){
                    addCart();
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
                      child: Text("Add Cart",style: TextStyle(
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
        ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Image.network(
                    "http://192.168.43.205/Ecommerce/product/${widget.model.cover}",
                    fit: BoxFit.cover,
                    height: 180,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${widget.model.productName}",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.w700
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${widget.model.description}",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.w500
                  ))
                ],
              ),
            ),

          ],
        ),
      )
    );
  }
}
