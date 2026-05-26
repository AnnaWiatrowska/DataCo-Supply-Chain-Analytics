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
* 
## 6. Realizacja raportu w Power BI

Raport został zaprojektowany z myślą o użytkownikach biznesowych i operacyjnych, łącząc estetykę (Dark Mode) z optymalizacją wydajności miar.

### Strona 1: Raport Sprzedaży (Global Sales Overview)
* **Monitorowanie KPI:** Analiza łącznych przychodów, dynamiki sprzedaży oraz zysków w ujęciu globalnym.
* **Interfejs i UX:** Wdrożenie wysuwanego panelu filtrów (Slicer Pane), zapewniającego oszczędność przestrzeni roboczej.
* **Detale na żądanie:** Wykorzystanie niestandardowych Tooltipów wyświetlających Top 3 produkty pod względem przychodu po najechaniu na kategorię.
 ![Sales Overview](strona1.jpg)

### Strona 2: Dashboard Logistyczny (Logistics Overview)
* **Efektywność operacyjna:** Monitorowanie wskaźnika OTDR (On-Time Delivery Rate) oraz identyfikacja opóźnień w dostawach.
* **Analiza wąskich gardeł:** Porównanie rzeczywistego czasu wysyłki z planowanym (Actual vs Plan) w podziale na klasy wysyłki.
* **Dynamiczna kontekstowość:** Implementacja miar DAX automatycznie aktualizujących nagłówki wykresów w zależności od wybranych rynków i okresów.
  ![Logistics Overview](strona2.jpg)

### Strona 3: Profil Klienta (Clients Analytics)
* **Struktura przychodów:** Analiza struktury bazy klienckiej (18,5K klientów) z podziałem na segmenty (Consumer, Corporate, Home Office), gdzie segment konsumencki generuje blisko 52% łącznego przychodu.
* **Geografia i rankingi:** Identyfikacja kluczowych rynków poprzez analizę przychodów w ujęciu geograficznym (Revenue by State) połączona z tabelą rankingową najlepszych klientów.
* **Segmentacja (Scatter Plot):** Wykres rozrzutu mapujący zysk (Profit) względem przychodu (Revenue) per klient, pozwalający na szybkie wyodrębnienie transakcji wysokomarżowych oraz stratnych.
![Clients Analytics](strona3.png)

### Strona 4: Retencja Klientów (Customer Retention)
* **Powracalność klientów:** Dedykowany moduł kohortowy i trendu monitorujący liczbę powracających kupujących (Returning Customers) oraz stabilność wskaźnika retencji (Retention Rate) w czasie.
* **Analiza utraty (Churn):** Analiza trendów odpływu klientów (Churn Rate) w podziale na segmenty rynku, kluczowa dla optymalizacji działań marketingowych i utrzymaniowych B2B i B2C.
![Customer Retention](strona4.jpg)

### Analityka DAX:
* Wykorzystanie funkcji Time Intelligence do kalkulacji skumulowanych wartości (Revenue YTD) oraz wskaźników dynamiki rok do roku (Revenue Growth Rate).
* Zastosowanie funkcji iteracyjnych (`CONCATENATEX`) połączonych z weryfikacją kontekstu filtrowania (`ISFILTERED`) do automatyzacji warstwy opisowej raportu.
