import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/alert_dialog.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/services/celo_web3.dart';
import 'package:flutter_celo_composer/module/services/create_did.dart';
import 'package:flutter_celo_composer/module/models/celo_model.dart';
import 'package:flutter_celo_composer/module/services/secure_storage.dart';
import 'package:flutter_celo_composer/module/view/screens/home_page.dart';

enum Status { init, loading, done }

class CeloDIDProvider extends ChangeNotifier {
  UserSecureStorage storage = UserSecureStorage();
  CeloWeb3Helper helper = CeloWeb3Helper();
  Status createStatus = Status.init;
  Status verifyStatus = Status.init;
  Status changeStatus = Status.init;
  Status authStatus = Status.init;
  Status viewStatus = Status.init;

  Future<dynamic> createCeloDID(CeloDIDModel data, dynamic context) async {
    try {
      String did = addCeloPrefix(data.identifier ?? '');
      createStatus =
          createStatus != Status.loading ? Status.loading : Status.done;
      notifyListeners();
      if (createStatus == Status.done) return;
      String? response =
          await helper.registerDID(data.address!, did, data.identifier!);
      if (response != null) {
        print('RESPONSE =====>>>>> $response');
        createStatus = Status.done;
        notifyListeners();
        await storage.setCreatedBoolean();
        await storage.setIdentifier(data.identifier.toString());
        await storage.setUserAddress(data.address!);
        alertDialogs(
            context,
            'Celo DID Created',
            'Celo DID successfuly registered. You can now authenticate with your identifier by using the address $response',
            () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (dynamic context) => const HomePage()),
                (route) => false));
      } else {
        createStatus = Status.done;
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'unable to register did');
      }
      notifyListeners();
    } catch (e) {
      createStatus = Status.done;
      notifyListeners();
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
      debugPrint(e.toString());
    }
  }

  Future<dynamic> verifyCeloDID(CeloDIDModel data, dynamic context) async {
    try {
      verifyStatus =
          verifyStatus != Status.loading ? Status.loading : Status.done;
      notifyListeners();
      if (verifyStatus == Status.done) return;
      String? response = await helper.verifyDID(
          data.address!, data.oldIdentifier!, data.identifier!);
      verifyStatus = Status.done;
      notifyListeners();
      if (response != null) {
        await storage.setUserAddress(data.address!);
        alertDialogs(context, 'Celo DID Verification',
            'Celo DID has successfully been verified. You can now make transactions using the DID.',
            () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'Unable to verify DID');
      }
    } catch (e) {
      verifyStatus = Status.done;
      notifyListeners();
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
      debugPrint(e.toString());
    }
  }

  Future<dynamic> changeCeloDID(CeloDIDModel data, dynamic context) async {
    try {
      String did = addCeloPrefix(data.identifier ?? '');
      changeStatus =
          changeStatus != Status.loading ? Status.loading : Status.done;
      notifyListeners();
      if (changeStatus == Status.done) return;
      String? response = await helper.changeDID(data.address!, data.celoDid!,
          did, data.oldIdentifier!, data.identifier!);
      if (response != null) {
        await storage.setUserAddress(data.address!);
        print('RESPONSE =====>>>>> $response');
        changeStatus = Status.done;
        notifyListeners();
        await storage.setCreatedBoolean();
        await storage.setIdentifier(data.identifier.toString());
        alertDialogs(context, 'Celo DID Changed',
            'Celo DID successfuly changed. You can now authenticate with your new Celo DID: $response',
            () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        changeStatus = Status.done;
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'unable to change did');
      }
      notifyListeners();
    } catch (e) {
      changeStatus = Status.done;
      notifyListeners();
      CustomSnackbar.responseSnackbar(
          context, Colors.redAccent, 'unable to change did');
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchCeloDID(CeloDIDModel data, dynamic context) async {
    try {
      // String did = addCeloPrefix(data.identifier ?? '');
      viewStatus = viewStatus != Status.loading ? Status.loading : Status.done;
      if (viewStatus == Status.done) return;
      notifyListeners();
      String? response = await helper.fetchDID(data.address!, data.identifier!);
      if (response != null) {
        await storage.setUserAddress(data.address!);
        viewStatus = Status.done;
        notifyListeners();
        await storage.setCeloDID(response);
        alertDialogs(context, 'Celo DID', 'Celo DID : $response', () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        viewStatus = Status.done;
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'unable to fetch did');
      }
      notifyListeners();
    } catch (e) {
      viewStatus = Status.done;
      notifyListeners();
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
    }
  }

  Future<dynamic> authenticateUser(CeloDIDModel data, dynamic context) async {
    try {
      // String did = addCeloPrefix(data.identifier ?? '');
      authStatus = authStatus != Status.loading ? Status.loading : Status.done;
      if (authStatus == Status.done) return;
      notifyListeners();
      dynamic response =
          await helper.authenticateUser(data.address!, data.celoDid!);
      if (response.toString() == 'true') {
        authStatus = Status.done;
        notifyListeners();
        Navigator.pop(context);
        alertDialogs(context, 'SUCESSFUL',
            'You are successfully authenticated to perform this operation', () {
          Navigator.pop(context);
        });
      } else {
        authStatus = Status.done;
        Navigator.pop(context);
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'unable to authenticate celo DID');
      }
      notifyListeners();
    } catch (e) {
      authStatus = Status.done;
      notifyListeners();
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
    }
  }
}
