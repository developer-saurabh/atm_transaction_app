import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';
import '../widgets/custom_button.dart';
import '../theme/app_colors.dart';
import 'otp_screen.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();

  void _withdraw() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => OtpScreen(
                onVerified: () {
                  final atm = Provider.of<ATMProvider>(context, listen: false);
                  try {
                    atm.withdraw(amount);
                    Navigator.pop(context); // pop OTP
                    Navigator.pop(context); // pop Withdraw
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Withdrawal Successful!')),
                    );
                  } catch (e) {
                    Navigator.pop(context); // pop OTP
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '❌ ${e.toString().replaceFirst("Exception: ", "")}',
                        ),
                      ),
                    );
                  }
                },
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('💸 Withdraw Money'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Enter amount to withdraw:",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.money_off_csred_outlined),
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(text: "Proceed to OTP", onPressed: _withdraw),
          ],
        ),
      ),
    );
  }
}
