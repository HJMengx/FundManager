import 'package:flutter/material.dart';
import 'package:mxfundmanager/CustomWidgets/real_rich_text.dart';
import 'package:flutter/gestures.dart';

typedef ClickItemWithCallBack = void Function(bool isExpenses);

class MoneyInfoItemWidget extends StatelessWidget {
  final String title;

  final String upperContent;

  final String littleContent;

  final ClickItemWithCallBack callback;

  MoneyInfoItemWidget(
      {Key key,
      this.title,
      this.upperContent,
      this.littleContent,
      this.callback})
      : assert(title != null),
        assert(upperContent != null),
        assert(littleContent != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
//      margin: EdgeInsets.only(left: 20, right: 20),
      width: (MediaQuery.of(context).size.width - 52) / 3,
      height: 60,
      alignment: Alignment.center,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Text(
            title,
            style: new TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
          new RealRichText([
            TextSpan(
              text: this.upperContent,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (this.callback != null) {
                    print("调用了 ${this.title}");
                    if (this.title.toLowerCase() == "expenses" ||
                        this.title.toLowerCase() == "花费") {
                      this.callback(true);
                    } else {
                      this.callback(false);
                    }
                  }
                },
            ),
            TextSpan(
              text: this.littleContent,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ]),
        ],
      ),
    );
  }
}
