# BaseApp — projeto iOS inicial

Este projeto contém um app SwiftUI com navegação inicial e um cliente HTTP JSON opcional. Não inclui lógica de negócio, credenciais, endpoints nem dependências externas.

## Personalizar

1. Abra `BaseApp.xcodeproj` e selecione o scheme `BaseApp`. Se o projeto foi criado pelo gerador, esses nomes já foram substituídos pelo nome escolhido.
2. Configure a equipe de assinatura e revise o bundle ID em Debug e Release.
3. Substitua `ContentView` pelo primeiro fluxo do produto. Ajuste plataformas, versão mínima do iOS e permissões conforme necessário. A base usa iOS 17 ou posterior.
4. Use `APIClient` apenas se houver uma API. Forneça URL e cabeçalhos por uma configuração apropriada ao novo app; não grave segredos no código ou no Git.
5. Adicione o ícone em `Assets.xcassets/AppIcon.appiconset` antes de distribuir.
6. Compile para iOS Simulator.

## Estrutura

- `BaseApp/BaseApp.swift`: ponto de entrada.
- `BaseApp/ContentView.swift`: tela inicial mínima com `NavigationStack`.
- `BaseApp/Networking/APIClient.swift`: transporte JSON com `URLSession`.
- `BaseApp/Assets.xcassets`: cor de destaque e conjunto de ícone vazio.
- `BaseApp.xcodeproj`: target único e scheme compartilhado.

## Origem

Esta base foi extraída da estrutura de um app SwiftUI com camadas de interface, modelos e serviços HTTP. Ela retém o ponto de entrada, a navegação e um cliente de rede independente. Telas financeiras, perfis de servidor, leitura de códigos e recursos de marca ficaram fora da base. Nenhuma configuração de API é necessária para abrir ou compilar o projeto.
