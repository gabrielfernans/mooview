/* 	
	MOOVIEW - UMA PLATAFORMA PARA RECOMENDAÇÃO E AVALIAÇÃO DE FILMES
	PARADIGMAS DE LINGUAGEM DE PROGRAMACAO - 2020.1e - UFCG

	INTEGRANTES:
                GABRIEL FERNANDES DA COSTA
                ERICK MORAIS DE SENA
                DANIEL DE MATOS FIGUEREDO
                NATAN VINICIUS DA SILVA LUCENA
*/
:- include('view.pl').

:- initialization(main).

main :-
    slogan(),
    loading(),
    logOpt(),
    read(option).