--1)Listar RA professor,carga total/p

SELECT P.Ra, sum(Carga)	AS Carga
FROM Professor P, Disciplina D
where P.RA = D.ProfRA
GROUP BY P.RA;

--2)Listar P,A,D,N

SELECT *
FROM Disciplina D
	  , Professor P
		, Aluno A
		, Nota N

WHERE A.RA = N.AlunoRA
	AND D.CRT = N.DiscCRT
	AND P.RA = D.ProfRA;

--3)nome,CPF p com disciplina

SELECT P.Nome, P.CPF
FROM Professor P, Disciplina D
where P.RA = D.ProfRA
GROUP BY P.RA, P.CPF, P.Nome;

--4)Listar a nota média/disciplina

SELECT CRT, round(AVG(N.Nota),1)  AS MEDIA
FROM Disciplina D
		, Nota N
WHERE D.CRT = N.DiscCRT
GROUP BY CRT
ORDER BY 1;

/*
SELECT CRT, AVG(N.Nota)  AS MEDIA
	FROM Disciplina D
	INNER JOIN Nota N 
	ON D.CRT = N.DiscCRT
	GROUP BY CRT
	ORDER BY 1
*/


/* ATIVIDADE 2 
1) SELECT P.Ra, sum(Carga)	AS Carga
	FROM Professor P, Disciplina D
		where P.RA = D.ProfRA
	GROUP BY P.RA; 
*/

--TV1
SELECT *
FROM Professor;
SELECT *
FROM Disciplina;

--TV2
SELECT *
FROM Professor
	INNER JOIN Disciplina ON Professor.RA = Disciplina.ProfRA;

--TV3
SELECT P.Ra, sum(Carga)	AS Carga
FROM Professor P, Disciplina D
where P.RA = D.ProfRA
GROUP BY P.RA;