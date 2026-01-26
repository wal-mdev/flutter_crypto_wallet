# Flutter Crypto Wallet 

Um aplicativo moderno de monitoramento de criptomoedas desenvolvido em Flutter, integrando dados em tempo real da API CoinGecko com foco em performance e experiência do usuário.

## Principais Funcionalidades

- **Dados em Tempo Real**: Integração completa com a API da **CoinGecko** para listar o Top 150 Market Cap.
- **Gráficos Interativos**: Visualização de dados históricos e variações de preço utilizando a biblioteca **fl_chart**.
- **Busca Inteligente**: Pesquisa de moedas com suporte a **Debouncing** (evita requisições excessivas à API).
- **Sistema de Favoritos**: Gerenciamento local de moedas favoritas.
- **Atualização Automática**: Contador regressivo para atualização periódica dos dados de mercado.

## Design e UI/UX

- **Suporte a Temas**: Suporta totalmente **Tema Claro (Light Mode)** e **Tema Escuro (Dark Mode)**, respeitando as configurações do sistema.
- **Material 3**: Interface moderna utilizando os padrões mais recentes do Google.
- **Feedback Visual**: Uso estratégico de SnackBars para erros de navegação e BottomSheets para confirmações de ações (ex: remover favorito).

## Arquitetura e Performance

O projeto foi construído seguindo princípios sólidos de arquitetura de software:

- **MVVM (Model-View-ViewModel)**: Separação clara entre a lógica de negócio e a interface de usuário.
- **Command Pattern**: Gerenciamento de estados de carregamento, erro e sucesso de forma padronizada.
- **Injeção de Dependências**: Uso de `get_it` para um código mais testável e desacoplado.
- **Otimização de Performance**:
  - Reconstrução granular de widgets para evitar renderizações desnecessárias.
  - Cache em memória de dados da API para navegação instantânea.

## Como Rodar

1.  Certifique-se de ter o Flutter instalado (`flutter doctor`).
2.  Clone o repositório.
3.  Crie um arquivo `.env` na raiz (se necessário para chaves de API).
4.  Execute:
    ```bash
    flutter pub get
    flutter run
    ```

## Testes

O projeto conta com uma suíte de testes unitários cobrindo as principais camadas logicamente isoladas:

- **Modelos**: Validação de parsing de JSON (CoinMarket, CoinDetail).
- **Providers**: Testes de lógica de estado (FavoritesProvider).
- **ViewModels**: Testes de comando e fluxo de dados (Home, Details, Favorites).

Para rodar os testes, utilize:
```bash
flutter test
```
