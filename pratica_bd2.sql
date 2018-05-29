/
  
  --1) (1.0) Crie um subprograma para inserção de Banda/Artista (tabela Bandas_e_Artistas), já
--fazendo a inserção na tabela específica adequada. (Pesquise e use valor default em
--parâmetro)

CREATE OR REPLACE PROCEDURE cadastraBandaOuArtista(
	p_idBan_Art Bandas_e_Artistas.id%TYPE,
	p_nomeArtistico Bandas_e_Artistas.nome_artistico%TYPE,
	p_cidadeOrigem Bandas_e_Artistas.cidade_origem%TYPE,
	p_inicioCarreira Bandas_e_Artistas.inicio_carreira%TYPE,
	p_tipo Bandas_e_Artistas.tipo%TYPE,
	p_idBanda Banda.id%TYPE,
	p_estiloBanda Banda.estilo%TYPE,
	p_idArt Artista.id%TYPE,
	p_data_nascArt Artista.data_nasc%TYPE)
IS
BEGIN

	INSERT INTO Bandas_e_Artistas(id,nome_artistico, cidade_origem, inicio_carreira, tipo) 
		VALUES(p_idBan_Art, p_nomeArtistico, p_cidadeOrigem, p_inicioCarreira, p_tipo);
	
	IF (LOWER(p_tipo) = 'banda') THEN	
		INSERT INTO Banda(id, estilo)
			VALUES(p_idBanda, p_estiloBanda);
	ELSE
		INSERT INTO Artista(id, nome_real, data_nasc)
			VALUES(p_idArt, p_nomeArtistico, p_data_nascArt);
	END IF;
	EXCEPTION 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao inserir os dados: '|| SQLERRM );
	
END cadastraBandaOuArtista;
/
--2) (1.0) Crie um subprograma para remoção de Banda/Artista, dado o seu nome artístico.
CREATE OR REPLACE PROCEDURE removeBandaEArtista3(
	p_nomeArtistico IN Bandas_e_Artistas.nome_artistico%TYPE)
IS
	v_tipoASerRemovido Bandas_e_Artistas.tipo%TYPE;
	v_idASerRemovido Bandas_e_Artistas.id%TYPE;
BEGIN
  
  		SELECT id INTO v_idASerRemovido FROM Bandas_e_Artistas  
    WHERE LOWER(p_nomeArtistico) like LOWER(nome_artistico);
								
	SELECT tipo INTO v_tipoASerRemovido FROM Bandas_e_Artistas 
		WHERE LOWER(p_nomeArtistico) like LOWER(nome_artistico);
		
	IF (LOWER(v_tipoASerRemovido) like 'banda') THEN
		DELETE FROM Banda WHERE id = v_idASerRemovido;
	ELSE
		DELETE FROM Artista WHERE id = v_idASerRemovido;
	END IF;
	
	DELETE FROM Bandas_e_Artistas WHERE id = v_idASerRemovido;
	
	EXCEPTION 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao deletar os dados: '|| SQLERRM );


END REMOVEBANDAEARTISTA3;
/
--3) (1.0) Crie um subprograma para retornar O nome e o tempo da música mais longa gravada
--por um determinado artista. Faça uma versão com procedimento e uma com função.

CREATE OR REPLACE PROCEDURE musicaMaisLonga31(
  p_nomeArtista IN Artista.nome_real%TYPE
)

IS
  v_musicaMaisLonga Musica.tempo_duracao%TYPE;
  v_NomeMusicaMaisLonga Musica.Nome%TYPE;
BEGIN

SELECT MAX(m.tempo_duracao) INTO v_musicaMaisLonga FROM Musica m
      JOIN Composicao c 
          ON c.id_musica = m.id
      JOIN Artista a
          ON a.id = c.id_artista
      WHERE LOWER(a.nome_real) LIKE LOWER(p_nomeArtista);
      
SELECT m.nome INTO v_NomeMusicaMaisLonga FROM Musica m
      JOIN Composicao c 
          ON c.id_musica = m.id
      JOIN Artista a
          ON a.id = c.id_artista
      WHERE m.tempo_duracao = v_musicaMaisLonga;
DBMS_OUTPUT.PUT_LINE(v_NomeMusicaMaisLonga);

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END musicaMaisLonga31;

/
--4) (2.0) Crie um subprograma que retorne, para cada artista ou banda, a proporção de tempo
--que ele passou em cada gravadora, em relação a seu tempo de carreira. Crie uma tabela
--temporária para inserir casos em que há conflito entre tempo de carreira e tempo em
--gravadora/gravadoras (artista/banda com tempo de carreira menor que o tempo em que
--ficou em uma ou mais gravadoras.)
/
--5) (2.0) Crie um subprograma que retorne os nomes de todas as músicas e, para cada uma, seu
--tempo de duração e O de seu intérprete. (Pesquise e use: VARRAY e RECORD).
/
CREATE OR REPLACE PROCEDURE mostraDadosMusica
IS
    TYPE listaDados_rec IS RECORD (
        nomeMusica Musica.nome%TYPE,
        tempoDuracao Musica.tempo_duracao%TYPE,
        nomeInterprete Artista.nome_real%TYPE);
    TYPE a_musica IS VARRAY(10) OF listaDados_rec;
    listaMusica a_musica := a_musica();
    i INTEGER := listaMusica.First;
    
    CURSOR c_listaMusicas IS
        SELECT m.nome, m.tempo_duracao, a.nome_real FROM
            Artista a 
            JOIN Composicao c 
                ON a.id = c.id_artista 
            JOIN Musica m 
                ON m.id = c.id_musica;
BEGIN
    OPEN c_listaMusicas;
    
    WHILE i IS NOT NULL LOOP
        FETCH c_listaMusicas INTO listaMusica(i).nomeMusica,listaMusica(i).tempoDuracao, listaMusica(i).nomeInterprete;
        DBMS_OUTPUT.PUT_LINE('A musica '||listaMusica(i).nomeMusica||' tem '||listaMusica(i).tempoDuracao||' de duração e é cantada por '||listaMusica(i).nomeInterprete);
        i := listaMusica.NEXT(i);
        EXIT WHEN c_listaMusicas%NOTFOUND;      
    END LOOP;
    CLOSE c_listaMusicas;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);   
END mostraDadosMusica;

/
--6) (2.0) Crie um pacote matemático para operações matemáticas variadas. Inclua
--procedimentos e/ou funções.
CREATE OR REPLACE PACKAGE Math_pack AS
    PROCEDURE Soma(num1 FLOAT, num2 FLOAT);
    PROCEDURE Subtracao(num1 FLOAT, num2 FLOAT);
    PROCEDURE Divisao(num1 FLOAT, num2 FLOAT);
    PROCEDURE Multiplicao(num1 FLOAT, num2 FLOAT);
    PROCEDURE Logaritmo(num1 INTEGER, num2 INTEGER);

END Math_pack;
/
CREATE OR REPLACE PACKAGE BODY Math_pack AS
    PROCEDURE Soma(num1 FLOAT, num2 FLOAT) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE((num1+num2));
    END Soma;
    PROCEDURE Subtracao(num1 FLOAT, num2 FLOAT) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE((num1-num2));
    END Subtracao;
    PROCEDURE Divisao(num1 FLOAT, num2 FLOAT) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE((num1/num2));
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('NÃO É PERMITIDO DIVIDIR POR ZERO');
    END Divisao;
    PROCEDURE Multiplicao(num1 FLOAT, num2 FLOAT) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE((num1*num2));
    END Multiplicao;
    PROCEDURE Logaritmo(num1 INTEGER, num2 INTEGER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(LOG(num1, num2));
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERRO: '||SQLERRM);
    END Logaritmo;
END Math_pack;
/
--7) (2.0 (1 ponto extra)) Crie um subprograma para alteração do ID de determinado artista ou
--banda. Use lógica PL/SQL para modificar todas as tabelas que possuam restrições de chaves
--estrangeiras com o id da tabela Bandas_e_Artistas.
  
  
  
