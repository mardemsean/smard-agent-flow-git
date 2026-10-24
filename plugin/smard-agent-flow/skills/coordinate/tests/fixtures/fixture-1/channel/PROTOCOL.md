# HANDSHAKE PROTOCOL v1
- Each session has a card cards/<cse_>.json (schema harness/handshake-de-sessao/v1). Only the owning session edits its card.
- Messages: messages/NNNN__de-<X>__para-<Y>.md, YAML header (de, para, em_resposta_a, assunto, data_utc, cse_autor), body <= 40 lines.
- Minutes: minutes/ATA-NNNN.md, written by the coordinator or its loop.
- NOTHING IS DELETED, OVERWRITTEN OR RENAMED. Divergences go in a message.
- Evidence before claims: path + command + output.
