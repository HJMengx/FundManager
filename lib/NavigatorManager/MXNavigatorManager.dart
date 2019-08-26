import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseWidget {
  // Get the identifier of Page
  String getIdentifier();

  // Resetting params
  void resetParams(Map<String, dynamic> params);

  // GetWidget
  Widget getWidget();
}

class MXNavigatorManager {
  static MXNavigatorManager _shared;

  factory MXNavigatorManager() {
    return sharedInstance();
  }

  MXNavigatorManager._internal();

  static MXNavigatorManager sharedInstance() {
    if (_shared == null) {
      _shared = MXNavigatorManager._internal();
    }
    return _shared;
  }

  Map<String, BaseWidget> _pages = new Map<String, BaseWidget>();

  void registerRouter(String identifier, BaseWidget widget) {
    if (!this._pages.containsKey(identifier)) {
      this._pages[identifier] = widget;
    }
  }

  void unRegisterRouter(String identifier) {
    if (this._pages.containsKey(identifier)) {
      this._pages.remove(identifier);
    }
  }

  // Navigator.push
  void pushPage(BuildContext context, String identifier,
      Map<String, dynamic> params, Widget desPage) {
    Widget willPushPage;
    if (this._pages.containsKey(identifier)) {
      BaseWidget page = this._pages[identifier];
      if (params != null) {
        page.resetParams(params);
      }
      willPushPage = page.getWidget();
    } else if (desPage != null) {
      willPushPage = desPage;
    } else {
      throw new Exception("The Identifier is not register.");
    }

    Navigator.of(context).push(MaterialPageRoute(
        settings: new RouteSettings(name: identifier),
        builder: (context) {
          return willPushPage;
        }));
  }

  // Modal
  void presentPage(BuildContext context, String identifier,
      Map<String, dynamic> params, Widget desPage) {
    Widget willPushPage;
    if (this._pages.containsKey(identifier)) {
      BaseWidget page = this._pages[identifier];
      if (params != null) {
        page.resetParams(params);
      }
      willPushPage = page.getWidget();
    } else if (desPage != null) {
      willPushPage = desPage;
    } else {
      throw new Exception("The Identifier is not register.");
    }

    Navigator.of(context).push(CupertinoPageRoute(
        settings: new RouteSettings(name: identifier),
        fullscreenDialog: true,
        builder: (context) {
          return willPushPage;
        }));
  }

  // Animate With Custom
  void customAnimateToPage(
      BuildContext context,
      String identifier,
      Map<String, dynamic> params,
      RouteTransitionsBuilder transitionsBuilder,
      Duration duration,
      Widget desPage) {
    Widget willPushPage;
    if (this._pages.containsKey(identifier)) {
      BaseWidget page = this._pages[identifier];
      if (params != null) {
        page.resetParams(params);
      }
      willPushPage = page.getWidget();
    } else if (desPage != null) {
      willPushPage = desPage;
    } else {
      throw new Exception("The Identifier is not register.");
    }
    Navigator.of(context).push(PageRouteBuilder(
        settings: new RouteSettings(name: identifier),
        pageBuilder: (context, _, __) {
          return willPushPage;
        },
        transitionsBuilder: transitionsBuilder,
        transitionDuration: duration));
  }

  // Pop
  void popPage(BuildContext context, {String identifier}) {
    if (context != null) {
      if (identifier == null ||
          identifier == "" ||
          identifier.replaceAll(" ", "").length == 0) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).popUntil((Route<dynamic> route) {
          return route.settings.name == identifier;
        });
      }
    }
  }
}
