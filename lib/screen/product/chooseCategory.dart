import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_prototype/model/categoryProductModel.dart';
import 'package:flutter_e_commerce_prototype/network/network_api.dart';
import 'package:http/http.dart' as http;


class ChooseCategoryProduct extends StatefulWidget {
  @override
  _ChooseCategoryProductState createState() => _ChooseCategoryProductState();
}

class _ChooseCategoryProductState extends State<ChooseCategoryProduct> {
  var loading = false;

  List<CategoryProductModel> listCategory = [];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryProduct();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Category"),
      ),
      body: Container(
        child: loading
            ? Center(
          child: CircularProgressIndicator()
        )
            : ListView.builder(
          itemCount: listCategory.length,
          itemBuilder: (context, i){
            final a = listCategory[i];
            return InkWell(
              onTap: (){
                Navigator.pop(context,a);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(a.categoryName),
//                      Container(
//                        padding: EdgeInsets.symmetric(vertical: 4),
//                        child: Divider(
//                          color: Colors.grey,
//                        ),
//                      )
                        ],
                      ),
                    ),
                    leading: Icon(Icons.check_circle,color: Colors.blue,),
                  ),
                ),
              )

            );
          },
        )
      ),
    );
  }
}
