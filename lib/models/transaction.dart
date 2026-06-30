class TransactionModel {
  final int id;
  final String type; // DEPOT, RETRAIT, TRANSFERT, PAIEMENT
  final double montant;
  final double frais;
  final String description;
  final String date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.montant,
    required this.frais,
    required this.description,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: json['type'],
      montant: (json['montant'] as num).toDouble(),
      frais: (json['frais'] as num).toDouble(),
      description: json['description'],
      date: json['date'],
    );
  }
}
