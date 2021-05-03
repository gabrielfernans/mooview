module View where

intro :: String
intro = "--------------------------------------------------------------------------------|\n"++
        "                                                                                |\n" ++
        "  ███       ███  █████████  █████████  ██      ██  ██  ███████  ██          ██  |\n" ++
        "  ████    █████  ██     ██  ██     ██   ██    ██   ██  ██        ██        ██   |\n" ++
        "  ██  ██ ██  ██  ██     ██  ██     ██    ██  ██    ██  ████       ██  ██  ██    |\n" ++
        "  ██   ███   ██  ██     ██  ██     ██     ████     ██  ██          ████████     |\n" ++
        "  ██         ██  █████████  █████████      ██      ██  ███████      ██  ██      |\n" ++
        "                                                                                |\n" ++
        "             UMA PLATAFORMA PARA RECOMENDAÇÃO E AVALIAÇÃO DE FILMES             |\n" ++
        "                                                                                |\n" ++
        "--------------------------------------------------------------------------------|\n"

logOption :: String
logOption = "|-------------------------------------------|\n"++
            "|             ACESSE O SISTEMA:             |\n"++
            "|                                           |\n"++
            "|  1. FAZER LOGIN                           |\n"++
            "|  2. REALIZAR CADASTRO                     |\n"++
            "|                                           |\n"++
            "|                   OPÇÃO:                  |\n"++
            "|-------------------------------------------|\n"

menuView :: String
menuView =  "|-------------------------------------------|\n"++
            "|                   MENU:                   |\n"++
            "|                                           |\n"++
            "|   1. AVALIAR FILME                        |\n"++
            "|   2. VER RECOMENDAÇÕES DO SISTEMA         |\n"++
            "|   3. CONSULTAR FILME POR ATOR             |\n"++
            "|   4. CONSULTAR FILME POR DIRETOR          |\n"++
            "|   5. CONSULTAR FILME POR TITULO           |\n"++
            "|   6. CONSULTAR FILME POR GENERO           |\n"++
            "|   7. CONSULTAR LISTA DE DESEJO            |\n"++
            "|   8. ADICIONAR FILME A LISTA DE DESEJO    |\n"++
            "|   9. CONSULTAR FILMES ASSISTIDOS          |\n"++
            "|   0. SAIR DO PROGRAMA                     |\n"++
            "|                                           |\n"++
            "|                   OPÇÃO:                  |\n"++
            "|-------------------------------------------|\n"
