import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/custom_verify_alert.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/models/celo_model.dart';
import 'package:flutter_celo_composer/module/models/contract_model.dart';
import 'package:flutter_celo_composer/module/models/product_model.dart';
import 'package:flutter_celo_composer/module/services/secure_storage.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class IntegrateCeloPage extends ConsumerStatefulWidget {
  const IntegrateCeloPage({super.key});

  @override
  ConsumerState<IntegrateCeloPage> createState() => _IntegrateCeloPageState();
}

class _IntegrateCeloPageState extends ConsumerState<IntegrateCeloPage> {
  TextEditingController controller = TextEditingController();
  // Sample list of products
  final List<Product> _products = <Product>[
    Product(
      name: 'Sneakers',
      price: 10,
      imageUrl:
          'https://www-konga-com-res.cloudinary.com/w_auto,f_auto,fl_lossy,dpr_auto,q_auto/media/catalog/product/I/E/203218_1662079565.jpg',
    ),
    Product(
      name: 'Sneaker',
      price: 12,
      imageUrl:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8c25lYWtlcnN8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
    ),
    Product(
      name: 'Italian Shoe',
      price: 8,
      imageUrl:
          'https://www-konga-com-res.cloudinary.com/w_auto,f_auto,fl_lossy,dpr_auto,q_auto/media/catalog/product/Y/W/198090_1662138982.jpg',
    ),
    Product(
      name: 'Nike Slide',
      price: 6,
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0055/5502/8083/products/IMG-5706646f5eecd68151b6d61e1df56ca9-V_1024x1024@2x.jpg?v=1618572604',
    ),
  ];

  final List<Contract> contractList = <Contract>[
    Contract(name: 'Decentralized Chat App', icon: Icons.chat_bubble),
    Contract(name: 'Fitness App', icon: Icons.fitness_center),
    Contract(name: 'Order App', icon: Icons.food_bank_outlined)
  ];

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  final String recipientAddress =
      '0xbA3172d4CC82b504aEe9d3c1B2235F777831a091'; // replace with the receiver address

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.04, right: size.width * 0.04, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Buy from us',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 1.5,
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: ((BuildContext context, int i) {
                    return Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            blurRadius: 2,
                            color: Colors.black12,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.network(_products[i].imageUrl),
                          Text(_products[i].name),
                          ElevatedButton(
                            child: Text('Pay ${_products[i].price} Celo'),
                            onPressed: () async {
                              String? userAddress =
                                  await UserSecureStorage().getUserAddress();
                              if (!mounted) return;
                              customAlertDialogs(
                                  context,
                                  'Confirm User',
                                  'Only authorized and verified user can proceed with any transaction on the platform.',
                                  'Enter the Celo DID for $userAddress',
                                  userAddress,
                                  controller);
                              // Replace 'celo-payment-url' with the actual Celo payment URL
                              // _launchURL(
                              //     'celo://wallet/pay?address=$recipientAddress&amount=${_products[i].price}&comment=${_products[i].name}');
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Interact with smart contracts',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contractList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 0.8,
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: ((BuildContext context, int i) {
                    return InkWell(
                      onTap: () async {
                        String? userAddress =
                            await UserSecureStorage().getUserAddress();
                        if (!mounted) return;
                        customAlertDialogs(
                            context,
                            'Confirm User',
                            'Only authorized and verified user can proceed with any smart contract on the platform.',
                            'Enter the Celo DID for $userAddress',
                            userAddress,
                            controller);
                      },
                      child: Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              blurRadius: 2,
                              color: Colors.black12,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(contractList[i].icon,
                                  size: 35, color: Colors.black54),
                              const SizedBox(height: 10),
                              Text(
                                contractList[i].name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54),
                              ),
                            ]),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30)
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
