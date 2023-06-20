import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/models/celo_model.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_button.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_dropdown.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_textfield.dart';
import 'package:flutter_celo_composer/module/view_model/controllers/celo_controller.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeDIdPage extends StatefulWidget {
  const ChangeDIdPage({super.key});

  @override
  State<ChangeDIdPage> createState() => _ChangeDIdPageState();
}

class _ChangeDIdPageState extends State<ChangeDIdPage> {
  TextEditingController walletController = TextEditingController();
  TextEditingController oldIdentifierController = TextEditingController();
  TextEditingController identifierController = TextEditingController();
  TextEditingController oldCeloDIDController = TextEditingController();
  String? text;
  String? oldText;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Change DID',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer(builder: (_, WidgetRef ref, __) {
        final read = ref.read(celoProvider);
        final watch = ref.watch(celoProvider);
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.04, right: size.width * 0.04, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset('assets/images/logo.png',
                          height: 60, width: 90),
                      const SizedBox(width: 10),
                      const Text(
                        'DECENTRALIZED ID',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black54),
                      )
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Enter your details to generate a new unique celo DID which serves as a means of authentication on this app.',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 30),
                        CustomTextField(
                          text: 'Wallet Address',
                          controller: walletController,
                          hint: 'enter your wallet address',
                          validator: (value) => value != null && value.isEmpty
                              ? 'Field must be filled'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          text: 'Old Celo DID',
                          controller: oldCeloDIDController,
                          hint: 'enter your old celo DID',
                        ),
                        const SizedBox(height: 15),
                        DropDownCustom(
                          text: 'Old Unique Identifier',
                          subText: 'Select and enter the old unique identifier',
                          value: oldText,
                          onChanged: (dynamic value) {
                            setState(() {
                              oldText = value;
                            });
                          },
                          hint: 'Select an identifier',
                          items: const <String>[
                            'Full Name',
                            'Password',
                            'Secret Key',
                            'Others'
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: oldText != null
                              ? CustomTextField(
                                  text: oldText ?? '',
                                  controller: oldIdentifierController,
                                  hint: oldText != 'Others'
                                      ? 'enter your ${oldText!.toLowerCase()}'
                                      : 'enter your old identifier',
                                )
                              : null,
                        ),
                        const SizedBox(height: 15),
                        DropDownCustom(
                          text: 'New Unique Identifier',
                          value: text,
                          onChanged: (dynamic value) {
                            setState(() {
                              text = value;
                            });
                          },
                          hint: 'Select an identifier',
                          items: const <String>[
                            'Full Name',
                            'Password',
                            'Secret Key',
                            'Others'
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: text != null
                              ? CustomTextField(
                                  text: text ?? '',
                                  controller: identifierController,
                                  hint: text != 'Others'
                                      ? 'enter your ${text!.toLowerCase()}'
                                      : 'enter your unique identifier',
                                )
                              : null,
                        ),
                        const SizedBox(height: 30),
                        CustomButtonWidget(
                          text: watch.changeStatus == Status.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Change CELO DID',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                          onPressed: () async {
                            if (formKey.currentState!.validate() ||
                                text != null ||
                                oldText != null) {
                              CeloDIDModel data = CeloDIDModel(
                                  address: walletController.text.trim(),
                                  oldIdentifier:
                                      oldIdentifierController.text.trim(),
                                  identifier: identifierController.text.trim(),
                                  celoDid: oldCeloDIDController.text.trim());
                              await read.changeCeloDID(data, context);
                            } else {
                              CustomSnackbar.responseSnackbar(
                                  context,
                                  Colors.redAccent,
                                  'Fill  all required fields..');
                              return;
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    walletController.dispose();
    identifierController.dispose();
    oldIdentifierController.dispose();
    super.dispose();
  }
}
