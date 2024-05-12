import 'package:flutter/material.dart';
import 'package:mobile/models/assignments/assignment_model.dart';
class AssignmentsModel with ChangeNotifier {
  Map<int, AssignmentModel> _assignments = {};

  AssignmentModel getAssignmentModel(int id) {
    if (!_assignments.containsKey(id)) {
      _assignments[id] = AssignmentModel();
    }
    return _assignments[id];
  }

}
