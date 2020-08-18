CREATE TABLE usuario (
	Nome VARCHAR(20) PRIMARY KEY,
	Senha VARCHAR(20)
	)

CREATE TABLE Registro(
	Codigo INT IDENTITY(1,1),
	Info VARCHAR(100)
	)

--INSERT INTO usuario(Nome) VALUES ('Andre')
GO
ALTER TRIGGER TG_Insere_user
	ON usuario
	FOR INSERT
	AS
	BEGIN
		DECLARE @nome VARCHAR(20)
		DECLARE @senha VARCHAR(20)

		SELECT @nome = Nome, @senha = Senha FROM inserted
	
		INSERT INTO Registro(Info) 
			VALUES ('Usuario foi inserido! Nome: ' + @nome
					+ ', Senha: ' + @senha)
	END


--DELETE FROM usuario WHERE Nome = 'Andre'
GO
ALTER TRIGGER TG_deleta_user
	ON usuario
	AFTER DELETE
	AS
	BEGIN
		DECLARE @count INT
		DECLARE @nome VARCHAR(20)
		DECLARE @senha VARCHAR(20)

		SELECT @count = COUNT(*) FROM usuario

		SELECT @nome = Nome, @senha = Senha FROM deleted

		INSERT INTO Registro(Info) VALUES 
			('Usuario foi Deletado! Nome: ' + @nome
			+ ', Senha: ' + @senha 			
			+ '. Sobraram: ' + CAST(@count AS VARCHAR)
			 )
	END

GO
CREATE TRIGGER TG_update_user
	ON usuario
	FOR UPDATE
	AS
	BEGIN
		DECLARE @nomeNovo VARCHAR(20)
		DECLARE @senhaNova VARCHAR(20)
		DECLARE @nomeAnt VARCHAR(20)
		DECLARE @senhaAnt VARCHAR(20)

		SELECT @nomeNovo = Nome, @senhaNova = Senha FROM inserted

		SELECT @nomeAnt = Nome, @senhaAnt = Senha FROM deleted

		INSERT INTO Registro VALUES ('Usuario alterado. Antigo: ' + @nomeAnt
									 + ',  ' + @senhaAnt 
									 + ' se tornou Novo: ' + @nomeNovo
									 + ', ' + @senhaNova)
	END

--INSERT INTO usuario(Nome) VALUES ('Andre')
GO
ALTER TRIGGER TG_Insere_user
	ON usuario
	INSTEAD OF INSERT
	AS
	BEGIN
		DECLARE @nome VARCHAR(20)
		DECLARE @senha VARCHAR(20)

		SELECT @nome = Nome FROM inserted
	
		SET @senha = CAST(rand() AS VARCHAR)

		INSERT INTO usuario(Nome, Senha) VALUES (@nome, @senha)

		INSERT INTO Registro(Info) 
			VALUES ('Usuario foi inserido! Nome: ' + @nome
					+ ', Senha: ' + @senha)
	END

--CURSOR
GO
ALTER TRIGGER TG_Insere_user
	ON usuario
	FOR INSERT
	AS
	BEGIN
		DECLARE @nome VARCHAR(20)
		DECLARE @senha VARCHAR(20)

		DECLARE lista CURSOR
			FOR SELECT Nome, Senha FROM inserted

		OPEN lista

		FETCH NEXT FROM lista
			INTO @nome, @senha

		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO Registro(Info) 
					VALUES ('Usuario foi inserido! Nome: ' + @nome
							+ ', Senha: ' + @senha)
				
				FETCH NEXT FROM lista
					INTO @nome, @senha
			END

		CLOSE lista
		DEALLOCATE lista
	END

GO
ALTER TRIGGER TG_update_user
	ON usuario
	FOR UPDATE
	AS
	BEGIN
		DECLARE @nomeNovo VARCHAR(20)
		DECLARE @senhaNova VARCHAR(20)
		DECLARE @nomeAnt VARCHAR(20)
		DECLARE @senhaAnt VARCHAR(20)

		DECLARE listaNovo CURSOR
			FOR SELECT Nome, Senha FROM inserted
		DECLARE listaAnt CURSOR
			FOR SELECT Nome, Senha FROM deleted
			
		OPEN listaNovo
		OPEN listaAnt
		
		FETCH NEXT FROM listaNovo
			INTO @nomeNovo, @senhaNova
		FETCH NEXT FROM listaAnt
			INTO @nomeAnt, @senhaAnt

		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO Registro VALUES ('Usuario alterado. Antigo: ' + @nomeAnt
									 + ',  ' + @senhaAnt 
									 + ' se tornou Novo: ' + @nomeNovo
									 + ', ' + @senhaNova)			
		
				FETCH NEXT FROM listaNovo
					INTO @nomeNovo, @senhaNova
				FETCH NEXT FROM listaAnt
					INTO @nomeAnt, @senhaAnt
			END
			
		CLOSE listaNovo
		CLOSE listaAnt
		DEALLOCATE listaNovo
		DEALLOCATE listaAnt

	END