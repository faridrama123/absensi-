import 'package:absensi/api/erp.glomed.service.dart';
import 'package:absensi/models/login/return.dart';
import 'package:absensi/provider/result_state.dart';
import 'package:flutter/material.dart';

class ProviderLogin extends ChangeNotifier {
  final DevService devService;

  ProviderLogin({required this.devService}) {}

  late ReturnLogin _returnLogin;
  late ResultState _state;
  String _message = '';
  String get message => _message;
  ReturnLogin get returnLogin => _returnLogin;
  ResultState get state => _state;

  String _username = '';
  String _password = '';

  void setLogin(String username, String password) {
    _username = username;
    _password = password;
  }

  Future<dynamic> get fetchLogin => _fetchLogin();

  Future<dynamic> _fetchLogin() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await devService.login(_username, _password);
      if (result == null) {
        print("no data");
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        print(" data ready");

        _state = ResultState.HasData;
        notifyListeners();
        return _returnLogin = result;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
