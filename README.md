# DataCo Supply Chain Analytics

## 1. Cel projektu
Przygotowanie zbioru danych *DataCo Supply Chain* do analizy biznesowej. Projekt obejmuje pełny proces ETL – od czyszczenia i modelowania danych w SQL, po wizualizację kluczowych wskaźników (KPI) w Power BI.

## 2. Technologie
* **SQL Server / T-SQL** (czyszczenie, transformacja, modelowanie)
* **Power BI** (wizualizacja, DAX)

## 3. Architektura danych
Model gwiazdy (Star Schema): tabela faktów (`Fact_Sales`) oraz cztery tabele wymiarów (`Dim_Customer`, `Dim_Order`, `Dim_Product`, `Dim_Date`).

## 4. Etapy prac (ETL)
* **Weryfikacja jakości:** Audyt zbioru `stg_DataCoSupplyChainDataset` z użyciem `SUM(CASE WHEN...)` oraz `TRY_CAST` w celu identyfikacji braków i błędów formatowania.
* **Czyszczenie danych:** Przygotowanie tabel przejściowych, ujednolicenie typów danych (finansowe) oraz deduplikacja rekordów.
* **Modelowanie:** Przekształcenie struktury płaskiej w model gwiazdy (`Fact_Sales` oraz wymiary).
* **Testy:** Weryfikacja spójności modelu poprzez testy relacji (`LEFT JOIN` w celu wykrycia tzw. *orphan records*).

## 5. Roadmapa
* **Power BI:** Import danych i konfiguracja modelu relacyjnego.
* **DAX:** Implementacja miar (np. dynamika zysku YoY, wskaźnik opóźnień).
* **Dashboard:** Budowa raportu dla działu logistyki.
* **Publikacja:** Prezentacja wniosków biznesowych.
