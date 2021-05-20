/* 	
	MOOVIEW - UMA PLATAFORMA PARA RECOMENDAÇÃO E AVALIAÇÃO DE FILMES
	PARADIGMAS DE LINGUAGEM DE PROGRAMACAO - 2020.1e - UFCG

	INTEGRANTES:
                GABRIEL FERNANDES DA COSTA
                ERICK MORAIS DE SENA
                DANIEL DE MATOS FIGUEREDO
                NATAN VINICIUS DA SILVA LUCENA
*/

:- include('View.pl').

/* 
    PARAMETROS
        Usuario(Login, Filmes, Notas, ListaDesejo).
*/
:- include('Usuario.pl').

/*
    PARAMETROS:
        Filme(Titulo, Notas, Elenco, Diretor, Genero, Lancamento, Sinopse).
*/
:- include('Filme.pl').

:- initialization(main).

main :-


avaliarFilme(TituloFilme, Nota) :- getFilmeTitulo(TituloFilme, Filme),
                                   
notaMedia(Notas, Media) :-  
                            length(Notas, L),
                            somatorio(Notas, Soma),
                            Media is Soma/L.

somatorio([], 0).
somatorio([H | T], Soma) :- somatorio(T,Soma1),
                             Soma is Soma1+H.

consultaPorAtor(_, [], []).
consultaPorAtor(Ator, [H | T], R):-
                            getFilmeElenco(H, E),
                            consultaPorAtor(Ator, T, R1),
                            (member(Ator, E) -> append(H,R1,R); R is R1).

consultaPorDiretor(_, [], []).
consultaPorDiretor(Diretor, [H | T], R):-
                            getFilmeDiretor(H, D),
                            consultaPorDiretor(Diretor, T, R1),
                            (Diretor =:= D -> append(H,R1,R); R is R1).

consultaPorGenero(_, [], []).
consultaPorGenero(Genero, [H | T], R):-
                            getFilmeGenero(H, G),
                            consultaPorAtor(Ator, T, R1),
                            (Genero =:= G -> append(H,R1,R); R is R1).

adicionarFilmeAssistido((Login, Filmes, Notas, ListaDesejo), Assistido, Avaliacao, (Login, Filmes1, Notas1, ListaDesejo)) :-
                            append(Filmes, Assistido, Filmes1),
                            append(Notas, Avaliacao, Notas1).

removerListaDesejo((Login, Filmes, Notas, []), Filme, (Login, Filmes, Notas, [])).
removerListaDesejo((Login, Filmes, Notas, ListaDesejo), Filme, (Login, Filmes, Notas, ListaDesejo1)):-
                            member(Filme, ListaDesejo),
                            removeDesejo(ListaDesejo, Filme, ListaDesejo1).

removeDesejo([H | T], H, T).
removeDesejo([H | T], Filme, R) :-
                            removeDesejo(T, Filme, R1),
                            append(H, R1, R).

adicionarFilmeListaDesejo((Login, Filmes, Notas, ListaDesejo), Desejo, (Login, Filmes, Notas, ListaDesejo1):-
                            append(ListaDesejo, Desejo, ListaDesejo1).

getFilme([], _, []).
getFilme([H | T], Titulo, Filme) :-
                            getFilmeTitulo(H, R),
                            getFilme(T, Titulo, R1),
                            (R =:= Titulo -> Filme is H; getFilme(T, Titulo, R1),).


