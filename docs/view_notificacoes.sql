CREATE OR REPLACE VIEW view_notificacoes AS
SELECT t1.id AS id,
       t1.id_remetente,
       t2.user_nome AS nome_remetente,
       t2.user_apelido AS apelido_remetente,
       t2.departamento AS departamento_remetente,
       t1.id_destinatario AS id_destinatario,
       t3.user_nome AS nome_destinatario,
       t3.user_apelido AS apelido_destinatario,
       t3.departamento AS departamento_destinatario,
       t1.titulo,
       t1.data_hora,
       t1.mensagem,
       t1.lido,
       t1.arquivado,
       t1.enviado,
       t1.origem
FROM notificacoes t1
JOIN usuarios t2 ON t2.user_id = t1.id_remetente
JOIN usuarios t3 ON t3.user_id = t1.id_destinatario
