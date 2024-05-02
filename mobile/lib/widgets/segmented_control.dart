import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentedControl extends StatefulWidget {
  final List<String> labels;
  final Function(int) onSegmentChosen;
  final int groupValue;
  final double borderRadius;
  final double? width;
  final double? height;
  const SegmentedControl({
    super.key,
    required this.labels,
    required this.onSegmentChosen,
    required this.groupValue,
    this.borderRadius = 10.0,
    this.width,
    this.height,
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
        child: Text(widget.labels[i]),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: CupertinoSegmentedControl<int>(
          children: children,
          onValueChanged: widget.onSegmentChosen,
          groupValue: widget.groupValue,
          padding: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }
}
