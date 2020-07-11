import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';

class CalendarProvider with ChangeNotifier {
  final _repository = Repository();

  CalendarProvider() {
    getAvailableSchedules();
  }

  Future<Null> getAvailableSchedules() async {
    final response = await _repository.getAvailableDates();
    return response;
  }
}
