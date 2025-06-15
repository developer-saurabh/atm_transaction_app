import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';
import '../widgets/custom_button.dart';
import '../theme/app_colors.dart';
import 'dashboard_screen.dart';

class AccountOpeningScreen extends StatefulWidget {
  const AccountOpeningScreen({super.key});

  @override
  State<AccountOpeningScreen> createState() => _AccountOpeningScreenState();
}

class _AccountOpeningScreenState extends State<AccountOpeningScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _accNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Provider.of<ATMProvider>(context, listen: false).setAccountInfo(
        name: _nameController.text.trim(),
        accNumber: _accNumberController.text.trim(),
        ifsc: _ifscController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text("🏦 Open Account"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField("Full Name", _nameController),
              const SizedBox(height: 16),
              _buildField(
                "Account Number",
                _accNumberController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildField("IFSC Code", _ifscController),
              const SizedBox(height: 16),
              _buildField(
                "Mobile Number",
                _mobileController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildField(
                "Email",
                _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              CustomButton(text: "Create Account", onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator:
          (value) => value == null || value.trim().isEmpty ? "Required" : null,
    );
  }
}
