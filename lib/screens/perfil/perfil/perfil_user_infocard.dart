/// PERFIL_USER_INFOCARD
///
/// Responsável por: Card de informações do usuário com avatar, nome e dados pessoais
/// (e-mail, telefone, CPF) formatados e organizados visualmente.
/// Utilizado em: Tela de perfil para exibir informações principais do usuário.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_info_label.dart';
import 'package:sudema_app/screens/perfil/perfil/utils/perfil_utils.dart';

/// Widget PerfilInfoCard
///
/// Descrição: Card com avatar circular, nome do usuário e lista de informações
/// pessoais formatadas com linha decorativa lateral.
class PerfilInfoCard extends StatelessWidget {
  final Map<String, dynamic> userData;  // Dados do usuário da API

  const PerfilInfoCard({required this.userData, super.key});

  /// BUILD
  ///
  /// Descrição: Constrói card com avatar, nome e informações pessoais formatadas.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Column com estrutura completa do card
  @override
  Widget build(BuildContext context) {
    // Extrai dados com fallback para strings vazias
    String telefone = userData['phone'] ?? '';
    String cpf = userData['cpf'] ?? '';

    return Column(
      children: [
        // Seção superior: Avatar + Nome
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,        // Fundo cinza claro
            borderRadius: BorderRadius.circular(20),  // Bordas arredondadas
          ),
          child: Row(
            children: [
              // Avatar circular padrão
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey,     // Fundo cinza
                child: Icon(Icons.person, color: Colors.white),  // Ícone de pessoa
              ),
              const SizedBox(width: 12),
              // Nome do usuário
              Expanded(
                child: Text(
                  userData['name'] ?? 'Nome não encontrado',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Seção inferior: Informações pessoais com linha decorativa
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha decorativa vertical
            Container(
              width: 3,
              height: 80,                        // Altura fixa para cobrir as 3 informações
              color: Colors.grey.shade300,       // Mesma cor do card superior
            ),
            const SizedBox(width: 12),
            // Lista de informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // E-mail (sem formatação)
                  LabeledInfoItem(
                    label: 'E-mail',
                    value: userData['email'] ?? 'E-mail não encontrado',
                  ),
                  const SizedBox(height: 8),
                  // Telefone (formatado com máscara)
                  LabeledInfoItem(
                    label: 'Telefone',
                    value: formatarTelefone(telefone),  // Aplica máscara (XX) XXXXX-XXXX
                  ),
                  const SizedBox(height: 8),
                  // CPF (formatado com máscara)
                  LabeledInfoItem(
                    label: 'CPF',
                    value: formatarCpf(cpf),            // Aplica máscara XXX.XXX.XXX-XX
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Fim da classe PerfilInfoCard
  // 
  // Card de informações do usuário com:
  // - Avatar circular padrão
  // - Nome do usuário em destaque
  // - E-mail, telefone e CPF formatados
  // - Linha decorativa lateral
  // - Layout responsivo e organizado
}
