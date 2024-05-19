import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentedControl extends StatefulWidget {
  final List<String> labels;
  final Function(int) onSegmentChosen;
  final int groupValue;
  final double borderRadius;
  final double? width;
  final double? height;
  final Color selectedColor;
  final Color unselectedColor;
  final Color borderColor;

  const SegmentedControl({
    super.key,
    required this.labels,
    required this.onSegmentChosen,
    required this.groupValue,
    this.borderRadius = 10.0,
    this.width,
    this.height,
    this.selectedColor = const Color(0xFF3786A8),
    this.unselectedColor = CupertinoColors.white,
    this.borderColor = const Color(0xFF3786A8),
  });

  @override
  State<SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  @override
  Widget build(BuildContext context) {
    Map<int, Widget> children = {};
    for (int i = 0; i < widget.labels.length; i++) {
      children[i] = Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.groupValue == i
              ? widget.selectedColor
              : widget.unselectedColor,
          border: Border.all(
            color: widget.borderColor,
          ),
        ),
        child: Text(
          widget.labels[i],
          style: TextStyle(
            color: widget.groupValue == i
                ? widget.unselectedColor
                : widget.selectedColor,
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: CupertinoSegmentedControl<int>(
          children: children,
          onValueChanged: widget.onSegmentChosen,
          groupValue: widget.groupValue,
          padding: const EdgeInsets.all(4.0),
          borderColor: widget.borderColor,
        ),
      ),
    );
  }
}
