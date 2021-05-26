/* 	
	MOOVIEW - UMA PLATAFORMA PARA RECOMENDAÇÃO E AVALIAÇÃO DE FILMES
	PARADIGMAS DE LINGUAGEM DE PROGRAMACAO - 2020.1e - UFCG

	INTEGRANTES:
                GABRIEL FERNANDES DA COSTA
                ERICK MORAIS DE SENA
                DANIEL DE MATOS FIGUEREDO
                NATAN VINICIUS DA SILVA LUCENA
*/

% :- include('View.pl').

/* 
    PARAMETROS
        Usuario(Login, Filmes, Notas, ListaDesejo).
*/
% :- include('Usuario.pl').

/*
    PARAMETROS:
        Filme(Titulo, Notas, Elenco, Diretor, Genero, Lancamento, Sinopse).
*/
% :- include('Filme.pl').

:- initialization(main).
%lerfilmes

%a_primeira_saida_eh_uma_representacao_em_string_do_arquivo
%a_segunda_saida_eh_uma_representacao_em_lista_do_arquivo
lerFilmes(StringDoArquivo, ListaDoArquivo) :-
    open('filmes.txt', read, Stream),
    read_file(Stream, Line),
    resgataFilmes(Line, StringDoArquivo), ListaDoArquivo = Line,
    close(Stream).

%o_argumento_passado_deve_ser_uma_string_com_os_novos_filmes_cada_atributo_
%separado_por_virgula_e_sem_aspas
escreverFilmes(StringComNovosFilmes) :-
    lerFilmes(X), 
    open('filmes.txt', write, Stream),
    string_concat(X, StringComNovosFilmes, Resultado),
    write(Stream, Resultado),
    close(Stream).

resgataFilmes([],'').
resgataFilmes([H | T], String) :-
    atomic_list_concat(H, ',', R),
    string_concat(R, '\n', Resultado),
    resgataFilmes(T, StringProxima),
    string_concat(Resultado, StringProxima, String).

%lerusuario

%a_primeira_saida_eh_uma_representacao_em_string_do_arquivo
%a_segunda_saida_eh_uma_representacao_em_lista_do_arquivo
lerUsuarios(StringDoArquivo, ListaDoArquivo) :-
    open('usuarios.txt', read, Stream),
    read_file(Stream, Line),
    resgataUsuarios(Line, StringDoArquivo), ListaDoArquivo = Line,
    close(Stream).

%o_argumento_passado_deve_ser_uma_string_com_os_novos_usuarios_cada_atributo_
%separado_por_virgula_e_sem_aspas
escreverUsuarios(StringComNovosUsuarios) :-
    lerUsuarios(X,Y), 
    open('usuarios.txt', write, Stream),
    string_concat(X, StringComNovosUsuarios, Resultado),
    write(Stream, Resultado),
    close(Stream).

resgataUsuarios([],'').
resgataUsuarios([H | T], String) :-
    atomic_list_concat(H, ',', R),
    string_concat(R, '\n', Resultado),
    resgataUsuarios(T, StringProxima),
    string_concat(Resultado, StringProxima, String).

%dependecia_para_ler_e_escrever_arquivos

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[H|T]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, String),
    atomic_list_concat(H,",", String),
    read_file(Stream,T),!.


getFilmeElenco((_,_,T,_,_,_,_),T).
getFilmeGenero((_,_,_,_,T,_,_),T).
getFilmeTitulo((T,_,_,_,_,_,_),T).
getFilmeSinopse((_,_,_,_,_,_,T),T).
getFilmeDiretor((_,_,_,T,_,_),T).
getFilmeLancamento((_,_,_,_,_,T,_),T).
getFilmeNotas((_,T,_,_,_,_,_),T).
getLogin((Login, _, _, _), Login).
getFilmes((_, Filmes, _, _), Filmes).
getNotas((_,_, Notas, _), Notas).
getDesejo((_, _, _, Desejo), Desejo).

somatorio([], 0).
somatorio([H | T], Soma) :- somatorio(T,Soma1),
                             Soma is Soma1+H.

consultaPorAtor(_, [], []).
consultaPorAtor(Ator, [H | T], R):-
                            getFilmeElenco(H, E),
                            consultaPorAtor(Ator, T, R1),
                            (member(Ator, E) -> append([H],R1,R); R = R1).

consultaPorDiretor(_, [], []).
consultaPorDiretor(Diretor, [H | T], R):-
                            getFilmeDiretor(H, D),
                            consultaPorDiretor(Diretor, T, R1),
                            (Diretor == D -> append([H],R1,R); R = R1).

consultaPorGenero(_, [], []).
consultaPorGenero(Genero, [H | T], R):-
                            getFilmeGenero(H, G),
                            consultaPorGenero(Genero, T, R1),
                            (Genero == G -> append([H],R1,R); R = R1).
jaAssistiu(_,[],0).
jaAssistiu(F,[H|T],R):-
	getFilmeTitulo(F,Y),
	getFilmeTitulo(H,E),
	(Y==E -> R=1; jaAssistiu(F,T,R1),R=R1).
	

recomendar([],_,X,_,X).
recomendar([H|T],G,X,A,R):-
	length(X,L),
	getFilmeGenero(H,F),
	jaEscolheu(F,G,E),
	jaAssistiu(H,A,J),
	(L==10->R=X; J==1->recomendar(T,G,X,A,R1), R=R1; E==0->recomendar(T,G,X,A,R1), R=R1; append(X,[H],N), recomendar(T,G,N,A,R1), R=R1).
	
	

jaEscolheu(_,[],0).
jaEscolheu(G,[H|T],R):-
	(G==H->R=1; jaEscolheu(G,T,R1), R=R1).
	
	
	
assisteFilme([H | T], Login, Assistido, Avaliacao, Usuarios) :- 
                            getLogin(H, L),
                            (L == Login -> adicionarFilmeAssistido(H, Assistido, Avaliacao, R1), removerListaDesejo(R1,Assistido,R2),append([R2], T, Usuarios); assisteFilme(T,Login,Assistido, Avaliacao, R2), append([H], R2, Usuarios)).


adicionarFilmeAssistido((Login, Filmes, Notas, ListaDesejo), Assistido, Avaliacao, (Login, Filmes1, Notas1, ListaDesejo)) :-
                            append(Filmes, [Assistido], Filmes1),
                            append(Notas, [Avaliacao], Notas1).

getGeneros([],X,X).
getGeneros([H|T],X,R):-
	length(X,L),
	getFilmeGenero(H,G),
	jaEscolheu(G,X,B),
	
	(L==3->R=X;B==1->getGeneros(T,X,R1), R=R1 ;append([G],X,N), getGeneros(T,N,R1), R=R1).

ordenar([],[]).
ordenar([H|T],R):-
    maior(T,R1),
    getFilmeNotas(R1,NM),
    notaMedia(NM,MN),
    getFilmeNotas(H,N),
    notaMedia(N,M),
    (M>=MN -> ordenar(T,R2),append([H],R2,R); swap(H,MN,T,A), ordenar(A,B), append([R1],B,R)).
    
maior([],('a',[-1],[],'a','a',1,'a')).
maior([H|T],R):-
    maior(T,R1),
    getFilmeNotas(R1,NM),
    notaMedia(NM,MN),
    getFilmeNotas(H,N),
    notaMedia(N,M),
    (M>=MN -> R=H; R=R1).
    
swap(_,_,[],[]).
swap(X,Y,[H|T],R):-
    getFilmeNotas(H,N),
    notaMedia(N,M),
    (M==Y->append([X],T,R); swap(X,Y,T,R1),append([H],R1,R)).

getFilme([],_, []).
getFilme([H | T], Titulo, Filme) :-
                            getFilmeTitulo(H, R),
                            getFilme(T, Titulo, R1),
                            (R == Titulo -> Filme = H; getFilme(T, Titulo, R1),Filme=R1).
                            
atualizaNotaFilme([],_,_,[]).
atualizaNotaFilme([H|T], Titulo, Avaliacao, R):-
    getFilmeTitulo(H,R1),
    (R1==Titulo -> atualizaFilme(H, Avaliacao, R3), append([R3],T,R); atualizaNotaFilme(T,Titulo,Avaliacao,R2), append([H],R2,R)).


atualizaFilme((Titulo,Notas,Elenco,Diretor,Genero,Lancamento,Sinopse),Avaliacao,(Titulo,Notas1,Elenco,Diretor,Genero,Lancamento,Sinopse)):-
    append(Notas, [Avaliacao], Notas1).
    
    
removerListaDesejo((Login, Filmes, Notas, []), Filme, (Login, Filmes, Notas, [])).
removerListaDesejo((Login, Filmes, Notas, ListaDesejo), Filme, (Login, Filmes, Notas, ListaDesejo1)):-
                            (member(Filme, ListaDesejo)->removeDesejo(ListaDesejo, Filme, ListaDesejo1); ListaDesejo1=ListaDesejo).

removeDesejo([H | T], H, T).
removeDesejo([H | T], Filme, R) :-
                            removeDesejo(T, Filme, R1),
                            append([H], R1, R).
                            
adicionarDesejo([],_,_,[]).
adicionarDesejo([H|T],Login,Filme,R):-
	getLogin(H,L),
	getFilmes(H,F),
	getNotas(H,N),
	getDesejo(H,D),
	adicionarDesejo(T,Login,Filme,R1),
	(L==Login -> 
	append(D,[Filme],ND),
	append([(L,F,N,ND)],R1,R);
	append([H],R1,R)
	).
	
                            
                            
                            
getUsuario([], _, []).
getUsuario([H | T], Login, Usuario) :-
                            getLogin(H, L),
                            (L == Login -> Usuario = H; getUsuario(T, Login, R), Usuario = R).
                            
getUsuarioAssistidos([], [], []).
getUsuarioAssistidos([H | T], [A | B], R) :-
                            getUsuarioAssistidos(T, B , R1),
                            R2 = (H,A),
                            append([R2], R1, R).
                            
getListaDesejo([],_,[]).
getListaDesejo([H|T],Login,R):-
	getLogin(H,L),
	getDesejo(H,D),
	(L==Login->R=D; getListaDesejo(T,Login,R1), R=R1).
	
getListaAssistidos([],_,[]).
getListaAssistidos([H|T],Login,R):-
	getLogin(H,L),
	getFilmes(H,Filmes),
	getNotas(H,Notas),
	getUsuarioAssistidos(Filmes,Notas,A),
	(L==Login->R=A; getListaAssistidos(T,Login,R1), R=R1).
	
formatarFilmes([],'').
formatarFilmes([H|T],R):-
	getFilmeTitulo(H,Titulo),
	getFilmeSinopse(H,Sinopse),
	formatarFilmes(T,R1),
	string_concat('Titulo: ', Titulo, A),
	string_concat(A,'\n',B),
	string_concat('Sinopse: ', Sinopse, C),
	string_concat(C,'\n',D),
	string_concat(B,D,R2),
	string_concat(R2,'\n',R3),
	string_concat(R3,R1,R).
	
usuarioReconhecido([], Login, -1).
usuarioReconhecido([H|T], Login, Resposta) :-
	getLogin(H,R),
	(R == Login -> Resposta = 1;
	usuarioReconhecido(T, Login, Resposta)).

main:-
	write("--------------------------------------------------------------------------------|\n"),
	write("                                                                                |\n"),
	write( "  ███       ███  █████████  █████████  ██      ██  ██  ███████  ██          ██  |\n"),
	write( "  ████    █████  ██     ██  ██     ██   ██    ██   ██  ██        ██        ██   |\n"),
	write(   "  ██  ██ ██  ██  ██     ██  ██     ██    ██  ██    ██  ████       ██  ██  ██    |\n"),
	write(       "  ██   ███   ██  ██     ██  ██     ██     ████     ██  ██          ████████     |\n"),
	write(       "  ██         ██  █████████  █████████      ██      ██  ███████      ██  ██      |\n"),
	write(       "                                                                                |\n"),
	write(       "             UMA PLATAFORMA PARA RECOMENDAÇÃO E AVALIAÇÃO DE FILMES             |\n"),
	write(       "                                                                                |\n"),
	write(        "--------------------------------------------------------------------------------|\n"),
	%lerFilmes(FormaDeString, FormaDeLista), write(FormaDeLista), nl, write(FormaDeString), 
	Filmes=[('uma noite no museu',[],['ben stiller','robin williams','owen wilson'],'shawn levy','aventura',2006,'O novo seguranca do museu de historia natural de nova york faz uma grande descoberta. Por causa de uma antiga maldicao egipcia, os animais, passaros, insetos e outras pecas em exibicao ganham vida quando os visitantes vao embora. soldados romanos, pistoleiros do velho oeste, o ex-presidente Theodore Roosevelt e muitas outras figuras historicas entram em acao em uma aventura fantastica.'),
	('annie hall',[],['woody allen', 'diane keaton'],'woody allen','comedia',1977,'Um humorista judeu e divorciado que faz analise há quinze anos, se apaixona por Annie Hall, uma cantora em início de carreira com uma cabeça um pouco complicada. Em pouco tempo eles decidem morar juntos, mas as crises conjugais comeaam a aparecer e afetar os sentimentos de ambos.'),
	('birdman',[],['michael keaton', 'edward norton'],'alejandro gonzalez inarritu','drama',2014,'Por mais de 20 anos, o ator Riggan Thomson foi conhecido por interpretar Birdman, um super-heroi que se tornou um icone cultural. Entretanto, ao recusar-se a gravar o quarto filme com o mesmo personagem, sua carreira comeca a decair. Em uma tentativa de recuperar a fama perdida e tambem o reconhecimento do publico, ele decide dirigir, roteirizar e estrelar a adaptação de um texto consagrado para a Broadway.'),
	('boyhood',[],['ethan hawke', 'patricia arquette','ellar coltrane'],'richard linklater','drama',2014,'Acompanhe a vida do garoto Mason durante um periodo de doze anos, da infancia a juventude, analisando seu relacionamento com os pais, suas descobertas, experiencias e seus conflitos.'),
	('meia noite em paris',[],['owen wilson','rachel mcadams'],'woody allen','romance',2011,'Gil Pender e um jovem escritor em busca da fama. De ferias em Paris com sua noiva, ele sai sozinho para explorar a cidade e conhece um grupo de estranhos que sao, na verdade, grandes nomes da literatura. Eles levam Gil a uma viagem ao passado e, quanto mais tempo passam juntos, mais o jovem escritor fica insatisfeito com o presente.'),
	('a favorita',[],['emma stone','olivia colman'],'yorgos lanthimos',drama,2018,'Na Inglaterra do seculo 18, Sarah Churchill, a Duquesa de Marlborough, exerce sua influencia na corte como confidente, conselheira e amante secreta da Rainha Ana. Seu posto privilegiado, no entanto, e ameacado pela chegada de Abigail, nova criada que logo se torna a queridinha da majestade e agarra com unhas e dentes essa oportunidade unica.'),
	('superbad',[],['jonah hill', 'emma stone','seth rogen'],'greg mottola',comedia,2007,'Os estudantes adolescentes Seth e Evan tem grandes esperancas para uma festa de formatura. Os adolescentes co-dependentes pretendem beber e conquistar garotas para que eles possam se tornar parte da multidao popular da escola, mas a ansiedade de separacao e dois policiais entediados complicam a auto-missao proclamada dos amigos.'),
	('o lobo de wall street',[],['leonardo dicaprio','jonah hill'],'martin scorsese','comedia',2013,'Jordan Belfort e um ambicioso corretor da bolsa de valores que cria um verdadeiro imperio, enriquecendo de forma rapida, porem ilegal. Ele e seus amigos mergulham em um mundo de excessos, mas seus metodos ilicitos despertam a atencao da policia.'),
	('touro indomavel',[],['robert de niro', 'joe pesci'],'martin scorsese','drama',1980,'O filme conta a historia de um boxeador de peso medio e suas vitorias até ter a sua primeira oportunidade de ser campeao da sua categoria. Ele se apaixona por uma linda garota do Bronx, mas a incapacidade de expressar seus sentimentos eventualmente atrapalha sua vida profissional, o que lhe custa tudo.'),
	('cassino',[],['robert de niro', 'joe pesci'],'martin scorsese','drama',1995,'No inicio dos anos 70, o mafioso Sam Rothstein é encarregado de administrar um cassino em Las Vegas. Inicialmente, ele e o amigo Nicky Santoro, com tendencias violentas, conseguem transformar a casa de jogos em um verdadeiro imperio. Mas Sam tem uma fraqueza: ele se apaixona e casa com a bela Ginger, uma ex-prostituta ainda ligada a um trambiqueiro. Com o passar dos anos, a fortuna de Ace vai diminuindo, e ele questiona se esses dois comparsas foram a real causa do seu declinio.')
	],
	Usuarios=[],
	entrada(Filmes,Usuarios).
	
entrada(Filmes,Usuarios):-
	write('1: Fazer Login.\n'),
	write('2: Fazer Cadastro.\n'),
	write('Opcao:\n'),
	read(Opcao),
	(Opcao==1->login(Filmes,Usuarios); cadastro(Filmes,Usuarios)).
	
login(Filmes,Usuarios):-
	write('Login:\n'),
	read(Login),
	usuarioReconhecido(Usuarios,Login,R),
	(R==(-1) -> write('Usuario nao encontrado!\n'), entrada(Filmes,Usuarios); menu(Filmes,Usuarios,Login)).
	
cadastro(Filmes,Usuarios):-
	write('Digite o nome de usuario:\n'),
	read(Usuario),
	usuarioReconhecido(Usuarios,Usuario,R),
	(R==(-1)->
	append(Usuarios,[(Usuario,[],[],[])],Atualizados),
	write('Usuario cadastrado com sucesso!\n'),
	%write(Atualizados),
	login(Filmes,Atualizados);
	write('Nome de usuario indisponível!\n'),
	cadastro(Filmes,Usuarios)
	).
	
aux([A,B,C,D,E,F,G],(A,B,C,D,E,F,G)).

conversao([],[]).
conversao([H|T],R):-
	aux(H,R1),
	conversao(T,R2),
	append([R1],R2,R).

menu(Filmes,Usuarios,Login):-
	write('1: Avaliar Filme.\n'),
	write('2: Consultar Filmes por Ator.\n'),
	write('3: Consultar Filme por Titulo.\n'),
	write('4: Consultar Filmes por Genero.\n'),
	write('5: Consultar Filmes por Diretor.\n'),
	write('6: Consultar Lista de Desejos.\n'),
	write('7: Adicionar Filme a Lista de Desejos.\n'),
	write('8: Consultar Lista de Filmes Assistidos.\n'),
	write('9: Ver Recomendações do Sistema.\n'),
	write('10: Ver Catalogo Completo de Filmes.\n'),
	write('0: Sair do Sistema.\n'),
	write('Opcao: \n'),
	read(Opcao),
	opcao(Opcao,Filmes,Usuarios,Login).

opcao(Opcao,Filmes,Usuarios,Login):-
	(Opcao==1->avaliar(Filmes,Usuarios,Login);
	 Opcao==2->cAtor(Filmes,Usuarios,Login);
	 Opcao==3->cTitulo(Filmes,Usuarios,Login);
	 Opcao==4->cGenero(Filmes,Usuarios,Login);
	 Opcao==5->cDiretor(Filmes,Usuarios,Login);
	 Opcao==6->cDesejos(Filmes,Usuarios,Login);
	 Opcao==7->aDesejo(Filmes,Usuarios,Login);
	 Opcao==8->cAssistidos(Filmes,Usuarios,Login);
	 Opcao==9->recomendacao(Filmes,Usuarios,Login);
	 Opcao==10->catalogo(Filmes,Usuarios,Login);
	 write('Saindo...\n'),halt).
	 
recomendacao(Filmes,Usuarios,Login):-
	getUsuarioFromLogin(Usuarios,Login,Atual),
	getFilmes(Atual,Assistidos),
	converte(Assistidos,Filmes,X),
	ordenar(X,FilmesAssistidos),
	ordenar(Filmes,FilmesOrdenados),
	getGeneros(FilmesAssistidos,[],Generos),
	recomendar(FilmesOrdenados,Generos,[],X,R),
	formatarFilmes(R,Resp),
	write(Resp),
	menu(Filmes,Usuarios,Login).
	
getUsuarioFromLogin([H|T],Login,R):-
	getLogin(H,X),
	(X==Login->R=H; getUsuarioFromLogin(T,Login,R)).

converte([],_,[]).

converte([H|T],Filmes,R):-
	getFilme(Filmes,H,R1),
	converte(T,Filmes,X),
	append([R1],X,R).
	
	 
aDesejo(Filmes,Usuarios,Login):-
	write('Digite o Nome do Filme:\n'),
	read(Filme),
	adicionarDesejo(Usuarios,Login,Filme,Atualizados),
	menu(Filmes,Atualizados,Login).
	
cDesejos(Filmes,Usuarios,Login):-
	write('Digite o Nome do Usuario: \n'),
	read(Usuario),
	getListaDesejo(Usuarios,Usuario,R),
	write(R),
	write('\n'),
	menu(Filmes,Usuarios,Login).
	
cAssistidos(Filmes,Usuarios,Login):-
	write('Digite o Nome do Usuario: \n'),
	read(Usuario),
	getListaAssistidos(Usuarios,Usuario,R),
	write(R),
	write('\n'),
	menu(Filmes,Usuarios,Login).	

	 
avaliar(Filmes,Usuarios,Login):-
	write('Digite o Nome do Filme: \n'),
	read(Filme),
	getFilme(Filmes,Filme,K),
	(K==[] -> write('Filme nao se encontra no catalogo!\n'), menu(Filmes,Usuarios,Login); 
	write('Digite sua Nota: \n'),
	read(Nota),
	atualizaNotaFilme(Filmes,Filme,Nota,FilmesAtualizados),
	assisteFilme(Usuarios,Login,Filme,Nota,UsuariosAtualizados),
	menu(FilmesAtualizados,UsuariosAtualizados,Login)
	).
	
	
cAtor(Filmes,Usuarios,Login):-
	write('Digite o Nome do Ator: \n'),
	read(Ator),
	consultaPorAtor(Ator,Filmes,R),
	formatarFilmes(R,R1),
	write(R1),
	menu(Filmes,Usuarios,Login).

cGenero(Filmes,Usuarios,Login):-
	write('Digite o Nome do Genero: \n'),
	read(Genero),
	consultaPorGenero(Genero,Filmes,R),
	formatarFilmes(R,R1),
	write(R1),
	menu(Filmes,Usuarios,Login).
	
cTitulo(Filmes,Usuarios,Login):-
	write('Digite o Nome do Titulo: \n'),
	read(Titulo),
	getFilme(Filmes,Titulo,R),
	write(R),
	write('\n'),
	menu(Filmes,Usuarios,Login).

cDiretor(Filmes,Usuarios,Login):-
	write('Digite o Nome do Diretor: \n'),
	read(Diretor),
	consultaPorDiretor(Diretor,Filmes,R),
	formatarFilmes(R,R1),
	write(R1),
	menu(Filmes,Usuarios,Login).
	
catalogo(Filmes,Usuarios,Login):-
	formatarFilmes(Filmes,R),
	write(R),
	menu(Filmes,Usuarios,Login).
notaMedia([],0).                 
notaMedia(Notas, Media) :-  
	length(Notas, L),
    somatorio(Notas, Soma),
    Media is Soma/L.

	
	
	

    

	
