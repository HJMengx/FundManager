import 'package:mxfundmanager/database/DataBaseManager.dart';

class Item extends Object implements BaseModel {
  String type;
  double money;
  DateTime date;
  String memo;
  String category;

  Item() {
    this.type = "";
    this.money = 0;
    this.date = null;
    this.memo = "";
    this.category = "Expense";
  }

  Item.initFromJson(Map params) {
    if (params.containsKey("type")) {
      this.type = params["type"];
    }

    if (params.containsKey("money")) {
      this.money = params["money"];
    }

    if (params.containsKey("date")) {
      this.date = params["date"];
    }

    if (params.containsKey("memo")) {
      this.memo = params["memo"];
    }

    if (params.containsKey("category")) {
      this.category = params["category"];
    }
  }

  Item.initWithParams(
      String type, double money, DateTime date, String memo, String category) {
    if (type != null) {
      this.type = type;
    }

    if (money != null && money > 0) {
      this.money = money;
    }
    if (date != null) {
      this.date = date;
    } else {
      this.date = DateTime.now();
    }

    if (memo != null) {
      this.memo = memo;
    }

    if (category != null) {
      this.category = category;
    }
  }

  @override
  BaseModel initFromMap(Map params) {
    if (params.containsKey("type")) {
      this.type = params["type"];
    }

    if (params.containsKey("money")) {
      this.money = params["money"];
    }

    if (params.containsKey("date")) {
      this.date = params["date"];
    } else {
      this.date = DateTime.now();
    }

    if (params.containsKey("memo")) {
      this.memo = params["memo"];
    }

    if (params.containsKey("category")) {
      this.category = params["category"];
    }
    return this;
  }

  @override
  String toString() {
    return this.date.toString() +
        " " +
        this.type +
        " expense: " +
        this.money.toString() +
        ", memo: ${this.memo}";
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "type": this.type,
      "money": this.money,
      "date": this.date.toIso8601String(),
      "memo": this.memo,
      "category": this.category
    };
  }
}
