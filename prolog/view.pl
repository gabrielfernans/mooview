slogan() :- cls(),
            write(" ___________________________________________________________________________"),nl,
            write("|                                                                           |"),nl,
            write("|      #####    ####  #########  ##        ##  ##  #######  ##       ##     |"),nl,
            write("|      ## ##   ## ##  ##     ##   ##      ##   ##  ##       ##   #   ##     |"),nl,
            write("|      ##  ## ##  ##  ##     ##    ##    ##    ##  #######  ##  ###  ##     |"),nl,
            write("|      ##   ###   ##  ##     ##     ##  ##     ##  ##       ## ## ## ##     |"),nl,
            write("|      ##    #    ##  #########      ####      ##  #######  ####   ####     |"),nl,
            write("|                                                                           |"),nl,
            write("|           UMA PLATAFORMA PARA RECOMENDACAO E AVALIACAO DE FILMES          |"),nl,
            write("|___________________________________________________________________________|"),nl,
            sleep(2).

loading() :- cls(),
             load1(),
             sleep(1),
             cls(),
             load2(),
             sleep(1),
             cls(),
             load3(),
             sleep(1),
             cls().

load1() :- write(" ___________________________________________________________________________"),nl,
           write("|                                                                           |"),nl,
           write("|      #####    ####  #########  ##        ##  ##  #######  ##       ##     |"),nl,
           write("|      ## ##   ## ##  ##     ##   ##      ##   ##  ##       ##   #   ##     |"),nl,
           write("|      ##  ## ##  ##  ##     ##    ##    ##    ##  #######  ##  ###  ##     |"),nl,
           write("|      ##   ###   ##  ##     ##     ##  ##     ##  ##       ## ## ## ##     |"),nl,
           write("|      ##    #    ##  #########      ####      ##  #######  ####   ####     |"),nl,
           write("|                                                                           |"),nl,
           write("|           UMA PLATAFORMA PARA RECOMENDACAO E AVALIACAO DE FILMES          |"),nl,
           write("|                                                                           |"),nl,
           write("|                                   o                                       |"),nl,
           write("|___________________________________________________________________________|"),nl.

load2() :- write(" ___________________________________________________________________________"),nl,
           write("|                                                                           |"),nl,
           write("|      #####    ####  #########  ##        ##  ##  #######  ##       ##     |"),nl,
           write("|      ## ##   ## ##  ##     ##   ##      ##   ##  ##       ##   #   ##     |"),nl,
           write("|      ##  ## ##  ##  ##     ##    ##    ##    ##  #######  ##  ###  ##     |"),nl,
           write("|      ##   ###   ##  ##     ##     ##  ##     ##  ##       ## ## ## ##     |"),nl,
           write("|      ##    #    ##  #########      ####      ##  #######  ####   ####     |"),nl,
           write("|                                                                           |"),nl,
           write("|           UMA PLATAFORMA PARA RECOMENDACAO E AVALIACAO DE FILMES          |"),nl,
           write("|                                                                           |"),nl,
           write("|                                      o                                    |"),nl,
           write("|___________________________________________________________________________|"),nl.

load3() :- write(" ___________________________________________________________________________"),nl,
           write("|                                                                           |"),nl,
           write("|      #####    ####  #########  ##        ##  ##  #######  ##       ##     |"),nl,
           write("|      ## ##   ## ##  ##     ##   ##      ##   ##  ##       ##   #   ##     |"),nl,
           write("|      ##  ## ##  ##  ##     ##    ##    ##    ##  #######  ##  ###  ##     |"),nl,
           write("|      ##   ###   ##  ##     ##     ##  ##     ##  ##       ## ## ## ##     |"),nl,
           write("|      ##    #    ##  #########      ####      ##  #######  ####   ####     |"),nl,
           write("|                                                                           |"),nl,
           write("|           UMA PLATAFORMA PARA RECOMENDACAO E AVALIACAO DE FILMES          |"),nl,
           write("|                                                                           |"),nl,
           write("|                                         o                                 |"),nl,
           write("|___________________________________________________________________________|"),nl.


cls() :- write('\33\[2J').

logOpt() :- write(" ___________________________________________________________________________"),nl,
            write("|                                                                           |"),nl,
            write("|                                ACESSE O SISTEMA                           |"),nl,
            write("|                                                                           |"),nl,
            write("|     1. FAZER LOGIN                                                        |"),nl,
            write("|     2. REALIZAR CADASTRO                                                  |"),nl,
            write("|                                                                           |"),nl,
            write("|     OPCAO:                                                                |"),nl,
            write("|___________________________________________________________________________|"),nl.
