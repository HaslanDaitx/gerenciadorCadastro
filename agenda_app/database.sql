CREATE TABLE cadastro (
    codigo INTEGER PRIMARY KEY,
    descricao TEXT NOT NULL CHECK (descricao <> '' AND length(descricao) > 0),
    CONSTRAINT check_codigo_positivo CHECK (codigo > 0)
);

CREATE TABLE log_operacoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    operacao TEXT NOT NULL,
    data_hora TEXT NOT NULL
);

CREATE TRIGGER log_insert AFTER INSERT ON cadastro
BEGIN
    INSERT INTO log_operacoes (operacao, data_hora)
    VALUES ('Insert', datetime('now', 'localtime'));
END;

CREATE TRIGGER log_update AFTER UPDATE ON cadastro
BEGIN
    INSERT INTO log_operacoes (operacao, data_hora)
    VALUES ('Update', datetime('now', 'localtime'));
END;

CREATE TRIGGER log_delete AFTER DELETE ON cadastro
BEGIN
    INSERT INTO log_operacoes (operacao, data_hora)
    VALUES ('Delete', datetime('now', 'localtime'));
END;