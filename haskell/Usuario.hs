module Usuario where

data Usuario = Usuario { login :: String
                       , filmesAssistidos :: [(String, Double)]
                       , listaDesejo :: [String]
                       } deriving (Eq,Ord,Show,Read)