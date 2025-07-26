# SUDEMA Mobile Frontend

> Aplicativo móvel oficial da SUDEMA (Superintendência de Administração do Meio Ambiente) da Paraíba para denúncias ambientais, consulta de balneabilidade e notícias.

## 📱 Sobre o Projeto

O SUDEMA Mobile é um aplicativo Flutter desenvolvido para facilitar o acesso dos cidadãos aos serviços da SUDEMA, permitindo:

- **Denúncias Ambientais**: Registro de ocorrências com localização e evidências
- **Balneabilidade**: Consulta da qualidade das praias paraibanas
- **Notícias**: Informações atualizadas sobre meio ambiente
- **Perfil do Usuário**: Gerenciamento de conta e dados pessoais

## 🏗️ Arquitetura do Projeto

### Estrutura de Pastas

```
lib/screens/
├── home/                      # Tela principal do aplicativo
│   ├── home_screen.dart       # Container principal com navegação
│   ├── home_body.dart         # Conteúdo da home
│   ├── banner_carrossel.dart  # Carrossel de banners
│   ├── noticias_carrossel.dart # Carrossel de notícias
│   └── servicos_carrossel.dart # Carrossel de serviços
├── login/                     # Sistema de autenticação
│   ├── login.dart             # Tela de login
│   └── controller/            # Lógica de autenticação
├── cadastro/                  # Sistema de registro
│   ├── cadastro_screen.dart   # Tela principal de cadastro
│   ├── confirmar_cadastro.dart # Confirmação por código
│   ├── controller/            # Lógica de cadastro
│   ├── service/               # Integração com API
│   └── widgets/               # Componentes do formulário
├── senhas/                    # Recuperação de senha (3 etapas)
│   ├── RecuperacaoSenha.dart  # 1ª etapa: inserção de e-mail
│   ├── CodigoDeSenha.dart     # 2ª etapa: validação do código
│   └── NovaSenha.dart         # 3ª etapa: redefinição
├── perfil/                    # Sistema de perfil do usuário
│   ├── perfil/                # Tela principal do perfil
│   │   ├── perfil_page.dart   # Container principal
│   │   ├── perfil_*.dart      # Componentes do perfil
│   │   └── controller/        # Lógica de gerenciamento
│   └── menu/                  # Funcionalidades do menu
│       ├── alterarsenha/      # Alteração de senha
│       ├── alteraremail/      # Alteração de e-mail
│       ├── alterarperfil/     # Edição de dados pessoais
│       └── desativarConta/    # Desativação de conta
├── denuncia/                  # Sistema de denúncias ambientais
│   ├── PageDenuncia.dart      # Tela inicial com informações
│   ├── denunciawraprellerscreen.dart # Wrapper do fluxo
│   ├── categoria/             # Seleção de categoria
│   ├── identificacao/         # Identificação do denunciante
│   ├── localizacao/           # Localização da ocorrência
│   ├── denuncia/              # Formulário principal
│   ├── resumo/                # Revisão antes do envio
│   └── service/               # Integração com API
├── balneabilidade/            # Sistema de consulta de praias
│   ├── balneabilidade.dart    # Tela principal
│   ├── balneabilidade_mapa.dart # Mapa interativo
│   ├── balneabilidade_filtros.dart # Sistema de filtros
│   ├── controller/            # Lógica de gerenciamento
│   └── services/              # Integração com API
├── noticias/                  # Sistema de notícias
│   ├── pagina_noticias/       # Lista de notícias
│   ├── pagina_noticiaCompleta/ # Visualização completa
│   └── service/               # Integração com API
├── diversos/                  # Telas auxiliares
│   ├── splash_screen.dart     # Tela de abertura
│   ├── mainscreen.dart        # Container de navegação
│   ├── reativar_conta.dart    # Reativação de conta
│   └── webview_screen.dart    # Visualização web
└── widgets/                   # Componentes reutilizáveis
    ├── navbar.dart            # Navegação inferior
    ├── drawer.dart            # Menu lateral
    ├── appbar*.dart           # AppBars customizadas
    └── custom_snackbar.dart   # Feedback visual
```

### Padrões Arquiteturais

- **MVC Pattern**: Controllers para lógica de negócio
- **Widget Composition**: Componentes reutilizáveis
- **Service Layer**: Abstração da comunicação com API
- **State Management**: StatefulWidget com setState e Provider
- **Responsive Design**: Layout adaptativo mobile/tablet

## 🔐 Sistema de Autenticação

### Fluxo de Login
- Autenticação via JWT (JSON Web Token)
- Persistência local com SharedPreferences
- Validação de expiração automática
- Redirecionamento seguro para login
- Integração com Firebase Messaging para notificações

### Recuperação de Senha (3 Etapas)

#### 1. **RecuperacaoSenha** - Inserção de E-mail
```dart
// Validação de e-mail via regex
bool _isValidEmail(String email) {
  return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
}

// Endpoint: POST /password-reset/forgot-password
```

#### 2. **CodigoDeSenha** - Validação do Código
```dart
// Campo PIN de 6 dígitos com PinCodeTextField
// Timeout de 5 minutos
// Opção de reenvio com prevenção de spam

// Endpoint: POST /password-reset/verify-token
```

#### 3. **NovaSenha** - Redefinição
```dart
// Validações: mínimo 8 caracteres + coincidência
// Toggle de visibilidade independente
// Navegação para login com limpeza de stack

// Endpoint: POST /password-reset/reset-password
```

### Sistema de Cadastro
- Formulário completo com validações brasileiras
- Máscaras automáticas (CPF, telefone)
- Confirmação por código via e-mail
- Integração com API de registro

## 👤 Sistema de Perfil

### Funcionalidades Principais

#### **Visualização de Perfil**
- Carregamento de dados via JWT decode
- Formatação automática (CPF: XXX.XXX.XXX-XX, Telefone: +55 (XX) XXXXX-XXXX)
- Estados de loading/erro com feedback visual
- Menu de opções integrado

#### **Alteração de Senha**
```dart
// 3 campos: atual, nova, confirmação
// Toggle de visibilidade independente
// Validações locais + API
// Feedback via Flushbar

// Endpoint: PUT /usuarios/mobile/{id}/alterar-senha
```

#### **Alteração de E-mail**
```dart
// Validação por senha atual
// Atualização automática de token JWT
// Tratamento de encoding (latin1 → utf8)
// Mensagens específicas para erros comuns

// Endpoint: PUT /usuarios/mobile/{id}/alterar-email
```

#### **Edição de Perfil**
```dart
// Máscaras automáticas brasileiras
// Validações específicas por campo
// Preenchimento inicial formatado
// Integração com API SUDEMA

// Endpoint: PUT /usuarios/mobile/{id}
```

#### **Desativação de Conta**
```dart
// Confirmação obrigatória por senha
// Feedback visual com instruções de reativação
// Logout automático pós-desativação
// Navegação com limpeza de stack

// Endpoint: PATCH /usuarios/mobile/{id}/desativar
```

## 🚨 Sistema de Denúncias

### Fluxo Completo de Denúncia

#### **Tela Inicial (PageDenuncia)**
- Informações educativas sobre denúncias ambientais
- Link para Decreto Estadual nº 44.889/2024
- Botão principal para iniciar denúncia

#### **Fluxo de Denúncia (DenunciaWrapperScreen)**
1. **Seleção de Categoria**: Tipos de infrações ambientais
2. **Identificação**: Opção anônima ou identificada
3. **Localização**: Mapa interativo para marcar local
4. **Formulário**: Descrição detalhada e upload de imagens
5. **Resumo**: Revisão antes do envio
6. **Confirmação**: Feedback de sucesso

### Recursos Técnicos
- Upload de múltiplas imagens
- Geolocalização integrada
- Validações específicas por categoria
- Termos de uso obrigatórios
- Integração completa com API SUDEMA

## 🏖️ Sistema de Balneabilidade

### Funcionalidades

#### **Mapa Interativo**
- Visualização de estações de monitoramento
- Marcadores com status de qualidade da água
- Zoom e navegação fluida

#### **Sistema de Filtros**
- Filtro por município
- Filtro por praia específica
- Filtro por classificação (Própria/Imprópria)
- Aplicação em tempo real

#### **Dados das Praias**
- Informações de qualidade da água
- Histórico de monitoramento
- Status atualizado via API
- Cards informativos por estação

### Arquitetura Técnica
- Provider para gerenciamento de estado
- Controller dedicado para lógica de negócio
- Services especializados (localização, filtros, ícones)
- Integração com API de balneabilidade

## 📰 Sistema de Notícias

### Funcionalidades

#### **Lista de Notícias**
- Feed completo de notícias da SUDEMA
- Sistema de busca integrado
- Carregamento paginado
- Cards responsivos com imagens

#### **Visualização Completa**
- Tela dedicada para leitura
- Formatação HTML preservada
- Imagens em alta resolução
- Compartilhamento integrado

### Recursos Técnicos
- Remoção automática de tags HTML
- Cache de imagens
- Estados de loading e erro
- Navegação fluida entre telas

## 🎨 Design System

### Cores Institucionais
```dart
static const Color primaryColor = Color(0xFF2A2F8C);    // Azul SUDEMA
static const Color successColor = Color(0xFF1B8C00);    // Verde (ações positivas)
static const Color errorColor = Colors.red;             // Vermelho (erros)
static const Color backgroundColor = Colors.white;      // Fundo padrão
```

### Componentes Reutilizáveis

#### **InputDecoration Padronizada**
```dart
// Bordas arredondadas (8-12px)
// Estados consistentes (normal, focado, erro)
// Cores semânticas
// Toggle de visibilidade para senhas
```

#### **Flushbar Feedback**
```dart
// Posição TOP com animação suave
// Cores semânticas por tipo
// Ícones apropriados
// Duração configurável (3-5s)
```

#### **Layout Responsivo**
```dart
// Breakpoint: 600dp para tablet
// Padding diferenciado por dispositivo
// Centralização adaptativa
// Largura máxima controlada (500px)
```

### Navegação

#### **Bottom Navigation (NavBar)**
- 4 abas principais: Home, Denúncias, Balneabilidade, Notícias
- Ícones SVG customizados
- Indicador visual de seleção
- Labels condicionais

#### **Drawer Lateral**
- Acesso rápido às funcionalidades
- Informações do usuário logado
- Botões de login/logout
- Links para contato

## 🌐 Integração com API

### Configuração
```dart
// URL base via flutter_dotenv
final baseUrl = dotenv.env['URL_API'];

// Headers padrão
headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
}
```

### Endpoints Principais

#### **Autenticação**
- `POST /auth/login` - Login do usuário
- `POST /auth/register` - Cadastro de novo usuário
- `POST /auth/register/resend-confirm` - Reenvio de código
- `POST /password-reset/forgot-password` - Solicitar código
- `POST /password-reset/verify-token` - Validar código
- `POST /password-reset/reset-password` - Redefinir senha

#### **Perfil do Usuário**
- `GET /usuarios/mobile/me` - Obter dados do usuário
- `PUT /usuarios/mobile/{id}` - Atualizar perfil
- `PUT /usuarios/mobile/{id}/alterar-senha` - Alterar senha
- `PUT /usuarios/mobile/{id}/alterar-email` - Alterar e-mail
- `PATCH /usuarios/mobile/{id}/desativar` - Desativar conta

#### **Denúncias**
- `POST /denuncias` - Criar nova denúncia
- `GET /categorias` - Listar categorias
- `POST /upload` - Upload de imagens

#### **Balneabilidade**
- `GET /estacoes` - Listar estações de monitoramento
- `GET /municipios` - Listar municípios
- `GET /praias` - Listar praias

#### **Notícias**
- `GET /noticias` - Listar notícias
- `GET /noticias/{id}` - Obter notícia específica

### Tratamento de Erros
```dart
// Status codes específicos
// 200/204: Sucesso
// 400: Dados inválidos
// 401: Token inválido/expirado
// 404: Recurso não encontrado
// 500: Erro interno

// Extração de mensagens da API
final error = jsonDecode(response.body)['message'] ?? 'Erro genérico';
```

## 📱 Responsividade

### Breakpoints
```dart
final bool isTablet = screenWidth >= 600;  // 600dp breakpoint
```

### Adaptações por Dispositivo

#### **Mobile (< 600dp)**
- Padding: 16-24px
- Alinhamento: esquerda
- Layout: direto sem centralização

#### **Tablet (≥ 600dp)**
- Padding: 24px+
- Alinhamento: centro
- Layout: ConstrainedBox com maxWidth: 500px
- Centralização dupla

## 🔧 Validações

### E-mail
```dart
RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
```

### CPF
```dart
// Algoritmo oficial de verificação
// Máscara: XXX.XXX.XXX-XX
```

### Telefone
```dart
// 11 dígitos exatos (celular brasileiro)
// Máscara: (XX) XXXXX-XXXX
```

### Senha
```dart
// Mínimo 8 caracteres
// Combinação de letras, números e símbolos
// Confirmação obrigatória
```

### Nome
```dart
// Mínimo 2 palavras (nome + sobrenome)
// Trim automático
```

## 🛠️ Tecnologias Utilizadas

### Core
- **Flutter**: Framework principal
- **Dart**: Linguagem de programação

### Packages Principais
```yaml
dependencies:
  flutter_dotenv: ^5.0.2          # Variáveis de ambiente
  shared_preferences: ^2.0.15     # Persistência local
  http: ^0.13.5                   # Requisições HTTP
  jwt_decoder: ^2.0.1             # Decodificação JWT
  google_fonts: ^4.0.3            # Fontes Google
  another_flushbar: ^1.12.29      # Feedback visual
  pin_code_fields: ^7.4.0         # Campo PIN
  mask_text_input_formatter: ^2.4.0  # Máscaras de entrada
  flutter_svg: ^2.0.5             # Ícones SVG
  provider: ^6.0.0                # Gerenciamento de estado
  firebase_messaging: ^14.0.0     # Notificações push
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 2.17.0
- Android Studio / VS Code
- Dispositivo/Emulador Android/iOS

### Instalação
```bash
# Clone o repositório
git clone https://gitcodata.pb.gov.br/ti-idema/sudema-mobile_frontend.git

# Entre no diretório
cd sudema-mobile_frontend

# Instale as dependências
flutter pub get

# Configure as variáveis de ambiente
cp .env.example .env
# Edite o arquivo .env com as configurações necessárias

# Execute o aplicativo
flutter run
```

### Configuração do Ambiente
```env
URL_API=https://homolog.sigma.pb.gov.br/sislia/api/v1
```

## 🧪 Testes

### Estrutura de Testes
```dart
// Keys para testes automatizados
key: const Key('emailField')
key: const Key('senhaField')
key: const Key('submitButton')
```

### Executar Testes
```bash
flutter test
```

## 📋 Funcionalidades Implementadas

### ✅ Sistema de Autenticação
- [x] Login com JWT
- [x] Cadastro de usuários
- [x] Recuperação de senha (3 etapas)
- [x] Persistência de sessão
- [x] Logout seguro
- [x] Reativação de conta

### ✅ Perfil do Usuário
- [x] Visualização de dados
- [x] Edição de perfil
- [x] Alteração de senha
- [x] Alteração de e-mail
- [x] Desativação de conta

### ✅ Sistema de Denúncias
- [x] Fluxo completo de denúncia
- [x] Seleção de categorias
- [x] Geolocalização
- [x] Upload de imagens
- [x] Denúncias anônimas/identificadas

### ✅ Balneabilidade
- [x] Mapa interativo
- [x] Sistema de filtros
- [x] Dados de qualidade da água
- [x] Estações de monitoramento

### ✅ Sistema de Notícias
- [x] Feed de notícias
- [x] Busca integrada
- [x] Visualização completa
- [x] Carrossel na home

### ✅ UX/UI
- [x] Design responsivo
- [x] Feedback visual
- [x] Validações em tempo real
- [x] Estados de loading
- [x] Tratamento de erros
- [x] Splash screen animada

### ✅ Integração
- [x] API SUDEMA completa
- [x] Formatação de dados brasileiros
- [x] Máscaras de entrada
- [x] Validações robustas
- [x] Notificações push

## 🔮 Roadmap

### Próximas Funcionalidades
- [ ] Modo offline
- [ ] Testes automatizados
- [ ] Melhorias de performance
- [ ] Acessibilidade aprimorada
- [ ] Internacionalização

## 👥 Equipe

**Desenvolvimento**: Equipe TI-IDEMA  
**Órgão**: SUDEMA - Superintendência de Administração do Meio Ambiente  
**Estado**: Paraíba - Brasil

## 📄 Licença

Este projeto é propriedade do Governo do Estado da Paraíba e está licenciado para uso interno da SUDEMA.

---

**SUDEMA Mobile** - Protegendo o meio ambiente da Paraíba através da tecnologia 🌱📱