import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  toastMessage({required String message}){
    Fluttertoast.showToast(msg: message);
  }
}


