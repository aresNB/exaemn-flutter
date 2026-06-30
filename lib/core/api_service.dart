import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:badwallet_mobile/core/api_config.dart';
import 'package:badwallet_mobile/models/wallet.dart';
import 'package:badwallet_mobile/models/transaction.dart';
import 'package:badwallet_mobile/models/facture.dart';

class ApiService {
  final String base = ApiConfig.baseUrl;

  // GET solde
  Future<double> getBalance(String phone) async {
    final res = await http.get(Uri.parse('$base/api/wallets/$phone/balance'));
    if (res.statusCode != 200)
      throw Exception('Erreur lors de la récupération du solde');
    return double.parse(res.body);
  }

  // GET wallet par téléphone
  Future<Wallet> getWalletByPhone(String phone) async {
    final res = await http.get(Uri.parse('$base/api/wallets/$phone'));
    if (res.statusCode != 200) throw Exception('Portefeuille introuvable');
    return Wallet.fromJson(jsonDecode(res.body));
  }

  // GET historique des transactions
  Future<List<TransactionModel>> getTransactions(String phone) async {
    final res = await http.get(
      Uri.parse('$base/api/wallets/$phone/transactions'),
    );
    if (res.statusCode != 200)
      throw Exception('Erreur lors du chargement des transactions');
    final List data = jsonDecode(res.body);
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  // POST transfert
  Future<void> transfer(
    String senderPhone,
    String receiverPhone,
    double amount,
  ) async {
    final res = await http.post(
      Uri.parse('$base/api/wallets/transfer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderPhone': senderPhone,
        'receiverPhone': receiverPhone,
        'amount': amount,
      }),
    );
    if (res.statusCode != 200) throw Exception('Échec du transfert');
  }

  // GET factures impayées du mois
  Future<List<Facture>> getCurrentFactures(
    String walletCode, {
    String? unite,
  }) async {
    String url = '$base/api/external/factures/$walletCode/current';
    if (unite != null) url += '?unite=$unite';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200)
      throw Exception('Erreur lors du chargement des factures');
    final List data = jsonDecode(res.body);
    return data.map((e) => Facture.fromJson(e)).toList();
  }

  // POST paiement de factures sélectionnées
  Future<void> payFactures(
    String phone,
    String serviceName,
    List<String> references,
  ) async {
    final res = await http.post(
      Uri.parse('$base/api/wallets/pay-factures'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phoneNumber': phone,
        'serviceName': serviceName,
        'factureReferences': references,
      }),
    );
    if (res.statusCode != 200)
      throw Exception('Échec du paiement des factures');
  }
}
