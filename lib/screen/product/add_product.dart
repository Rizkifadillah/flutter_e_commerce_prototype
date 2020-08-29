import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter_e_commerce_prototype/model/categoryProductModel.dart';
import 'package:flutter_e_commerce_prototype/screen/product/chooseCategory.dart';
import 'package:path/path.dart'as path;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final TextEditingController _product = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();

  FocusNode priceNode = FocusNode();
  FocusNode descriptionNode = FocusNode();


  File image;

  gallery()async{
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image =_image;
    });
  }


  TextEditingController nameController = TextEditingController();
  TextEditingController sellingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  CategoryProductModel model;

  chooseCategory()async{
    model = await Navigator.push(context,MaterialPageRoute(
        builder: (context) => ChooseCategoryProduct()
    ));
    setState(() {
      categoryController = TextEditingController(text: model.categoryName);
    });
  }


  save()async{
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

//    final response = await http.post("http://192.168.43.205/Ecommerce/api/addProduct.php", body:{
//      "productName" : nameController.text,
//      "sellingPrice" : sellingController.text,
//      "description" : descriptionController.text
//    });
//
//    final data = jsonDecode(response.body);
//    int value = data["value"];
//    String message = data["message"];
//    print(data);

   try{
     var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
     var lenght = await image.length();
     var url = Uri.parse("http://192.168.43.205/Ecommerce/api/addProduct.php");
     var request = http.MultipartRequest("POST",url);
     var multiPartFile = http.MultipartFile("image", stream, lenght,
         filename: path.basename(image.path));

     request.fields['productName'] = nameController.text;
     request.fields['sellingPrice'] = sellingController.text;
     request.fields['description'] = descriptionController.text;
     request.fields['idCategory'] = model.id;
     request.files.add(multiPartFile);

     var response = await request.send();
     response.stream.transform(utf8.decoder).listen((value){
       final data = jsonDecode(value);
       int valueGet = data['value'];
       String message = data ['message'];
       if(valueGet == 1){
         Navigator.pop(context);
         print(message);
       }else{
         Navigator.pop(context);
         print(message);
       }
     });
   }catch(e){
     debugPrint("Error $e");
   }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      chooseCategory();
                    },
                    child: TextField(
                      enabled: false,
                      controller: categoryController,
                      cursorColor: Colors.green,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Choose Categories",
                          labelStyle: TextStyle(color: Colors.green,fontSize: 18,fontWeight: FontWeight.w300),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.green
                              )
                          )
                      ),
                      onSubmitted: (_){
                        FocusScope.of(context).requestFocus(priceNode);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    cursorColor: Colors.green,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                        labelStyle: TextStyle(color: Colors.green,fontSize: 18,fontWeight: FontWeight.w300),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.green
                        )
                      )
                    ),
                    onSubmitted: (_){
                      FocusScope.of(context).requestFocus(priceNode);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: sellingController,
                    cursorColor: Colors.green,
                    focusNode: priceNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Selling Price",
                        labelStyle: TextStyle(color: Colors.green,fontSize: 18,fontWeight: FontWeight.w300),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.green
                            )
                        )
                    ),
                    onSubmitted: (_){
                      FocusScope.of(context).requestFocus(descriptionNode);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: descriptionController,
                    cursorColor: Colors.green,
                    focusNode: descriptionNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                        labelText: "Description Product",
                        labelStyle: TextStyle(color: Colors.green,fontSize: 18,fontWeight: FontWeight.w300),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.green
                            )
                        )
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: gallery,
                  child: image == null
                      ? Image.asset("././assets/placeholderhutan.jpg", fit: BoxFit.cover)
                      : Image.file(image,fit:BoxFit.cover)
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: (){
                  save();
                },
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                        colors: [Colors.tealAccent,Colors.blueAccent[100]]

                    )
                  ),
                  child: Center(
                    child: Text('Save Product', style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
