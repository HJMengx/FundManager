import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:mxfundmanager/model/item.dart';
import 'package:mxfundmanager/NavigatorManager/MXNavigatorManager.dart';
import 'package:mxfundmanager/ItemDetailPage/ItemDetailPage.dart';

import 'package:mxfundmanager/CustomWidgets/real_rich_text.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ConsumeDetailPage extends StatefulWidget {
  final DateTime checkDate;

  List<Item> _consumes;

  double _totalExpense = 0;

  ConsumeDetailPage({Key key, this.checkDate}) : super(key: key) {
    // 初始化
    this.getDayConsumeData(DateTime.now());
    print("数据初始化完毕");
  }

  void getDayConsumeData(DateTime date) {
    // 先模拟数据
    math.Random(10);
    if (this._consumes == null) {
      this._consumes = new List<Item>();
    }
    // Loading Data
    for (int i = 0; i < 4; i++) {
      Item consume = Item.initWithParams(
          "Food",
          (i + 1) * math.Random().nextInt(50).toDouble() + 1.0,
          DateTime(2010 + i), "Buy couple shoes", "Expense");
      print("初始化实例对象 $i, consume: $consume");
      this._totalExpense += consume.money;
      this._consumes.add(consume);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return new ConsumeDetailPageState();
  }
}

class ConsumeDetailPageState extends State<ConsumeDetailPage>
    implements BaseWidget {
  Map<String, dynamic> _params;

  List<charts.Series<Item, int>> _createChartsData() {
    return [
      new charts.Series<Item, int>(
        id: "Sales",
        domainFn: (Item consume, _) => consume.date.year,
        //
        measureFn: (Item consume, _) => consume.money,
        data: this.widget._consumes,
        labelAccessorFn: (Item consume, _) => consume.type,
        colorFn: (Item consume, index) {
          // 255, 20, 147, (index + 1) * 0.1
          return charts.Color(r: 255, g: 20, b: 147, a: (index + 1) * 30);
        },
      )
    ];
  }

  @override
  String getIdentifier() {
    return "ConsumePage";
  }

  @override
  void resetParams(Map<String, dynamic> params) {
    this.setState(() {
      this._params = params;
    });
  }

  @override
  Widget getWidget() {
    return this.widget;
  }

  Widget buildPieCharts() {
    print("构建饼图");
    return charts.PieChart(
      this._createChartsData(),
      animate: true,
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 80,
          arcRendererDecorators: [new charts.ArcLabelDecorator()]),
    );
  }

  Widget buildGaugeCharts() {
    print("构建百分比占用图");
    return charts.PieChart(
      this._createChartsData(),
      animate: true,
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 60,
          startAngle: 0,
          arcLength: 2 * math.pi,
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.inside)
          ]),
    );
  }

  Widget buildRow(Item consume, BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: 51,
      decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(color: Colors.black54, width: 0.5),
          borderRadius: new BorderRadius.all(new Radius.circular(5)),
          boxShadow: [
            new BoxShadow(
                color: Colors.black54, offset: new Offset(3, 3), blurRadius: 5)
          ]),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(left: 5, top: 10, bottom: 10),
            width: 30,
            child: new Icon(
              Icons.shop,
              color: Colors.orangeAccent,
            ),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 5),
            height: 40,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // 数据部分
                new Container(
                  height: 25,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        width: 120,
                        child: new RealRichText([
                          TextSpan(
                            text: consume.type + "  ",
                          ),
                          TextSpan(
                              text:
                                  ((consume.money / this.widget._totalExpense) *
                                              100)
                                          .toString()
                                          .substring(0, 4) +
                                      "%",
                              style: new TextStyle(color: Colors.black54))
                        ]),
                      ),
                      new Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width - 200,
                        child: new RealRichText([
                          TextSpan(
                            text: "expense: ",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: consume.money.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
                // 进度条
                new Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 10,
                  width: (MediaQuery.of(context).size.width - 80) *
                      consume.money /
                      this.widget._totalExpense,
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(5)),
                      color: Colors.orangeAccent),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          this.widget.checkDate.year.toString() +
              "-" +
              this.widget.checkDate.month.toString() +
              "-" +
              this.widget.checkDate.day.toString(),
          style: new TextStyle(color: Colors.black87, fontSize: 16),
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
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              // Route Go Analyse
            },
            child: new Container(
              margin: EdgeInsets.only(right: 20),
              width: 32,
              height: 32,
              child: new Icon(
                Icons.compare_arrows,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: new Container(
        margin: EdgeInsets.only(bottom: 10),
        child: new ListView.builder(
            itemCount: this.widget._consumes.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return new Container(
                  width: 400,
                  height: 300,
                  child: new Stack(
                    children: <Widget>[
                      this.buildGaugeCharts(),
                      new Center(
                        child: new Text(
                          "Expenses \n" + this.widget._totalExpense.toString(),
                          style:
                              new TextStyle(color: Colors.black, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return new GestureDetector(
                    onTap: () {
                      // Goto The DetailPage
                      ItemDetailPage itemPage = new ItemDetailPage(
                        item: this.widget._consumes[index],
                      );
                      MXNavigatorManager.sharedInstance()
                          .pushPage(context, "ItemPage", null, itemPage);
                    },
                    child: this
                        .buildRow(this.widget._consumes[index - 1], context));
              }
            }),
      ),
    );
  }
}
