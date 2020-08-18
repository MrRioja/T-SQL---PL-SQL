-- A)	Quando uma inserção ocorrer, o campo Info guarde “Novo usuário adicionado”, e o campo Nome e 
-- Senha guarde os valores que acabaram de ser inseridos. Neste caso, o campo Tipo deve receber valor 1.

CREATE OR ALTER TRIGGER TG_Cria_Novo_Usuario
	ON RegistroCompleto
	INSTEAD OF INSERT
	AS
	BEGIN
	DECLARE @NOME VARCHAR(30), @SENHA VARCHAR(30)

	SELECT @NOME = NOME, @SENHA = SENHA
	FROM inserted

	INSERT INTO RegistroCompleto
		(info, tipo, nome, senha)
	VALUES
		('Novo usuário adicionado', 1, @NOME, @SENHA);
END;

--B)	Quando um DELETE ocorrer, deve se guardar os valores deletados e um texto “Usuário deletado”. 
--Neste caso, o campo Tipo deve receber valor 3. 

CREATE OR ALTER TRIGGER TG_Apaga_Usuario
	ON RegistroCompleto
	FOR DELETE
	AS
	BEGIN
	DECLARE @NOME VARCHAR(30), @SENHA VARCHAR(30)

	SELECT @NOME = NOME, @SENHA = SENHA
	FROM deleted

	INSERT INTO RegistroCompleto
		(info, tipo, nome, senha)
	VALUES
		('Usuário deletado', 3, @NOME, @SENHA);
END;

--C)	Quando um UPDATE ocorrer, duas linhas devem ser inseridas no registro:
--	1 -	A primeira linha com os valores antigos nos campos nome e senha e texto “usuário antes”. O campo Tipo deve receber valor 2.
--	2 -	A segunda com os valores novos nos campos nome e senha e o texto “usuário depois” no campo texto. O campo Tipo deve receber valor 2.

CREATE OR ALTER TRIGGER TG_Atualiza_Usuario
	ON RegistroCompleto
	INSTEAD OF UPDATE
	AS
	BEGIN
	DECLARE @NOME_OLD VARCHAR(30), @SENHA_OLD VARCHAR(30)
	DECLARE @NOME_NEW VARCHAR(30), @SENHA_NEW VARCHAR(30)

	SELECT @NOME_OLD = NOME, @SENHA_OLD = SENHA
	FROM deleted
	SELECT @NOME_NEW = NOME, @SENHA_NEW = SENHA
	FROM inserted

	INSERT INTO RegistroCompleto
		(info, tipo, nome, senha)
	VALUES
		('Usuário antes', 2, @NOME_OLD, @SENHA_OLD);

	INSERT INTO RegistroCompleto
		(info, tipo, nome, senha)
	VALUES
		('Usuário depois', 2, @NOME_NEW, @SENHA_NEW);
END;

-- 2)	Usando o banco acima, altere o gatilho de inserção para checar se a senha do usuário 
-- tem pelo menos 8 caracteres antes de permitir a inserção de tal usuário. 
-- Se a senha tiver pelo menos 8 dígitos, a inserção é aceita, senão, barre a inserção 
-- e apresente uma mensagem de erro para o usuário. Para saber o tamanho de uma string em T-SQL, 
-- use o comando LEN(). Ex. Len(‘teste’) resulta em 5.

CREATE OR ALTER TRIGGER TG_Cria_Novo_Usuario
	ON RegistroCompleto
	INSTEAD OF INSERT
	AS
	BEGIN
	DECLARE @NOME VARCHAR(30), @SENHA VARCHAR(30)

	SELECT @NOME = NOME, @SENHA = SENHA
	FROM inserted

	IF LEN(@SENHA) >= 8 
			INSERT INTO RegistroCompleto
		(info, tipo, nome, senha)
	VALUES
		('Novo usuário adicionado', 1, @NOME, @SENHA);
		ELSE
			PRINT 'A senha deve conter no mínimo 8 caracteres.';
END;	

-- 3) Faça o gatilho de inserção de modo que: quando uma cobrança no débito é realizada, 
-- o gatilho seja ativado para colocar a data correta na tabela Debito e atualizar o saldo na tabela ContaCorrente. 
-- Utilize IDENTITY para os campos ContaCorrente.Numero e Debito.Codigo.
-- O campo Data deve ser do tipo DATETIME e a função getdate() retorna a data atual do servidor no formato DATETIME.	

CREATE TABLE ContaCorrente
(
	Numero INT IDENTITY(1,1) PRIMARY KEY,
	Nome VARCHAR(100),
	Saldo DECIMAL(10,2)
);

CREATE TABLE Debito
(
	Codigo INT IDENTITY(1,1) PRIMARY KEY,
	NumeroConta INT FOREIGN KEY REFERENCES ContaCorrente(Numero),
	Data DATETIME,
	Valor DECIMAL(10,2)
);

CREATE OR ALTER TRIGGER TG_Atualiza_Saldo
	ON Debito
	INSTEAD OF INSERT
	AS
	BEGIN

	DECLARE @NumeroConta INT, @Data DATETIME, @Valor DECIMAL(10,2)

	SELECT @NumeroConta = NumeroConta, @Data = getdate(), @Valor = Valor
	FROM inserted

	UPDATE ContaCorrente SET Saldo = (Saldo - @Valor) WHERE Numero = @NumeroConta

	INSERT INTO Debito
		(NumeroConta, Data, Valor)
	VALUES
		(@NumeroConta, @Data, @Valor)
END;