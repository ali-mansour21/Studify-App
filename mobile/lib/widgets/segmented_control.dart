import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentedControl extends StatefulWidget {
  final List<String> labels;
  final Function(int) onSegmentChosen;
  final int groupValue;
  const SegmentedControl(
      {super.key,
      required this.labels,
      required this.groupValue,
      required this.onSegmentChosen});

  @override
  State<SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  @override
  Widget build(BuildContext context) {
    Map<int, Widget> children = {};
    for (int i = 0; i < widget.labels.length; i++) {
      children[i] = Text(widget.labels[i]);
    }

    return CupertinoSegmentedControl<int>(
      children: children,
      onValueChanged: widget.onSegmentChosen,
      groupValue: widget.groupValue,
    );
  }
}
