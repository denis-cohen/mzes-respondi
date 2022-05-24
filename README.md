# MZES Mitarbeiter:innen-Befragung

## Hinweise für respondi

1. Bitte arbeiten Sie stets im RProject (`mzes-respondi.RProj`). Beim Start-up wird u.a. das dependency-management via `renv` initialisiert/aktiviert und die Ordnerstruktur des Projekts erzeugt.
1. Bitte legen Sie den Datensatz in den Ordner `dat` und passen Sie in der Datei `.Rprofile` die Werte der Objekte `respondi_xlsx_name` und `respondi_sheet_name` an. Nach der erstmaligen Änderung muss die R-Sitzung neu gestartet werden, damit die Änderung effektiv wird.
1. Führen Sie bitte das Skript `r/get-univariate-summaries.r` aus. Die dadurch erzeugten univariaten Häufigkeitverteilungen persönlicher Merkmale werden unter `csv/univariate` gespeichert.
