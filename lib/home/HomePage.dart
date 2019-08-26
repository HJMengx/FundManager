import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mxfundmanager/CustomWidgets/MoneyInfoItemWidget.dart';
import 'package:mxfundmanager/CustomWidgets/UseDayWidget.dart';
import 'package:mxfundmanager/NavigatorManager/MXNavigatorManager.dart';
import 'package:mxfundmanager/DayDetailPage/ConsumeDetailPage.dart';
import 'package:mxfundmanager/addconsume/AddConsumePage.dart';
import 'package:mxfundmanager/database/DataBaseManager.dart';
import 'package:mxfundmanager/model/item.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> implements BaseWidget {
  Map<String, dynamic> _params;

  GlobalKey<ConsumeDetailPageState> consumeKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void registerRoutes() {
    // Register Self
    MXNavigatorManager.sharedInstance()
        .registerRouter(this.getIdentifier(), this);
    // Register Indicate Page(Consume Page)

    ConsumeDetailPage consumePage = new ConsumeDetailPage(
      key: this.consumeKey,
      checkDate: DateTime.now(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  String getIdentifier() {
    return "HomePage";
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register Routes
    this.registerRoutes();
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        "Money Manager",
        style: new TextStyle(color: Colors.black87, fontSize: 16),
      ),
      leading: Builder(builder: (context) {
        return IconButton(
          icon: new Icon(Icons.menu, color: Colors.black87),
          //自定义图标
          onPressed: () {
            // 打开抽屉菜单
            Scaffold.of(context).openDrawer();
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
            child: new Image.asset(
              "assets/diagram.png",
              width: 32,
              height: 32,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.buildAppBar(context),
      drawer: new Drawer(
        child: new Container(
          color: Colors.black87,
        ),
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height - 100,
        child: new ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              if (index == 0) {
                // 基本数据
                return new Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                          color: Color.fromRGBO(0, 0, 0, 0.2), width: 0.5),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(5)),
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black54,
                            offset: new Offset(3, 0),
                            blurRadius: 5)
                      ]),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new MoneyInfoItemWidget(
                        title: "2019",
                        upperContent: "A",
                        littleContent: "ugust",
                      ),
                      // Split Line
                      new Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        width: 1,
                        height: 30,
                        color: Colors.black87,
                      ),
                      new MoneyInfoItemWidget(
                        title: "Incomes",
                        upperContent: "1024",
                        littleContent: ".88",
                        callback: (isExpenses) {},
                      ),
                      // Split Line
                      new Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        width: 1,
                        height: 30,
                        color: Colors.black87,
                      ),
                      new MoneyInfoItemWidget(
                        title: "Expenses",
                        upperContent: "15",
                        littleContent: ".5",
                        callback: (isExpenses) {
                          ConsumeDetailPage page = new ConsumeDetailPage(
                            checkDate: DateTime.now(),
                          );
                          MXNavigatorManager.sharedInstance()
                              .pushPage(context, "ConsumePage", null, page);
                        },
                      )
                    ],
                  ),
                );
              } else {
                // 月份数据
                return new UseDayWidget(
                  expenses: ["", "", "", "", ""],
                );
              }
            }),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          // 添加数据
          Future<int> index = DatabaseManager.sharedInstance().insert("item",
              Item.initWithParams("Food", 100.00, null, "又花钱了", "Expense"));
          index.whenComplete(() {
            print(index);
          });
          Future<List<Map>> models =
              DatabaseManager.sharedInstance().query("item");
          models.then((List<Map> values) {
            for (Map model in values) {
              print(Item.initFromJson(model));
            }
          });
          // Go to Add Incomes Or Consumes
          AddConsumePage page = new AddConsumePage();
          MXNavigatorManager.sharedInstance()
              .pushPage(context, "AddConsumePage", null, page);
        },
        child: new Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
