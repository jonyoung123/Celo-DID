import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/models/celo_model.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_button.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_dropdown.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_textfield.dart';
import 'package:flutter_celo_composer/module/view_model/controllers/celo_controller.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyDIdPage extends ConsumerStatefulWidget {
  const VerifyDIdPage({super.key});

  @override
  ConsumerState<VerifyDIdPage> createState() => _VerifyDIdPageState();
}

class _VerifyDIdPageState extends ConsumerState<VerifyDIdPage> {
  TextEditingController walletController = TextEditingController();
  TextEditingController identifierController = TextEditingController();
  TextEditingController celoController = TextEditingController();
  String? text;
  bool obscureText = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Verify DID',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
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
                        'Enter the identifier to verify your celo DID code.',
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
                      CustomTextField(
                        text: 'Celo DID',
                        controller: celoController,
                        hint: 'enter your Celo DID',
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
                          'Password',
                          'Secret Key',
                          'Others'
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: text != null
                            ? CustomTextField(
                                text: text ?? '',
                                obscureText: obscureText,
                                controller: identifierController,
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
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                CustomButtonWidget(
                  text: ref.watch(celoProvider).verifyStatus == Status.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Verify CELO DID',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                  onPressed: () async {
                    if (formKey.currentState!.validate() || text != null) {
                      CeloDIDModel data = CeloDIDModel(
                          address: walletController.text.trim(),
                          oldIdentifier: celoController.text.trim(),
                          identifier: identifierController.text.trim());
                      await ref.read(celoProvider).verifyCeloDID(data, context);
                    } else {
                      CustomSnackbar.responseSnackbar(context, Colors.redAccent,
                          'Fill all required fields...');
                    }
                  },
                )
              ],
            ),
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
