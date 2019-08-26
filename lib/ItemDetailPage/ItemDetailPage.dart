import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mxfundmanager/model/item.dart';
import 'package:mxfundmanager/NavigatorManager/MXNavigatorManager.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  ItemDetailPage({Key key, this.item}) : super(key: key) {}

  AppBar _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Container(
        width: 120,
        child: new Text(
          "Details",
          style: new TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      leading: Builder(builder: (context) {
        return IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.black87),
          //自定义图标
          onPressed: () {
            // 退回到上个页面
            MXNavigatorManager.sharedInstance().popPage(context);
          },
        );
      }),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(
              Icons.delete,
              color: Colors.black87,
              size: 32,
            ),
            onPressed: () {
              print("Delete Click");
            }),
      ],
    );
  }

  Widget _buildType() {
    return new Container(
      height: 50,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(left: 10, top: 9, bottom: 9),
            width: 100,
            alignment: Alignment.centerLeft,
            child: new Image.asset(
              "assets/" + this.item.type.toLowerCase() + ".png",
              height: 32,
              width: 32,
            ),
          ),
          new Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, top: 9, bottom: 9, right: 10),
            height: 32,
            child: new Text(this.item.type),
          )
        ],
      ),
    );
  }

  Widget _buildItemDetailRow(String name, String value) {
    return new Container(
      height: 50,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(left: 10, top: 9, bottom: 9),
            width: 100,
            height: 32,
            child: new Text(
              name,
              style: new TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6)),
            ),
          ),
          new Container(
            margin: EdgeInsets.only(left: 20, top: 9, bottom: 9),
            height: 32,
            child: new Text(
                value == "" || value == null ? "Don`t fill the memo" : value),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: this._buildAppBar(),
      body: new Container(
        margin: EdgeInsets.only(left: 5, top: 20, right: 5),
        height: 280,
        child: new Stack(
          children: <Widget>[
            new Container(
              height: 260,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(
                      color: Color.fromRGBO(0, 0, 0, 0.2), width: 0.5),
                  borderRadius: new BorderRadius.all(new Radius.circular(5)),
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black54,
                        offset: new Offset(1, 1),
                        blurRadius: 2)
                  ]),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  this._buildType(),
                  new Container(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    height: 1,
                    margin: EdgeInsets.only(left: 10, right: 10),
                  ),
                  this._buildItemDetailRow("Category", this.item.category),
                  this._buildItemDetailRow("Money", this.item.money.toString()),
                  this._buildItemDetailRow("Date", this.item.date.toString()),
                  this._buildItemDetailRow("Memo", this.item.memo),
                ],
              ),
            ),
            // 编辑按钮
            Positioned(
                bottom: 5,
                right: 20,
                child: new Container(
                  width: 40,
                  height: 40,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent,
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black54,
                          offset: new Offset(1, 1),
                          blurRadius: 2)
                    ],
                  ),
                  child: new Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 24,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
