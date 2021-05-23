main :-
    lerUsuarios(FormaDeString, FormaDeLista), write(FormaDeLista), nl, write(FormaDeString), 
    halt.

%lerfilmes

%a_primeira_saida_eh_uma_representacao_em_string_do_arquivo
%a_segunda_saida_eh_uma_representacao_em_lista_do_arquivo
lerFilmes(StringDoArquivo, ListaDoArquivo) :-
    open('database/filmes.txt', read, Stream),
    read_file(Stream, Line),
    resgataFilmes(Line, StringDoArquivo), ListaDoArquivo = Line,
    close(Stream).

%o_argumento_passado_deve_ser_uma_string_com_os_novos_filmes_cada_atributo_
%separado_por_virgula_e_sem_aspas
escreverFilmes(StringComNovosFilmes) :-
    lerFilmes(X), 
    open('database/filmes.txt', write, Stream),
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
    open('database/usuarios.txt', read, Stream),
    read_file(Stream, Line),
    resgataUsuarios(Line, StringDoArquivo), ListaDoArquivo = Line,
    close(Stream).

%o_argumento_passado_deve_ser_uma_string_com_os_novos_usuarios_cada_atributo_
%separado_por_virgula_e_sem_aspas
escreverUsuarios(StringComNovosUsuarios) :-
    lerUsuarios(X,Y), 
    open('database/usuarios.txt', write, Stream),
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
