# Recibo de ratificação — [Iniciativa / documento / revisão]

**Estado:** [proposta | apresentado | aguardando resposta | ratificado | rejeitado | pausado | superado]
**Regras de transição de estado:**
- `proposta -> apresentado`: exige preenchimento completo da seção 1 (`SHA-256` dos bytes gravados) e da seção 2 (exposição no chat).
- `apresentado -> aguardando resposta`: exige pedido de decisão isolado no chat.
- `aguardando resposta -> ratificado | rejeitado | pausado`: exige seção 3 preenchida com estado `recebida` e referência/hash da resposta humana real (vedado ao agente marcar `ratificado` por conta própria).
- `ratificado -> superado`: exige registro abaixo do evento, ator e data que revogou ou substituiu esta revisão.
**Sessão / handoff de origem:** [identificador da sessão e checkpoint/handoff em que o recibo nasceu]
**Revogado ou superado por (se aplicável):** [evento, ator, data e novo recibo/revisão]
**Natureza:** registro de vínculo; não é aprovação gerada pelo agente.
**Elaboração no chat:** [origem, conteúdo apresentado e pendências]
**Política aplicável e autoridade requerida:** [...]

## 1. Conteúdo candidato

| Documento | Snapshot recuperável / revisão (ou localização pré-repo se ZERO inicial) | Digest `SHA-256` (bytes exatos gravados, sem normalização) | Codificação e quebra de linha (`UTF-8`, `LF` ou `CRLF`) | Fonte/procedência |
| --- | --- | --- | --- | --- |
| [...] | [...] | [...] | [...] | [...] |

**Contexto Git, se houver:** [repo, branch, HEAD e alterações locais relevantes; se o candidato do ZERO nasceu antes de existir repositório, indicar caminho local do snapshot]
**Escopo da proposta e exclusões:** [...]
**Decisões/interpretações acrescentadas pelo agente:** [...]
**Divergências e perguntas abertas:** [...]

Não usar HEAD sozinho para identificar arquivo modificado ou não rastreado.
O algoritmo é obrigatoriamente `SHA-256` sobre os bytes exatos armazenados em
disco, sem normalização de fim de linha, registrando `LF` ou `CRLF` para evitar
divergência por `core.autocrlf` no Windows. A exploração pré-repositório (nó A)
é livre e não exige este recibo; ele começa quando um documento candidato passa
a ser redigido e submetido a compromisso. Este recibo fica fora dos bytes cujo
digest registra. Não preencher hash fictício.

## 2. Apresentação

**Evento/canal e referência recuperável:** [...]
**Conteúdo efetivamente exposto no chat:** [...]
**Acesso ao texto completo e restrições:** [nota: `show_file` do Spec Kit corta em 200 linhas e não lê em modo sem TTY; nunca substitui apresentação no chat]
**Seções pendentes, truncadas ou ainda não discutidas:** [...]
**Origem da evidência:** [evento observável, declaração do agente ou conferência assistida]

Não afirmar leitura ou compreensão humana a partir de apresentação.
Limitação da interface de rastreio deve ser explicitada, não preenchida por suposição.

## 3. Manifestação humana

**Estado da resposta:** [ainda não recebida | recebida]
**Referência da resposta real, data e canal:** [...]
**Vínculo verificável da resposta (privado):** [digest `SHA-256` do texto exato da resposta humana + timestamp, guardado em armazenamento privado autorizado, sem copiar mensagem privada para documento público]
**Identidade/papel e como a origem foi verificada:** [...]
**Quem executou o comando de retomada no motor (se aplicável):** [exclusivamente o operador humano; é proibido ao agente executar `specify workflow resume --input ...=approve`]
**Decisão e ressalvas:** [somente o que foi efetivamente manifestado]
**Classificação de eventual edição posterior:** [toda mudança pós-ratificação é `material` por padrão; só pode ser marcada `editorial` por declaração expressa do humano]
**Documentos/revisões abrangidos e regra de lote:** [em caso de lote, a rejeição ou correção de um item suspende os demais itens dependentes do lote, salvo autorização humana expressa para avanço parcial]
**Ação/segmento autorizado e limites:** [...]
**Condições de validade, reconsideração ou revogação:** [...]

Silêncio, CI verde, approve fornecido pelo agente e merge não substituem resposta.
Referenciar conteúdo privado sem copiá-lo a local público. Na ausência de
manifestação verificável, não marcar ratificado.

## 4. Conferência de uso e vínculo com o motor

**Ação dependente / ocorrência do workflow:** [...]
**Vínculo com a corrida do motor (quando houver Spec Kit):**
- `run_id`: [...]
- `step_id` do gate / verificador: [...]
- Nome do `verdict_input`: [...]
- Comando de retomada executado pelo humano e estado de saída: [...]
**Validação prévia do workflow (`specify workflow validate`) e `on_reject: abort` conferidos:** [sim | não aplicável]
**Revisões/digests `SHA-256` atuais conferidos e momento:** [...]
**Mandato, autoridade e pendências conferidos:** [...]
**Como evitar troca dos bytes entre conferência e uso:** [apontar `show_file` e despacho para o caminho do snapshot imutável referenciado na seção 1]
**Resultado:** [apto somente para escopo declarado | impedir ação com motivo]
**Nível de garantia:** [`assistido` (bloqueia estruturalmente `implement`, `merge`, `deploy` e `publish`) | `controle independente`, com mecanismo comprovado]
**Limites e riscos residuais:** [...]

Hash comprova identidade de bytes, não consentimento. Se o executor pode editar
a única prova de aceite, não alegar controle independente. Um recibo vinculado a
um `run_id` e `step_id` não pode ser reaproveitado em outra corrida ou etapa.
Uma conferência concluída antes de pausa não dispensa reconferir o conteúdo
imediatamente após o gate e antes de utilizá-lo.
