data Filme = Filme { titulo :: String
                   , nota :: [Double]
                   , genero :: String
				   , elenco :: [String]
                   , diretor :: String
                   , date :: String
                   , sinopse :: String
       
                   } deriving (Eq,Ord,Show,Read)

 