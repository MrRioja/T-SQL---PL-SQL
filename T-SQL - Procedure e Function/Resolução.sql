--Exercicios 1 e 2:

CREATE OR ALTER PROCEDURE CalcularNota
	AS
	BEGIN
		--EXERCICIO 1
		 UPDATE Nota SET N1 = (P1+APS+Prog)/3 
		--EXERCICIO 2
		 UPDATE Nota SET NotaFinal = (N1*0.4+N2*0.6)
	END;

--EXECUCAO DA PROCEDURE
EXEC CalcularNota;
--VALIDACAO DO RESULTADO
SELECT * FROM Nota;

Exercicio 3: 
A) Ocorreu porque haviam tuplas com campos nulos(NULL), e esses campos estavam
envolvidos na soma contida na PROCEDURE para calcular as notas.

B) CREATE OR ALTER PROCEDURE CalcularNota
	AS
	BEGIN
		UPDATE Nota SET P1 = 0 WHERE P1 IS NULL
		UPDATE Nota SET APS = 0 WHERE APS IS NULL
		UPDATE Nota SET Prog = 0 WHERE Prog IS NULL
		UPDATE Nota SET N2 = 0 WHERE N2 IS NULL
		UPDATE Nota SET N1 = (P1+APS+Prog)/3
		UPDATE Nota SET NotaFinal = (N1*0.4+N2*0.6)
	END;

Exercicio 4: 
CREATE OR ALTER PROCEDURE CalculaAprovacao
	AS
	BEGIN
		UPDATE Nota SET Aprovacao = 1 WHERE NotaFinal>=5
	END;

Exercicio 5:
CREATE OR ALTER PROCEDURE CalculaAprovacao
	AS
	BEGIN
		EXEC CalcularNota
		UPDATE Nota SET Aprovacao = 1 WHERE NotaFinal>=5
	END;

Exercicio 6:
CREATE OR ALTER PROCEDURE CalculaAprovacao
	@media FLOAT
	AS
	BEGIN
		UPDATE Nota SET Aprovacao = 0 WHERE NotaFinal >= 0
		UPDATE Nota SET Aprovacao = 1 WHERE NotaFinal >= @media
	END;
	
Exercicio 7:
CREATE OR ALTER PROCEDURE ChecaAprovacao 
	@ra INT,
    @crt INT,
    @status VARCHAR(10) OUTPUT
	AS
	BEGIN
		SET @status = (SELECT IIF(Aprovacao = 1,'Aprovado','Reprovado') 
						FROM Nota
							WHERE AlunoRA = @ra
							  AND DiscCRT = @crt)
	END;
--VALIDACAO DO RESULTADO
DECLARE @resultado VARCHAR(10)
EXEC ChecaAprovacao 101,10,@resultado OUTPUT
PRINT @resultado

Exercicio 8:
CREATE OR ALTER FUNCTION FN_ChecaAprovacao (@RA INT, @CRT INT)
	RETURNS VARCHAR(10)
	AS
	BEGIN 
		RETURN (SELECT IIF(Aprovacao = 1,'Aprovado','Reprovado') 
					FROM Nota
						WHERE AlunoRA = @RA
						  AND DiscCRT = @CRT)
	END;
--VALIDACAO DO RESULTADO
SELECT dbo.FN_ChecaAprovacao(103,13) Aprovacao

Exercicio 9:
CREATE OR ALTER FUNCTION NotaCompleta(@CRT INT, @RA INT)
	RETURNS TABLE
	AS
	RETURN (
			SELECT *, 
				   ((ISNULL(P1,0)+ISNULL(APS,0)+ISNULL(Prog,0))/3) AS N1, 
				   ((((ISNULL(P1,0)+ISNULL(APS,0)+ISNULL(Prog,0))/3)*0.4)+ISNULL(N2,0)*0.6) AS NotaFinal 
				FROM Nota 
					WHERE AlunoRA = @RA
					  AND DiscCRT = @CRT);
--VALIDACAO DO RESULTADO	
SELECT * FROM NotaCompleta(10,100)

Exercicio 10:
Sim, tornando a query do "RETURN" do exercicio 9 uma subquery,
adicionando na query externa uma coluna que ira comparar a nota final com a media 5 
e atraves do calculo informar se o aluno foi aprovado ou não, conforme FUNCTION abaixo:

CREATE OR ALTER FUNCTION NotaCompleta(@CRT INT, @RA INT)
	RETURNS TABLE
	AS
	RETURN (

			SELECT *,
				   IIF(NotaFinal >= 5,'Aprovado','Reprovado') AS Aprovacao
			FROM (
					SELECT *, 
				  		   ((ISNULL(P1,0)+ISNULL(APS,0)+ISNULL(Prog,0))/3) AS N1, 
						   ((((ISNULL(P1,0)+ISNULL(APS,0)+ISNULL(Prog,0))/3)*0.4)+ISNULL(N2,0)*0.6) AS NotaFinal
						FROM Nota 
							WHERE AlunORA = @RA
							  AND DIScCRT = @CRT
				  ) AS Notas
		   );
--VALIDACAO DO RESULTADO
SELECT * FROM NotaCompleta(13,101)