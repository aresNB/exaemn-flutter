class Facture {
  final String reference;
  final String serviceName;
  final double montant;
  final bool payee;
  final String? dateFacture;

  Facture({
    required this.reference,
    required this.serviceName,
    required this.montant,
    required this.payee,
    this.dateFacture,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      reference: json['reference'],
      serviceName: json['serviceName'],
      montant: (json['montant'] as num).toDouble(),
      payee: json['payee'] ?? false,
      dateFacture: json['dateFacture'],
    );
  }
}