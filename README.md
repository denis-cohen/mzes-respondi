# MZES Mitarbeiter:innen-Befragung

## Hinweise für respondi

### Vorbereitung

1. Bitte arbeiten Sie stets im RProject (`mzes-respondi.RProj`). Beim Start-up wird u.a. das dependency-management via `renv` initialisiert/aktiviert und die Ordnerstruktur des Projekts erzeugt.
1. Bitte legen Sie den Datensatz in den Ordner `dat` und passen Sie in der Datei `.Rprofile` die Werte der Objekte `respondi_xlsx_name` und `respondi_sheet_name` an. Nach der erstmaligen Änderung muss die R-Sitzung neu gestartet werden, damit die Änderung effektiv wird.

### Auswertung der quantitativen/geschlossenenen Fragen

1. Führen Sie bitte das Skript `r/get-univariate-summaries.r` aus. Die dadurch erzeugten univariaten Häufigkeitverteilungen werden unter `csv/univariate` gespeichert.
1. Führen Sie bitte das Skript `r/get-bivariate-summaries.r` aus. Die dadurch erzeugten bivariaten Häufigkeitverteilungen (Häufigkeitesverteilungen nach Subgruppen) werden unter `csv/bivariate` gespeichert. Dabei werden gemäß Datenschutzkonzept Auswertungen unterbunden, bei denen eine Subgruppengröße von $N=5$ unterschritten wird. Ein entsprechender Hinweis unter Nennung der betroffenen CSV-Dateien wird generiert. **Bitte prüfen Sie, dass die genannten CSV-Dateien keine Häufigkeitsverteilungen enthalten**.

### Auswertung der qualitativen/offenen Freitextfragen

1. Führen Sie bitte das Skript `r/get-randomized-responses.r` aus. Das Skript erzeugt zwei CSV-Datei, die gemäß Datenschutzkonzept alle validen (nicht-fehlenden) Freitextantworten innerhalb einer Fragegruppe zufallssortiert und frei von sonstigen identifizierenden Informationen (Beobachtungsnummer, sonstige Angaben auf Beobachtungsebene) beinhaltet:
    - `csv/open-text/pre-anonymization.csv` (als Referenz)
    - `csv/open-text/post-anonymization.csv` (zur aktiven manuellen Anonymisierung)
1. **Bitte arbeiten Sie in der Datei `csv/open-text/post-anonymization.csv`, um das besprochene manuelle Anonymisierungsverfahren umzusetzen:**
    1. Um zu gewährleisten, dass Freitextantworten keine Rückschlüsse auf einzelne Personen zulassen, werden die offenen Antworten zunächst vom beauftragten Unternehmen auf Anonymität geprüft und, falls nötig, anonymisiert. **Bitte vermerken Sie manuelle Änderungen zur Gewährleistung der Anonymität in der Spalte** `anonymized_by_respondi`. 
    1. Anschließend werden die offenen Antworten an zwei Beschäftigte des MZES übermittelt und erneut auf Anonymität überprüft. Die Übermittlung der Daten erfolgt dabei ohne Verknüpfung zu sonstigen personenbezogenen Daten, sondern lediglich in Form eines Textdokuments, das die offenen Antworten zu einer gegebenen Frage in zufälliger Reihenfolge ohne Bezug zu weiteren quantitativen Angaben (wie bspw. persönlichen Merkmalen) beinhaltet. Sollte die Gefahr der Deanonymisierung aufgrund des Inhalts der Freitextangaben bestehen, werden die betroffenen Freitextangaben weiter anonymisiert. Sollte dies nicht möglich sein, wird die betroffene Freitextantwort gelöscht. **Bitte kennzeichnen Sie Antworten, bei denen Sie implizite (d.h. sich ggf. aus dem Kontext ergebende) deanonymisierende Inhalte vermuten in der Spalte** `flagged_by_respondi`.
1. Aufgrund von technischen Schwierigkeiten bei der Trennung und Randomisierung multipler Antworten auf ein und die selbe Frage hatten wir uns darauf geeinigt, multiple Antworten zu Fragen zwar in separaten (bis zu acht) Textfeldern zu erfassen, die manuelle Anonymisierung aber pro Frage und Befragtem -- nicht pro Textfeld und Befragtem -- abzurechnen. Da diese Information im Zuge der Randomisierung verloren geht, erzeugen Zeilen 20-26 des Skripts `r/get-randomized-responses.r` über alle Befragten hinweg die Summe aller Fragen, bei denen mindestens ein Textfeld eine valide (nicht-fehlende) Freitextangabe enthält. Diese wird unter `csv/open-text/num_answered_questions.csv` gespeichert. **Bitte prüfen Sie dieses abrechnungsrelevante Verfahren auf Richtigkeit**.

### Export

Für den Export senden Sie bitte folgende Ordner/Auswertungsdateien an die hier verlinkten Rezipient*innen:

1. Den Inhalt des Ordners `csv/univariate` $\rightarrow$ [Simon Ellerbrock](mailto:Simon.Ellerbrock@mzes.uni-mannheim.de)
1. Den Inhalt des Ordners `csv/bivariate`, nach vorangegangener Prüfung (vgl. oben) $\rightarrow$ [Simon Ellerbrock](mailto:Simon.Ellerbrock@mzes.uni-mannheim.de)
1. Die manuell anonymisierte Fassung der Datei `csv/open-text/post-anonymization.csv` $\rightarrow$ [Anna Adendorf](mailto:Anna.Adendorf@mzes.uni-mannheim.de), [Anna-Sophie Kurella](anna.kurella@mzes.uni-mannheim.de)
1. Die abrechnungsrelevante Gesamtzahl der beantworteten Freitextfragen, d.h., die Datei `csv/open-text/num_answered_questions.csv` $\rightarrow$ [Simon Ellerbrock](mailto:Simon.Ellerbrock@mzes.uni-mannheim.de)
