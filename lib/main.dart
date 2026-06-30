import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badwallet_mobile/core/wallet_provider.dart';
import 'package:badwallet_mobile/features/auth/splash_screen.dart';

void main() {
  runApp(const BadWalletApp());
}

class BadWalletApp extends StatelessWidget {
  const BadWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletProvider(),
      child: MaterialApp(
        title: 'BadWallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
        home: const SplashScreen(),
      ),
    );
  }
}
