---
name: criar-app-swift-base
description: Crie ou amplie apps iOS EKOM com tabs, menus, listas, cadastros e camadas SwiftUI conforme o template e as convenções deste repositório.
---

# Criar e ampliar apps Swift EKOM

Resolva o caminho real deste arquivo, inclusive quando instalado por symlink. A raiz do repositório fica dois níveis acima de `skills/criar-app-swift-base`.

Antes de implementar, leia `docs/CODING_CONVENTIONS.md` na raiz e os arquivos de exemplo citados para a funcionalidade em questão. Esse documento e `template/` são a fonte de verdade: nomes, pastas, composição de listas e formulários, callbacks, ações, mensagens e previews devem seguir os precedentes. Não gere apenas um App/ContentView vazio para pedidos de base EKOM.

Para um app novo, execute `scripts/create_app.py` com nome, destino novo e bundle ID. Preserve a estrutura completa gerada: tabs, menu, cadastro de exemplo, ViewModel, services, preview content e Shared. Adapte o exemplo ao domínio solicitado; não conserve rótulos de exemplo como funcionalidades reais. Dados faltantes podem usar placeholders claros, informados ao usuário.

Para novas funcionalidades, reproduza o conjunto de arquivos e a experiência documentados: entidade/Payload/FormData/LocalizedError, ViewModel com flags e init sem carga, services por operação, lista, formulário, fixtures e `#Preview`. Leia os arquivos existentes no app antes de alterá-los. Preserve convenções específicas já adotadas e explicite qualquer divergência necessária.

Compile a instância gerada para iOS Simulator quando o Xcode estiver disponível. Confira inclusão dos resources, previews sem rede, injeção dos ViewModels, ações de criar/editar/excluir, validação, erros, confirmação destrutiva e feedback de carregamento. Não afirme que testes de compilação comprovam interação visual. Informe se a API ainda está em modo demo, a ausência de persistência e o que falta configurar.
