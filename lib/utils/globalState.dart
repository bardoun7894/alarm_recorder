class GlobalState{
  GlobalState._();
  final Map<dynamic,dynamic> _data =
  <dynamic,dynamic>{};
  static GlobalState instance =
  new GlobalState._();
set(dynamic key,dynamic value)=>
    _data[key]=value;
get(dynamic key)=>_data[key];

}