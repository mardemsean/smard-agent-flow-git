# Preflight — [Requisito e decisão em exame]

**Elaboração no chat:** [origem, conteúdo/revisão apresentados e pendências;
seguir o protocolo do contrato documental, sem presumir ciência ou concordância]

**Requisito e revisão:** [...]
**Estado:** [investigação | pronto para decisão | retorno à exploração]
**Responsável / autoridade decisória:** [...]

O preflight antecede o compromisso arquitetural. A parte ADR só é preenchida
quando houver uma decisão relevante a registrar. Se houver várias decisões
independentes, criar registros separados, com referências ao preflight comum.

## 1. Decisões candidatas e restrições

**Decisão em exame e por que precisa ocorrer agora:** [...]
**Forças e restrições reais, com origem:** [...]
**Escolhas provisórias herdadas de protótipos:** [...]
**O que pode continuar aberto ou reversível:** [...]

| Opção | Benefício | Custo e desvantagem | Evidência / lacuna | Reversibilidade |
| --- | --- | --- | --- | --- |
| [incluir adiar ou não mudar, se plausível] | [...] | [...] | [...] | [...] |

## 2. Antecipação de falhas e passagem do tempo

**Risco que justifica esta análise:** [...]
**Método:** [premortem, experimento, modelo, cenário narrativo ou combinação]

| Horizonte / cenário | Premissas e procedimento | Consequências previstas | Evidência disponível | Sinal de invalidação / resposta |
| --- | --- | --- | --- | --- |
| [horizonte escolhido por motivo explícito] | [...] | [...] | [...] | [...] |

**O que o método não demonstra:** [...]
**Teste empírico necessário antes do compromisso:** [ou justificativa de dispensa]
**Risco residual e aceite por autoridade identificada:** [...]
**Gatilho, responsável e momento de reavaliação:** [...]

Não descrever previsões como fatos futuros. Pareceres de agentes compartilham
possíveis vieses; concordância entre eles não prova independência da evidência.

## 3. Resultado do preflight

**Encaminhamento:** [decidir | experimentar | rever requisito | voltar à exploração]
**Lacunas que impedem a decisão:** [...]
**Razão e autorização para avançar:** [referência recuperável ou pendente]

---

# ADR-[NNNN] — [Decisão, quando cabível]

**Discussão desta decisão no chat:** [opções e consequências apresentadas,
discordâncias e resposta efetiva; apresentação do preflight não é aceite do ADR]

**Estado:** [proposto | aceito | rejeitado | substituído | depreciado]
**Data / revisão:** [...]
**Decisores e registro de aceite:** [ou pendente]
**Requisito, revisão e preflight:** [...]
**Substitui / substituído por:** [...]

## Contexto

[Forças relevantes e referências às evidências; não duplicar todo o preflight.]

## Decisão e alternativas

[O que foi escolhido, alternativas consideradas e por que os trade-offs foram
aceitos. Não justificar uma escolha apenas porque já está no protótipo.]

## Consequências

**O que melhora / o que fica mais difícil:** [...]
**Efeitos sobre dados, operação, custo e evolução:** [...]
**Reversão, migração e limitações:** [...]
**Condições de reavaliação e responsável:** [...]

## Continuidade

**Specs e critérios afetados:** [...]
**Ações de implementação e verificação:** [referências, não segunda lista divergente]

Alterar uma decisão aceita exige registro explícito de revisão ou substituição,
sem apagar a razão histórica da escolha anterior.
