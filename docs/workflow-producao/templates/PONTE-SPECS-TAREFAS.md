# Ponte de execução — [Requisito / iniciativa]

**Elaboração no chat:** [origem, conteúdo/revisão apresentados e pendências;
seguir o protocolo do contrato documental, sem presumir ciência ou concordância]

**Estado:** [proposta | autorizada | suspensa | concluída]
**Requisito e revisão ratificada:** [...]
**ADRs aplicáveis:** [ou motivo de não serem necessários]
**Executor escolhido:** [Spec Kit, OpenSpec ou outro; versão/configuração relevante]
**Specs e tarefas canônicas:** [referências nativas, sem duplicá-las aqui]
**Responsável humano e agente executor:** [...]

## 1. Mapa da intenção ao contrato verificável

| Compromisso / limite do requisito | Spec e critério estável | Forma de verificação | Tarefa canônica |
| --- | --- | --- | --- |
| [...] | [...] | [teste automatizado, inspeção ou observação justificada] | [...] |

**Compromissos ainda sem cobertura:** [bloqueio ou justificativa e aceite]
**Comportamentos incluídos na spec sem origem no requisito:** [justificar ou remover]
**Conflitos que retornam ao preflight/requisito:** [...]

As specs definem o comportamento e a qualidade esperados; tarefas organizam
a execução. Um checklist de tarefas concluído não substitui critérios atendidos.
Cada documento nativo gerado pelo executor também precisa ser explicitado no
chat. Apresentar somente esta ponte não torna visíveis escolhas ocultas nas specs,
planos ou tarefas; dúvidas materiais retornam ao diálogo antes da execução afetada.

## 2. Mandato de autonomia

**Resultado e condição de encerramento:** [...]
**Escopo de código e dados autorizado:** [...]
**Escolhas locais delegadas:** [...]
**Decisões reservadas:** [...]
**Ações com efeitos externos permitidas:** [específicas; ausência não é permissão]
**Limites de tempo, custo e tentativas:** [...]
**Checkpoints combinados:** [por evento ou marco; evitar supervisão por comando]
**Interromper quando:** [conflito, risco material, mudança de escopo ou limite]
**Forma do relato:** [resultado, evidência, pendência decisória; não fluxo de logs]
**Autorização do mandato:** [autoridade, data e revisão; ou pendente]

Este mandato não contorna permissões da ferramenta, do ambiente ou do repositório.
Autorizar execução não equivale a autorizar merge ou deploy.

## 3. Organização da execução e revisão

**Dependências entre tarefas:** [referência ao executor]
**Fatias de PR e sua justificativa:** [...]
**Checks aplicáveis e evidência manual necessária:** [...]
**Revisores e decisões de aceitação necessárias:** [...]
**Destino de código exploratório reaproveitado:** [revisão e adequação necessárias]
**Entrega, observação e recuperação:** [referência ao registro de entrega]

## 4. Mudanças durante a execução

**Descoberta e impacto:** [...]
**Tratamento:** [ajuste local autorizado | revisão da spec | novo ADR | rever requisito]
**Revisões afetadas e nova autorização, se necessária:** [...]

Não ampliar o contrato silenciosamente para justificar o que o agente construiu.
