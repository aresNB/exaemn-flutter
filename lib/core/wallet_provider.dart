import 'package:flutter/material.dart';
import 'package:badwallet_mobile/core/api_service.dart';
import 'package:badwallet_mobile/models/wallet.dart';
import 'package:badwallet_mobile/models/transaction.dart';

enum WalletStatus { initial, loading, loaded, error }

class WalletProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  String? phoneNumber;
  Wallet? wallet;
  double balance = 0;
  List<TransactionModel> transactions = [];

  WalletStatus status = WalletStatus.initial;
  String? errorMessage;

  void setPhone(String phone) {
    phoneNumber = phone;
    loadWallet();
  }

  Future<void> loadWallet() async {
    if (phoneNumber == null) return;
    status = WalletStatus.loading;
    notifyListeners();

    try {
      wallet = await _api.getWalletByPhone(phoneNumber!);
      balance = wallet!.balance;
      transactions = await _api.getTransactions(phoneNumber!);
      status = WalletStatus.loaded;
    } catch (e) {
      errorMessage = e.toString();
      status = WalletStatus.error;
    }
    notifyListeners();
  }

  Future<void> refreshBalance() async {
    if (phoneNumber == null) return;
    try {
      balance = await _api.getBalance(phoneNumber!);
      notifyListeners();
    } catch (_) {}
  }

  void disconnect() {
    phoneNumber = null;
    wallet = null;
    balance = 0;
    transactions = [];
    status = WalletStatus.initial;
    notifyListeners();
  }
}