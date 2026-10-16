# Índice canônico do método

Este índice mapeia responsabilidades, não comprova leitura ou aprovação.

## Entrada e governança

| Fonte | Responsabilidade |
| --- | --- |
| [README](README.md) | Orientação de entrada e estado do laboratório |
| [METHODOLOGY](METHODOLOGY.md) | Intenção e articulação do ciclo |
| [RULES](RULES.md) | Regras de trabalho humano-agente |
| [AGENTS](AGENTS.md) | Roteamento operacional e leituras por ação |
| [Workflow](docs/workflow-producao/WORKFLOW.md) | Árvore, estados, passagens e integração com entrega |
| [Contrato documental](docs/workflow-producao/CONTRATO-DOCUMENTAL.md) | Gatilhos, evidências e elaboração visível |
| [Baseline](docs/workflow-producao/BASELINE-METODO.md) | Constituição documental e capacidades condicionais |
| [Prompts](docs/workflow-producao/prompts/README.md) | Interações reutilizáveis e estado dos roteiros |
| [Memória entre sessões](docs/workflow-producao/MEMORIA-SESSOES.md) | Cinco registros persistentes, checkpoint e sucessão; funções particulares ainda abertas |
| [Adaptação ao Spec Kit](docs/workflow-producao/ADAPTACAO-SPECKIT.md) | Preflight corrigido: diálogo, gates, vínculo de ratificação e execução segmentada |

## Templates disponíveis, não documentos de produto preenchidos

| Template | Gatilho |
| --- | --- |
| [Exploração](docs/workflow-producao/templates/EXPLORACAO.md) | Preservar aprendizado selecionado |
| [ZERO](docs/workflow-producao/templates/REQUIREMENT-ZERO.MD) | Elaborar fundamento do produto |
| [Requisito numerado](docs/workflow-producao/templates/requirement-NNNN.md) | Mudança ou expansão da intenção |
| [Preflight e ADR](docs/workflow-producao/templates/PREFLIGHT-ADR.md) | Examinar risco e decisão material |
| [Ponte de execução](docs/workflow-producao/templates/PONTE-SPECS-TAREFAS.md) | Conectar specs/tarefas e mandato |
| [Entrega e aprendizado](docs/workflow-producao/templates/ENTREGA-APRENDIZADO.md) | Revisar, liberar e observar |
| [Constituição](docs/workflow-producao/templates/CONSTITUICAO-REPOSITORIO.md) | Necessidade concreta de repo/incorporação |
| [Passagem](docs/workflow-producao/templates/REGISTRO-PASSAGEM.md) | Conservar decisão/transição relevante |
| [Capacidades e integrações](docs/workflow-producao/templates/CAPACIDADES-INTEGRACOES.md) | Adotar ou modificar prompt, skill, MCP, agente ou executor |
| [Checkpoint de sessão](docs/workflow-producao/templates/CHECKPOINT-SESSAO.md) | Preservar e recuperar memória antes da compactação/passagem |
| [Recibo de ratificação](docs/workflow-producao/templates/RATIFICACAO-DOCUMENTAL.md) | Relacionar conteúdo apresentado, resposta humana e revisão autorizada |

## Limites do inventário

O índice cobre o método em elaboração, não certifica toda a documentação ou
capacidade instalada no laboratório. Componentes existentes como `.claude/`,
`.github/`, `smard-ide/` e `skills-web/` não foram auditados como integrações
do método. A presença de um arquivo ou diretório não demonstra ativação,
autorização ou compatibilidade.
