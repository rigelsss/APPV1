import 'package:flutter/material.dart';
import '../controller/alterar_email_controller.dart';
import '../widgets/alterar_email_widgets.dart';

class AlterarEmailForm extends StatefulWidget {
  const AlterarEmailForm({super.key});

  @override
  State<AlterarEmailForm> createState() => _AlterarEmailFormState();
}

class _AlterarEmailFormState extends State<AlterarEmailForm> {
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _novoEmailController = TextEditingController();
  final TextEditingController _confirmarEmailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          const Text('Senha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('senhaField'),
            controller: _senhaController,
            obscureText: _obscureText,
            decoration: inputDecoration().copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Informe a senha atual' : null,
          ),
          const SizedBox(height: 24),
          const Text('Novo e-mail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('novoEmailField'),
            controller: _novoEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration(),
            validator: (value) =>
                value == null || value.isEmpty ? 'Informe o novo e-mail' : null,
          ),
          const SizedBox(height: 24),
          const Text('Confirme o novo e-mail',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('confirmarEmailField'),
            controller: _confirmarEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration(),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Confirme o novo e-mail';
              if (value != _novoEmailController.text) return 'Os e-mails não coincidem';
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('submitButton'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AlterarEmailController.confirmarAlteracao(
                    context: context,
                    senhaAtual: _senhaController.text,
                    novoEmail: _novoEmailController.text,
                    confirmacaoEmail: _confirmarEmailController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B8C00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'Confirmar alteração de e-mail',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
