Usuario(Login, Filmes, Notas, ListaDesejo).

getUsuarioLogin((Login, _, _, _) Login).
getUsuarioFilmes((_, Filmes, _, _) Filmes).
getUsuarioNotas((_, _, Notas, _) Notas).
getUsuarioDesejo((_, _, _, ListaDesejo) ListaDesejo).
