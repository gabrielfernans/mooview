module Test where

import Data.Char(digitToInt)
import Control.Concurrent
import System.IO
import System.Directory

slogan:: String
slogan =  "------------------------------------------------------------------------------|\n"++
        "                                                                                |\n"++
        "  ███       ███  █████████  █████████  ██      ██  ██  ███████  ██          ██  |\n"++
        "  ████     ████  ██     ██  ██     ██   ██    ██   ██  ██       ██   ████   ██  |\n"++
        "  ██  ██ ██  ██  ██     ██  ██     ██    ██  ██    ██  ████     ██  ██  ██  ██  |\n"++
        "  ██   ███   ██  ██     ██  ██     ██     ████     ██  ██       ████      ████  |\n"++
        "  ██         ██  █████████  █████████      ██      ██  ███████  ██          ██  |\n"++
        "                                                                                |\n"++
        "             UMA PLATAFORMA PARA RECOMENDAÇÃO E AVALIAÇÃO DE FILMES             |\n"++
        "                                                                                |\n"++
        "--------------------------------------------------------------------------------|\n"

main = do
        putStr slogan