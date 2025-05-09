import 'package:flutter/material.dart';
import 'package:sudema_app/screens/RegistroUser.dart';
import 'package:sudema_app/screens/widgets/appbardenuncia.dart';

class Termoscondicoes extends StatefulWidget {
  const Termoscondicoes({super.key});

  @override
  State<Termoscondicoes> createState() => _TermoscondicoesState();
}

class _TermoscondicoesState extends State<Termoscondicoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDenuncia(title: 'Termos e Condições'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Introdução',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Este aplicativo é uma ferramenta oficial da Superintendência de Administração do Meio Ambiente da Paraíba (SUDEMA), criado com o objetivo de aproximar a população das ações de proteção ambiental no estado da Paraíba. Por meio dele, os cidadãos poderão realizar denúncias ambientais, visualizar a balneabilidade das praias, acompanhar informações relevantes e colaborar com a fiscalização ambiental de forma ágil e segura.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 12,),
            Text(' O uso deste aplicativo implica na aceitação integral destes Termos e Condições de Uso, bem como da nossa Política de Privacidade. Leia com atenção antes de se cadastrar ou utilizar nossos serviços.',style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,),
            SizedBox(height: 20,),
            Text(
              '2. Coleta de dados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Para utilizar algumas funcionalidades do aplicativo, será necessário realizar um cadastro com os seguintes dados pessoais: nome completo; CPF; e-mail; telefone; e senha de acesso. Esses dados serão utilizados exclusivamente para autenticação do usuário, comunicação e para fins de segurança, conforme previsto na Lei nº 13.709/2018 (LGPD).',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20,),
            Text(
              '3. Denúncias Ambientais',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'O aplicativo permite o envio de denúncias ambientais, que podem ser realizadas de forma identificada ou anônima. No entanto, mesmo no modo anônimo, os dados do denunciante serão armazenados com segurança, visando garantir a integridade das informações, prevenir fraudes e permitir eventual investigação, se necessário.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 12,),
            Text('A SUDEMA assegura que nenhum dado pessoal será divulgado a terceiros, exceto quando expressamente autorizado pelo usuário ou por força de obrigação legal.Segurança e Proteção de Dados',
              style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,),
            SizedBox(height: 20,),
            Text(
              '4. Segurança e Proteção de dados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Nos comprometemos com a privacidade e segurança dos dados pessoais fornecidos pelos usuários. Adotamos medidas técnicas e administrativas para proteger suas informações contra acessos não autorizados, vazamentos, perdas ou alterações indevidas',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,),
            SizedBox(height: 12,),
            Text('Todos os dados coletados são armazenados em ambiente seguro e utilizados exclusivamente para as finalidades informadas neste Termo.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,),
            SizedBox(height: 20,),
            Text('5. Responsabilidades do Usuário', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 8),
            Text('Ao utilizar este aplicativo, o usuário compromete-se a: fornecer informações verdadeiras, exatas e atualizadas no momento do cadastro; manter a confidencialidade da senha de acesso; utilizar o aplicativo de forma ética, responsável e conforme a legislação vigente; não utilizar o aplicativo para envio de denúncias falsas ou caluniosas.',
            style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,),
            SizedBox(height: 20,),
            Text('6. Atualizações e Modificações', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('A SUDEMA se reserva o direito de alterar estes Termos e Condições de Uso a qualquer momento, mediante aviso prévio no próprio aplicativo. O uso continuado da plataforma após tais alterações será considerado como aceitação das novas condições.',
            style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,),
            SizedBox(height: 20,),
            Text('7. Contato e Suporte', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Em caso de dúvidas, sugestões ou solicitações relacionadas a este aplicativo ou ao tratamento de dados pessoais, entre em contato com a SUDEMA pelo site institucional: www.sudema.pb.gov.br',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,),
            SizedBox(height: 20,),
            Text('8. Foro e Legislação Aplicável', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 8),
            Text('Estes Termos serão regidos e interpretados de acordo com as leis brasileiras, em especial a LGPD. Fica eleito o foro da comarca de João Pessoa – PB para dirimir eventuais controvérsias, com renúncia expressa a qualquer outro, por mais privilegiado que seja.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistroUser(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A2F8C),
                  padding: EdgeInsets.symmetric(horizontal: 124, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Concluir Leitura',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
