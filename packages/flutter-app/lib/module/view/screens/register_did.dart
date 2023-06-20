import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/models/celo_model.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_button.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_dropdown.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_textfield.dart';
import 'package:flutter_celo_composer/module/view_model/controllers/celo_controller.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterDIdPage extends ConsumerStatefulWidget {
  const RegisterDIdPage({super.key});

  @override
  ConsumerState<RegisterDIdPage> createState() => _RegisterDIdPageState();
}

class _RegisterDIdPageState extends ConsumerState<RegisterDIdPage> {
  TextEditingController walletController = TextEditingController();
  TextEditingController identifierController = TextEditingController();
  String? text;
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  Image.asset('assets/images/logo.png', height: 60, width: 90),
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
                      'Enter your details to generate your unique celo DID which serves as a means of authentication on this app.',
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
                    ),
                    const SizedBox(height: 15),
                    DropDownCustom(
                      text: 'Unique Identifier',
                      value: text,
                      onChanged: (dynamic value) {
                        setState(() {
                          text = value;
                        });
                      },
                      hint: 'Select an identifier',
                      items: const <String>[
                        'Full Name',
                        'Wallet Address',
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
                              obscureText: obscureText,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    !obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.black26,
                                  )),
                              hint: text != 'Others'
                                  ? 'enter your ${text!.toLowerCase()}'
                                  : 'enter your unique identifier',
                            )
                          : null,
                    ),
                    const SizedBox(height: 50),
                    CustomButtonWidget(
                      text: watch.createStatus == Status.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Register CELO DID',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                      onPressed: () async {
                        if (walletController.text.trim().isEmpty ||
                            text == null) {
                          CustomSnackbar.responseSnackbar(context,
                              Colors.redAccent, 'Fill the required fields..');
                          return;
                        }
                        CeloDIDModel data = CeloDIDModel(
                            address: walletController.text.trim(),
                            identifier: identifierController.text.trim());
                        await read.createCeloDID(data, context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    walletController.dispose();
    identifierController.dispose();
    super.dispose();
  }
}
