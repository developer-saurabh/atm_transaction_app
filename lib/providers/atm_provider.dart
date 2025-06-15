import 'package:flutter/material.dart';
import '../models/transaction.dart';

class ATMProvider extends ChangeNotifier {
  double _balance = 5000.0;
  final List<Transaction> _history = [];

  double get balance => _balance;
  List<Transaction> get history => _history;

  static const double dailyLimit = 40000.0;

  bool _limitWarningShownToday = false;

  double get todayTotal {
    final today = DateTime.now();
    return _history
        .where(
          (tx) =>
              tx.date.year == today.year &&
              tx.date.month == today.month &&
              tx.date.day == today.day,
        )
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  bool canTransact(double amount) {
    return (todayTotal + amount) <= dailyLimit;
  }

  void deposit(double amount) {
    if (canTransact(amount)) {
      _balance += amount;
      _history.add(
        Transaction(type: 'Deposit', amount: amount, date: DateTime.now()),
      );
      _checkLimitWarning();
      notifyListeners();
    } else {
      throw Exception("Daily limit exceeded");
    }
  }

  void withdraw(double amount) {
    if (amount <= _balance) {
      if (canTransact(amount)) {
        _balance -= amount;
        _history.add(
          Transaction(type: 'Withdraw', amount: amount, date: DateTime.now()),
        );
        _checkLimitWarning();
        notifyListeners();
      } else {
        throw Exception("Daily limit exceeded");
      }
    } else {
      throw Exception("Insufficient balance");
    }
  }

  void _checkLimitWarning() {
    if (!_limitWarningShownToday && todayTotal >= dailyLimit * 0.9) {
      _limitWarningShownToday = true;
      notifyListeners(); // so listeners can catch this event
    }
  }

  bool get limitWarningShown => _limitWarningShownToday;

  void resetDailyWarning() {
    _limitWarningShownToday = false;
  }
}
