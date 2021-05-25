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
                            (L == Login -> adicionarFilmeAssistido(H, Assistido, Avaliacao, R1), removerListaDesejo(R1,Assistido,R2),append([R2], T, Usuarios); assisteFilme(T, Assistido, Avaliacao, R2), append([H], R2, Usuarios)).


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

main:-
	Filmes=[('a',[],['a','b'],'a','a',1,'a')],
	Usuarios=[('a',[],[],['a','b'])],
	write('Login: \n'),
	read(Login),
	menu(Filmes,Usuarios,Login).

menu(Filmes,Usuarios,Login):-
	write('1: Avaliar Filme.\n'),
	write('2: Consultar Filmes por Ator.\n'),
	write('3: Consultar Filme por Titulo.\n'),
	write('4: Consultar Filmes por Genero.\n'),
	write('5: Consultar Filmes por Diretor.\n'),
	write('6: Consultar Lista de Desejos.\n'),
	write('7: Adicionar Filme a Lista de Desejos.\n'),
	write('8: Consultar Lista de Filmes Assistidos.\n'),
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
	 Opcao==8->cAssistidos(Filmes,Usuarios,Login);
	 write('Saindo...\n'),halt).
	 
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
	write('Digite sua Nota: \n'),
	read(Nota),
	atualizaNotaFilme(Filmes,Filme,Nota,FilmesAtualizados),
	assisteFilme(Usuarios,Login,Filme,Nota,UsuariosAtualizados),
	menu(FilmesAtualizados,UsuariosAtualizados,Login).
	
	
cAtor(Filmes,Usuarios,Login):-
	write('Digite o Nome do Ator: \n'),
	read(Ator),
	consultaPorAtor(Ator,Filmes,R),
	write(R),
	write('\n'),
	menu(Filmes,Usuarios,Login).

cGenero(Filmes,Usuarios,Login):-
	write('Digite o Nome do Genero: \n'),
	read(Genero),
	consultaPorGenero(Genero,Filmes,R),
	write(R),
	write('\n'),
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
	consultaPorAtor(Diretor,Filmes,R),
	write(R),
	write('\n'),
	menu(Filmes,Usuarios,Login).
	