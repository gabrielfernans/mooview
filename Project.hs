---- : UNIVERSIDADE FEDERAL DE CAMPINA GRANDE - UFCG 
---- : UNIDADE ACADÊMICA DE SISTEMAS E COMPUTAÇÃO
---- : PARADIGMAS DE LINGUAGENS DE PROGRAMAÇÃO
---- : PROFESSOR: EVERTON LEANDRO GALDINO ALVES

---- : PROJETO FINAL - PARADIGMA FUNCIONAL

---- : INTEGRANTES: 
---- :            DANIEL DE MATOS FIGUEREDO 
---- :            ERICK MORAIS DE SENA 
---- :            GABRIEL FERNANDES DA COSTA 
---- :            NATAN VINICIUS DA SILVA LUCENA 

---- : PLATAFORMA DE AVALIAÇÃO E RECOMENDAÇÃO DE FILMES

module Project where

data Usuario = Usuario { login :: String
                       , filmesAssistidos :: [(Filme, Double)]
                       , listaDesejo :: [Filme]
                       } deriving Show
                    
data Filme = Filme { titulo :: String
                   , nota :: [Double]
                   , elenco :: [String]
                   , diretor :: String
                   , roteirista :: String
                   , genero :: String
                   , premios :: [String]
                   , lancamento :: Int
                   , sinopse :: String
                   } deriving Show

avaliarFilme :: String-> String-> Double-> Void
avaliarFilme nomeUsuario nomeFilme nota = notaFilme ++ [nota]
    where notaFilme = *buscaCSV*
        

recomendarFilmes :: String-> [(String, String)] 



consultarPorDiretor :: String -> [Filme]
consultarPorDiretor direçao = [filmesDoDiretor | filmesDoDiretor <- filmes, diretor filmesDiretor = direçao]
where
    filmes = *buscaCSV*

consultarPorAtor :: String -> [Filme]
consultarPorAtor ator = [filmesComAtor | filmesComAtor <- filmes, elem ator (elenco filmes)]
where
    filmes = *buscaCSV*
consultarPorGenero :: String -> [Filme]
consultarPorGenero generoFilme = [filmesPorGenero | filmesPorGenero <- filmes, genero filme = generoFilme]
where
    filmes = *buscaCSV*

getFilme :: String -> Filme
getFilme titulo = [filmePorTitulo | filmePorTitulo <- filmes, titulo == titulo filmes)] !! 0
where
    filmes = *buscaCSV*

notaMediaFilme :: [Double] -> Double
notaMediaFilme notas = (somatorioDeNotas notas) / length notas

somatorioDeNotas :: [Double] -> Double
somatorioDeNotas [] = 0
somatorioDeNotas (h : t) = h + somatorioDeNotas t


assistiuFilme:: Filme->[Filme]->Int
assistiuFilme filme (h:t)
    |nome filme==nome h=1
    |length t==0 = 0
    |otherwise=assistiuFilme filme t
    
getGeneros:: [Filme]->[String]->[String]
getGeneros (h:t) escolhidos
    |length t==0=escolhidos
    |length escolhidos==3 = escolhidos
    |length escolhidos==0 = getGeneros (t) (escolhidos++[genero h])
    |jaEscolheu (genero h) (escolhidos)==0 = getGeneros (t) (escolhidos++[genero h])
    |otherwise = getGeneros (t) (escolhidos)

jaEscolheu:: String->[String]->Int
jaEscolheu genero (h:t)
    |h==genero = 1
    |length t==0 = 0
    |otherwise=jaEscolheu genero t
	
recomendarFilmes:: [Filme]->[Filme]->[String]->Int->[Filme]
recomendarFilmes (h:t) assistidos generosPreferidos qtd
    |qtd==0=[]
    |length t==0=[]
    |(assistiuFilme h assistidos == 0) && (jaEscolheu (genero h) (generosPreferidos)==1)=[h]++(recomendarFilmes t assistidos generosPreferidos (qtd-1))
    |otherwise = recomendarFilmes t assistidos generosPreferidos qtd


sort:: [Filme]->[Filme]
sort (h:t)
    |length t==0 =[h]
    |nota h>=nota (maior t)=[h]++(sort t)
    |otherwise = [maior t]++sort (swap t h (maior t))
    
    
    
maior:: [Filme]->Filme
maior (h:t)
    |length t==0=h
    |nota h>= (nota (maior t)) = h
    |otherwise = maior t
	
	
swap:: [Filme]->Filme->Filme->[Filme]
swap (h:t) insere remove
	|length t==0 && nome h==nome remove = [insere] 
    |length t==0=[h]
    |nome h==nome remove=[insere]++t
    |otherwise = [h]++swap t insere remove
	



getListaDeDesejo :: String -> 
    
pegaUsusario :: String -> Usuario
pegausuario login = [usuario | usuario <- usuarios, elem login (primeiroNome usuarios)] !! 0
where
    usuarios = *buscaCSV*

menu :: IO()
menu = do
    putStrn "I - Avaliar Filme"
    putStrn "II - Recomendar Filme"
    putStrn "III - Consultar Filme por Ator"
    putStrn "IV - Consultar Filme por Diretor"
    putStrn "V - Consultar Filme por Titulo"
    putStrn "VI - Consultar Filme por Genero"
    putStrn "VII - Marcar Filme como Assistido"
    putStrn "VIII - Consultar Minha Lista de Desejos"
    putStrn "IX - Adicionar Filme a Minha Lista de Desejos"
    putStrn "X - Remover Filme da Minha Lista de Desejos"
    putStrn "EXIT - Sair do programa\n"
    putStrn "Opcao: "
    opcao <- getLine
    minhaOpcao opcao

minhaOpcao :: String-> IO()
minhaOpcao opcao =
                    | opcao == "I" = avaliarFilme 
                    | opcao == "II" = recomendarFilmes   
                    | opcao == "III" = consultarPorAtor
                    | opcao == "IV" = consultarPorDiretor  
                    | opcao == "V" = consultarPorTitulo 
                    | opcao == "VI" = consultarPorGenero 
                    | opcao == "VII" = marcarComoAssistido 
                    | opcao == "VIII" = consultarListaDesejo 
                    | opcao == "IX" = adicionarFilmeListaDesejo 
                    | opcao == "X" = removerFilmeListaDesejo 
                    | opcao == "EXIT" = putStrn "Saindo..." 
                    | otherwise = do {putStrn "Opcao invalida!"; menu}