# Notatki ze spotkania nr 4 - Databases

## 1 - Każda migracja do chmury wiąże się ze ovsługą sporej ilości danych. Złe dobranie bazy lub storage - prędzej czy później stanie stanie się to problemem. 

- cosmos jest do szybko dostpnych i georeplikowalnych danych - tp jest no SQL

zwykły blob jet nie mutowalny
duże bloby - page bloby - np obraz dysku
append blob - mutowalne bloby

datalike - duża ilość danych w strukturach

dyski zarządzalne - MS przechowuje go u siebie i nim zarządza a my mamy na to SLA
niezarzadzalne - my musimy wskazać gdzie gobędziemy trzymać i nie ma SLA

Vcore zamiast DTU
Klasyfikscja danych - temat na egzamin
    - Redtricted
    - private
    - public


hot - nie płącimy za odczyty ale ma najwyższy koszt składowania
warstwa cool op≤łaca się wtedy, kiedy do danych sięgamy raz na pół roku - chodzi o koszty transferu danych]
warstwa archiwe - 10 razy tańszy od hot. Odczyt danych jest drogi i nie jest w real time. Nie można czytać takich danych bez zmiany warstwy na hot albo cold. Co sporo kosztuje. Opłaca się przy dostępności raz na rok.