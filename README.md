# EKOM Swift Starter

Base completa para novos apps iOS da EKOM, mantida na organização GitHub `iotsmartsys`. O repositório contém o projeto Xcode em `template/`, um gerador em `scripts/` e a Skill Codex em `skills/criar-app-swift-base/`.

## Criar um app

```sh
python3 scripts/create_app.py MeuApp /caminho/para/MeuApp --bundle-id com.example.MeuApp
```

O destino deve ser um diretório novo. O comando copia o template e ajusta pasta, arquivo de entrada, target, scheme, nome exibido e bundle ID. O bundle ID é escolhido em cada execução. Depois, abra `MeuApp.xcodeproj`, selecione a equipe de assinatura e acrescente um ícone antes de distribuir. Leia `template/README.md` para conhecer a base.

## Instalar a Skill no Codex

```sh
ln -s "$(pwd)/skills/criar-app-swift-base" "${CODEX_HOME:-$HOME/.codex}/skills/criar-app-swift-base"
```

Execute na raiz deste repositório. Se já houver uma Skill com esse nome, remova ou renomeie a instalação antiga antes de criar o link. A Skill resolve a localização real de seu arquivo para encontrar o template dentro do mesmo repositório.

## Publicação

Este repositório ainda não contém uma licença; a decisão está pendente. O template usa a tela inicial simples e não inclui o ícone do app financeiro de origem, credenciais ou endpoints.

## Convenções e funcionalidades

Leia [docs/CODING_CONVENTIONS.md](docs/CODING_CONVENTIONS.md) antes de ampliar um app. A base inclui tabs, menu, lista, formulário, ViewModel, services por operação, JSON de preview e Shared HTTP. O modo demo funciona em memória; a integração real exige configurar API e desativá-lo.
