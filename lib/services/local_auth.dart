import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final LocalAuthentication _bioauth = LocalAuthentication();

  static Future<bool> authenticate() async {
    final isAvailable = await _bioauth.isDeviceSupported();
    final isBioAvailable = await _bioauth.canCheckBiometrics;

    bool isAuthenticated = false;
    if (!isAvailable) return false;
    try {
      if (isBioAvailable && isAvailable) {
        List<BiometricType> biometricTypes =
            await _bioauth.getAvailableBiometrics();
        print(biometricTypes);

        isAuthenticated = await _bioauth.authenticate(
          localizedReason: 'Scan to Authenticate',
          options: const AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true),
        );
      }

      return isAuthenticated;
    } on PlatformException catch (e) {
      e.toString();
      return false;
    }
  }

  Future<void> cantCheckBiometricsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Biometrics Found'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Can not login with Biometrics'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
