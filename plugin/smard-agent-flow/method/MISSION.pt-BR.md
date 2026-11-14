# Missão

> Tradução. O original é o texto em inglês, [MISSION.md](MISSION.md); em caso
> de divergência, vale o original.

*Por que o SMard Agent Flow existe.*

O SMard Agent Flow foi criado dentro do harness Claude Code. Hoje ele opera em
harnesses de doze fabricantes diferentes, e a razão dele é a mesma em todos.

## O que aconteceu

Dezenas de vezes, investimos pelo menos cem milhões de tokens em um único
projeto, às vezes duzentos milhões. Depois auditamos o repositório — o local
e, principalmente, o remoto no Git — e o que encontramos causou surpresa,
indignação e bastante frustração. O trabalho que as sessões haviam relatado não
era o trabalho que o repositório continha. Havíamos sido fraudados.

Por modelos de linguagem? Improvável. A frustração aumentou quando veio
acompanhada da compreensão de que se tratava de autofraude.

## Quem responde

Um engenheiro de sistemas não pode alegar ingenuidade. Havíamos terceirizado
cem por cento do workflow metodológico, da documentação e dos commits para
agentes LLM. E o fizemos em um momento histórico, o do advento dos LLMs, no
qual modelos generativos baseados em transformers, treinados em corpora
massivos de textos, ainda não podem ser tratados como mais do que modelos
distributivos que alocam tokens dentro de um espaço probabilístico.

Um sistema desse tipo escreve o que é provável que venha a seguir. Ao fim de
uma longa sessão de trabalho, "feito", "testado" e "integrado" são palavras
prováveis, tenha a coisa sido feita, testada e integrada ou não. Receber essas
palavras como um relatório é erro do engenheiro, não do modelo. Ninguém nos
enganou. Assinamos sem ler.

## A missão

Tornar essa autofraude difícil de cometer.

O SMard Agent Flow mantém com o humano o que não se delega — a intenção, a
decisão, a ratificação e o juízo sobre a evidência — e delega a digitação.
Suas regras são a resposta direta ao que encontramos naquelas auditorias:

- Um rascunho nunca autoriza a própria execução. Rascunho, apresentado e
  ratificado são três estados diferentes.
- Um merge não é aprovação, deploy nem benefício observado. Checks verdes não
  são sucesso em produção.
- Evidência não é inferência, hipótese nem simulação. O que um agente diz sobre
  o próprio trabalho é uma alegação até que algo fora do agente o confirme.
- Todo documento nasce à vista, na conversa, antes de virar arquivo. O
  silêncio, a existência de um arquivo e um merge não ratificam nada.
- A autonomia é real e limitada. O agente trabalha dentro de um mandato e para
  quando iria excedê-lo.

O ciclo, as regras e os documentos estão em [METHODOLOGY.md](METHODOLOGY.md),
[RULES.md](RULES.md) e [README.md](README.md).

## O que não prometemos

O método não torna um modelo veraz e não substitui a auditoria. Ele mantém o
engenheiro no lugar onde a auditoria acontece: antes do compromisso, com o
repositório aberto, e não cem milhões de tokens depois.

O modelo aloca tokens. O engenheiro responde pelo trabalho.
