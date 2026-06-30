class Wallet {
  final int id;
  final String phoneNumber;
  final String email;
  final String code;
  final String currency;
  final double balance;

  Wallet({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.code,
    required this.currency,
    required this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      code: json['code'],
      currency: json['currency'],
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
