import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/china_lunar_copy.dart';
import 'utils/date_util.dart';
import 'widget_single_choose.dart';

class WidgetDateChoose<T> extends StatefulWidget {
  final bool showPartition;
  final Color colorPartition;
  final EdgeInsets paddingPartition;
  final double heightPartition;
  final DateChooseController controller;
  final bool useMagnifier;
  final double magnification;
  final double height;

  WidgetDateChoose(
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
  _WidgetDateChooseState createState() => _WidgetDateChooseState();
}

class _WidgetDateChooseState extends State<WidgetDateChoose> {
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
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: ChangeNotifierProvider<DateChooseController>(
        create: (context) => widget.controller,
        child: Consumer<DateChooseController>(
          builder: (context, model, _) => Row(
            children: [
              Expanded(
                child: WidgetSingleChoose(
                  controller: widget.controller.dayController,
                  list: widget.controller.days,
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
                  controller: widget.controller.monthController,
                  list: widget.controller.months,
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
                  controller: widget.controller.yearController,
                  list: widget.controller.years,
                  itemExtent: (widget.height) / 3,
                  colorPartition: widget.colorPartition,
                  paddingPartition: widget.paddingPartition,
                  showPartition: widget.showPartition ?? true,
                  heightPartition: widget.heightPartition,
                  useMagnifier: widget.useMagnifier,
                  magnification: widget.magnification,
                  builder: (context, index, number, isSelected) {
                    return Center(
                      child: Text("$number", style: _style(isSelected)),
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

class DateChooseController extends ChangeNotifier {
  final FixedExtentScrollController dayController =
      FixedExtentScrollController();
  final FixedExtentScrollController monthController =
      FixedExtentScrollController();
  final FixedExtentScrollController yearController =
      FixedExtentScrollController();
  final StreamController<DateWithLeap> _streamController =
      StreamController<DateWithLeap>();

  final DateTime start;
  final DateTime end;
  final DateTime initDate;

  final int _durationSecond = 2;
  final bool isLunar;
  Duration _duration;
  Stream<DateWithLeap> _streamDate;
  List<int> years;
  List<int> months;
  List<int> days;
  bool inAnimate;
  ChinaLunar chinaLunar = ChinaLunar();

  DateChooseController({
    @required this.start,
    @required this.end,
    this.initDate,
    this.isLunar = false,
  }) {
    _initAndListen();
  }

  _initAndListen() {
    inAnimate = false;
    _duration = Duration(seconds: _durationSecond);
    _streamDate = _streamController.stream;
    years = List.generate(end.year - start.year, (index) => start.year + index);
    months = List.generate(12, (index) => index + 1);
    days = List.generate(
        DateUtil.daysInMonth(1, start.year), (index) => index + 1);
    _streamController.add(DateWithLeap(date: initDate));
    yearController.addListener(() {
      _onChanged();
    });
    monthController.addListener(() {
      _onChanged();
    });
    dayController.addListener(() {
      _onChanged(isDay: true);
    });
    Future.delayed(Duration(milliseconds: 750), (){
      animateTo(initDate);
    });
  }

  _animateToItem(int index, FixedExtentScrollController controller) {
    controller.jumpToItem(index);
  }

  _onChanged({bool isDay = false}) {
    if (inAnimate) return;
    DateTime date;
    bool isLeap = false;
    if (isLunar) {
      date = DateTime(
          start.year + yearController.selectedItem,
          (monthController.selectedItem + 1 <=
                  chinaLunar
                      .leapMonth(start.year + yearController.selectedItem))
              ? (monthController.selectedItem + 1)
              : monthController.selectedItem,
          dayController.selectedItem + 1);
      int leapMonth = chinaLunar.leapMonth(date.year);
      int leapDays = chinaLunar.solarDays(date.year, date.month);
      if (monthController.selectedItem == leapMonth) isLeap = true;
      if (leapMonth != 0) {
        months = List.generate(
            13, (index) => (index + 1 <= leapMonth) ? (index + 1) : index);
      } else {
        months = List.generate(12, (index) => index + 1);
      }
      days = List.generate(leapDays, (index) => index + 1);
    } else {
      date = DateTime(start.year + yearController.selectedItem,
          monthController.selectedItem + 1, dayController.selectedItem + 1);
      days = List.generate(
          DateUtil.daysInMonth(monthController.selectedItem + 1,
              start.year + yearController.initialItem + 1),
          (index) => index + 1);
    }
    notifyListeners();
    _streamController.add(DateWithLeap(date: date, isLeap: isLeap));
  }

  Stream<DateWithLeap> get watchChanged => _streamDate;

  Duration get durationAnimate => _duration;

  Future<DateWithLeap> get currentSelected async => await _streamDate.last;

  Future<void> animateTo(DateTime date) async {
    inAnimate = true;
    _animateToItem(date.day - 1, dayController);
    _animateToItem(date.month - 1, monthController);
    _animateToItem(date.year - start.year, yearController);
    Future.delayed(_duration, () {
      inAnimate = false;
    });
  }

  @override
  void dispose() {
    _streamController.close();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }
}

class DateWithLeap {
  final DateTime date;
  final bool isLeap;

  const DateWithLeap({this.date, this.isLeap});
}
