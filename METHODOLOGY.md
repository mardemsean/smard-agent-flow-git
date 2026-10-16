# Metodologia — da inquietação à produção

**Estado:** desenho autorizado para elaboração; detalhes operacionais permanecem
propostos quando não houver decisão explícita.
**Escopo:** este laboratório desenvolve o método; sua infraestrutura não constitui
automaticamente o produto que uma exploração futura poderá originar.
**Origem:** diálogo de 2026-10-16 sobre continuidade entre criação, especificação
e entrega. A autorização para prosseguir não ratifica escolhas técnicas futuras.

## Intenção

Acompanhar o humano desde uma inquietação ainda sem linguagem até os efeitos de
software em uso. Articular exploração criativa, desenvolvimento orientado por
especificações e execução orientada por tarefas sem reduzir a pessoa a
fornecedora de briefing, supervisora de comandos ou aprovadora de merges.

## Ciclo e entradas

Exploração e ideação ↔ prototipagem → síntese da intenção → preflight e
simulações proporcionais ao risco → decisões e specs → tarefas sob mandato →
implementação e PR → revisão e merge → entrega → observação e nova exploração.

Não é uma sequência obrigatória de cerimônias. Pode-se começar adiante quando
há maturidade e evidência suficientes; retornar, incubar ou não construir são
desfechos legítimos. O nascimento do repositório é independente da maturidade
da intenção. Nome de produto, repo e branch não são requisitos para pensar.

O [workflow canônico](docs/workflow-producao/WORKFLOW.md) contém a árvore de
decisões, estados, critérios de passagem, posição do humano e contrato de
integração com GitHub. Este arquivo é sua porta de entrada, não outra definição
concorrente do ciclo.

## Documentos que acompanham o amadurecimento

O `REQUIREMENT-ZERO.MD` funda e acompanha a intenção do produto entre exploração
e formalização. Os `requirement-NNNN.md` representam mudanças posteriores,
inclusive propostas de emenda ao fundamento. ADRs registram decisões materiais;
specs estabelecem contratos verificáveis; tarefas organizam execução, não
substituem intenção nem verificação.

O [contrato documental](docs/workflow-producao/CONTRATO-DOCUMENTAL.md) é a fonte
dos gatilhos, responsabilidades e evidências. O agente explicita cada documento
no chat antes de redigir e apresenta conteúdo substantivo depois. Rascunho,
apresentação, resposta humana e ratificação são estados diferentes.

## Infraestrutura e executores

O método, suas regras, prompts e templates podem existir num workspace anterior
ao repositório do produto. A [baseline](docs/workflow-producao/BASELINE-METODO.md)
define sua incorporação proporcional. Ferramentas específicas recebem adaptadores,
não versões concorrentes da política.

Spec Kit ou outro executor poderá receber requisitos e decisões amadurecidos e
devolver specs, planos, tarefas e evidências. A rota técnica e a versão ainda
precisam ser verificadas; este desenho não instala nem modifica o executor.

## Evolução do próprio método

Mudanças seguem as [regras](RULES.md), com discussão visível e procedência.
Experiência de uso pode justificar simplificação ou revisão. Não converter
templates vazios, etapas cumpridas ou volume documental em medida de maturidade.
Papéis reais, limites de autonomia, executor e políticas remotas de integração
continuam dependentes de decisões contextualizadas.
