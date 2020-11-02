import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget_single_choose.dart';

class WidgetTimeChoose<T> extends StatefulWidget {
  final bool showPartition;
  final Color colorPartition;
  final EdgeInsets paddingPartition;
  final double heightPartition;
  final TimeChooseController controller;
  final bool useMagnifier;
  final double magnification;
  final double height;

  WidgetTimeChoose(
      {@required this.height,
      @required this.controller,
      this.useMagnifier,
      this.heightPartition,
      this.magnification,
      this.colorPartition,
      this.paddingPartition,
      this.showPartition})
      : assert(controller != null && height != null,
            "Controller and height for WidgetDateChoose must not null!");

  @override
  _WidgetTimeChooseState createState() => _WidgetTimeChooseState();
}

class _WidgetTimeChooseState extends State<WidgetTimeChoose> {
  int currentPosition;

  String _minimum10(int t) {
    return "${t < 10 ? "0$t" : t}";
  }

  TextStyle _style(bool isSelected) => TextStyle(
      fontSize: 15,
      height: 1.2,
      fontWeight: FontWeight.w800,
      color: isSelected ? Color.fromRGBO(40, 40, 40, 1) : Colors.grey);

  @override
  void dispose() {
    widget.controller.hoursController.dispose();
    widget.controller.minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: ChangeNotifierProvider<TimeChooseController>(
        create: (context) => widget.controller,
        child: Consumer<TimeChooseController>(
          builder: (context, model, _) => Row(
            children: [
              Expanded(
                child: WidgetSingleChoose(
                  controller: widget.controller.hoursController,
                  list: widget.controller.hours,
                  itemExtent: (widget.height) / 3,
                  colorPartition: widget.colorPartition,
                  paddingPartition: widget.paddingPartition,
                  showPartition: widget.showPartition ?? true,
                  heightPartition: widget.heightPartition,
                  useMagnifier: widget.useMagnifier,
                  magnification: widget.magnification,
                  builder: (context, index, number, isSelected) {
                    return Center(
                      child: Text("${_minimum10(number)}",
                          style: _style(isSelected)),
                    );
                  },
                ),
              ),
              Expanded(
                child: WidgetSingleChoose(
                  controller: widget.controller.minutesController,
                  list: widget.controller.minutes,
                  itemExtent: (widget.height) / 3,
                  colorPartition: widget.colorPartition,
                  paddingPartition: widget.paddingPartition,
                  showPartition: widget.showPartition ?? true,
                  heightPartition: widget.heightPartition,
                  useMagnifier: widget.useMagnifier,
                  magnification: widget.magnification,
                  builder: (context, index, number, isSelected) {
                    return Center(
                      child: Text("${_minimum10(number)}",
                          style: _style(isSelected)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeChooseController extends ChangeNotifier {
  final FixedExtentScrollController hoursController =
      FixedExtentScrollController();
  final FixedExtentScrollController minutesController =
      FixedExtentScrollController();
  final StreamController<DateTime> _streamController =
      StreamController<DateTime>();

  DateTime initDate;
  Stream<DateTime> _streamDate;
  List<int> minutes;
  List<int> hours;

  TimeChooseController({this.initDate}) {
    _initAndListen();
  }

  _initAndListen() {
    if (initDate == null) initDate = DateTime.now();
    _streamDate = _streamController.stream;
    hours = List.generate(24, (index) => index);
    minutes = List.generate(60, (index) => index);
    _streamController.add(initDate);
    minutesController.addListener(() {
      _onChanged();
    });
    hoursController.addListener(() {
      _onChanged(isDay: true);
    });
    Future.delayed(Duration(milliseconds: 250), () {
      animateTo(initDate);
    });
  }

  _animateToItem(int index, FixedExtentScrollController controller) {
    controller.jumpToItem(index);
  }

  _onChanged({bool isDay = false}) {
    DateTime date = DateTime(initDate.year, initDate.month, initDate.day,
        hoursController.selectedItem, minutesController.selectedItem);
    _streamController.add(date);
  }

  Stream<DateTime> get watchChanged => _streamDate;

  Future<void> animateTo(DateTime date) async {
    _animateToItem(date.hour - 1, hoursController);
    _animateToItem(date.minute - 1, minutesController);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
