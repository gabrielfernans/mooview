Filme(Titulo, Notas, Elenco, Diretor, Genero, Lancamento, Sinopse).

getFilmeTitulo((Titulo, _, _, _, _, _, _), Titulo).
getFilmeNotas((_, Notas, _, _, _, _, _), Notas).
getFilmeElenco((_, _, Elenco, _, _, _, _), Elenco).
getFilmeDiretor((_, _, _, Diretor, _, _, _), Diretor).
getFilmeGenero((_, _, _, _, Genero, _, _), Genero).
getFilmeLancamento((_, _, _, _, _, Lancamento, _), Lancamento).
getFilmeSinopse((_, _, _, _, _, _, Sinopse), Sinopse).
