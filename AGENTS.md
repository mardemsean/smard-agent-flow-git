# Instruções para agentes neste laboratório

Leia [METHODOLOGY.md](METHODOLOGY.md) e [RULES.md](RULES.md) ao iniciar trabalho
sobre o método. Use [INDEX.md](INDEX.md) para localizar fontes canônicas.
Respeite instruções de escopo mais específico e políticas do ambiente; conflito
material deve ser explicitado, não resolvido silenciosamente.

## Antes de agir, leia o contrato pertinente

| Ação | Leituras obrigatórias no escopo do método | Evidência esperada |
| --- | --- | --- |
| Explorar intenção | Workflow, regras e exploração existente se houver | Companhia e síntese visível, sem obrigar formalização |
| Criar/alterar documento | Protocolo de elaboração visível no contrato documental e documento atual | Proposta no chat, delta substantivo e pendências por documento |
| Fundar ou mudar intenção | ZERO/requisito vigente, exploração pertinente e template correspondente | Proposta rastreável; ratificação antes de executar novo compromisso |
| Constituir repo/baseline | Baseline, contrato documental e políticas existentes | Inventário contextual e autorizações externas necessárias |
| Assumir decisão arquitetural | Requisito, decisões anteriores e preflight pertinente | Alternativas, consequências e decisão identificável |
| Especificar/delegar | Requisito ratificado, ADRs aplicáveis e ponte de execução | Cobertura, tarefas canônicas e mandato delimitado |
| Alterar prompt, skill, MCP ou adaptador | Baseline, inventário pertinente e contratos da ferramenta adotada | Procedência, permissões, instalação/remoção e compatibilidade verificadas |
| Alterar execução determinística | Contrato técnico, configuração e testes existentes da área | Cobertura positiva/negativa; regressão para bug |
| Abrir PR, integrar ou liberar | Regras de revisão/release existentes e registro DEL pertinente | Evidências e autorizações da revisão atual |
| Preparar compactação ou passagem de sessão | MEMORIA-SESSOES e registros locais disponíveis da linhagem | Checkpoint verificável dos dois nomes, sem inventar suas funções |
| Retomar como sucessor | MEMORIA-SESSOES, envelope e os dois registros disponíveis | Recuperação explícita, lacunas e reconciliação com estado atual |

O contrato de memória está em
[MEMORIA-SESSOES.md](docs/workflow-producao/MEMORIA-SESSOES.md).
Hook precompact e recuperação automática ainda não estão implementados.

## Execução no repositório

Não há um único comando de build/teste para todos os componentes. Descubra e
leia os manifests e instruções da área alterada; execute a menor validação
pertinente. Para documentação do método, confira links locais e consistência de
referências. Não instalar dependências ou executar suites não relacionadas.

O workflow existente `.github/workflows/smard-ide.yml` documenta verificações
desse componente; não é pipeline de validação ou release do método inteiro.
Não o altere por associação sem necessidade e autorização de escopo.

## Fronteiras

Não preencher aprovação humana, gerar documentação silenciosa nem tratar merge
como ratificação genérica. Não criar repo, publicar, conceder acesso, instalar
skills/MCPs ou habilitar CI com base apenas num template. Adaptadores específicos
devem referenciar estas fontes, não redefinir política em paralelo.

As leituras técnicas citadas pelo usuário sobre Specify são requisitos para
investigar uma integração futura, não evidência de que ela foi implementada.
Antes de modificar o executor, verificar versão, documentação original,
arquitetura de extensão e testes aplicáveis.
