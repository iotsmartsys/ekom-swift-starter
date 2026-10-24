# Convenções de código e experiência

Este documento e os exemplos em `template/` são a fonte de verdade. A Skill deve lê-los antes de gerar ou ampliar um app. Use SwiftUI, Foundation e Combine conforme estes precedentes. Não substitua a arquitetura por outra sem requisito do produto.

## Estrutura obrigatória por funcionalidade

Para uma entidade singular `Item` e seu plural `Items`:

- `Views/ItemsView.swift`: lista, pesquisa, apresentação de formulário, confirmação de exclusão, callbacks e mensagens.
- `Views/ItemFormView.swift`: formulário de criação/edição com estado local.
- `ViewModel/Items/Item.swift`: entidade `Codable, Equatable, Identifiable`, alias `ItemsResponse`, DTO `ItemPayload`, estado `ItemFormData`, erro `ItemFormError` e tokens de pesquisa.
- `ViewModel/Items/ItemsViewModel.swift`: `ObservableObject`, propriedades `@Published` e coordenação dos services.
- `Services/Items/FindItemsService.swift`, `CreateItemService.swift`, `UpdateItemService.swift`, `DeleteItemService.swift`: uma operação por arquivo, herdando de `HttpService`.
- `Preview Content/ItemsExtensions.swift` e `items_sample.json`: amostras sintéticas carregadas do bundle.

Preserve `ViewModel` no singular, `Views/Controls`, `Shared/HttpHandlers`, `Shared/Settings` e `Shared/Enviroments`. A grafia `Enviroment` é mantida por compatibilidade com a origem. Símbolos e arquivos em inglês; mensagens de interface em português. Não crie pastas vazias ou arquivos de domínio antigo no app novo. Recursos compartilhados ficam fora da pasta do app, no grupo sincronizado `Shared` do Xcode.

## Navegação, menus e propriedade do estado

`Views/Controls/MainTabView.swift` é o precedente: `TabView(selection:)`, identificadores de tab estáveis, `Label` com SF Symbol e um `NavigationStack` por tab. A raiz possui os ViewModels com `@StateObject` e os injeta com `.environmentObject`. Telas filhas usam `@EnvironmentObject`; não instanciam um novo ViewModel em `body`.

`MoreTab.swift` contém `MoreTabsView`: `List`, seções “Geral” e “Configurações”, `NavigationLink` para cadastros e título “Menu”. Reutilize o ViewModel da raiz para o mesmo conjunto de dados. Não aninhe outro `NavigationStack` no menu já apresentado em uma tab. Adicione funcionalidades do produto como tabs ou destinos do menu seguindo estes exemplos.

## Lista e ações

Siga `ItemsView.swift`: título inline, `.searchable` sempre visível, filtro com `localizedCaseInsensitiveContains` sobre `searchTokens`, `ProgressView` durante carga, `List`/`ForEach`, atualização por gesto e estado vazio. Preserve linhas com alinhamento leading, espaçamento 6, nome em body, descrição em caption e secondary, estado ativo em verde e inativo em secondary.

O botão de inclusão fica em `.topBarTrailing` com `Label("Novo …", systemImage: "plus")`. Ações laterais trailing: editar com pencil/tint azul e excluir com trash/role destructive. Excluir primeiro abre confirmação “Tem certeza que deseja excluir?”, com nome do registro, ação “Excluir” e cancelamento. A ação destrutiva só chama o service após confirmação.

Use enum privado `<Entity>FormMode: Identifiable` com `.create` e `.edit(Entity)`, título e `formData`. Apresente com `.sheet(item:)`. Feche o modal apenas após sucesso do save; falha mantém os valores digitados.

## Formulário, validação e botões

Siga `ItemFormView.swift`: `NavigationStack` próprio para o modal, `Form`, seções “Identificação” e “Detalhes”, título inline. Receba `title`, `initialData`, `isSaving` e callback `onSubmit`. Inicialize `@State formData` no init com `State(initialValue:)`.

Use `@Environment(\.dismiss)` em “Cancelar” na cancellationAction. A confirmationAction exibe “Criar” ou “Salvar” conforme `isEditing`, impede envio duplicado com `.disabled(isSaving)` e mostra progresso. O botão valida com `makePayload()` antes de chamar `onSubmit`; a própria tela de lista valida também antes de chamar o ViewModel. Validação local aparece em seção do Form, caption e vermelho. Não feche em falha.

`FormData` contém valores editáveis, init vazio e init a partir da entidade, `isEditing` e `makePayload() throws`. Remova espaços nas extremidades dos textos; nome vazio gera `LocalizedError` com mensagem acionável; descrição vazia vira nil. O DTO contém somente campos aceitos pelo endpoint.

## ViewModels, services e transporte

Mantenha `isLoading`, `isSaving`, `errorMessage` e coleção publicados. O init aceita `load` e dados iniciais para previews. Services retornam `Result` por completion; alterações observáveis e callbacks da UI ocorrem na main. Use `[weak self]` para callbacks que capturam o ViewModel. Atualize flags também em falha. ID ausente deve produzir erro “ID inválido” antes da requisição.

Criação/edição recarregam a coleção após sucesso; exclusão remove o item após resposta bem-sucedida. Preserve ordenação por ativo primeiro e nome sem distinção de caixa. A UI não chama URLSession e o service não conhece SwiftUI.

`Shared/HttpHandlers` preserva a fachada `APIClient`, `HTTPClientCore`, clientes por verbo e `HttpService`, inclusive adaptadores async/await. Configure `ApiConfiguration.baseURL`, headers em tempo de execução e `Enviroment` com endpoints relativos ao novo produto. Sem Firebase, segredos fixos, logs de bodies/headers ou endpoints antigos. Transporte preserva corpo de respostas 201; 204 pode retornar Data vazio; services sem resposta decodificada usam a variante Bool. Não tente decodificar JSON vazio como entidade.

A demonstração usa `ItemsDemoStore` exclusivamente em memória e JSON sintético; não é persistência de produção. Ao integrar backend, defina URL, autenticação e contrato, desative `usesDemoData` e adapte DTOs/services. Não apresente a demonstração como integração concluída.

## Erros, toast e mensagens

Use `error.localizedDescription`; erros de validação são `LocalizedError`. Erros HTTP devem ter fallback com status, nunca mensagem nil ou exposição automática de corpo do servidor. `ToastContainer` envolve a lista; estados `showToast` e `toastMessage` pertencem à tela. `showError` adiciona prefixo “Erro: ” e oculta após dois segundos. Erro de carregamento precisa ser exibido; erro de salvar não fecha o modal. Não adicione toast de sucesso que não existe no precedente sem uma escolha do produto.

## Previews obrigatórios

Escreva `#Preview` (esta é a grafia correta) em cada nova tela e control visual. Listas recebem `.environmentObject(ItemsViewModel(load: false, items: ItemsResponse.sampleData))` dentro de `NavigationStack`. Formulários recebem `FormData` e callback vazio; tabs usam `load: false`. Nenhum preview deve iniciar rede ou alterar o armazenamento demo global. Os JSON devem estar no bundle e usar dados sintéticos. Para estados de carga, vazio, erro e edição, acrescente previews quando o comportamento novo depender desses estados.

## Precedentes e adaptações

A inspeção de FinancialApp identificou CategoriesView/CategoryFormView e PaymentMethodsView/PaymentMethodFormView como referência dos cadastros; CategoriesViewModel e os quatro services de categoria como referência de coordenação; MainTabView, MoreTab e ToastContainer como referência de experiência; Preview Content como referência de fixtures; Shared/HttpHandlers como referência HTTP.

Entries e RecurringEntries acrescentam filtros, seções, formulários maiores e ações de domínio. Use sua composição de views e estados como referência, mas não inclua parcelas, moedas, recorrências, scanner de pagamento ou ações financeiras em uma entidade genérica. Shared/Services de dispositivos, MQTT e automação também são específicos. Credenciais e cache de configuração remoto da origem não pertencem ao template.

Correções deliberadas na extração: preview de tabs sem rede, um stack por tab, erro de carregamento visível, vazio explícito, transporte sem logs sensíveis e sem descarte de body em 201. Estas correções não mudam as convenções de nomes e a separação das camadas.
