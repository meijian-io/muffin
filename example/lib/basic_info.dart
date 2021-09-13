import 'package:muffin/sharing/data_model_change_listener.dart';

class BasicInfo extends DataModelChangeListener {
  static BasicInfo instance = BasicInfo('_userId', false);

  String? _userId;
  bool? _isBindTbk;

  BasicInfo(this._userId, this._isBindTbk);

  String get userId => _userId!;

  set userId(String? value) {
    if (_userId == value) {
      return;
    }
    _userId = value;
    notifyListeners();
  }

  bool get isBindTbk => _isBindTbk!;

  set isBindTbk(bool value) {
    if (_isBindTbk == value) {
      return;
    }
    _isBindTbk = value;
    notifyListeners();
  }

  @override
  Map<String, Object> toMap() {
    return {'userId': _userId!, 'isBindTbk': _isBindTbk!};
  }

  @override
  void formJson(Map<String, dynamic> map) {
    this._userId = map['userId'] as String;
    this._isBindTbk = map['isBindTbk'] as bool;
    notifyListeners();
  }

  @override
  String key() {
    return 'BasicInfo';
  }
}
