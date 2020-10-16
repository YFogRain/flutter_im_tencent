import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tencent_im_example/utils/AppColors.dart';

// ignore: must_be_immutable
class LoadingDialog extends StatefulWidget {
  String loadingText;
  bool outsideDismiss;
  Function dismissDialog;

  LoadingDialog(
      {Key key,
      this.loadingText = "loading...",
      this.outsideDismiss = true,
      this.dismissDialog})
      : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialog();
}

class _LoadingDialog extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitFadingCircle(
      color: AppColors.splashColor,
    ));
  }

  _dismissDialog() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.dismissDialog != null) {
      widget.dismissDialog(
          //将关闭 dialog的方法传递到调用的页面.
          () {
        Navigator.of(context).pop();
      });
    }
  }
}
