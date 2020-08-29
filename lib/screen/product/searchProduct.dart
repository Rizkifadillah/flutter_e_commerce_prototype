import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_prototype/model/productModel.dart';
import 'package:flutter_e_commerce_prototype/network/network_api.dart';
import 'package:flutter_e_commerce_prototype/screen/product/detailProduct.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {

  var loading = false;

  List<ProductModel> list = [];
  List<ProductModel> listSearch = [];
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

  final price = NumberFormat("#,##0",'en_US');
  TextEditingController searchController = TextEditingController();
  
  onSearch(String text)async {
    listSearch.clear();
    if (text.isEmpty) {
      setState(() {

      });
    }
    list.forEach((a) {
      if (a.productName.toLowerCase().contains(text))
        listSearch.add(a);
    });
    setState(() {

    });
  }



  Future<void>onRefresh()async{
    getProduct();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white
          ),
          controller: searchController,
          onChanged: onSearch,
          autofocus: true,
            cursorColor: Colors.white,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
//              border: UnderlineInputBorder(
//                borderSide: BorderSide(color: Colors.white),
//              ),
              focusColor: Colors.white,
              suffixIcon: Icon(Icons.search,color:Colors.white),
                hintText: "Search Product",
                hintStyle: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w300),
//                focusedBorder: OutlineInputBorder(
////                    borderRadius: BorderRadius.circular(30),
//                    borderSide: BorderSide(
//                        color: Colors.green
//                    )
//                )
            ),
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: loading 
            ? Center(child: CircularProgressIndicator(),)
            : searchController.text.isNotEmpty || listSearch.length != 0
            ? GridView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,mainAxisSpacing: 8,crossAxisSpacing: 8
            ),
            itemCount: listSearch.length,
            itemBuilder: (context, i){
              final a = listSearch[i];
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailProduct(a,getProduct)
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
                        SizedBox(
                          height: 10,
                        ),
                        Text("${a.productName}"),
                        Text("Rp ${price.format(a.sellingPrice)}")
                      ],
                    ),
                  ),
                ),
              );
            }
        )
            : Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Please Search your item product",
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.grey
              ),)
            ],
          ),
        )
      ),
    );
  }
}
