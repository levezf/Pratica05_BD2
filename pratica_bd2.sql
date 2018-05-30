/*
-- Remocao das tabelas
DROP TABLE Historico_em_Gravadora;
DROP TABLE Historico_Artista_em_Banda;
DROP TABLE Gravacao;
DROP TABLE Composicao;
DROP TABLE Artista_em_Banda;
DROP TABLE Artista;
DROP TABLE Banda;
DROP TABLE Bandas_E_Artistas;
DROP TABLE Musica;
DROP TABLE Gravadora;
DROP SEQUENCE Seq_Bandas_e_Artistas;
DROP SEQUENCE Seq_Musica;
DROP SEQUENCE Seq_Gravadora;
*/
-- Criacao das tabelas
CREATE TABLE Bandas_e_Artistas (
  id NUMBER,
	nome_artistico VARCHAR2(64) NOT NULL,	
	cidade_origem	VARCHAR2(32),	
	inicio_carreira DATE,
	tipo VARCHAR2(16),
	
  CONSTRAINT pk_bandas_e_artistas	PRIMARY KEY(id),
  CONSTRAINT ck_bandas_e_artistas_tipo CHECK (tipo in ('Artista', 'Banda'))
);

CREATE TABLE Banda (
  id NUMBER,
	estilo VARCHAR2(16) DEFAULT 'Desconhecido' NOT NULL,
	
  CONSTRAINT pk_banda PRIMARY KEY(id),
	CONSTRAINT fk_banda_bandas_e_artistas	FOREIGN KEY (id) 
		REFERENCES Bandas_e_Artistas (id) ON DELETE CASCADE 
);

CREATE TABLE Artista (
  id NUMBER,
	nome_real VARCHAR2(64) NOT NULL,
	data_nasc DATE,
	
  CONSTRAINT pk_artista PRIMARY KEY(id),
	CONSTRAINT fk_artista_bandas_e_artistas FOREIGN KEY (id) 
		REFERENCES Bandas_e_Artistas (id) ON DELETE CASCADE 
);

CREATE TABLE Musica (
  id NUMBER,
	nome VARCHAR2(32) NOT NULL,
	tempo_duracao NUMBER(4) CHECK (tempo_duracao >= 0),
	
  CONSTRAINT pk_musica PRIMARY KEY(id)
);

CREATE TABLE Gravadora (
	id NUMBER,
  nome VARCHAR2(32) NOT NULL,
	cnpj VARCHAR2(16),
	endereco VARCHAR2(64),
	
  CONSTRAINT pk_gravadora PRIMARY KEY(id),
	CONSTRAINT un_gravadora_cnpj UNIQUE(cnpj)
);

CREATE TABLE Composicao (
  id_artista NUMBER,
  id_musica NUMBER,
	data date,
	
  CONSTRAINT pk_composicao PRIMARY KEY(id_artista, id_musica),
 	CONSTRAINT fk_composicao_artista FOREIGN KEY (id_artista) 
		REFERENCES Artista (id)	ON DELETE CASCADE,	
	CONSTRAINT fk_composicao_musica FOREIGN KEY (id_musica) 
		REFERENCES Musica (id) ON DELETE CASCADE
);

CREATE TABLE Artista_em_Banda (
	id_artista NUMBER,
	id_banda NUMBER,
 	inicio DATE,
	funcao VARCHAR2(32) NOT NULL,
  salario NUMBER(8,2),
	
  CONSTRAINT pk_artista_em_banda PRIMARY KEY(id_artista, id_banda),
	CONSTRAINT FK_artista_em_banda_artista FOREIGN KEY (id_artista) 
		REFERENCES Artista (id)	ON DELETE CASCADE, 
	CONSTRAINT FK_artista_em_banda_banda FOREIGN KEY (id_banda) 
		REFERENCES Banda (id) ON DELETE CASCADE
);

CREATE TABLE Historico_Artista_em_Banda (
	id_artista NUMBER,
	id_banda NUMBER,
	inicio DATE,
	fim	DATE,
	funcao VARCHAR2(32) NOT NULL,
	
  CONSTRAINT pk_historico_artista_em_banda	
    PRIMARY KEY (id_artista, id_banda, inicio),
	CONSTRAINT FK_hist_art_em_banda_artista FOREIGN KEY (id_artista) 
		REFERENCES Artista (id)	ON DELETE CASCADE, 
	CONSTRAINT FK_hist_art_em_banda_banda FOREIGN KEY (id_banda) 
		REFERENCES Banda (id) ON DELETE CASCADE
);

CREATE TABLE historico_em_gravadora (
  id_bandas_e_artistas NUMBER,
	id_gravadora NUMBER NOT NULL,
	inicio DATE,
	fim	DATE,
	CONSTRAINT pk_historico_em_gravadora
    PRIMARY KEY(id_bandas_e_artistas, id_gravadora, inicio),
	CONSTRAINT fk_hist_em_gravadora_banda_art FOREIGN KEY (id_bandas_e_artistas) 
		REFERENCES Bandas_e_Artistas (id) ON DELETE CASCADE,
	CONSTRAINT fk_hist_em_gravadora_gravadora	FOREIGN KEY (id_gravadora) 
		REFERENCES Gravadora (id) ON DELETE CASCADE
);

CREATE TABLE Gravacao (
  id_bandas_e_artistas NUMBER,
	id_musica NUMBER,
	data DATE,
	id_gravadora NUMBER,
	
  CONSTRAINT pk_gravacao 
		PRIMARY KEY(id_bandas_e_artistas, id_musica, data),
	CONSTRAINT fk_gravacao_banda_artistas	FOREIGN KEY (id_bandas_e_artistas) 
		REFERENCES Bandas_e_artistas (id)	ON DELETE CASCADE,
	CONSTRAINT fk_gravacao_musica FOREIGN KEY (id_musica) 
		REFERENCES Musica (id) ON DELETE CASCADE,
	CONSTRAINT fk_gravacao_gravadora FOREIGN KEY (id_gravadora) 
		REFERENCES Gravadora (id) ON DELETE CASCADE
);

-- Criacao das sequencias
CREATE SEQUENCE Seq_Bandas_e_Artistas START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Seq_Musica START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Seq_Gravadora START WITH 1 INCREMENT BY 1;


-- Populando as tabelas
INSERT INTO Gravadora (id, nome, cnpj, endereco)
  VALUES(Seq_Gravadora.NEXTVAL, 'GravaSom', '1234567890', 'Rua Silvio Santos, 123 - Sao Paulo');
INSERT INTO Gravadora (id, nome, cnpj, endereco)
  VALUES(Seq_Gravadora.NEXTVAL, 'Som da Terra', '1234567891', 'Rua Ronald Golias, 171 - Sao Carlos');
INSERT INTO Gravadora (id, nome, cnpj, endereco)
  VALUES(Seq_Gravadora.NEXTVAL, 'Grave Aqui', '1234567892', 'Rua Silvester Stalone, 753 - Campinas');
INSERT INTO Gravadora (id, nome, cnpj, endereco)
  VALUES (Seq_Gravadora.NEXTVAL, 'Records', '06213248148', 'Rua Graças, 254 - Sao Paulo'); 
INSERT INTO Gravadora (id, nome, cnpj, endereco)
  VALUES (Seq_Gravadora.NEXTVAL,'BMG', '62189251685', 'Rua Carajas, 154 - Sao Paulo');
INSERT INTO Gravadora (id, nome, cnpj, endereco)
  VALUES (Seq_Gravadora.NEXTVAL, 'SONY', '16423021545', 'Rua da Dores, 489 - Rio de Janeiro'); 
INSERT INTO Gravadora (id, nome, cnpj, endereco)
  VALUES (Seq_Gravadora.NEXTVAL, 'WARNER', '46589756204', 'Rua Bahia, 784 - Belo Horizonte');


INSERT INTO Musica (id, nome, tempo_duracao) 
  VALUES(Seq_Musica.NEXTVAL, 'O Livro sem Paginas', 162);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Menino da Torneira', 143);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Metamorfose Ambulante', 189);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Feira da Fruta', 140);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Morango no Nordeste', 130);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Hoje a noite nao tem sol', 200);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Tô de olho na senhora', 90);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Rei do Furdunco', 102);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Sansao sem Dalila', 64);
INSERT INTO Musica (id, nome, tempo_duracao)
  VALUES (Seq_Musica.NEXTVAL, 'Facao Guarani', 111);

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo) 
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Enxada e Rastelo', 'Pratânia', TO_DATE('02/03/1936', 'dd/mm/yyyy'), 'Banda');
INSERT INTO Banda (id, Estilo)
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Sertanejo');

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Enxada', 'Pratânia', TO_DATE('02/03/1921', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Jose Carvalho', NULL);

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Rastelo', 'Pratânia', TO_DATE('02/03/1925', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Joao Carvalho', NULL);

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Grupo Capim na Lua', 'Sao Paulo', TO_DATE('19/12/1980', 'dd/mm/yyyy'), 'Banda');
INSERT INTO Banda (id, Estilo)
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Rock');
  
INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Armstrong', 'Houston', TO_DATE('19/12/1980', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Neil Armstrong', TO_DATE('12/08/1945', 'dd/mm/yyyy'));

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Aldrin', 'Atlanta', TO_DATE('19/12/1980', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Edwin Aldrin',  TO_DATE('02/04/1942', 'dd/mm/yyyy'));
  
INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Collins', 'Seattle', TO_DATE('19/12/1980', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Michael Collins', TO_DATE('22/06/1935', 'dd/mm/yyyy'));

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Raul Seixas', DEFAULT, NULL, 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Raul Seixas', null);

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Ira', 'Sao Paulo', TO_DATE('15/06/1981', 'dd/mm/yyyy'), 'Banda');
INSERT INTO Banda (id, Estilo)
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Rock');

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Edgar Scandurra', 'Sao Paulo', TO_DATE('15/06/1981', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Edgar Scandurra',  TO_DATE('07/06/1951', 'dd/mm/yyyy'));

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Nasi', 'Goiania', TO_DATE('15/06/1981', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Marcos Valadão Rodolfo',  TO_DATE('07/06/1952', 'dd/mm/yyyy'));

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES(Seq_Bandas_e_Artistas.NEXTVAL, 'Joaquim Vieira', 'Goiania', TO_DATE('15/06/1976', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES(Seq_Bandas_e_Artistas.CURRVAL, 'Teddy Vieira', null);

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES (Seq_Bandas_e_Artistas.NEXTVAL, 'Tribo de Marley', 'Carapicuiba', TO_DATE('16/10/2004', 'dd/mm/yyyy'), 'Banda');
INSERT INTO Banda (id, Estilo)
  VALUES (Seq_Bandas_e_Artistas.CURRVAL, 'Reggae');

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES (Seq_Bandas_e_Artistas.NEXTVAL, 'Os Sambas Le Le', 'Rio de Janeiro', TO_DATE('16/04/2004', 'dd/mm/yyyy'), 'Banda');
INSERT INTO Banda (id, Estilo)
  VALUES (Seq_Bandas_e_Artistas.CURRVAL, DEFAULT);

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES (Seq_Bandas_e_Artistas.NEXTVAL, 'Ana Palpite', 'Campinas', TO_DATE('15/01/1991', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES (Seq_Bandas_e_Artistas.CURRVAL, 'Maria dos Santos', NULL);

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES (Seq_Bandas_e_Artistas.NEXTVAL, 'Os Tomates', 'Paranapiacaba', TO_DATE('28/12/1979', 'dd/mm/yyyy'), 'Banda');
INSERT INTO Banda (id, Estilo)
  VALUES (Seq_Bandas_e_Artistas.CURRVAL, 'ROCK');

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
    VALUES (Seq_Bandas_e_Artistas.NEXTVAL, 'Iranildo Belchior', 'Salvador', TO_DATE('13/04/1970', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES (Seq_Bandas_e_Artistas.CURRVAL, 'Adilson das Cruzes',  TO_DATE('15-09-1950', 'dd/mm/yyyy'));

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES (Seq_Bandas_e_Artistas.NEXTVAL, 'Barao do Som', 'Kingston', TO_DATE('18/03/1978', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES (Seq_Bandas_e_Artistas.CURRVAL, 'Jacrilson Regis', TO_DATE('10-06-1965', 'dd/mm/yyyy'));

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES (Seq_Bandas_e_Artistas.NEXTVAL, 'Grandes Reis' , 'Porto Alegre', TO_DATE('17/04/1974', 'dd/mm/yyyy'), 'Banda');
INSERT INTO Banda (id, Estilo) 
  VALUES (Seq_Bandas_e_Artistas.CURRVAL, 'MPB');

INSERT INTO Bandas_e_Artistas (id, nome_artistico, cidade_origem, inicio_carreira, tipo)
  VALUES (Seq_Bandas_e_Artistas.NEXTVAL, 'Josefino' , 'Terra Natal', TO_DATE('18/03/1988', 'dd/mm/yyyy'), 'Artista');
INSERT INTO Artista (id, nome_real, data_nasc) 
  VALUES (Seq_Bandas_e_Artistas.CURRVAL, 'Josefino da Silva',  TO_DATE('10/06/1925', 'dd/mm/yyyy'));


INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES(1, 2, TO_DATE('1952', 'yyyy'), 2);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES(4, 4, TO_DATE('1981', 'yyyy'), 1);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES(9, 1, TO_DATE('2005', 'yyyy'), 2);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES(8, 3, TO_DATE('1975', 'yyyy'), 3);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES (18, 6, TO_DATE('1980', 'yyyy'), 4);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES (16, 7, TO_DATE('1991', 'yyyy'), 6);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES (17, 8, TO_DATE('1975', 'yyyy'), NULL);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES (17, 7, TO_DATE('1985', 'yyyy'), 7);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES (20, 9, TO_DATE('1995', 'yyyy'), 5);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES (20 ,5 , TO_DATE('1996', 'yyyy'), 5);
INSERT INTO Gravacao (id_bandas_e_artistas, id_musica, data, id_gravadora)
  VALUES (16, 10, TO_DATE('2001', 'yyyy'), 5);


INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES(1, 2, TO_DATE('02/03/1936', 'dd/mm/yyyy'), TO_DATE('01/04/2008', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES(8, 3, TO_DATE('18/09/1965', 'dd/mm/yyyy'), TO_DATE('04/07/1995', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES(9, 2, TO_DATE('01/04/1973', 'dd/mm/yyyy'), TO_DATE('19/11/2014', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (18, 4, TO_DATE('10/03/1980', 'dd/mm/yyyy'), NULL );
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (16, 6, TO_DATE('01/06/1990', 'dd/mm/yyyy'), NULL );
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (16, 5, TO_DATE('01/06/1999', 'dd/mm/yyyy'), TO_DATE('01/06/1999', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (17, 5, TO_DATE('01/06/1970', 'dd/mm/yyyy'), TO_DATE('06/09/1991', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (16, 4, TO_DATE('01/06/1980', 'dd/mm/yyyy'), TO_DATE('01/06/1990', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (19, 5, TO_DATE('01/06/1984', 'dd/mm/yyyy'), TO_DATE('01/06/1999', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (2, 5, TO_DATE('01/07/1984', 'dd/mm/yyyy'), TO_DATE('01/06/1999', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (3, 5, TO_DATE('01/07/1984', 'dd/mm/yyyy'), TO_DATE('01/06/1999', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (8, 7, TO_DATE('01/08/1984', 'dd/mm/yyyy'), TO_DATE('01/06/1999', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (15, 5, TO_DATE('01/09/1984', 'dd/mm/yyyy'), TO_DATE('01/06/1999', 'dd/mm/yyyy'));
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (19, 6, TO_DATE('01/10/1984', 'dd/mm/yyyy'), NULL);
INSERT INTO Historico_em_Gravadora (id_bandas_e_artistas, id_gravadora, inicio, fim)
  VALUES (20, 5, TO_DATE('01/11/1984', 'dd/mm/yyyy'), TO_DATE('01/06/1999', 'dd/mm/yyyy'));

INSERT INTO Composicao (id_artista, id_musica, data) 
  VALUES(12, 2, TO_DATE('01/06/1999', 'dd/mm/yyyy'));
INSERT INTO Composicao (id_artista, id_musica, data)
  VALUES(10, 1, TO_DATE('01/06/2014', 'dd/mm/yyyy'));
INSERT INTO Composicao (id_artista, id_musica, data)
  VALUES(6, 4, TO_DATE('01/06/1980', 'dd/mm/yyyy'));
INSERT INTO Composicao (id_artista, id_musica, data)
  VALUES (17, 5, TO_DATE('01/06/1990', 'dd/mm/yyyy'));
INSERT INTO Composicao (id_artista, id_musica, data)
  VALUES (18, 6, NULL );
INSERT INTO Composicao (id_artista, id_musica, data)
  VALUES (20, 7, TO_DATE('01/06/1999', 'dd/mm/yyyy'));
INSERT INTO Composicao (id_artista, id_musica, data)
  VALUES (20, 8, TO_DATE('01/06/2000', 'dd/mm/yyyy'));
INSERT INTO Composicao (id_artista, id_musica, data)
  VALUES (20, 10, TO_DATE('01/06/2001', 'dd/mm/yyyy'));

INSERT INTO Artista_em_Banda (id_artista, id_banda, inicio, funcao, salario)
  VALUES(10, 9, TO_DATE('01/06/1935', 'dd/mm/yyyy'), 'Vocal', 25000);
INSERT INTO Artista_em_Banda (id_artista, id_banda, inicio, funcao, salario) 
  VALUES(11, 9, TO_DATE('01/06/1981', 'dd/mm/yyyy'), 'Vocal', 32000);
INSERT INTO Artista_em_Banda (id_artista, id_banda, inicio, funcao, salario)
  VALUES(5, 4, TO_DATE('01/06/1975', 'dd/mm/yyyy'), 'Vocal', 14000);
INSERT INTO Artista_em_Banda (id_artista, id_banda, inicio, funcao, salario)
  VALUES(6, 4, TO_DATE('01/06/1975', 'dd/mm/yyyy'), 'Vocal', 1500);
INSERT INTO Artista_em_Banda (id_artista, id_banda, inicio, funcao, salario)
  VALUES (15, 16, TO_DATE('01/06/1995', 'dd/mm/yyyy'), 'Baixista', 800);
INSERT INTO Artista_em_Banda (id_artista, id_banda, inicio, funcao, salario)
  VALUES (18, 14, TO_DATE('01/06/1982', 'dd/mm/yyyy'), 'Guitarrista', 1250);
INSERT INTO Artista_em_Banda (id_artista, id_banda, inicio, funcao, salario)
  VALUES (17, 19, TO_DATE('01/06/1965', 'dd/mm/yyyy'), 'Guitarrista', 14250);
INSERT INTO Artista_em_Banda (id_artista, id_banda, inicio, funcao, salario)
  VALUES (20, 19, TO_DATE('01/06/1996', 'dd/mm/yyyy'), 'Baixista', 17050);


INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao)
  VALUES(2, 1, TO_DATE('02/03/1936', 'dd/mm/yyyy'), TO_DATE('21/05/1991', 'dd/mm/yyyy'), 'Cantor e violonista');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES(3, 1, TO_DATE('02/03/1936', 'dd/mm/yyyy'), TO_DATE('21/05/2011', 'dd/mm/yyyy'), 'Cantor e violeiro');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES(7, 4, TO_DATE('19/12/1980', 'dd/mm/yyyy'), TO_DATE('21/05/1991', 'dd/mm/yyyy'), 'Vocal');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES (17, 16, TO_DATE('10/03/1979', 'dd/mm/yyyy'), TO_DATE('21/05/1991', 'dd/mm/yyyy'), 'Guitarrista');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES (18, 16, TO_DATE('10/05/2004', 'dd/mm/yyyy'), TO_DATE('10/05/2005', 'dd/mm/yyyy'), 'Pianista');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES (20, 14, TO_DATE('20/04/1998', 'dd/mm/yyyy'), TO_DATE('21/04/2005', 'dd/mm/yyyy'), 'Baterista');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES (8, 19, TO_DATE('21/04/1998', 'dd/mm/yyyy'), TO_DATE('21/04/1999', 'dd/mm/yyyy'), 'Vocal');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES (10, 19, TO_DATE('22/04/1998', 'dd/mm/yyyy'), TO_DATE('21/08/1998', 'dd/mm/yyyy'), 'Vocal');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES (18, 19, TO_DATE('23/04/1998', 'dd/mm/yyyy'), TO_DATE('21/04/2002', 'dd/mm/yyyy'), 'Vocal');
INSERT INTO Historico_Artista_em_Banda (id_artista, id_banda, inicio, fim, funcao) 
  VALUES (10, 16, TO_DATE('23/04/2000', 'dd/mm/yyyy'), TO_DATE('21/04/2001', 'dd/mm/yyyy'), 'Vocal');
  
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
--Artista/Banda/Gravacao/
CREATE OR REPLACE PROCEDURE modificaIdArtista(
id Bandas_e_Artistas.id%TYPE
)
IS
    CURSOR c_

BEGIN
END modificaIdArtista;
  
/
select *from artista;

UPDATE Gravacao SET id_Bandas_e_Artistas = 1000 WHERE id_Bandas_e_Artistas = 2;
UPDATE Banda SET id = 1000 WHERE id=2;
UPDATE Historico_Artista_em_Banda SET id_artista = 1000 WHERE id_artista =2;
UPDATE Artista_em_Banda SET id_artista = 1000 WHERE id_artista = 2;
UPDATE Composicao SET id_artista = 1000 WHERE id_artista =2;
UPDATE Artista SET id= 1000 WHERE id=2;
UPDATE Bandas_e_Artistas SET id = 1000 WHERE id=2;


ALTER TABLE Artista DROP CONSTRAINT FK_ARTISTA_BANDAS_E_ARTISTAS;
ALTER TABLE Artista DROP PRIMARY KEY;
ALTER TABLE Artista ADD
CONSTRAINT FK_ARTISTA_BANDAS_E_ARTISTAS 
    FOREIGN KEY (id) REFERENCES Bandas_e_Artistas(id) ON UPDATE CASCADE ON DELETE CASCADE initially deferred deferrable;

ALTER TABLE Banda DROP CONSTRAINT FK_BANDA_BANDAS_E_ARTISTAS;
ALTER TABLE Banda DROP PRIMARY KEY;
ALTER TABLE Banda ADD CONSTRAINT FK_BANDA_BANDAS_E_ARTISTAS 
    FOREIGN KEY (id) REFERENCES Bandas_e_Artistas(id) ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE Historico_em_Gravadora DROP CONSTRAINT FK_HIST_EM_GRAVADORA_BANDA_ART;
ALTER TABLE Historico_em_Gravadora DROP PRIMARY KEY;
ALTER TABLE Historico_em_Gravadora ADD CONSTRAINT FK_HIST_EM_GRAVADORA_BANDA_ART
    FOREIGN KEY(id_Bandas_e_Artistas) REFERENCES Bandas_e_Artistas(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Gravacao DROP CONSTRAINT FK_GRAVACAO_BANDA_ARTISTAS;
ALTER TABLE Gravacao DROP PRIMARY KEY;
ALTER TABLE Gravacao ADD CONSTRAINT FK_GRAVACAO_BANDA_ARTISTAS
    FOREIGN KEY(id_Bandas_e_Artistas) REFERENCES Bandas_e_Artistas(id) ON UPDATE CASCADE ON DELETE CASCADE;
