import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';
import '../theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<ATMProvider>(context).history;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('📑 Transaction History'),
        backgroundColor: AppColors.primary,
      ),
      body:
          history.isEmpty
              ? const Center(
                child: Text(
                  "No transactions yet. 💼",
                  style: TextStyle(fontSize: 18, color: AppColors.textDark),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final tx = history[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        tx.type == "Deposit"
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: tx.type == "Deposit" ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        "${tx.type} - ₹ ${tx.amount.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${tx.date}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
