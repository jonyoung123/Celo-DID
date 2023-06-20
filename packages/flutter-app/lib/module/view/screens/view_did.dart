import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/models/celo_model.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_button.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_dropdown.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_textfield.dart';
import 'package:flutter_celo_composer/module/view_model/controllers/celo_controller.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewDIdPage extends ConsumerStatefulWidget {
  const ViewDIdPage({super.key});

  @override
  ConsumerState<ViewDIdPage> createState() => _ViewDIdPageState();
}

class _ViewDIdPageState extends ConsumerState<ViewDIdPage> {
  TextEditingController walletController = TextEditingController();
  TextEditingController identifierController = TextEditingController();
  String? text;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'View DID',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Enter your wallet address and your unique identifier to view the DID.',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      // DropDownCustom(
                      //   text: 'Celo DID format',
                      //   value: format,
                      //   subText:
                      //       'Select the format for generating your celo identity',
                      //   onChanged: (dynamic value) {
                      //     setState(() {
                      //       format = value;
                      //     });
                      //   },
                      //   hint: 'Select an identifier',
                      //   items: const <String>[
                      //     'address format',
                      //     'String format',
                      //   ],
                      // ),
                      // const SizedBox(height: 15),
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
                  text: ref.watch(celoProvider).viewStatus == Status.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'View CELO DID',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                  onPressed: () async {
                    if (walletController.text.trim().isEmpty ||
                        text != null &&
                            identifierController.text.trim().isEmpty ||
                        text == null) {
                      CustomSnackbar.responseSnackbar(context, Colors.redAccent,
                          'Fill the required fields..');
                      return;
                    }
                    CeloDIDModel data = CeloDIDModel(
                        address: walletController.text.trim(),
                        identifier: identifierController.text.trim());
                    await ref.read(celoProvider).fetchCeloDID(data, context);
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
