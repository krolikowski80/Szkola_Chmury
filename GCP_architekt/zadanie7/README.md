>   Dress4Win jest internetową firmą, która pomaga swoim użytkownikom zorganizować i zarządzać swoją garderobą za pomocą aplikacji internetowej i aplikacji mobilnej. Ich aplikacja rozrosła się z kilku serwerów do nawet kilkuset serwerów i urządzeń w kolokowanym centrum danych. Jednak pojemność ich infrastruktury jest obecnie niewystarczająca do szybkiego rozwoju aplikacji. Ze względu na ten wzrost i chęć firmy do szybszego wprowadzania innowacji, Dress4Win zobowiązuje się do pełnej migracji do publicznej chmury.

>   W pierwszej fazie migracji do chmury, Dress4Win przenosi swoje środowiska rozwojowe i testowe. Budują również miejsce odzyskiwania danych w przypadku awarii, ponieważ ich obecna infrastruktura znajduje się w jednym miejscu. Nie są oni pewni, które komponenty ich architektury mogą migrować tak jak są i które komponenty muszą zmienić przed migracją.

## Przejdźmy do głównych wytycznych projektowych:

### Firma posiada jedną głowną bazę danych MySQL - jeden serwer dla danych użytkowników, inwentaryzacji, danych statycznych. Serwis ten jest głównym elementem, który ma zostać przeniesiony do środowiska w Google Cloud.
