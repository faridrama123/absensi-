import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/erp.glomed.service.dart';
import 'package:flutter_application_1/models/cabang/return.dart';
import 'package:flutter_application_1/provider/result_state.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProviderCabang extends ChangeNotifier {
  final DevService devService;

  ProviderCabang({required this.devService}) {}

  late ReturnCabang _returnCabang;
  late ResultState _state;
  String _message = '';
  String get message => _message;
  ReturnCabang get returnCabang => _returnCabang;
  ResultState get state => _state;

  late int _cabangClick;
  int get cabangClick => _cabangClick;

  void setCabangClick(int value) {
    _cabangClick = value;
  }

  late ReturnCabang _returnCabangFilter;
  ReturnCabang get returnCabangFilter => _returnCabangFilter;

  void setFilterCabang(String value) {
    _returnCabangFilter = _returnCabang;

    if (value == "reset") {
      print("reset");
      _returnCabangFilter.listcabang = _returnCabang.listcabang;
      notifyListeners();
    } else {
      _returnCabangFilter.listcabang =
          _returnCabangFilter.listcabang!.map((user) {
        String? namacabangxx = user?.namaCabang ?? "";

        String namalowercase = namacabangxx.toLowerCase();
        print(namalowercase);

        if (namalowercase.contains(value)) return user;
        notifyListeners();

        return null;
      }).toList();
    }
  }

  Future<dynamic> get fetchHistory => _fetchHistory();

  Future<dynamic> _fetchHistory() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();

      SharedPreferences pref = await SharedPreferences.getInstance();
      var _accesToken = pref.getString("PREF_TOKEN")!;

      final result = await devService.allcabang(_accesToken);

      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _returnCabang = result;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'connection error ..';
    }
  }
}
