# Pyrit

Nowoczesny i interaktywny system do zarządzania planami zajęć, przeznaczony dla
uczelni wyższych oraz szkół niższego szczebla.

Strona projektu: [http://mine.opensoftware.pl][1]

# Demo

Wersja demonstracyjna systemu dostępna jest [tutaj][2].

# Wymagania:

* GNU/Linux - praktycznie dowolna dystrybucja, zalecana GNU/Debian
* PostgreSQL >= 9.0
* ruby >= 2.0


# Instalacja

Jeżeli potrzebujesz wsparcia przy wdrożeniu systemu zapraszamy na
[stronę projektu][1] po więcej szczegółów.


    git clone https://github.com/Opensoftware/pyrite
    git checkout stable

    rake db:create
    rake db:migrate
    rake db:seed

# Licencja

AGPL

Patrz plik LICENSE

# Kontakt

biuro@opensoftware.pl

[1]: http://mine.opensoftware.pl
[2]: http://siatka-demo.opensoftware.pl
