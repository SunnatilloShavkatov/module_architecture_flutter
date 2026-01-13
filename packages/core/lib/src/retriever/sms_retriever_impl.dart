import 'dart:io';

import 'package:core/src/constants/constants.dart';
import 'package:flutter_pinput/flutter_pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this._smartAuth);

  final SmartAuth _smartAuth;

  @override
  Future<void> dispose() async {
    if (!Platform.isAndroid) {
      return;
    }
    await _smartAuth.removeSmsRetrieverApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    if (!Platform.isAndroid) {
      return null;
    }
    final res = await _smartAuth.getSmsWithRetrieverApi(matcher: Constants.defaultSmsCodeMatcher);
    if (res.hasData && res.requireData.code != null) {
      return res.requireData.code;
    }
    return null;
  }
}
