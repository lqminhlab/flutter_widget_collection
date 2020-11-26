import 'package:flutter/material.dart';

class WidgetPageGesture extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final Function toLeftEnd;
  final Function toRightEnd;
  final Function toTopEnd;
  final Function toBottomEnd;

  const WidgetPageGesture(
      {@required this.child,
      @required this.width,
      @required this.height,
      this.toLeftEnd,
      this.toBottomEnd,
      this.toRightEnd,
      this.toTopEnd});

  @override
  _WidgetPageGestureState createState() => _WidgetPageGestureState();
}

class _WidgetPageGestureState extends State<WidgetPageGesture> {
  bool onDrag = false;
  bool opacity = false;

  double dx0 = 0;
  double dx = 0;
  bool toLeft = false;
  bool toLeftOpacity = true;
  bool toRight = false;
  bool toRightOpacity = true;

  double dy0 = 0;
  double dy = 0;
  bool toTop = false;
  bool toTopOpacity = true;
  bool toBottom = false;
  bool toBottomOpacity = true;

  void onHorizontalStart(DragStartDetails dt) async {
    dx0 = dt.localPosition.dx;
  }

  void onHorizontalUpdate(DragUpdateDetails dt) async {
    dx = dt.localPosition.dx;
  }

  void onHorizontalDrag(DragEndDetails dt) async {
    onDrag = true;
    if (dx0 < dx) {
      setState(() {
        toLeft = true;
        toLeftOpacity = false;
        opacity = true;
      });
      await Future.delayed(Duration(milliseconds: 250));
      setState(() {
        opacity = false;
      });
      await Future.delayed(Duration(milliseconds: 250));
      setState(() => setState(() {
            toLeft = false;
          }));
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        toLeftOpacity = true;
      });
      widget.toLeftEnd?.call();
    } else {
      setState(() {
        toRight = true;
        toRightOpacity = false;
        opacity = true;
      });
      await Future.delayed(Duration(milliseconds: 250));
      setState(() {
        opacity = false;
      });
      await Future.delayed(Duration(milliseconds: 250));
      setState(() => setState(() {
            toRight = false;
          }));
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        toRightOpacity = true;
      });
      widget.toRightEnd?.call();
    }
    onDrag = false;
  }

  void onVerticalStart(DragStartDetails dt) async {
    dy0 = dt.localPosition.dy;
  }

  void onVerticalUpdate(DragUpdateDetails dt) async {
    dy = dt.localPosition.dy;
  }

  void onVerticalDrag(DragEndDetails dt) async {
    onDrag = true;
    if (dy0 < dy) {
      setState(() {
        toBottom = true;
        toBottomOpacity = false;
        opacity = true;
      });
      await Future.delayed(Duration(milliseconds: 250));
      setState(() {
        opacity = false;
      });
      await Future.delayed(Duration(milliseconds: 250));
      setState(() => setState(() {
            toBottom = false;
          }));
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        toBottomOpacity = true;
      });
      widget.toBottomEnd?.call();
    } else {
      setState(() {
        toTop = true;
        toTopOpacity = false;
        opacity = true;
      });
      await Future.delayed(Duration(milliseconds: 250));
      setState(() {
        opacity = false;
      });
      await Future.delayed(Duration(milliseconds: 250));
      setState(() => setState(() {
            toTop = false;
          }));
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        toTopOpacity = true;
      });
      widget.toTopEnd?.call();
    }
    onDrag = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragStart: onHorizontalStart,
        onHorizontalDragUpdate: onHorizontalUpdate,
        onHorizontalDragEnd: onDrag ? null : onHorizontalDrag,
        onVerticalDragStart: onVerticalStart,
        onVerticalDragUpdate: onVerticalUpdate,
        onVerticalDragEnd: onDrag ? null : onVerticalDrag,
        child: Container(
          width: widget.width,
          height: MediaQuery.of(context).size.height,
          child: ClipRect(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: opacity ? 0 : 1,
                  duration: Duration(milliseconds: 250),
                  child: widget.child,
                ),
                AnimatedPositioned(
                    left: !toLeft ? -widget.width : 0,
                    child: AnimatedOpacity(
                      opacity: !toLeftOpacity ? 0 : 1,
                      duration: Duration(milliseconds: 500),
                      child: widget.child,
                    ),
                    duration: Duration(milliseconds: 500)),
                AnimatedPositioned(
                    right: !toRight ? -widget.width : 0,
                    child: AnimatedOpacity(
                      opacity: !toRightOpacity ? 0 : 1,
                      duration: Duration(milliseconds: 500),
                      child: widget.child,
                    ),
                    duration: Duration(milliseconds: 500)),
                AnimatedPositioned(
                    bottom: !toTop ? -widget.height : 0,
                    child: AnimatedOpacity(
                      opacity: !toTopOpacity ? 0 : 1,
                      duration: Duration(milliseconds: 500),
                      child: widget.child,
                    ),
                    duration: Duration(milliseconds: 500)),
                AnimatedPositioned(
                    top: !toBottom ? -widget.height : 0,
                    child: AnimatedOpacity(
                      opacity: !toBottom ? 0 : 1,
                      duration: Duration(milliseconds: 500),
                      child: widget.child,
                    ),
                    duration: Duration(milliseconds: 500)),
              ],
            ),
          ),
        ));
  }
}
