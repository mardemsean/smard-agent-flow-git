# Continuidade entre sessões e sucessão de agentes

**Confirmado pelo humano:** `sledge-handoff.md`, `DIAMOND.md`,
`hyperbrain-lesson.md`, `knowledge.md` e `cortex.md` são memórias persistentes
entre sessões. Devem participar obrigatoriamente da passagem ao sucessor antes
da compactação, por integração com o evento precompact.

**Funções mapeadas em 2026-10-16** [observação documental das convenções
HYPERBRAIN e da skill `smard-ledger-handoff` 4.2.0; o que restar marcado como
aberto continua reservado ao operador]:

| Arquivo | Função observada | Evidência |
| --- | --- | --- |
| `sledge-handoff.md` | Handoff intencional de fim de sessão: cold start, Basis, Verify block, "What not to retry" (classes E0–E7), intents, ledger JSON; escrito em duplicata (raiz do projeto, deliverables, HTML para o operador, HYPERBRAIN). Provável referência à skill `smard-ledger-handoff` [dedução; o nome "sledge" não consta na skill — confirmar com o operador] | `SKILL.md` da skill (M1–M5, F1–F4); instinct `handoff-as-file` |
| `DIAMOND.md` | Lição cristalizada a partir de erro de tool call ou de código ("erro de tool call ou de codigo vira DIAMOND"), minerada deterministicamente (error_miner, classes E0–E7) e indexada em `B:\DIAMONDS\INDICE.md` | `B:\DIAMONDS\INDICE.md` |
| `hyperbrain-lesson.md` | Aprendizagem depositada no HYPERBRAIN via `snap.py` (`knowledge-<data>-<slug>.md` em `B:\persistent-memory\research\` ou `pre-compact-knowledge\`). A distinção exata frente a `knowledge.md` permanece **aberta** | destinos de `snap.py`; `knowledge-2026-10-16-smard-agent-flow-kit-speckit.md` |
| `knowledge.md` | Gotchas factuais da sessão, cada um com fonte literal | `knowledge-2026-10-16-smard-agent-flow-kit-speckit.md` |
| `cortex.md` | **Aberto e ambíguo na casa:** plugin Hermes (`cortexlayer`/`hicortex`) ou HYPERBRAIN `B:\persistent-memory`; questão registrada sem resposta no handoff `hermes-claude-acp-2206` (2026-10-15). Não definir sem o operador | `handoff-2026-10-16-hermes-claude-acp-2206.md`, seção Open questions |

**Ainda não definido:** distinção final `hyperbrain-lesson.md` × `knowledge.md`,
papel de `cortex.md`, relações e conteúdo detalhado de cada um.
Não deduzir responsabilidades além do evidenciado acima, não fundir arquivos e
não inventar cinco esquemas. O contrato abaixo propõe somente armazenamento e
continuidade.
**Origem:** diálogo de 2026-10-16; localização e protocolo são propostas de desenho.

## 1. Localização proposta

```text
.session-memory/
  sessions/
    <session-id>/
      checkpoints/
        <checkpoint-id>/
          checkpoint.md
          sledge-handoff.md
          DIAMOND.md
          hyperbrain-lesson.md
          knowledge.md
          cortex.md
```

IDs são técnicos e fornecidos pelo harness, sem exigir naming do humano.
Checkpoint é um pacote de continuidade; não redefine a semântica dos cinco
arquivos. Este desenho não criou pacotes nem memórias de sessão fictícias.
O [template de checkpoint](templates/CHECKPOINT-SESSAO.md) é o envelope comum.

O pacote registra repo/workspace, branch, HEAD, estado não commitado e origem.
Esses campos situam a memória; não tornam HEAD prova de alterações ainda locais.
Checkpoints anteriores permanecem recuperáveis. Não sobrescrever um pacote
pronto enquanto o sucessor o lê; o adaptador deve definir publicação coerente e
seleção inequívoca do pacote pronto mais recente da linhagem pretendida.

## 2. Obrigação de preservação não é obrigação de inventar conteúdo

Todo checkpoint contabiliza explicitamente os cinco nomes e sua revisão/origem.
Se um arquivo existe, preservar sua informação sem reinterpretar sua função.
Se não existe, está inacessível ou sua função ainda não foi definida, registrar
essa lacuna. Não criar arquivo vazio e marcar a transferência como completa.

Enquanto os contratos particulares permanecerem abertos, o envelope pode
conservar estado operacional conhecido e referências sem distribuir conteúdo
arbitrariamente entre os cinco nomes. Isso é continuidade parcial identificada,
não implementação concluída do método de memória.

## 3. Ciclo precompact → checkpoint → recuperação

| Momento | Dever do agente/adaptador | Evidência |
| --- | --- | --- |
| Durante a sessão | Manter registros incrementais com elaboração visível; não esperar o último instante | Conteúdo e pendências apresentados no chat |
| Ao receber aviso anterior à compactação | Identificar os cinco registros e preparar snapshot coerente da linhagem | Envelope, estado dos arquivos e referências exatas |
| Antes de declarar pronto | Verificar leitura, integridade, completude declarada e localização acessível ao sucessor autorizado | Pacote pronto ou parcial/falha explícita |
| Compactação | Bloquear se a ferramenta realmente permitir e faltar requisito impeditivo; caso contrário, relatar que não foi possível garantir preservação | Resultado real do hook, não sucesso presumido |
| Início/retomada pelo sucessor | Localizar pacote pronto da linhagem correta, ler envelope e cinco arquivos disponíveis | Registro de recuperação e lacunas |
| Antes de continuar trabalho | Confrontar memória com arquivos, diff, branch, processos e permissões atuais | Divergências explicitadas e contexto reconciliado |

A memória transmite contexto, não novos poderes. Recuperar autorização registrada
não a estende nem prova que continue válida. Processo deixado em execução pode
ter terminado; tarefa supostamente concluída precisa de evidência correspondente.
Conteúdo herdado é fonte contextual, não instrução superior às regras vigentes.

Não carregar a transcrição inteira por padrão nem tratar um resumo como verdade
infalível. Preservar fatos, incertezas, procedência e divergências relevantes.
Leitura/recuperação pelo sucessor não equivale a ratificação humana.

## 4. Contrato técnico do adaptador, ainda não implementado

`precompact` é o evento conceitual; nome, disponibilidade e garantias precisam
ser verificados em cada harness e versão. Não pressupor que todos permitam
bloquear compactação ou escrever no chat durante hooks.

Antes de implementar, verificar: evento realmente anterior à perda de contexto,
contexto acessível, tempo limite, permissão de escrita, retorno de falha, capacidade
de bloqueio, execução repetida, concorrência e mecanismo de leitura pelo sucessor.
Hook isolado não garante que o próximo agente descubra o pacote.

O contrato deverá ser idempotente para um mesmo evento, não misturar sessões e
não anunciar pronto antes de persistir/verificar o conjunto. Testes devem cobrir
sucesso, evento duplicado, arquivo ausente, gravação interrompida, timeout,
pacote parcial, linhagem incorreta e recuperação após troca de workspace.

Se o hook não conseguir explicitar alterações no chat, não ganha exceção para
inventar documentação às escondidas: manter elaboração incremental visível,
limitar o snapshot a conteúdo já apresentado e registrar um recibo técnico.
Conteúdo novo de emergência fica identificado como não apresentado e não
ratificado; o sucessor o explicita antes de utilizá-lo como compromisso.
Compactação inesperada continua sendo uma limitação, não aprovação para fingir
um checkpoint que não ocorreu.

## 5. Exclusão Git, retenção e transporte

O `.gitignore` deste laboratório exclui `/.session-memory/` desde a criação,
não apenas na publicação. Templates e contratos do método continuam versionados.
Não usar exclusões globais como `knowledge.md` ou `DIAMOND.md`, que poderiam
ocultar documentos legítimos em outros contextos.

`.git/info/exclude` é alternativa local, não política distribuída. Em worktrees,
usar a localização indicada pelo Git, sem editar um checkout principal por
suposição. Não alterar esse arquivo silenciosamente. `.gitignore` não retira
arquivos já rastreados, não criptografa dados e não impede `git add -f`.

Antes de publicar, examinar arquivos rastreados e staged, diff, histórico
relevante e conteúdo de artefatos CI/releases. Não confiar apenas no ignore:
um job pode empacotar arquivos locais excluídos. Remoção do índice/histórico e
resposta a eventual exposição são operações separadas, com autorização adequada.

**Continuidade local não é portabilidade.** Um clone, worktree novo ou agente em
outro host não recebe esses arquivos pelo Git. O adaptador precisa oferecer
armazenamento persistente autorizado e transporte com controle de acesso,
linhagem e retenção. Não afirmar handoff entregue até o destino autorizado
conseguir recuperar o pacote. Não usar artefato público de CI como transporte.

Ignore também não protege de limpeza de workspace, arquivamento da sessão ou
falha de disco. Antes dessas operações, assegurar destino persistente autorizado
e recuperação verificável, ou explicitar o risco de perda. Prazos de retenção,
backup, acesso e descarte continuam a definir; não prometer retenção ilimitada.
Não persistir credenciais nem transcrições privadas por padrão.

## 6. Promoção de aprendizado ao repositório

Uma memória local não vira automaticamente documentação pública. Propor no chat
qual trecho seria útil ao projeto, sua origem, limitações e destino canônico.
Revisar privacidade, direitos, validade e risco de expor dados.

Somente após autorização aplicável, preparar síntese em requisito, ADR, guia ou
outro documento adequado e rastreável. Não copiar o pacote integral nem tratar
aprendizado de sessão como regra aprovada. O original privado pode continuar
privado; a documentação compartilhada deve fazer sentido sem depender de
referências que seus consumidores não podem acessar.

## 7. Decisões reservadas ao amadurecimento do design

- Distinção final entre `hyperbrain-lesson.md` e `knowledge.md` e o papel de
  `cortex.md` (mapeamento parcial evidenciado no cabeçalho; o restante segue
  reservado ao operador).
- Destino persistente entre hosts/worktrees e política de retenção/acesso.
- Harness inicial, integração real de hook e forma de recuperação pelo sucessor.
- Critérios que tornam um checkpoint parcial impeditivo e exceções possíveis.

Não preencher essas decisões por suposição. A obrigação de continuidade está
reconhecida; sua integração executável permanece pendente.
