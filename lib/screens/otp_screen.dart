import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../theme/app_colors.dart';

class OtpScreen extends StatefulWidget {
  final VoidCallback onVerified;

  const OtpScreen({super.key, required this.onVerified});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final String _correctOtp = "1111";

  void _verify() {
    if (_otpController.text == _correctOtp) {
      widget.onVerified();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Invalid OTP')));
    }
  }

  @override
  void initState() {
    super.initState();
    // Autofocus when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  final _focusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('🔑 Enter OTP'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "A 4-digit OTP has been sent to your registered mobile number.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              maxLength: 4,
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_open_outlined),
                labelText: 'Enter OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                counterText: '', // Hide character counter
              ),
              onSubmitted: (_) => _verify(),
            ),
            const SizedBox(height: 30),
            CustomButton(text: "Verify", onPressed: _verify),
          ],
        ),
      ),
    );
  }
}
