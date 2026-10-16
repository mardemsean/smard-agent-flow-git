# Baseline metodológica e integrações

**Estado:** proposta operacional do desenho autorizado para elaboração.
**Origem:** discussão de 2026-10-16 sobre documentos de governança, instruções
de agentes e adaptação de executores. Não comprova implantação de ferramentas.

## 1. Infraestrutura antes do produto

O método pode viver num workspace ou repositório próprio, com regras, prompts
e templates. Isso não obriga uma pessoa em exploração a criar repo, nomear
produto ou decidir branches. Um produto maduro pode incorporar a infraestrutura
diretamente, preservando documentos e políticas preexistentes.

Neste laboratório os arquivos de entrada ficam na raiz. Num produto adotante,
seus caminhos devem ser definidos e indexados sem sobrescrever regras existentes.
Usar `AGENTS.md` com esta grafia como convenção do método; adaptar localização e
descoberta à ferramenta real, sem presumir que todas leiam o mesmo arquivo.

## 2. Três conjuntos, não um pacote exigido na primeira conversa

| Conjunto | Conteúdo | Gatilho |
| --- | --- | --- |
| Infraestrutura do método | METHODOLOGY, RULES, INDEX, biblioteca de prompts e templates | Adoção/implementação do método; reutilizável antes do repo do produto |
| Baseline do repo adotante | README contextualizado, entradas metodológicas ou referências canônicas, AGENTS quando houver execução delegada, inventário de aplicabilidade | Constituição/incorporação do repo e ativação das atividades pertinentes |
| Complementos condicionais | Adaptadores, skills, MCPs, CI, comunidade, licenças, publicação web, operação | Necessidade real e autorização correspondente; não mera presença no catálogo |

O índice é obrigatório como mapa da baseline documental deste método. Uma seção
com referências pode bastar numa adoção pequena, desde que seja fonte canônica
explicitamente identificada; não duplicar índice e inventários divergentes.

Biblioteca disponível não significa prompt executado. Template disponível não
significa documento de produto instanciado. Inventário proposto não significa
instalação. Cada documento continua sujeito à apresentação no chat.

## 3. Prompts, templates, skills e MCPs têm contratos diferentes

| Tipo | Define | Não demonstra por si |
| --- | --- | --- |
| Prompt | Como conduzir uma interação e que contexto usar | Capacidade instalada, consenso ou autorização externa |
| Template | Estrutura de registro, seus campos e gatilho | Preenchimento correto ou aprovação |
| Skill | Procedimento reutilizável, entradas, limites e evidências | Disponibilidade em toda ferramenta ou permissão para qualquer ação |
| MCP | Interface de ferramentas/recursos com acesso e efeitos definidos | Confiança irrestrita no servidor ou autorização de cada operação |
| Adaptador de agente | Descoberta, formato e encaminhamento para fontes canônicas | Política independente ou compatibilidade não testada |
| Executor de specs/tarefas | Tradução e execução de contratos com seu próprio formato | Poder para inventar intenção ou ratificar o próprio trabalho |

Registrar adoções no [inventário de capacidades](templates/CAPACIDADES-INTEGRACOES.md).
Usar fontes, versões e estados reais. Não catalogar como "instalado e autorizado"
algo apenas citado na conversa ou encontrado no ambiente.

## 4. Adaptadores e publicação para máquinas

`CLAUDE.md` é condicional à integração escolhida. Se adotado, deve encaminhar
às regras canônicas e acrescentar apenas particularidades verificadas da ferramenta,
incluindo escopo, descoberta e manutenção. Outros agentes podem precisar de outros
arquivos. Não criar todos preventivamente nem sobrescrever configuração existente.

Skills e MCPs não têm um caminho universal de instalação. Documentar escopo
(projeto, usuário, sessão ou outro suportado), origem, acesso, segredos por
referência segura, efeitos externos, instalação/remoção e responsável.

`llms.txt`, se adotado, orienta consumo da documentação publicada. `robots.txt`
expressa regras de rastreamento web. Não são intercambiáveis com AGENTS ou regras
de execução, não são controle de acesso e não precisam nascer num repo sem site.
Sua adoção exige finalidade e comportamento dos consumidores verificados.

## 5. Ponte futura com Specify / Spec Kit

O [preflight corrigido](ADAPTACAO-SPECKIT.md) documenta a inspeção posterior de
arquivos do snapshot local e a passagem proposta entre conversa, revisão,
ratificação e execução. Distingue evidência lida de decisão relatada e ainda
não confirma integridade do pacote, compatibilidade em execução ou instalação.
Em qualquer divergência entre este repositório e mapas externos anteriores (como
`PONTE-SPECS-TAREFAS--smard-agent-flow-kit.md`), prevalece o contrato de
[ADAPTACAO-SPECKIT.md](ADAPTACAO-SPECKIT.md).

O usuário trouxe as seguintes leituras condicionais do projeto como referência
de desenho. Elas precisam ser localizadas e verificadas na versão escolhida antes
de implementar qualquer integração:

| Superfície alterada | Leitura técnica indicada | Contrato a verificar |
| --- | --- | --- |
| CLI | Shared Command Application Architecture; Specify CLI Command Architecture | Fronteira compartilhada, registro, módulos e testes espelhados |
| MCP de comandos | Shared Command Application Architecture; Specify MCP Command Architecture | Tipos, inventário, efeitos e protocolo local |
| Integração de agente | Agent Integration Design | Rotas de entrega, formatos, registro, instalação e remoção |
| Passo de workflow | Workflow Step Design | Registro, validação, execução, retomada e pacotes |
| Comportamento determinístico | Testing deterministic behavior | Casos positivos/negativos e evidência de regressão |

Esses títulos foram inicialmente fornecidos na conversa. A inspeção posterior
registrada no preflight cobre parte dessas fontes; os demais contratos continuam
pendentes de leitura específica. Não há compatibilidade executável confirmada.

Antes de escolher extensão suportada, complemento externo ou modificação do
executor, registrar: versão e fonte; mecanismo disponível; entradas/saídas;
propriedade de arquivos gerados; retomada; remoção; testes; riscos de atualização.
Não duplicar a fonte nativa de specs e tarefas.

O contrato de integração deve preservar ZERO/requisitos como origem de intenção,
passar decisões e critérios rastreáveis e apresentar cada documento gerado no
chat. Geração automática não cria exceção ao diálogo nem autoriza execução de
compromisso não ratificado.

## 6. O que não foi ativado

Memória persistente e sucessão têm contrato próprio em
[MEMORIA-SESSOES.md](MEMORIA-SESSOES.md). Os cinco registros vivem, por proposta,
num espaço local excluído do Git. O evento precompact exige adaptador verificado;
nenhum hook ou transporte entre hosts foi ativado por esta baseline.

Esta baseline adiciona orientação documental. Não instala skills/MCPs, não cria
CLAUDE.md, llms.txt ou robots.txt, não habilita novos jobs, não altera regras
remotas e não implementa comandos do Specify. A necessidade e a autorização
dessas ações serão decididas quando seus gatilhos ocorrerem.
