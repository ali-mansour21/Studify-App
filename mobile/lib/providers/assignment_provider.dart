import 'package:flutter/material.dart';
class AssignmentsModel with ChangeNotifier {
  Map<int, AssignmentsModel> _assignments = {};

  // Getter to retrieve an assignment model
  AssignmentsModel getAssignmentModel(int id) {
    if (!_assignments.containsKey(id)) {
      _assignments[id] = AssignmentModel();
    }
    return _assignments[id];
  }

}
