import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mxfundmanager/NavigatorManager/MXNavigatorManager.dart';
import 'package:mxfundmanager/model/opeartionType.dart';

class AddConsumePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AddConsumeState();
  }
}

class _AddConsumeState extends State<AddConsumePage> {
  String _currentType = "Expense";
  List<OperationType> _operationType = new List<OperationType>();

  bool _isCollect = false;

  void readData() {
    // 读取数据库数据
    for (int i = 0; i < 40; i++) {
      OperationType type = new OperationType();
      type.filename = "assets/food.png";
      type.type = "Expense";
      this._operationType.add(type);
    }
  }

  @override
  void initState() {
    super.initState();
    // 加载数据
    this.readData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new GestureDetector(
        onTap: () {
          // Switch to collect
          this.setState(() {
            if (this._isCollect) {
              this._currentType = "Income";
            } else {
              this._currentType = "Expense";
            }
            this._isCollect = !this._isCollect;
          });
        },
        child: new Container(
          width: 120,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                this._currentType,
                style: new TextStyle(color: Colors.black87, fontSize: 16),
              ),
              new Container(
                margin: EdgeInsets.only(left: 1),
                child: new Icon(
                  Icons.arrow_drop_down,
                  size: 32,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        ),
      ),
      leading: Builder(builder: (context) {
        return IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.black87),
          //自定义图标
          onPressed: () {
            // 退回到上个页面
            Navigator.of(context).popUntil((route) {
              return route.isFirst;
            });
          },
        );
      }),
    );
  }

  void _readMore() async {
    this.readData();
    Future.delayed(new Duration(seconds: 2)).then((value) {
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: this._buildAppBar(),
      body: new Container(
        margin: EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
        child: new GridView.builder(
            itemCount: this._operationType.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              if (index == this._operationType.length - 1) {
                this._readMore();
              }
              return new Container(
                height: 42,
                width: 42,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: new Color.fromRGBO(0, 0, 0, 0.1)),
                      constraints: new BoxConstraints(
                          maxWidth: 32,
                          maxHeight: 32,
                          minHeight: 32,
                          minWidth: 32),
                      child: new Center(
                        child: new Image.asset(
                          "assets/food.png",
                          width: 21,
                          height: 21,
                        ),
                      ),
                    ),
                    new Text("Food"),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
