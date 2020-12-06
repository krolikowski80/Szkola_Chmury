# [Zadanie nr 7 - Dress4Win](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-7-databases-on-google-cloud/zadanie-domowe-nr-7/)


Dress4Win jest internetową firmą, która pomaga swoim użytkownikom zorganizować i zarządzać swoją garderobą za pomocą aplikacji internetowej i aplikacji mobilnej. Ich aplikacja rozrosła się z kilku serwerów do nawet kilkuset serwerów i urządzeń w kolokowanym centrum danych. Jednak pojemność ich infrastruktury jest obecnie niewystarczająca do szybkiego rozwoju aplikacji. Ze względu na ten wzrost i chęć firmy do szybszego wprowadzania innowacji, Dress4Win zobowiązuje się do pełnej migracji do publicznej chmury.

W pierwszej fazie migracji do chmury, Dress4Win przenosi swoje środowiska developerskie i testowe. Budują również miejsce odzyskiwania danych w przypadku awarii, ponieważ ich obecna infrastruktura znajduje się w jednym miejscu. Nie są oni pewni, które komponenty ich architektury mogą migrować tak jak są i które komponenty muszą zmienić przed migracją.

#### 1. Firma posiada jedną głowną bazę danych MySQL - jeden serwer dla danych użytkowników, inwentaryzacji, danych statycznych. Serwis ten jest głównym elementem, który ma zostać przeniesiony do środowiska w Google Cloud.

* Najlepszym wyborem dla MySQL jest Cloud SQL.

#### 2. Dział bezpieczeństwa posiada serwery, które nie są związane bezpośrednio z samą architekturą aplikacji. Serwery te również mają zostać przeniesione do środowiska w Google Cloud:
    * Jenkins, monitoring, bastion hosts, skanery bezpieczeństwa
    * Serwery składają się z : 8 CPUs oraz 32GB RAM.
* Compute Engine
    * n2-standard-8 lub n2-standard-8 - w zalwżności od obciążenia

#### 3. Firma lokalnie posiada serwery NAS, które odpowiadają za przechowywanie obrazów, logów oraz kopii zapasowych. Serwery muszą posiadają możliwość wersjonowania obiektów oraz kontrolowania dostępu na poziomie pojedyńczego obiektu. Kilka informacji o atualnej pojemności w środowisku lokalnym, która musi zostać spełniona w środowisku chmurowym:
* Cloud Storage - regionalny z włączoną opcją wersjonowania

#### 4. Dress4Win planuje zbudować miejsce odzyskiwania danych w przypadku awarii, ponieważ ich obecna infrastruktura znajduje się w jednym miejscu.
Zaproponuj plan działania w przypadku awarii na poziomie samej bazy danych, ponieważ jest to krytyczny element działania aplikacji oraz środowisk w całej firmie, dlatego ten element wymaga dość dużej precyzji. Wykorzystanie możliwości jakie oferuje Cloud SQL:

* [Cloud SQL HA](https://cloud.google.com/sql/docs/mysql/high-availability)
    * Na obecny stan wiedzy nic leprzego nie pdrzychodzi mi do głowy

Zaproponuj plan, który będzie brał pod uwagę odzyskiwanie danych z rozwiązania dla serwerów NAS w Google Cloud tak, aby firma nie musiała się przejmować, że ich obrazy czy też np. logi z danego dnia nagle znikną
* Cloud storage z włączoną opcją wersjonowania

#### 5.Dodatkowe wytyczne:
Zarząd planuje ekspansje globalną jeśli chodzi o aplikacje, wiec również jej dane będą udostępniane globalnie w pewnych regionach. Zarząd zauważył, że baza MySQL pod względem architektury staje się wąskim gardłem, kiedy mówimy o skalowalności. Firma jest gotowa zainwestować czas na migrację do pełni zarządzalnego, skalowalnego, relacyjnego serwisu baz danych dla regionalnych i globalnych danych aplikacyjnych, aby ekspansja na rynek zagraniczny nie była przeszkodą.
