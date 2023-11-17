import 'package:flutter/cupertino.dart';

import 'globle_context.dart';

Future<dynamic> navigateToPage(Widget routePage, {Widget? currentWidget}) {
  try {
    FocusManager.instance.primaryFocus!.unfocus();
  } catch (e, s) {
    //  FirebaseCrashlytics.instance.recordError(e, s);
  }
  return Navigator.push(
    GlobalVariable.appContext,
    CupertinoPageRoute(builder: (context) => routePage),
  );
}
