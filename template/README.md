# BaseApp — base iOS EKOM

Base SwiftUI completa com `MainTabView`, menu “Mais”, lista pesquisável, formulário de criação/edição, confirmação de exclusão, toast, ViewModel, quatro services CRUD, previews JSON e camada HTTP em Shared.

O app inicia com dados sintéticos em memória. Criar, editar e excluir operam nesse estado; os dados são reiniciados ao encerrar o processo. Para integrar API, configure `Shared/Settings/ApiConfiguration.swift`, os endpoints em `Shared/Enviroments/Enviroment.swift` e desative `usesDemoData`. Não há Firebase ou credenciais embutidas.

Abra `BaseApp.xcodeproj` e selecione o scheme `BaseApp` (o gerador substitui esses nomes). Configure equipe de assinatura e ícone para distribuição. O deployment mínimo é iOS 17.

A estrutura e a experiência devem seguir `docs/CODING_CONVENTIONS.md` no repositório fonte; o gerador inclui esse documento na cópia do app. Use `Items` como precedente de uma funcionalidade completa, adaptando nome e campos ao domínio solicitado.
