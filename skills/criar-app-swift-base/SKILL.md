---
name: criar-app-swift-base
description: Crie um novo app iOS a partir do template Swift BaseApp deste repositório. Use quando o usuário pedir um projeto inicial Swift baseado neste template; não use para alterações comuns em apps existentes.
---

# Criar app Swift base

Este skill fica em `skills/criar-app-swift-base`. Resolva o caminho real deste arquivo e use a raiz do repositório dois níveis acima. `template/` e seu `README.md` são a fonte de verdade para a estrutura e as escolhas do projeto.

Para um novo app, leia o README e execute `scripts/create_app.py` na raiz do repositório com nome, destino novo e bundle ID escolhidos pelo usuário. Se algum dado não tiver sido fornecido, use um placeholder claro e informe o que precisa ser alterado antes da distribuição. Não edite o template ao criar uma instância. Adapte a instância aos requisitos do produto sem transportar código ou credenciais de apps anteriores.

Confirme nomes, target, scheme e bundle ID na instância criada. Compile para iOS Simulator quando o Xcode estiver disponível. Informe os placeholders restantes, especialmente assinatura e ícone.
