import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/models/celo_model.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_textfield.dart';
import 'package:flutter_celo_composer/module/view_model/controllers/celo_controller.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void customAlertDialogs(
    BuildContext contexxt,
    String titleText,
    String contentText,
    String contentText2,
    String? userAddress,
    TextEditingController controller) async {
  return showDialog<void>(
    context: contexxt,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Consumer(
        builder: (_, ref, __) => AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            title: Center(
              child: Text(
                titleText,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  contentText,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
                const SizedBox(height: 10),
                SelectableText(
                  contentText2,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  text: 'Celo DID',
                  controller: controller,
                  hint: 'enter your celo DID',
                  validator: (dynamic value) => value != null && value.isEmpty
                      ? 'DID must be filled'
                      : null,
                ),
              ],
            ),
            actions: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (controller.text.trim().isEmpty) {
                        CustomSnackbar.responseSnackbar(contexxt,
                            Colors.redAccent, 'Fill the required fields');
                      } else {
                        CeloDIDModel data = CeloDIDModel(
                            address: userAddress,
                            celoDid: controller.text.trim());
                        await ref
                            .read(celoProvider)
                            .authenticateUser(data, contexxt);
                      }
                    },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.blueGrey),
                    child: ref.watch(celoProvider).authStatus == Status.loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
              ),
            ]),
      );
    },
  );
}
