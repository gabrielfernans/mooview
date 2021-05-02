import System.IO
import System.Directory
import View
import Auth
import Filme
import Usuario

main :: IO()
main = do
	putStrLn intro
	entrada

entrada :: IO()
entrada=do
	putStrLn logOption
	opcao <- getLine
	opcaoEntrada (read opcao)
	
opcaoEntrada :: Int->IO()
opcaoEntrada opcao
	|opcao == 1 = do{logar}
    |opcao == 2 = do{cadastrar}
	|otherwise = do{putStrLn "Opção inválida. Tente novamente"; entrada}

logar :: IO()
logar = do
	putStrLn "Digite seu usuario: "
	usuario <- getLine
	
	usuarios_arquivados <- readFile "./database/usuarios.txt"
	let usuarios = read usuarios_arquivados :: [Usuario]
	let meuUsuario = getUsuarioFromLogin usuario usuarios :: Usuario
	
	if login meuUsuario == "" 
		then do
		putStrLn "Login invalido! Cadastre-se primeiro.\n"
		entrada
	else do
		putStr "Bem vindo de volta, "
		putStr usuario
		putStrLn "!!!"
		menu (usuario)

cadastrar :: IO()
cadastrar = do
	putStrLn "Digite seu novo usuario: "
	usuario <- getLine
	
	usuarios_arquivados <- readFile "./database/usuarios.txt"
	let usuarios = read usuarios_arquivados :: [Usuario]
	let usuarios_atualizados = Usuario usuario [] []
	
	removeFile "./database/usuarios.txt"
	appendFile "./database/usuarios.txt" (show (usuarios++[usuarios_atualizados]))
	
	print("Usuario cadastrado com sucesso")
	
	entrada

menu :: String->IO()
menu usuario = do
    putStrLn menuView
    opcao <- getLine
    minhaOpcao usuario (read opcao) 

minhaOpcao :: String->Int->IO()
minhaOpcao usuario opcao
    | opcao == 1 = do{avaliarFilme usuario} 
    | opcao == 2 = do{recomendacaoFilmes usuario}  
    | opcao == 3 = do{consultarPorAtor usuario}
    | opcao == 4 = do{consultarPorDiretor usuario}  
    | opcao == 5 = do{consultarPorTitulo usuario}  
    | opcao == 6 = do{consultarPorGenero usuario}   
    | opcao == 7 = do{consultarListaDesejo usuario}
    | opcao == 8 = do{adicionarListaDesejo usuario} 
    | opcao == 9 = do{consultarListaAssistidos usuario} 
    | opcao == 0 = do {putStrLn "Saindo...\n"} 
    | otherwise = do {putStrLn "Opcao invalida!"; menu usuario}

avaliarFilme :: String->IO()
avaliarFilme usuario = do
    putStrLn "Titulo: "
    filme <- getLine
    
    filmes_arquivados <- readFile "./database/filmes.txt"
    let filmes = read filmes_arquivados :: [Filme]
    
    if filmeExiste filme filmes
    	then do
        putStrLn "Nota: "
        avaliacao <- getLine

        let current_filme = getFilme filme filmes

        usuarios_arquivados <- readFile "./database/usuarios.txt"

        let usuarios = read usuarios_arquivados :: [Usuario]
        let current_user = getUsuarioFromLogin usuario usuarios
        let listaAssistidosAtualizada = adicionarFilmeFilmesAssistidos current_user (filme, read avaliacao)
        let usuarios_atualizados = atualizaFilmesAssistidos usuario listaAssistidosAtualizada usuarios
        
        let desejosAtualizada = removerListaDesejo (listaDesejo current_user) filme
        let usuarios_final = atualizaDesejos usuario desejosAtualizada usuarios_atualizados

        removeFile "./database/usuarios.txt"
        appendFile "./database/usuarios.txt" (show (usuarios_final))
        
        let notas_atualizadas = adicionaNota current_filme (read avaliacao)
        let filmes_atualizados = atualizaNotaFilme filme notas_atualizadas filmes
        
        removeFile "./database/filmes.txt"
        appendFile "./database/filmes.txt" (show (filmes_atualizados))
        
        putStrLn("Filme avaliado com sucesso")
    	
    else do
	    putStrLn("Tal filme nao existe")
    
    menu usuario

recomendacaoFilmes :: String->IO()
recomendacaoFilmes usuario = do
	usuarios_arquivados <- readFile "./database/usuarios.txt"
	let usuarios = read usuarios_arquivados :: [Usuario]
	
	filmes_arquivados <- readFile "./database/filmes.txt"
	let filmes = read filmes_arquivados :: [Filme]
	
	putStrLn(normalizandoFilmes (recomendacaoSistema (getUsuarioFromLogin usuario usuarios) filmes))
	
	menu usuario

consultarPorAtor :: String->IO()
consultarPorAtor usuario=do
    putStrLn "Ator: "
    ator <- getLine
    
    filmes_arquivados <- readFile "./database/filmes.txt"
    let filmes = read filmes_arquivados :: [Filme]
    
    if length(consultaPorAtor ator filmes) == 0 
    	then do
    		putStrLn "Ator nao encontrado"
    		menu usuario
    else do
    	putStrLn(normalizandoFilmes (consultaPorAtor ator filmes))
    	menu usuario

consultarPorDiretor :: String->IO()
consultarPorDiretor usuario = do
    putStrLn "Diretor: "
    direcao <- getLine

    filmes_arquivados <- readFile "./database/filmes.txt"
    let filmes = read filmes_arquivados :: [Filme]
    
    putStrLn(normalizandoFilmes (consultaPorDiretor direcao filmes))
    
    menu usuario

consultarPorTitulo :: String->IO()
consultarPorTitulo usuario = do
    putStrLn "Titulo: "
    nome <- getLine

    filmes_arquivados <- readFile "./database/filmes.txt"
    
    let filmes = read filmes_arquivados :: [Filme]
    
    if filmeExiste nome filmes
    	then do
    	putStrLn(normalizandoFilme (getFilme nome filmes))	
    else do
    	putStrLn "Não existe filme com esse titulo!"

    menu usuario

consultarPorGenero :: String->IO()
consultarPorGenero usuario = do
	putStrLn "Genero: "
	genero <- getLine
	
	filmes_arquivados <- readFile "./database/filmes.txt"
	let filmes = read filmes_arquivados :: [Filme]
	
	if length(consultaPorGenero genero filmes) == 0 
	    then do
	    putStrLn "Genero inexistente!"	
	else do
	    putStrLn(normalizandoFilmes (consultaPorGenero genero filmes))
	
	menu usuario

consultarListaDesejo :: String->IO()
consultarListaDesejo usuario = do
    putStrLn("Usuario: ")
    entrada <- getLine

    usuarios_arquivados <- readFile "./database/usuarios.txt"
    let usuarios = read usuarios_arquivados :: [Usuario]
    let current_user = getUsuarioFromLogin entrada usuarios
	
    print(getListaDeDesejo current_user)
	
    menu usuario

adicionarListaDesejo :: String -> IO()
adicionarListaDesejo usuario=do
    putStrLn "Filme: "
    filme <- getLine
    
    filmes_arquivados <- readFile "./database/filmes.txt"
    let filmes = read filmes_arquivados :: [Filme]
    
    if not(filmeExiste filme filmes)
    	then do
    	putStrLn "Filme inexistente!"
    else do
    	usuarios_arquivados <- readFile "./database/usuarios.txt"	
    	let usuarios = read usuarios_arquivados :: [Usuario]
    	let current_user = getUsuarioFromLogin usuario usuarios

    	let lista_nova = adicionarFilmeListaDesejo current_user filme
    	let usuarios_atualizados = atualizaDesejos usuario lista_nova usuarios
    
    	removeFile "./database/usuarios.txt"
    	appendFile "./database/usuarios.txt" (show (usuarios_atualizados))
    	
        putStrLn("Lista de desejos atualizada com sucesso")
    	
    menu usuario

consultarListaAssistidos :: String->IO()
consultarListaAssistidos usuario = do
    putStrLn("Usuario: ")
    entrada <- getLine

    usuarios_arquivados <- readFile "./database/usuarios.txt"
    let usuarios = read usuarios_arquivados :: [Usuario]
    let current_user = getUsuarioFromLogin entrada usuarios

    print(getListaAssistidos current_user)
    
    menu usuario

adicionaNota :: Filme->Double->[Double]
adicionaNota filme avaliacao = nota filme ++ [(avaliacao)]

atualizaNotaFilme :: String->[Double]->[Filme]->[Filme]
atualizaNotaFilme tituloFilme notas_atualizadas (h:t)
    |length t == 0 && titulo h == tituloFilme = [Filme {titulo = tituloFilme, nota = notas_atualizadas, genero = genero h, elenco = elenco h, diretor = diretor h, date = date h, sinopse = sinopse h}]
    |length t == 0 = [h]
    |titulo h == tituloFilme = [Filme {titulo = tituloFilme, nota = notas_atualizadas, genero = genero h, elenco = elenco h, diretor = diretor h, date = date h, sinopse = sinopse h}] ++ t
    |otherwise = [h] ++ (atualizaNotaFilme tituloFilme notas_atualizadas t)

recomendarFilmes :: [Filme]->[Filme]->[String]->Int->[Filme]
recomendarFilmes (h:t) assistidos generosPreferidos qtd
    |qtd == 0 = []
    |length t == 0 && (assistiuFilme h assistidos == 0) && (jaEscolheu (genero h) (generosPreferidos) == 1) = [h]
    |length t == 0 = []
    |(assistiuFilme h assistidos == 0) && (jaEscolheu (genero h) (generosPreferidos) == 1) = [h] ++ (recomendarFilmes t assistidos generosPreferidos (qtd-1))
    |otherwise = recomendarFilmes t assistidos generosPreferidos qtd

recomendacaoSistema :: Usuario-> [Filme]->[Filme] 
recomendacaoSistema usuario filmes 
	|length (filmesAssistidos usuario) == 0 = []
	|otherwise = recomendarFilmes (sort filmes) (toLista (filmesAssistidos usuario) filmes) (getGeneros ( toLista(sortAssistidos (filmesAssistidos usuario)) filmes) []) 10

consultaPorAtor :: String->[Filme]->[Filme]
consultaPorAtor ator filmes = [filmesComAtor | filmesComAtor <- filmes, elem ator (elenco filmesComAtor)]

consultaPorDiretor :: String->[Filme]->[Filme]
consultaPorDiretor direcao filmes = [filmesDoDiretor | filmesDoDiretor <- filmes, diretor filmesDoDiretor == direcao]

consultaPorGenero :: String->[Filme]->[Filme]
consultaPorGenero generoFilme filmes = [filmesPorGenero | filmesPorGenero <- filmes, genero filmesPorGenero == generoFilme]

adicionarFilmeFilmesAssistidos :: Usuario->(String,Double)->[(String, Double)]
adicionarFilmeFilmesAssistidos user avaliacao = filmesAssistidos user ++ [avaliacao]

atualizaFilmesAssistidos :: String->[(String,Double)]->[Usuario]->[Usuario]
atualizaFilmesAssistidos usuario nova_lista (h:t)
    |length t == 0 && login h == usuario = [Usuario {login=usuario, filmesAssistidos=nova_lista, listaDesejo=listaDesejo h}]
    |length t ==0  = [h]
    |login h==usuario = [Usuario {login = usuario, filmesAssistidos = nova_lista, listaDesejo = listaDesejo h}] ++ t
    |otherwise = [h] ++ (atualizaFilmesAssistidos usuario nova_lista t)

removerListaDesejo :: [String]->String->[String]
removerListaDesejo listaDesejo filme
	|length listaDesejo == 0 = []
	|length t == 0 && h == filme = []
	|length t == 0 = [h]
	|h == filme = t
	|otherwise = [h] ++ (removerListaDesejo t filme)
	where
		(h:t) = listaDesejo

adicionarFilmeListaDesejo :: Usuario->String->[String]
adicionarFilmeListaDesejo user filme = listaDesejo user ++ [filme]

atualizaDesejos :: String->[String]->[Usuario]->[Usuario]
atualizaDesejos usuario nova_lista (h:t)
    |length t == 0 && login h == usuario = [Usuario {login = usuario, filmesAssistidos = filmesAssistidos h, listaDesejo = nova_lista}]
    |length t == 0 = [h]
    |login h == usuario = [Usuario {login = usuario, filmesAssistidos = filmesAssistidos h, listaDesejo = nova_lista}] ++ t
    |otherwise = [h]++(atualizaDesejos usuario nova_lista t)
    
getListaDeDesejo :: Usuario->[String]
getListaDeDesejo usuario = listaDesejo usuario
    
getListaAssistidos :: Usuario->[(String,Double)]
getListaAssistidos usuario = filmesAssistidos usuario

getFilme :: String->[Filme]->Filme
getFilme nome filmes = [filmePorTitulo | filmePorTitulo <- filmes, nome == titulo filmePorTitulo] !! 0

comp :: (String, Double)->(String,Double)->Int
comp (x,y) (a,b)
	|y >= b = 1
	|otherwise = 0 

sortAssistidos :: [(String, Double)]->[(String,Double)]
sortAssistidos (h:t)
    |length t == 0 = [h]
    |comp h (maiorAssistidos t) == 1 = [h] ++ (sortAssistidos t)
    |otherwise = [maiorAssistidos t] ++ sortAssistidos (swapAssistidos t h (maiorAssistidos t))
    
maiorAssistidos:: [(String,Double)]->(String,Double)
maiorAssistidos (h:t)
    |length t == 0 = h
    |comp h (maiorAssistidos t) == 1 = h
    |otherwise = maiorAssistidos t
	
swapAssistidos:: [(String,Double)]->(String,Double)->(String,Double)->[(String,Double)]
swapAssistidos ((a,b):t) (insere,x) (remove,y)
	|length t == 0 && a == remove = [(insere,x)] 
    |length t == 0 = [(a,b)]
    |a==remove = [(insere,x)] ++ t
    |otherwise = [(a,b)] ++ swapAssistidos t (insere,x) (remove,y)

toLista :: [(String, Double)]->[Filme]->[Filme]
toLista ((a,b):t) filmes
	|length t == 0 = [filmeFromTitulo a filmes]
	|otherwise = [filmeFromTitulo a filmes] ++ toLista t filmes
	
filmeFromTitulo :: String->[Filme]->Filme
filmeFromTitulo tituloFilme (h:t)
	|titulo h == tituloFilme = h
	|otherwise = filmeFromTitulo tituloFilme t

assistiuFilme :: Filme->[Filme]->Int
assistiuFilme filme (h:t)
    |titulo filme == titulo h = 1
    |length t == 0 = 0
    |otherwise = assistiuFilme filme t
    
getGeneros :: [Filme]->[String]->[String]
getGeneros (h:t) escolhidos
	|length escolhidos == 3 = escolhidos
	|length t == 0 && jaEscolheu (genero h) (escolhidos) == 0 = escolhidos ++ [genero h]
    |length t == 0 = escolhidos
    |length escolhidos == 0 = getGeneros (t) (escolhidos ++ [genero h])
    |jaEscolheu (genero h) (escolhidos) == 0 = getGeneros (t) (escolhidos ++ [genero h])
    |otherwise = getGeneros (t) (escolhidos)

jaEscolheu :: String->[String]->Int
jaEscolheu genero lista
	|length lista == 0 = 0
    |h == genero = 1
    |length t == 0 = 0
    |otherwise = jaEscolheu genero t
    where
		(h:t) = lista

sort :: [Filme]->[Filme]
sort (h:t)
    |length t == 0 = [h]
    |notaMediaFilme h >= notaMediaFilme (maior t) = [h] ++ (sort t)
    |otherwise = [maior t] ++ sort (swap t h (maior t))
    
maior :: [Filme]->Filme
maior (h:t)
    |length t == 0 = h
    |notaMediaFilme h >= (notaMediaFilme (maior t)) = h
    |otherwise = maior t
	
swap :: [Filme]->Filme->Filme->[Filme]
swap (h:t) insere remove
	|length t == 0 && titulo h == titulo remove = [insere] 
    |length t == 0 = [h]
    |titulo h == titulo remove = [insere] ++ t
    |otherwise = [h] ++ swap t insere remove
	
notaMediaFilme :: Filme->Double
notaMediaFilme filme
	|length (nota filme) == 0 = 0
	|otherwise = (somatorioDeNotas (nota filme)) / (toDouble(length (nota filme)))

somatorioDeNotas :: [Double]->Double
somatorioDeNotas [] = 0
somatorioDeNotas (h : t) = h + somatorioDeNotas t

toDouble :: Int->Double
toDouble a
	|a == 0 = 0
	|otherwise = (toDouble (a - 1)) + 1.0

getUsuarioFromLogin :: String->[Usuario]->Usuario
getUsuarioFromLogin x (h:t)
	|x == login h = h
	|length t == 0 = Usuario "" [] []
	|otherwise = getUsuarioFromLogin x t

normalizandoFilmes :: [Filme] -> String
normalizandoFilmes [] = ""
normalizandoFilmes (h:t) = "Titulo: " ++ titulo h ++ " Sinopse: " ++ sinopse h ++ "\n" ++ normalizandoFilmes t

normalizandoFilme :: Filme -> String
normalizandoFilme filme = "Titulo: " ++ titulo filme ++ " Nota: " ++ show(notaMediaFilme filme) ++ " Genero: " ++ genero filme ++ "\n" ++ "Elenco: " ++ show(elenco filme) ++ " Diretor: " ++ diretor filme ++ " Date: " ++ show(date filme) ++ "\n" ++ "Sinopse: " ++ sinopse filme

filmeExiste :: String->[Filme]->Bool
filmeExiste nome filmes = length [filmePorTitulo | filmePorTitulo <- filmes, nome == titulo filmePorTitulo] /= 0 