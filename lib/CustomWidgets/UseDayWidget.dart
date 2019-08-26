import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UseDayWidget extends StatefulWidget {
  List expenses;

  UseDayWidget({Key key, this.expenses})
      : assert(expenses != null && expenses.length > 0),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UseDayState();
  }
}

class _UseDayState extends State<UseDayWidget> {
  Widget _buildRow(Icon icon, String type, String content) {
    // 图标, 类型   空间  金额
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(left: 20),
          alignment: Alignment.center,
          child: icon,
        ),
        new Container(
          margin: EdgeInsets.only(left: 20),
          alignment: Alignment.center,
          child: new Text(type),
        ),
        new Expanded(
            child: new Container(
          margin: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: new Text(content),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 20),
      decoration: new BoxDecoration(
          color: Colors.white,
          border:
              new Border.all(color: Color.fromRGBO(0, 0, 0, 0.2), width: 0.5),
          borderRadius: new BorderRadius.all(new Radius.circular(5)),
          boxShadow: [
            new BoxShadow(
                color: Colors.black54, offset: new Offset(3, 0), blurRadius: 5)
          ]),
      height: this.widget.expenses.length < 5
          ? this.widget.expenses.length * 30.0 + 35
          : 185.0,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                border: new Border(
                    bottom:
                        new BorderSide(color: Color.fromRGBO(0, 0, 0, 0.2)))),
            height: 30,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 20),
                  child: new Text(
                    "Wed 04/12",
                    style: new TextStyle(color: Colors.black54),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(right: 20),
                  child: new Text(
                    "Expenses: 1024",
                    style: new TextStyle(color: Colors.black54),
                  ),
                )
              ],
            ),
          ),
          new Container(
            height: 150,
            child: ListView.builder(
                itemCount: this.widget.expenses.length,
                itemBuilder: (context, index) {
                  return new Container(
                    margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
                    child: this._buildRow(
                        Icon(
                          Icons.fastfood,
                          color: Colors.blueAccent,
                        ),
                        "Food",
                        "-1084.5"),
                  );
                }),
          )
        ],
      ),
    );
  }
}
