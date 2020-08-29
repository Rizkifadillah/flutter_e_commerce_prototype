import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_prototype/screen/menu/account.dart';
import 'package:flutter_e_commerce_prototype/screen/menu/favorit.dart';
import 'package:flutter_e_commerce_prototype/screen/menu/history.dart';
import 'package:flutter_e_commerce_prototype/screen/menu/home.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: selectIndex != 0,
            child: TickerMode(
              enabled: selectIndex == 0,
              child: Home(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 1,
            child: TickerMode(
              enabled: selectIndex == 1,
              child: Favorit(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 2,
            child: TickerMode(
              enabled: selectIndex == 2,
              child: History(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 3,
            child: TickerMode(
              enabled: selectIndex == 3,
              child: Account(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
//        color: Colors.blue,
        child: Container(
          height: 50,
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
              InkWell(
                onTap: (){
                  setState(() {
                    selectIndex = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    selectIndex = 1;
                  });
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    selectIndex = 2;
                  });
                },
                child: Icon(
                  Icons.history,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    selectIndex = 3;
                  });
                },
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
