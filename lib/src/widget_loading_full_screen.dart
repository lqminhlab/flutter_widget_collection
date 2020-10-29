import 'package:flutter/material.dart';

import 'widget_fade_transitions.dart';
import 'widget_loading.dart';

class LoadingFullScreen extends StatelessWidget {
  final Widget child;
  final bool loading;
  final Color color;

  const LoadingFullScreen(
      {Key key, @required this.child, this.loading, @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !loading,
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              child: child ?? Container(),
            ),
            loading == true
                ? _LoadingWidget(
                    color: color,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  final Color color;

  const _LoadingWidget({this.color});

  @override
  Widget build(BuildContext context) {
    return WidgetFadeTransitions(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.black54,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Container(
              width: 85,
              height: 85,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999)),
              child: Center(
                child: WidgetLoading(
                  dotOneColor: color ?? Color.fromRGBO(251, 85, 171, 1),
                  dotTwoColor: color ?? Color.fromRGBO(251, 85, 171, 1),
                  dotThreeColor: color ?? Color.fromRGBO(251, 85, 171, 1),
                  dotType: DotType.circle,
                  duration: Duration(milliseconds: 1000),
                ),
              ),
            ),
          )),
    );
  }
}
