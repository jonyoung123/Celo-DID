// import 'dart:convert';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

final Web3Client client =
    Web3Client('https://alfajores-forno.celo-testnet.org', Client());

// Replace these with your actual contract ABI
// String? contractKey = dotenv.get('CONTRACT_ADDRESS');

String? privateKey = dotenv.env['PRIVATE_KEY'];
final String? contractAddress = dotenv.env['CONTRACT_ADDRESS'];

// replace with your actual contract address
// final String contractABI = json.encode(abi);

class CeloWeb3Helper {
  // final DeployedContract contract = DeployedContract(
  //   ContractAbi.fromJson(contractABI, 'CeloDIDRegistry'),
  //   contractAddress,
  // );

  /// Get deployed greeter contract
  Future<DeployedContract> get deployedCeloContract async {
    const String abiDirectory = 'lib/module/services/did.abi.json';
    String contractABI = await rootBundle.loadString(abiDirectory);

    final DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(contractABI, 'CeloDIDRegistry'),
      EthereumAddress.fromHex(contractAddress!),
    );

    return contract;
  }

  final EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey ?? '');

  Future<dynamic> createDID(String did) async {
    final DeployedContract contract = await deployedCeloContract;
    final ContractFunction createDIDFunction = contract.function('setDID');
    final response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: createDIDFunction,
        parameters: <dynamic>[did],
      ),
      chainId: 44787,
    );

    final dynamic receipt = await awaitResponse(response);
    return receipt;
  }

  Future<dynamic> registerDID(
      String address, String did, String identifier) async {
    final DeployedContract contract = await deployedCeloContract;
    final EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    final ContractFunction registerDIDFunction =
        contract.function('registerDID');
    final response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: registerDIDFunction,
        parameters: <dynamic>[ethAddress, did, identifier],
      ),
      chainId: 44787,
    );
    final dynamic receipt = await awaitResponse(response);
    return receipt;
  }

  Future<dynamic> fetchDID(String address, String identifier) async {
    final DeployedContract contract = await deployedCeloContract;
    final EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    final fetchDIDFunction = contract.function('getDIDByAddress');
    final response = await client.call(
      contract: contract,
      function: fetchDIDFunction,
      params: <dynamic>[ethAddress, identifier],
    );
    Uint8List bytes = Uint8List.fromList(response[0].toList());
    String byte32 = '0x${hex.encode(bytes)}';

    return byte32;
  }

  Future<dynamic> authenticateUser(String address, String celoDid) async {
    final DeployedContract contract = await deployedCeloContract;
    final EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    List<int> bytes = hex.decode(celoDid.replaceAll('0x', ''));
    Uint8List did = Uint8List.fromList(bytes);
    final authenticateUser = contract.function('authenticateUser');
    final response = await client.call(
      contract: contract,
      function: authenticateUser,
      params: <dynamic>[ethAddress, did],
    );
    print("response ====>> $response");
    return response[0];
  }

  Future<dynamic> changeDID(String address, String oldDid, String newDid,
      String identifier, String newIdentifier) async {
    final DeployedContract contract = await deployedCeloContract;
    final EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    // print(oldDid);
    List<int> bytes = hex.decode(oldDid.replaceAll('0x', ''));
    Uint8List did = Uint8List.fromList(bytes);
    // print(did);
    final ContractFunction changeDIDFunction = contract.function('changeDID');
    final String response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: changeDIDFunction,
        parameters: <dynamic>[
          ethAddress,
          did,
          newDid,
          identifier,
          newIdentifier
        ],
      ),
      chainId: 44787,
    );

    final dynamic receipt = await awaitResponse(response);
    return receipt;
  }

  Future<dynamic> verifyDID(
      String address, String didVal, String identifier) async {
    final DeployedContract contract = await deployedCeloContract;
    final EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    List<int> bytes = hex.decode(didVal.replaceAll('0x', ''));
    Uint8List did = Uint8List.fromList(bytes);
    // print(did);
    final ContractFunction verifyDIDFunction = contract.function('verifyDID');
    final response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: verifyDIDFunction,
        parameters: <dynamic>[ethAddress, did, identifier],
      ),
      chainId: 44787,
    );
    final dynamic receipt = await awaitResponse(response);
    // print("receipt ===>> $receipt");
    return receipt;
  }
}

Future<dynamic> awaitResponse(dynamic response) async {
  int count = 0;
  while (true) {
    final TransactionReceipt? receipt =
        await client.getTransactionReceipt(response);
    if (receipt != null) {
      print('receipt ===>> $receipt');
      return receipt.logs[0].data;
    }
    // Wait for a while before polling again
    await Future<dynamic>.delayed(const Duration(seconds: 1));

    if (count == 6) {
      return null;
    } else {
      count++;
    }
  }
}
