---
name: method
description: Use ao explorar uma ideia de software, criar ou alterar documentos do método, fundar requisitos, decidir arquitetura, especificar, delegar, abrir PR, entregar ou passar sessão no fluxo smard-agent-flow-git (inquietação à produção). Indica quais documentos canônicos ler antes de agir.
---

# smard-agent-flow: roteador do método

Esta skill é só um ponteiro. A política vive no repositório canônico; não a
redefina aqui nem de memória.

- Repositório local: `B:\agent-deliverables-to-sean\smard-agent-flow-git`
- Remoto (privado): `mardemsean/smard-agent-flow-git`

Se o caminho local não existir, diga isso ao operador e pare; não improvise as regras.

## 1. Sempre, ao começar

Leia, nesta ordem: `AGENTS.md`, `METHODOLOGY.md`, `RULES.md`, `INDEX.md`
(todos na raiz do repositório). Conflito material entre fontes é explicitado ao
operador, nunca resolvido em silêncio.

## 2. Depois, leia o contrato da ação

Caminhos relativos à raiz do repositório. A tabela completa e a evidência
esperada estão em `AGENTS.md`; esta é apenas a rota.

| Ação | Leia |
| --- | --- |
| Explorar intenção | `docs/workflow-producao/WORKFLOW.md`, `docs/workflow-producao/prompts/exploracao-acompanhada.md`, `docs/workflow-producao/templates/EXPLORACAO.md` |
| Criar ou alterar documento | `docs/workflow-producao/CONTRATO-DOCUMENTAL.md` (protocolo de elaboração visível) |
| Fundar ou mudar intenção | `docs/workflow-producao/templates/REQUIREMENT-ZERO.MD`, `docs/workflow-producao/templates/requirement-NNNN.md` |
| Constituir repositório ou baseline | `docs/workflow-producao/BASELINE-METODO.md`, `docs/workflow-producao/templates/CONSTITUICAO-REPOSITORIO.md` |
| Decisão arquitetural | `docs/workflow-producao/templates/PREFLIGHT-ADR.md` |
| Especificar ou delegar | `docs/workflow-producao/ADAPTACAO-SPECKIT.md`, `docs/workflow-producao/templates/PONTE-SPECS-TAREFAS.md`, `docs/workflow-producao/templates/RATIFICACAO-DOCUMENTAL.md` |
| Alterar prompt, skill, MCP ou adaptador | `docs/workflow-producao/BASELINE-METODO.md`, `docs/workflow-producao/templates/CAPACIDADES-INTEGRACOES.md` |
| Abrir PR, integrar ou liberar | `docs/workflow-producao/templates/ENTREGA-APRENDIZADO.md` (registro DEL) |
| Passar ou retomar sessão | `docs/workflow-producao/MEMORIA-SESSOES.md`, `docs/workflow-producao/templates/CHECKPOINT-SESSAO.md`, `docs/workflow-producao/templates/REGISTRO-PASSAGEM.md` |

## 3. Fronteiras (resumo; a fonte é `AGENTS.md`, seção Fronteiras)

- Não preencher aprovação humana, não gerar documentação em silêncio, não tratar
  merge como ratificação genérica.
- Não criar repositório, publicar, conceder acesso, instalar skills ou MCPs, nem
  habilitar CI com base só num template.
- Toda elaboração documental é mostrada no chat antes de virar arquivo.

## 4. O que ainda não existe

Hook de compactação, recuperação automática de sessão e a integração com o
Specify não estão implementados; o piloto do Spec Kit não está autorizado. Não
afirme o contrário. Este plugin não instala hooks nem executa nada.
