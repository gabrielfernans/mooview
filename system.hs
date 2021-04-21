---- : UFCG - UNIVERSIDADE FEDERAL DE CAMPINA GRANDE
---- : PARADIGMAS DE LINGUAGENS DE PROGRAMAÇÃO - COMPUTAÇÃO@UFCG
---- : PLATAFORMA DE RECOMENDAÇÃO DE FILMES - PARADIGMA FUNCIONAL - IMPLEMENTACAO EM HASKELL

data Usuario = Usuario { primeiroNome :: String  
                     , ultimoNome :: String 
                     , listaFilmesAssistidos :: [(Filme, Double)] 
                     , listaDesejo :: [Filme]
                     } deriving (Show) 

data Filme = Filme { titulo :: String  
                     , nota :: [Double]
                     , elenco :: [String]
                     , diretor :: String
                     , roteirista :: String
                     , genero :: [String]
                     , premios :: [String]
                     , lancamento :: Int
                     , sinopse :: String
                     } deriving (Show)                  

avaliarFilme :: String-> String-> Double-> Void
avaliarFilme nomeUsuario nomeFilme nota = nota <- notaFilme
    where notaFilme = *buscaCSV*
        

recomendarFilmes :: String-> [(String, String)] 



consultarPorDiretor :: String -> [(String, String)]
consultarPorDiretor direçao = [filmesDoDiretor | filmesDoDiretor <- filmes, diretor filmesDiretor = direçao]
where
    filmes = *buscaCSV*

notaMediaFilme :: [Double] -> Double
notaMediaFilme notas = (somatorioDeNotas notas) / length notas

somatorioDeNotas :: [Double] -> Double
somatorioDeNotas [] = 0
somatorioDeNotas (h : t) = h + somatorioDeNotas t