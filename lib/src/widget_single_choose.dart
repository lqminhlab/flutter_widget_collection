import 'package:flutter/material.dart';

typedef IndexedWidgetBuilder<T> = Widget Function(
    BuildContext context, int index, T data, bool isSelected);
typedef ChangedIndex<T> = void Function(int index, T data);

class WidgetSingleChoose<T> extends StatefulWidget {
  final List<T> list;
  final double itemExtent;
  final IndexedWidgetBuilder builder;
  final ChangedIndex onSelectedItemChanged;
  final bool showPartition;
  final Color colorPartition;
  final EdgeInsets paddingPartition;
  final double heightPartition;
  final ScrollController controller;
  final bool useMagnifier;
  final double magnification;

  WidgetSingleChoose(
      {this.list,
      @required this.itemExtent,
      @required this.builder,
      this.onSelectedItemChanged,
      this.controller,
      this.useMagnifier,
      this.heightPartition,
      this.magnification,
      this.colorPartition,
      this.paddingPartition,
      this.showPartition});

  @override
  _WidgetSingleChooseState createState() => _WidgetSingleChooseState();
}

class _WidgetSingleChooseState extends State<WidgetSingleChoose> {
  int currentPosition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Container(
          height: widget.itemExtent,
          padding: widget.paddingPartition,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(
                  width: widget.heightPartition ?? 1.2,
                  color: widget.colorPartition ?? Colors.lightBlue),
              bottom: BorderSide(
                width: widget.heightPartition ?? 1.2,
                color: widget.colorPartition ?? Colors.lightBlue,
              ),
            )),
          ),
        )),
        ListWheelScrollView.useDelegate(
          itemExtent: widget.itemExtent,
          onSelectedItemChanged: (index) {
            setState(() {
              currentPosition = index;
            });
            if (widget.onSelectedItemChanged != null)
              widget.onSelectedItemChanged(index, widget.list[index]);
          },
          controller: widget.controller,
          physics: FixedExtentScrollPhysics(),
          useMagnifier: widget.useMagnifier ?? false,
          magnification: widget.magnification ?? 1.0,
          childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.list.length,
              builder: (context, index) => widget.builder(context, index,
                  widget.list[index], (currentPosition ?? 0) == index)),
        )
      ],
    );
  }
}
