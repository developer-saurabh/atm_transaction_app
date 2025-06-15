import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';
import '../widgets/custom_button.dart';
import '../theme/app_colors.dart';
import 'withdraw_screen.dart';
import 'deposit_screen.dart';
import 'history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final atmProvider = Provider.of<ATMProvider>(context);
    final limitUsedFraction = atmProvider.todayTotal / ATMProvider.dailyLimit;

    // If limit warning just got triggered:
    if (atmProvider.limitWarningShown && limitUsedFraction >= 0.9) {
      Future.microtask(() => _showLimitWarning());
    }
  }

  void _showLimitWarning() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("⚠️ Daily Limit Alert"),
            content: const Text(
              "You have used over 90% of your daily ₹40,000 limit. "
              "Further transactions may be blocked soon. Please plan accordingly.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK, Got it"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final atmProvider = Provider.of<ATMProvider>(context);
    final remainingLimit = ATMProvider.dailyLimit - atmProvider.todayTotal;
    final limitUsedFraction = atmProvider.todayTotal / ATMProvider.dailyLimit;

    Color progressColor;
    if (limitUsedFraction < 0.5) {
      progressColor = Colors.green;
    } else if (limitUsedFraction < 0.85) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('💳 ATM Dashboard'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 32,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Current Balance",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "₹ ${atmProvider.balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "🧾 Remaining Daily Limit: ₹ ${remainingLimit.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          remainingLimit < 5000
                              ? Colors.redAccent
                              : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: limitUsedFraction.clamp(0.0, 1.0),
                      minHeight: 12,
                      valueColor: AlwaysStoppedAnimation(progressColor),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${(limitUsedFraction * 100).toStringAsFixed(1)}% of ₹40,000 used today",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // Buttons
            CustomButton(
              text: "Withdraw Money 💸",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WithdrawScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Deposit Money 💰",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DepositScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Transaction History 📑",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
