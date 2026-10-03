# St0nys-AIO-WoW-EXE-Patcher

🇩🇪 Deutsch | [🇬🇧 English](README.en.md)

Ein All-in-One-Patcher (AIO) für die `Wow.exe` von **World of Warcraft 3.3.5a
(Build 12340)**.
Er spielt Bugfixes, Performance-Optimierungen, erweiterte Sichtweiten,
verbesserte Sound-Einstellungen und einige Komfort-Funktionen direkt in die
EXE ein – in einem Durchgang, ohne zusätzliche Tools oder DLL-Injector.

Beim Start wählst du die **Sprache** (Deutsch / English) und danach in einem
Menü, **welche Patches** eingespielt werden sollen. Eingespielte Patches lassen
sich später jederzeit wieder **abwählen oder ergänzen** – bis zurück zur
originalen `Wow.exe`.

> [!IMPORTANT]
> Dieses Repository enthält **keine** `Wow.exe` und keine anderen Dateien von
> Blizzard. Du brauchst deine eigene, unveränderte `Wow.exe` 3.3.5a (12340).

> [!CAUTION]
> **Entwickler-Werkzeug, Benutzung auf eigene Gefahr.** Dieser Patcher ist
> für eigene Server, Modding und Tests gedacht. Auf öffentlichen Servern kann
> **jeder** Patch gegen die Serverregeln verstoßen und zu einem **Bann**
> führen – auch die Patches, die hier **nicht** als Bann-Gefahr markiert sind.
> Die Markierungen nennen nur die bekannten Fälle; was ein Server erkennt und
> duldet, entscheidet er selbst und ändert es auch mal. Prüfe die Richtlinien
> deines Servers, **bevor** du eine gepatchte `Wow.exe` dort benutzt. Der
> Patcher zeigt diese Warnung auch bei jedem Start an.

---

## Inhalt

- [Voraussetzungen](#voraussetzungen)
- [Benutzung](#benutzung)
- [Ablauf](#ablauf)
- [Patch-Auswahl](#patch-auswahl)
- [Patches ändern oder zurücknehmen](#patches-ändern-oder-zurücknehmen)
- [Parameter für den unbeaufsichtigten Betrieb](#parameter-für-den-unbeaufsichtigten-betrieb)
- [Dateien](#dateien)
- [Patch-Übersicht](#patch-übersicht)
- [Patch-Beschreibungen](#patch-beschreibungen)
- [Hinweise](#hinweise)
- [Danksagung](#danksagung)
- [Lizenz](#lizenz)

---

## Voraussetzungen

- Windows mit PowerShell (Windows PowerShell 5.1 ist ab Windows 10 vorinstalliert)
- Eine **originale, unmodifizierte** `Wow.exe` 3.3.5a, Build 12340 mit
  SHA256 `AA63A5750D60EF16746C686B3D5E26876D98953EAB08B1C026CD0FAF78E88CB8`
  (nur beim ersten Start; danach genügt eine mit diesem Patcher gepatchte
  `Wow.exe`)

## Benutzung

1. `patcher.bat` und `apply_patches.ps1` in den WoW-Ordner kopieren
   (dorthin, wo die `Wow.exe` liegt).
2. WoW beenden, falls es noch läuft.
3. `patcher.bat` per Doppelklick starten.
4. Sprache wählen (nur beim ersten Start), Patches auswählen, bestätigen – fertig.

Patches **ändern oder zurücknehmen:** `patcher.bat` einfach erneut starten,
siehe [Patches ändern oder zurücknehmen](#patches-ändern-oder-zurücknehmen).

## Ablauf

1. ASCII-Banner wird angezeigt.
2. **Sprachauswahl:** `1` = Deutsch, `2` = English. Nur beim ersten Start – danach
   ist die Sprache gemerkt und lässt sich im Menü mit `L` umschalten.
3. Begrüßung, ENTER zum Starten.
4. Prüfung, ob eine `Wow.exe` im Ordner vorhanden ist.
5. Prüfung der `Wow.exe`: Beim ersten Start muss sie original und unmodifiziert
   sein (SHA256). Danach erkennt der Patcher eine von ihm gepatchte `Wow.exe` am
   Wasserzeichen und ermittelt, welche Patches darin stecken. Alles andere führt
   zum Abbruch.
6. **Patch-Auswahl** im Menü (siehe unten). Vorausgewählt ist die Auswahl vom
   letzten Mal bzw. bei einer gepatchten `Wow.exe` die Patches, die gerade
   darin stecken.
7. Bei Patches mit eigenem Wert (Sprunghöhe, Doppelsprung, Client-Infos) fragt
   der Patcher die Werte ab; danach speichert er die Auswahl.
8. Zusammenfassung der gewählten Patches (bei einer gepatchten `Wow.exe`: was
   neu dazukommt, was zurückgenommen wird), Hinweise (fehlende oder
   überflüssige Ergänzungs-Patches, Bann-Gefahr) und Sicherheitsabfrage (J/N).
9. Backup: Beim ersten Patchen wird das Original als `Wow.exe.ORI` gesichert,
   bei jedem weiteren Lauf die bisherige `Wow.exe` als `Wow.exe.BAK`.
10. Alle gewählten Patches werden im Speicher eingespielt (mit
    Fortschrittsanzeige) und die `Wow.exe` danach **einmal** zurückgeschrieben.
    Tritt dabei ein Fehler auf, bleibt die `Wow.exe` unverändert.
11. Der Patcher merkt sich den Hash der neuen `Wow.exe` samt Original-Bytes in
    `patcher_state.ini` (für einen schnelleren nächsten Start) und zeigt eine
    Abschlussmeldung.

## Patch-Auswahl

Das Menü listet alle Patches mit Nummer auf. `[X]` = wird eingespielt,
`[ ]` = wird übersprungen. Das Menü ist in dieselben Kategorien gegliedert wie
die [Patch-Übersicht](#patch-übersicht). Beim ersten Start ist das
**Preset „Billy's_Wow.exe“** vorausgewählt (Spalte „Standard“ in der Übersicht),
danach die gespeicherte Auswahl bzw. die Patches, die gerade in der `Wow.exe`
stecken. Mit `S` lädst du das zweite Preset **„St0nys_Wow.exe“** (Spalte
„St0ny“). Patches, die zusätzlich etwas benötigen, zeigen das in Klammern hinter
dem Namen; der Link dazu steht direkt darunter.

| Eingabe            | Wirkung                                     |
|--------------------|---------------------------------------------|
| `5`                | Patch 5 an-/abwählen                        |
| `3 7 12` / `3,7,12`| mehrere Patches an-/abwählen                |
| `10-15`            | einen Bereich an-/abwählen                  |
| `A`                | alle Patches an                             |
| `N`                | alle Patches aus (bei gepatchter `Wow.exe` + ENTER: Original wiederherstellen) |
| `L`                | Sprache umschalten (Deutsch ↔ English)      |
| `B`                | Preset „Billy's_Wow.exe“ laden (= Standard) |
| `S`                | Preset „St0nys_Wow.exe“ laden – **noch ungetestet** |
| `Q`                | abbrechen, die `Wow.exe` bleibt unverändert |
| `ENTER`            | Auswahl übernehmen und weiter               |

Vor der Sicherheitsabfrage zeigt der Patcher **Hinweise** an, gesperrt wird
nichts: wenn ein Ergänzungs-Patch fehlt (z. B. brauchen die erweiterten
Slider-Maxima die CVar-Unlocks), wenn ein Patch einen anderen überflüssig macht
(Warden komplett abschalten ersetzt den RCE-Fix) und – als rote Zeile – wenn
gewählte Patches zu einem Bann führen können (Anti-Cheat oder veränderte
Dateigröße, siehe [Hinweise](#hinweise)).

### Auswahl wird gespeichert

Sobald du die Auswahl mit ENTER übernimmst, speichert der Patcher sie in der
Datei `patcher_selection.ini` neben dem Skript. Beim nächsten Start ist genau
diese Auswahl wieder vorausgewählt – auch wenn du vorher bei der
Sicherheitsabfrage abgebrochen hast.

- Gespeichert wird pro Patch (über eine interne Kennung), nicht pro Nummer.
  Kommen in einer neueren Version Patches hinzu, bleibt deine Auswahl korrekt,
  und die neuen Patches starten mit ihrer Standard-Einstellung.
- Die Datei ist eine einfache Textdatei (`laa=1`, `cache=0`, …) und kann auch
  von Hand bearbeitet werden. Dort stehen auch die eingegebenen Werte der
  Client-Info-Patches (`value.clientversion=3.3.6` usw.).
- Auch die Sprache wird dort gemerkt (`language=de` bzw. `en`).
- **Zurücksetzen:** im Menü `B` drücken oder `patcher_selection.ini` löschen –
  dann gilt wieder das Preset „Billy's_Wow.exe“ (beim Löschen der Datei werden
  auch Sprache und gemerkte Werte wieder abgefragt).

Das Preset „Billy's_Wow.exe“ ist das Patch-Set von Billy Hoyle und zugleich die
Standard-Auswahl. Es ist in `apply_patches.ps1` festgelegt: Jeder Patch hat dort
einen Eintrag `On = $true` (im Preset) bzw. `On = $false` (nicht im Preset).

Das zweite Preset „St0nys_Wow.exe“ (Taste `S`) ist Billys Patch-Set plus den
Sicherheits-Patches Nr. 7–9 und den Login-Patches Nr. 10–12,
MPQ-Signaturprüfung aus, `/follow`-Fix, Level 101, Slider-Maxima,
GameObject-Sichtweite (Nr. 48), Tracker, Weltkarte und Fenstermodus. Die Liste
steht in `apply_patches.ps1` unter `$PRESET_STONY`,
in der Übersicht ist es die Spalte „St0ny“. **Achtung: Dieses Preset ist noch
ungetestet.** Der Patcher zeigt das beim Laden mit `S` als gelben Hinweis an.

## Patches ändern oder zurücknehmen

Eingespielte Patches sind nicht endgültig. Starte `patcher.bat` einfach erneut:
Im Menü sind dann genau die Patches angehakt, die gerade in der `Wow.exe`
stecken. Neu angehakte Patches sind mit **(neu)** markiert, abgewählte mit
**(wird zurückgenommen)**. So kannst du beliebig Patches dazunehmen, abwählen
oder Werte ändern (Sprunghöhe, Doppelsprung, Client-Infos). Mit `N` und ENTER
nimmst du alle Patches zurück – danach ist die `Wow.exe` wieder **byte-genau
das Original**.

So funktioniert es:

- **Erster Start:** Die `Wow.exe` muss original sein (SHA256-Prüfung), sonst
  bricht der Patcher ab. Beim Patchen wird das Original als `Wow.exe.ORI`
  gesichert, und jede gepatchte `Wow.exe` bekommt ein [Wasserzeichen](#hinweise).
- **Jeder weitere Start:** Ob die `Wow.exe` mit diesem Patcher gepatcht wurde,
  erkennt er am Wasserzeichen. Fehlt es (und ist die Datei nicht original),
  bricht er ab – etwa bei einer Exe, die mit einem anderen Tool gepatcht wurde.
- **Patchstand ermitteln:** Passt der Hash aus `patcher_state.ini` (dort merkt
  sich der Patcher nach jedem Lauf Hash, Patches, Werte und Original-Bytes),
  geht es über diese Datei – das ist der schnelle Weg. Sonst, z. B. wenn die
  Datei fehlt oder die `Wow.exe` von einem anderen Rechner stammt, prüft der
  Patcher alle Patch-Stellen in der Exe selbst: Welche Patches sind drin, und
  mit welchen Werten (Sprunghöhe, Build-Datum usw.)? Dafür enthält das Skript
  eine kleine Tabelle mit den Original-Bytes an allen Patch-Stellen. Gibt es
  danach nichts zu tun, legt der Patcher die `patcher_state.ini` trotzdem neu
  an, damit der nächste Start wieder den schnellen Weg nimmt.
- **Original wiederherstellen:** Aus der gepatchten Exe baut der Patcher im
  Speicher das Original wieder auf, prüft es per SHA256 und spielt darauf die
  neue Auswahl ein. Klappt das nicht exakt – etwa weil die Exe nach dem
  Patchen noch anderweitig verändert wurde –, bricht er ab.
- Vor dem Schreiben prüft der Patcher außerdem, dass sich das neue Ergebnis
  wieder sauber zum Original zurücknehmen lässt.
- `Wow.exe.ORI` bleibt bei weiteren Läufen unangetastet und ist immer das
  Original. Fehlt es, legt der Patcher es aus dem rekonstruierten Original neu
  an. Zusätzlich sichert er bei jedem weiteren Lauf die bisherige `Wow.exe` als
  `Wow.exe.BAK` – ein Schritt zurück ist also immer möglich.

> [!NOTE]
> Ein Patch mit einem Wert, der genau dem Original entspricht (z. B. die
> Sprunghöhe `-7.9555473`), ändert keine Bytes und wird bei der Prüfung der Exe
> deshalb nicht als eingespielt erkannt – er ist dann ja auch wirkungslos.

## Parameter für den unbeaufsichtigten Betrieb

Alle Parameter sind optional und werden von `patcher.bat` an
`apply_patches.ps1` durchgereicht.

| Parameter              | Bedeutung                                                                   |
|------------------------|-----------------------------------------------------------------------------|
| `-Language de\|en`     | Sprache für diesen Lauf festlegen. Zusammen mit `-Select` bleibt die gemerkte Sprache unverändert; wird die Auswahl im Menü mit ENTER übernommen, wird sie mitgespeichert. |
| `-Select <Auswahl>`    | Auswahlmenü überspringen: `saved` (gespeicherte Auswahl), `billy` (Preset „Billy's_Wow.exe“, auch `default`), `stony` (Preset „St0nys_Wow.exe“), `all`, `none` (alle Patches zurücknehmen, Original wiederherstellen) oder Nummern/Bereiche wie `"1,3,5-8"`. Die Auswahl ersetzt die Patches in der `Wow.exe` komplett. Mit `-Select` wird die gespeicherte Auswahl nicht verändert. |
| `-Unattended`          | keine Rückfragen und keine Pausen. Ohne `-Language` gilt die gemerkte Sprache bzw. Deutsch, ohne `-Select` die gespeicherte Auswahl bzw. das Preset „Billy's_Wow.exe“. |
| `-Path <Datei>`        | eine andere `Wow.exe` als die im Skriptordner patchen                        |

Beispiel:

```bat
patcher.bat -Language de -Select saved -Unattended
```

Exit-Codes: `0` = erfolgreich (oder nichts zu tun), `1` = Fehler, `2` =
abgebrochen (vom Benutzer oder weil keine Eingabe mehr möglich ist).

## Dateien

| Datei               | Zweck |
|---------------------|-------|
| `patcher.bat`       | Startdatei, ruft `apply_patches.ps1` auf |
| `apply_patches.ps1` | Patch-Engine: Sprachwahl, Prüfungen, Auswahlmenü, Backup; liest die EXE einmal, patcht im Speicher, schreibt einmal zurück |
| `README.md`         | Diese Datei |
| `README.en.md`      | Englische Anleitung |
| `patcher_selection.ini` | Wird beim ersten Start angelegt (gemerkte Sprache) und speichert die übernommene Auswahl samt eingegebenen Werten |
| `patcher_state.ini` | Wird beim Patchen angelegt: Hash der gepatchten `Wow.exe`, eingespielte Patches, Werte und Original-Bytes – beschleunigt den nächsten Start, ist aber nicht zwingend nötig |
| `Wow.exe.ORI`       | Sicherung der originalen `Wow.exe`, angelegt beim ersten Patchen |
| `Wow.exe.BAK`       | Sicherung der bisherigen `Wow.exe` vor dem letzten Lauf |
| `LICENSE`           | MIT-Lizenz |

---

## Patch-Übersicht

| Nr. | Patch | Autor | Standard | St0ny |
|----:|-------|-------|:--------:|:-----:|
|    | **System & Leistung** |  |  |  |
| 1  | 4GB-Patch (Large Address Aware) | Alastor StrixEfuartus / Kebabstorm / Robinsch | ✅ | ✅ |
| 2  | CACHE-Ordner-Erstellung deaktivieren | Alastor StrixEfuartus / Kebabstorm | – | – |
| 3  | Item-Cache sofort aktualisieren | Robinsch | ✅ | ✅ |
| 4  | WorldFrame-Absturzfix (ungültige Dreiecks-Indizes) | Alyst3r (0x539wowmod) / St0ny | – | – |
|    | **Sicherheit & Datenschutz** |  |  |  |
| 5  | Remote Code Execution Exploit Fix *(nur einen der beiden RCE-Patches aktivieren)* | Robinsch | – | – |
| 6  | Warden komplett abschalten, RCE-Fix *(Kick-Gefahr bei aktivem Warden; nur einen der beiden RCE-Patches aktivieren)* | Robinsch | – | – |
| 7  | Scan.dll deaktivieren | Alastor StrixEfuartus | – | ✅ |
| 8  | Client-Patches vom Server verbieten | Kebabstorm | – | ✅ |
| 9  | Hardware-Umfragen vom Server verbieten | Kebabstorm | – | ✅ |
|    | **Login & Verbindung** |  |  |  |
| 10 | Battle.net-Login überspringen | Kebabstorm | – | ✅ |
| 11 | Remote-Desktop-Prüfung überspringen | Kebabstorm | – | ✅ |
| 12 | HTTP-Anfragen an Battle.net deaktivieren | Kebabstorm | – | ✅ |
| 13 | Idle-Kick nach Character-Autologin verhindern *(wird für Character-Autologin benötigt; AFK- und Idle-Timer bleiben aktiv, [Discord](https://discord.com/channels/858041817043042364/1515439916878663701))* | St0ny | – | – |
|    | **Modding: Interface, MPQs & Addons** |  |  |  |
| 14 | Custom Glue-XML erlauben | Alastor StrixEfuartus / Kebabstorm / St0ny | ✅ | ✅ |
| 15 | Falsch/Nicht signierte MPQs zulassen | Alastor StrixEfuartus | – | ✅ |
| 16 | Erweiterte MPQ-Namen erlauben |  | ✅ | ✅ |
| 17 | Daten direkt aus dem Data-Ordner laden (ohne MPQ) | Alastor StrixEfuartus | ✅ | ✅ |
| 18 | LUA Unlock (Zauber, Bewegung, Makros) *(kann als Botting gewertet werden – Bann-Gefahr)* | Alastor StrixEfuartus | – | – |
| 19 | LUA Unlock (vollständig): alle geschützten Funktionen freigeben *(kann als Botting gewertet werden – Bann-Gefahr)* | St0ny | – | – |
| 20 | Alle Tastatur-Ereignisse an Addons weiterreichen (OnKeyDown) | Alyst3r (0x539wowmod) | – | – |
| 21 | Addon-Daten aller Accounts zusammenlegen (SavedVariables) *(gemeinsamer Ordner `WTF\Account\global`)* | boredatom / St0ny | – | – |
|    | **DLL-Loader** |  |  |  |
| 22 | AwesomeWotlkLib.dll Unterstützung aktivieren *(benötigt [awesome_wotlk](https://github.com/noname08662/awesome_wotlk))* | FrostAtom | ✅ | ✅ |
| 23 | voice.dll beim Start laden (mod-voicechat) [ALPHA] *(Modul noch unfertig, [mod-voicechat](https://github.com/Raz0r1337/mod-voicechat))* | St0ny | – | – |
|    | **Gameplay-Fixes** |  |  |  |
| 24 | Area-Trigger-Timer genauer (50 ms statt 100 ms) | Robinsch | ✅ | ✅ |
| 25 | Nahkampf-Schwung bei Rechtsklick entfernt | Robinsch | ✅ | ✅ |
| 26 | NPC-Angriffsanimation beim Drehen unterdrückt | Robinsch | ✅ | ✅ |
| 27 | Zauber-Animation nach Abbruch repariert | Robinsch | ✅ | ✅ |
| 28 | Force-Reaction bei /reload erhalten | Robinsch | ✅ | ✅ |
| 29 | Neue Post ohne 60 Sekunden Wartezeit | Robinsch | ✅ | ✅ |
| 30 | Chat-Befehle auch im Tod erlauben | Robinsch | ✅ | ✅ |
| 31 | /follow auch bei NPCs erlauben | Alastor StrixEfuartus / St0ny | – | ✅ |
| 32 | Level 101+ Fix (Spielwert-Tabellen, Barbierstuhl, Grundwerte) | Alastor StrixEfuartus / St0ny | – | ✅ |
| 33 | Charaktererstellung: mehr als 10 Klassen (Zufallsklasse) *(für eigene Klassen; Server muss es unterstützen)* | Alastor StrixEfuartus / Robinsch | – | – |
| 34 | Namensprüfung bei der Charaktererstellung abschalten (z. B. Zahlen im Namen) *(Server muss die Namen ebenfalls erlauben)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 35 | Max. Charaktere pro Server auf 255 erhöht | St0ny | ✅ | ✅ |
| 36 | Custom Item Fix (BETA) v2 *(Custom-Items ohne DBC-Anpassung: Modell, Icon und Item-Typ aus den Serverdaten)* | Kebabstorm / St0ny | – | – |
| 37 | Steigwinkel-Begrenzung aufheben (jeden Hang hochlaufen) *(kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alastor StrixEfuartus | – | – |
| 38 | Sprunghöhe ändern (Original -7.9555473) *(fragt den Wert ab, kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alastor StrixEfuartus | – | – |
| 39 | Im Sprung vorwärts/rückwärts steuern *(kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 40 | Im Sprung seitwärts steuern *(kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 41 | Im Sprung drehen ändert die Flugrichtung *(kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 42 | Doppelsprung (weitere Sprünge in der Luft) *(fragt den Wert ab, kann vom Server als Cheat erkannt werden, Exe wird größer – Bann-Gefahr)* | Alyst3r (0x539wowmod) / St0ny | – | – |
|    | **Grafik & Sichtweite** |  |  |  |
| 43 | CVar farclip unlock (max 10000) | Alastor StrixEfuartus | ✅ | ✅ |
| 44 | CVar horizonFarclipScale unlock (max 12) | St0ny | ✅ | ✅ |
| 45 | CVar environmentDetail unlock (kein Limit statt 1.5) | St0ny | ✅ | ✅ |
| 46 | CVar groundEffectDist unlock (max 3166 statt 140) |  | ✅ | ✅ |
| 47 | Grafikoptionen: Slider-Maxima erweitern | St0ny | – | ✅ |
| 48 | GameObject Sichtweite: Cat 0 und Cat 4 auf environmentDetail reagieren lassen | St0ny | – | ✅ |
| 49 | GameObject Sichtweite: Cat 0 von 30 auf 50 Yards *(kostet Leistung, mehr Kleinkram sichtbar)* | St0ny | – | – |
| 50 | Occluder Fix für Stormwind (Open Azeroth) | Robinsch | – | – |
| 51 | Blauer Mond am Nachthimmel reaktiviert | Robinsch | ✅ | ✅ |
| 52 | Keine Transparenz beim Heranzoomen | Alastor StrixEfuartus | ✅ | ✅ |
| 53 | Kein Ausblenden für NPCs mit Flag DO_NOT_FADE_IN *(Server muss das Flag setzen)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 54 | HD Unit-Frame Portraits: Renderauflösung 256 statt 64 Pixel *(Exe wird größer – Bann-Gefahr)* | Badgermilk0 | – | – |
|    | **Interface & Komfort** |  |  |  |
| 55 | Quest-Tracker automatisch sortieren |  | – | ✅ |
| 56 | Erweiterte Weltkarte standardmäßig aktiv |  | – | ✅ |
| 57 | Cast Bars auf allen Frames | Kebabstorm | ✅ | ✅ |
| 58 | Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert *(benötigt [Patch-G](https://discord.com/channels/407664041016688662/1541873346608889936))* | MacWarrior | – | – |
| 59 | FlashWindow Patch *(benötigt [FlashWindow-Addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash))* | Kebabstorm | ✅ | ✅ |
| 60 | Charaktererstellung: Aussehen nicht automatisch auswürfeln | Alyst3r (0x539wowmod) | – | – |
|    | **Fenster, Maus & Kamera** |  |  |  |
| 61 | Fenstermodus als Standard setzen | St0ny | – | ✅ |
| 62 | Fenstermodus maximiert als Standard setzen | St0ny | – | ✅ |
| 63 | Kein schwarzer Bildschirm beim Wechsel in den Fenstermodus | Robinsch | ✅ | ✅ |
| 64 | Mausflackern / Kamerasprünge Fix | Robinsch | ✅ | ✅ |
| 65 | CameraReforged [BETA]: Kamerahöhe und Zoom-Grenzen *(Schulterversatz noch ohne Wirkung; Exe wird größer – Bann-Gefahr)* | Stormhand / St0ny | – | – |
|    | **Sound** |  |  |  |
| 66 | Sound-Einstellungen optimieren *(benötigt [OpenAL](https://github.com/kcat/openal-soft), sonst wirken die Einstellungen nicht)* | St0ny | – | – |
|    | **Client-Infos: Version, Build, Titel, Datum, Icon** |  |  |  |
| 67 | Client-Version ändern (Original 3.3.5) *(fragt den Wert ab)* | MacWarrior | – | – |
| 68 | Build-Nummer ändern (Original 12340) *(fragt den Wert ab)* | MacWarrior | – | – |
| 69 | Programmtitel in den Dateieigenschaften ändern *(fragt den Wert ab)* | MacWarrior / St0ny | – | – |
| 70 | Build-Datum ändern (Original Jun 24 2010) *(fragt den Wert ab)* | MacWarrior | – | – |
| 71 | Programm-Icon ändern (Symbol der Wow.exe) *(fragt den Wert ab)* | MacWarrior / St0ny | – | – |

> [!NOTE]
> **Urheber gesucht:** Bei Patches ohne Eintrag in der Spalte „Autor“ ist der
> Urheber noch nicht bekannt. Wenn du weißt, von wem einer dieser Patches
> stammt, schreib es bitte als [Issue](https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher/issues) – dann wird es nachgetragen.

---

## Patch-Beschreibungen

### System & Leistung

**4GB-Patch (Large Address Aware)** *(Nr. 1, Autor: Alastor StrixEfuartus / Kebabstorm / Robinsch)*

Ermöglicht der `Wow.exe`, bis zu 4 GB RAM zu nutzen statt der
standardmäßigen 2-GB-Grenze für 32-Bit-Anwendungen.

**CACHE-Ordner-Erstellung deaktivieren** *(Nr. 2, standardmäßig aus, Autor: Alastor StrixEfuartus / Kebabstorm)*

Verhindert, dass der Client automatisch einen `CACHE`-Ordner anlegt.

**Item-Cache sofort aktualisieren** *(Nr. 3, Autor: Robinsch)*

Entfernt die 30-Sekunden-Verzögerung beim Aktualisieren des Item-Caches.
Änderungen an Items werden sofort sichtbar.

**WorldFrame-Absturzfix (ungültige Dreiecks-Indizes)** *(Nr. 4, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*

Verhindert einen Absturz in einer Funktion der Weltdarstellung (VA `0x81D510`).
Sie läuft über Dreiecke aus je drei Vertex-Indizes und rechnet „Index minus
Basis“ in eine Speicheradresse um. Ist ein Index kleiner als die Basis, zeigt
die Adresse vor den Puffer und der Client stürzt ab. Der Patch prüft vorher die
drei Indizes des ersten Dreiecks und überspringt die Funktion in diesem Fall.
Gegenüber dem Original sind die drei Sprungweiten korrigiert und der Code ist
kürzer.

> [!NOTE]
> Der Code liegt in der freien Lücke am Ende von `.text`, die auch Nr. 53 nutzt.
> Beide passen zusammen hinein, die Dateigröße ändert sich nicht.

> [!NOTE]
> Ein heuristischer Fix, wie ihn auch der Autor nennt: Geprüft wird nur das erste
> Dreieck jedes Aufrufs. Er stört nicht, wenn alles stimmt, fängt aber nicht jeden
> denkbaren Fall ab.

### Sicherheit & Datenschutz

**Remote Code Execution Exploit Fix** *(Nr. 5, standardmäßig aus, Autor: Robinsch)*

Schließt eine Sicherheitslücke, die Remote-Code-Ausführung über manipulierte
Pakete ermöglichen konnte: Die Sektion `.zdata` verliert ihr Ausführungsrecht,
und Warden-Module werden nicht mehr aus dem lokalen Cache geladen. Warden selbst
läuft weiter, auf Servern mit aktivem Warden gibt es also keine Probleme.

> [!NOTE]
> Nur einen der beiden RCE-Patches aktivieren: entweder diesen (Warden läuft
> weiter) oder „Warden komplett abschalten“ (Nr. 6), der die Lücke ebenfalls
> schließt. Beide zusammen bringen nichts zusätzlich.

**Warden komplett abschalten, RCE-Fix** *(Nr. 6, standardmäßig aus, Autor: Robinsch)*

Der Client verwirft alle Warden-Pakete des Servers (`SMSG_WARDEN_DATA`).
Warden-Module sind Code, den der Server im Client ausführen lässt – mit diesem
Patch ist das überhaupt nicht mehr möglich, auch nicht über künftige Tricks.
Macht den RCE-Fix (Nr. 5) überflüssig, es ist also nur sinnvoll, einen der
beiden zu aktivieren. Beide zusammen schaden aber nicht, der Patcher weist dann
nur darauf hin.

> [!WARNING]
> Der Client antwortet danach nicht mehr auf Warden. Server mit aktivem Warden
> (z. B. AzerothCore oder TrinityCore in der Standardeinstellung) können dich
> deshalb kicken.

**Scan.dll deaktivieren** *(Nr. 7, standardmäßig aus, Autor: Alastor StrixEfuartus)*

Verhindert das Laden der `Scan.dll`, die der Login-Server per „Scan“-Befehl
nachladen kann (ein Prüfmodul des Login-Servers, unabhängig von Warden): Aus
`.\Scan.dll` und `.\Scan.dll.new` wird `.\||an.dll` – `|` ist in Dateinamen
verboten, das Laden schlägt damit garantiert fehl.

**Client-Patches vom Server verbieten** *(Nr. 8, standardmäßig aus, Autor: Kebabstorm)*

Der Server kann dem Client keine Patch-Dateien mehr schicken und installieren
lassen.

**Hardware-Umfragen vom Server verbieten** *(Nr. 9, standardmäßig aus, Autor: Kebabstorm)*

Der Server kann keine Hardware-Umfrage (Informationen über deinen PC) mehr beim
Client anfordern.

### Login & Verbindung

**Battle.net-Login überspringen** *(Nr. 10, standardmäßig aus, Autor: Kebabstorm)*

Der Client überspringt den Battle.net-Login-Schritt und nutzt direkt den
klassischen Login.

**Remote-Desktop-Prüfung überspringen** *(Nr. 11, standardmäßig aus, Autor: Kebabstorm)*

Der Client prüft nicht mehr, ob er über eine Remote-Desktop-Verbindung läuft –
WoW lässt sich damit z. B. per RDP spielen.

**HTTP-Anfragen an Battle.net deaktivieren** *(Nr. 12, standardmäßig aus, Autor: Kebabstorm)*

Der Client ruft keine News, Hilfe-Artikel und Nutzungsbedingungen mehr von
Blizzards Servern ab – die gibt es für 3.3.5 ohnehin nicht mehr.

**Idle-Kick nach Character-Autologin verhindern** *(Nr. 13, standardmäßig aus, Autor: St0ny)*

Nach einem Autologin ohne jede Tastatur- oder Mauseingabe steht der
Zeitstempel der letzten Eingabe noch auf 0 – der Client hält den Spieler sofort
für untätig und kickt ihn (CharAutoLogin-Bug). Der Patch setzt den Zeitstempel
beim ersten Durchlauf auf „jetzt“, wenn er noch leer ist, und entfernt einen
Fatal-Error-Check, der dabei auslösen kann. Die eigentlichen Timer bleiben
unverändert: AFK-Status nach 5 Minuten, Logout nach 30 Minuten ohne Eingabe.
**Wird für Character-Autologin benötigt** – Details im [Discord](https://discord.com/channels/858041817043042364/1515439916878663701).

### Modding: Interface, MPQs & Addons

**Custom Glue-XML erlauben** *(Nr. 14, Autor: Alastor StrixEfuartus / Kebabstorm / St0ny)*

Ermöglicht Änderungen am Login- und Charakterauswahl-Bildschirm durch eigene
XML/Lua-Dateien (Glue-Screen-Modding): Die Signaturprüfung der Interface-Dateien
meldet immer „gültig“, und lokale Ordner `Interface\GlueXML` und
`Interface\FrameXML` werden nicht mehr in `*.old` umbenannt.

> [!NOTE]
> Nebenwirkung, die jede Fassung dieses Patches hat: Auch Addons ohne
> Signaturdatei gelten damit als „sicher“ (wie Blizzard-Code) und dürfen
> geschützte Funktionen aufrufen – in der Wirkung ähnlich dem LUA Unlock
> (Nr. 18). Server mit Anti-Cheat können das genauso werten.

Die verbreitete Fassung (Alastor/Kebabstorm) läuft bei fehlender Signaturdatei
mit uninitialisierten Variablen weiter und gibt dabei einen Zeiger ins Nichts
frei (undefiniertes Verhalten). Hier gibt der Fehlerausgang stattdessen direkt
„gültig“ zurück – gleiche Wirkung, ohne wilden Speicherzugriff.

**Falsch/Nicht signierte MPQs zulassen** *(Nr. 15, standardmäßig aus, Autor: Alastor StrixEfuartus)*

Die Signaturprüfung für MPQ-Archive meldet immer „gültig“. Der Client prüft
damit nur Archive, die der Server schickt: `wow-patch.mpq` (Client-Patch vom
Server) und `Cache\Survey.mpq` (Hardware-Umfrage). Die normalen `Data\*.MPQ`
lädt der Client ohnehin ohne Signaturprüfung – für eigene Patch-MPQs ist dieser
Patch also nicht nötig. Zusammen mit Nr. 8 und Nr. 9 hat er keine Wirkung mehr,
weil beide Wege dann gar nicht erst laufen.

**Erweiterte MPQ-Namen erlauben** *(Nr. 16)*

Ermöglicht die Nutzung von Wildcard-Namen für MPQ-Archive
(`patch-*.MPQ` und `patch-locale-*.MPQ`).

**Daten direkt aus dem Data-Ordner laden (ohne MPQ)** *(Nr. 17, Autor: Alastor StrixEfuartus)*

Der Client liest Dateien direkt aus dem Data-Ordner, ohne dass sie in ein MPQ
gepackt werden müssen – z. B. `Data\DBFilesClient\ItemDisplayInfo.dbc`.
Praktisch für Modder.

**LUA Unlock (Zauber, Bewegung, Makros)** *(Nr. 18, standardmäßig aus, Autor: Alastor StrixEfuartus)*

Addons und Makros dürfen geschützte Funktionen aufrufen: Bewegungsfunktionen
(`MoveForwardStart`, `TurnLeftStart`, …), `CastSpellByName`, `CastSpell`,
`UseAction`, `PetAttack`, `RunMacro`/`RunMacroText` und die
GM-Ticket-Funktionen. Nicht freigegeben, weil sie eigene Prüfungen im Code
haben: `TargetUnit`, `FocusUnit`, `InteractUnit`, `ReloadUI`; `AttackTarget`
meldet weiterhin einen Fehler.

> [!WARNING]
> Das ermöglicht Automatisierung. Server mit Anti-Cheat können das als Botting
> werten – das kann zu einem Bann führen.

**LUA Unlock (vollständig): alle geschützten Funktionen freigeben** *(Nr. 19, standardmäßig aus, Autor: St0ny)*

Erweitert Nr. 18 auf alle geschützten Funktionen. Die zentrale Schutzprüfung
des Clients kennt 24 Schutztypen in drei Klassen (immer verboten, nur nach
einem Hardware-Ereignis erlaubt, nur bei erlaubten Attribut-Änderungen) – sie
meldet mit diesem Patch für alle „erlaubt“. Zusätzlich werden die eigenen
Prüfungen der Funktionen umgangen, die nicht über diese zentrale Stelle laufen:
`TargetUnit`, `AssistUnit`, `TargetLastTarget`, `TargetNearest…`,
`TargetDirection…`, `AttackTarget`, `StartAttack`, `FocusUnit`, `ClearFocus`,
`InteractUnit`, `ReloadUI`, `UninviteUnit`, `CancelLogout`, die Pet-Befehle
(`PetAttack`, `PetFollow`, …) sowie `UseAction`, Handel, Auktionshaus,
Kalender, LFG, Raid-Untergruppen und das Anlegen und Ändern von Makros. Auch die
Sperrliste für Zauber aus unsicherem Code wird nicht mehr geprüft.

Nicht angetastet bleiben die Frame-Schutzprüfung (`SetAttribute`, `Show`,
`Hide` auf geschützten Frames) und `RegisterForSave` – sie betreffen keine
Spielaktionen. Macht Nr. 18 überflüssig; beide zusammen schaden nicht, der
Patcher weist dann nur darauf hin.

> [!WARNING]
> Das ermöglicht Automatisierung in vollem Umfang. Server mit Anti-Cheat können
> das als Botting werten – das kann zu einem Bann führen.

**Alle Tastatur-Ereignisse an Addons weiterreichen (OnKeyDown)** *(Nr. 20, standardmäßig aus, Autor: Alyst3r (0x539wowmod))*

Hat ein Frame ein OnKeyDown-Skript, meldet der Client die Taste danach als
erledigt – sie erreicht die Tastenbelegungen dann nicht mehr. Mit dem Patch läuft
jede Taste nach dem OnKeyDown-Skript weiter zu den Tastenbelegungen. So können
Addons alle Tastendrücke mitlesen, ohne die normale Steuerung zu blockieren.

> [!NOTE]
> Addons, die sich darauf verlassen, dass OnKeyDown eine Taste „schluckt“, lösen
> damit zusätzlich die belegte Aktion aus.

<a id="patch-21"></a>
**Addon-Daten aller Accounts zusammenlegen (SavedVariables)** *(Nr. 21, standardmäßig aus, Autor: boredatom / St0ny)*

WoW speichert die Daten der Addons normalerweise pro Account unter
`WTF\Account\<ACCOUNT>\`. Mit dem Patch nutzen alle Accounts dafür den
gemeinsamen Ordner `WTF\Account\global\` – wer mehrere Accounts spielt, richtet
seine Addons so nur einmal ein. Zusammengelegt werden:

- die accountweiten Addon-Daten (`SavedVariables\*.lua`),
- die Addon-Daten der Charaktere (`<Realm>\<Charakter>\SavedVariables\*.lua`),
- die Liste der aktivierten Addons (`AddOns.txt`, accountweit und je Charakter).

Makros, Tastenbelegungen sowie Chat- und Spieleinstellungen bleiben wie bisher
pro Account getrennt.

> [!NOTE]
> Vorhandene Addon-Daten zieht der Patch nicht um. Wer sie behalten will,
> kopiert vor dem ersten Start den Inhalt von `WTF\Account\<ACCOUNT>\` nach
> `WTF\Account\global\`. Nimmt man den Patch zurück, nutzt WoW wieder die
> Ordner der einzelnen Accounts; `global` bleibt unverändert liegen.

Technisch ändert der Patch 9 Byte in der Funktion, die nach dem Login den
Account-Namen für die Addon-Pfade übernimmt (VA `0x5F9080`): Statt des Namens
kopiert sie den Text `global`, der schon in der `Wow.exe` steht. Das Original
von boredatom (`patch_globalvariables.exe`) verschiebt dafür den Rest der
Funktion um 4 Byte, hier bleibt alles an seinem Platz. Die Werbung, die das
Original zusätzlich in die `Wow.exe` schreibt (ein Telegram-Hinweis im
Login-Bildschirm), ist nicht enthalten.

### DLL-Loader

**AwesomeWotlkLib.dll Unterstützung aktivieren** *(Nr. 22, Autor: FrostAtom)*

Ermöglicht das Laden der `AwesomeWotlkLib.dll` beim Client-Start. Diese DLL
erweitert den Client um zusätzliche Funktionen und Verbesserungen für private
Server.
**Benötigt** die `AwesomeWotlkLib.dll` aus [awesome_wotlk](https://github.com/noname08662/awesome_wotlk).
Gehört zusammen mit dem 4GB-Patch (Nr. 1); fehlt der in der Auswahl, weist der
Patcher darauf hin.

Der Lader sitzt am Start der Haupt-Fiber des Clients (kurz vor `WinMain`) und
überschreibt dafür den Anfang der Scan.dll-Startfunktion; die Lua-Funktion
`ScanDLLStart` wird zum Leerlauf und das Scan.dll-Flag auf „bestanden“ gesetzt.
Der Patch schaltet damit nebenbei den Scan.dll-Mechanismus ab (wie Nr. 7).
Fehlt die DLL, startet WoW normal weiter.

> [!NOTE]
> Der Patch selbst ist unkritisch, er lädt nur eine DLL, die hier nicht
> enthalten ist. Erst die geladene `AwesomeWotlkLib.dll` kann auf Servern mit
> Anti-Cheat auffallen – also nur dort einsetzen, wo awesome_wotlk erlaubt ist.
> Der Patcher zeigt dazu einen gelben Hinweis.

**voice.dll beim Start laden (mod-voicechat) [ALPHA]** *(Nr. 23, standardmäßig aus, Autor: St0ny)*

Lädt beim Start die `voice.dll` aus dem WoW-Ordner – den Client-Teil von
[mod-voicechat](https://github.com/Raz0r1337/mod-voicechat), einem
Voice-Chat-Modul für AzerothCore. Fehlt die DLL,
startet WoW ganz normal.

> [!CAUTION]
> **ALPHA** – das Modul mod-voicechat ist noch nicht fertig. Deshalb ist dieser
> Patch standardmäßig abgewählt. Der Patch selbst ist im Spiel getestet.

Dateigröße und PE-Header bleiben unverändert: Der Sprung am Einstiegspunkt
(VA `0x401005`) wird in eine freie 27-Byte-Lücke zwischen zwei Funktionen
(VA `0x944B45`) umgebogen. Dort stehen `push "voice.dll"` → `call [LoadLibraryA]`
→ Sprung zum ursprünglichen Ziel. Vor dem Schreiben prüft der Patcher
Einstiegspunkt, Lücke und den `LoadLibraryA`-Import.

### Gameplay-Fixes

**Area-Trigger-Timer genauer (50 ms statt 100 ms)** *(Nr. 24, Autor: Robinsch)*

Erhöht die Prüffrequenz für Area-Trigger von 100 ms auf 50 ms. Dadurch werden
Zonen-Übergänge und Trigger präziser erkannt.

**Nahkampf-Schwung bei Rechtsklick entfernt** *(Nr. 25, Autor: Robinsch)*

Verhindert den fehlerhaften Auto-Attack-Swing, der beim Rechtsklick auf ein
Ziel ausgelöst wurde.

**NPC-Angriffsanimation beim Drehen unterdrückt** *(Nr. 26, Autor: Robinsch)*

Unterdrückt die Angriffsanimation von NPCs beim Drehen, wenn kein echter
Angriff stattfindet.

**Zauber-Animation nach Abbruch repariert** *(Nr. 27, Autor: Robinsch)*

Behebt einen Bug, bei dem nach dem Abbrechen eines kanalisierten Zaubers die
Vorbereitungsanimation hängen blieb.

**Force-Reaction bei /reload erhalten** *(Nr. 28, Autor: Robinsch)*

Verhindert, dass Force-Reaction-Werte (z. B. Fraktionsstatus) beim Neuladen
der UI zurückgesetzt werden. Wichtig für Custom-Server.

**Neue Post ohne 60 Sekunden Wartezeit** *(Nr. 29, Autor: Robinsch)*

Der Client fragt neue Post sofort ab – kein Warten mehr von 60 Sekunden und kein
Relog, um neue Post zu bekommen.

**Chat-Befehle auch im Tod erlauben** *(Nr. 30, Autor: Robinsch)*

Slash-Befehle funktionieren auch, während der Charakter tot ist.

**/follow auch bei NPCs erlauben** *(Nr. 31, standardmäßig aus, Autor: Alastor StrixEfuartus / St0ny)*

Mit `/follow` lässt sich auch NPCs folgen, nicht nur Spielern. Basiert auf
dem `/follow`-Patch aus der 12th Generation EXE von Alastor StrixEfuartus,
Portierung und Anpassung von St0ny: Das Original leitet die Prüfung in
eine Code-Höhle um, die ihr Ergebnis ignoriert. Diese Höhle läge aber genau
in der Lücke am Ende von `.text`, die Nr. 4 und Nr. 53 nutzen. Hier wird
stattdessen der bedingte Sprung hinter der Prüfung unbedingt gemacht – ein
einziges Byte, gleiche Wirkung, und die Patches vertragen sich.

**Level 101+ Fix (Spielwert-Tabellen, Barbierstuhl, Grundwerte)** *(Nr. 32, standardmäßig aus, Autor: Alastor StrixEfuartus / St0ny)*

Die Spielwert-Tabellen des Clients (`gtCombatRatings`, `gtBarberShopCostBase`,
`gtOCTRegenHP`/`MP`, `gtChanceToMeleeCrit` … – elf Tabellen) haben je Spalte
100 Zeilen, eine pro Level. Ab Level 101 greift der Client außerhalb der Spalte
zu – Druiden sehen ihre Grundwerte nicht mehr, der Barbierstuhl funktioniert
nicht, im schlimmsten Fall stürzt der Client ab. Der Patch begrenzt die Zeile
auf die letzte der Spalte: Level 101+ bekommt die Werte für Level 100, alles
darunter bleibt unverändert.

> [!NOTE]
> Die verbreitete Fassung aus der 12th Generation EXE entfernt stattdessen das
> Level komplett aus der Rechnung – damit zeigen *alle* Charaktere die Werte
> für Level 1 (Wertungen, kritische Trefferchance, Regeneration …). Hier sind
> die beiden Zugriffsfunktionen (VA `0x7F69B0` und `0x7F69E0`) dafür neu
> geschrieben.

**Benötigt** laut Quelle den Patch „Custom Glue-XML erlauben“ (Nr. 14). In der
Quelle heißt er „Disable XML SIG MD5“, daher der dortige Hinweis „Use XML MD5“.

**Charaktererstellung: mehr als 10 Klassen (Zufallsklasse)** *(Nr. 33, standardmäßig aus, Autor: Alastor StrixEfuartus / Robinsch)*

Die Zufallsauswahl der Klasse bei der Charaktererstellung sammelt die
erlaubten Klassen in einem Feld mit 10 Plätzen. Mit eigenen Klassen
(`ChrClasses.dbc` mit mehr als 10 Einträgen) würde es überlaufen; der Patch
vergrößert es auf 30 Plätze. Welche Rasse welche Klasse darf, prüft weiterhin
der Server – mehr macht dieser Patch nicht.

**Namensprüfung bei der Charaktererstellung abschalten (z. B. Zahlen im Namen)** *(Nr. 34, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*

Schaltet die komplette clientseitige Namensprüfung bei der Charaktererstellung
ab: Die Prüffunktion (VA `0x6B0F90`) meldet immer „Name gültig“. Damit sind z. B.
Zahlen im Namen möglich – es entfallen aber auch alle anderen Regeln des Clients
(Länge, erlaubte Zeichen usw.). Im Original (0x539wowmod) per Detour mit falscher
Aufrufkonvention gelöst, hier direkt in der Funktion (`mov eax, 57h` / `ret`).

> [!WARNING]
> Der Server prüft Namen weiterhin selbst und muss sie ebenfalls erlauben, sonst
> lehnt er den Charakter ab.

**Max. Charaktere pro Server auf 255 erhöht** *(Nr. 35, Autor: St0ny)*

Hebt die clientseitige Begrenzung von 10 auf 255 Charaktere pro Server an.
Der Server muss dies ebenfalls unterstützen. Zusätzliche
Interface-Anpassungen (Glue-XML) sind nötig, damit der
Charakterauswahl-Bildschirm mehr als 10 Slots anzeigt.

**Custom Item Fix (BETA) v2** *(Nr. 36, standardmäßig aus, Autor: Kebabstorm / St0ny)*

Macht Custom-Items möglich, ohne die `Item.dbc` des Clients anzupassen. Viele
Stellen im Client lesen Display-ID, Inventartyp, Klasse, Unterklasse und Scheide
eines Items nur aus der `Item.dbc`. Items, die nur in der Datenbank des Servers
stehen, fehlen dort – der Client zeigt dann z. B. kein Modell am Charakter und
kein Icon. Die `Wow.exe` hat aber schon Hilfsfunktionen, die diese Werte zuerst
im Item-Cache suchen (also in den Daten, die der Server zu jedem Item schickt)
und erst danach in der `Item.dbc`. Der Patch leitet die reinen DBC-Zugriffe auf
diese Hilfsfunktionen um. Steht ein Item in beiden, gelten damit die Werte des
Servers. Auf dem Server reicht für ein Custom-Item dann der Eintrag in
`item_template`; bei TrinityCore muss dazu in der `worldserver.conf`
`DBC.EnforceItemAttributes = 0` gesetzt sein. Nur das Material (das Geräusch
beim Verschieben im Inventar) kommt weiter allein aus der `Item.dbc`.

Vorlage ist der „Custom Item Fix (BETA) v1“ aus Kebabstorms
[WoW 3.3.5 Patcher (Custom Item Fix)](https://www.wowmodding.net/files/file/283-wow-335-patcher-custom-item-fix/).

**Empfohlen** zusammen mit „CACHE-Ordner-Erstellung deaktivieren“ (Nr. 2): Dann
speichert WoW den Item-Cache nicht auf der Festplatte und holt geänderte
Custom-Items bei jedem Start frisch vom Server. Fehlt Nr. 2 in der Auswahl,
weist der Patcher darauf hin.

> [!NOTE]
> v2 ist im Spiel getestet. Die Patch-Liste von v1, aus der dieser Patch
> übernommen wurde, enthielt zwei Fehler, mit denen der Client abgestürzt wäre:
> In einer Zeile fehlte ein Byte (die Funktion für die Item-Klasse wurde dadurch
> zu Datenmüll), eine andere war eine Kopie der Zeile davor (ein Aufruf landete
> mitten in einer fremden Funktion). v2 behebt beides. Alle umgebauten Stellen
> wurden per Emulation mit Test-Items geprüft: nur im Cache, nur in der
> `Item.dbc`, in beiden und in keinem.

Aus v1 nicht übernommen: die PE-Prüfsumme (Windows prüft sie bei Programmen
nicht) und die Änderung `Cache` → `||che` – das ist genau Patch Nr. 2.

**Steigwinkel-Begrenzung aufheben (jeden Hang hochlaufen)** *(Nr. 37, standardmäßig aus, Autor: Alastor StrixEfuartus)*

Der Charakter kommt jeden Hang hoch, egal wie steil. Im Original ist bei 50°
Schluss: Der Client vergleicht die Neigung mit dem Kosinus dieses Winkels
(`0.6427876` bei VA `0xA37F0C`). Der Patch setzt ihn auf `0.0` = cos 90°.

> [!WARNING]
> Server mit Anti-Cheat können das als Climb-Hack erkennen – das kann zu einem
> Bann führen.

**Sprunghöhe ändern (Original -7.9555473)** *(Nr. 38, standardmäßig aus, Autor: Alastor StrixEfuartus)*

Ändert die Anfangsgeschwindigkeit des Sprungs (VA `0xAA33DC`, Original
`-7.9555473`). Der Patcher fragt den Wert nach der Auswahl ab: eine negative
Zahl von `-100` bis knapp unter `0`, Komma oder Punkt als Dezimaltrenner. Je
kleiner der Wert, desto höher der Sprung; die Höhe wächst mit dem Quadrat, d. h.
`-11.25` ergibt etwa die doppelte, `-15.91` etwa die vierfache Sprunghöhe. Der
Wert wird wie bei den Client-Info-Patches gemerkt.

> [!WARNING]
> Server mit Anti-Cheat können das als Jump-Hack erkennen – das kann zu einem
> Bann führen.

**Im Sprung vorwärts/rückwärts steuern** *(Nr. 39, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*

Normalerweise ignoriert der Client Vorwärts- und Rückwärts-Eingaben, solange der
Charakter springt oder fällt. Mit dem Patch lässt sich die Richtung auch in der
Luft ändern, bis hin zur Gegenrichtung. 0x539wowmod ersetzt dafür per DLL die
Vorwärts-Eingabe des Clients; deren Version weicht vom Original nur in zwei
Sprüngen ab (in der Luft nicht abbrechen, Geschwindigkeit neu berechnen), die
hier direkt in der EXE geändert werden – ohne DLL und ohne Code-Höhle. Dazu kommt
der Byte-Patch aus 0x539wowmod, der die Bewegung in der Luft aktualisiert.

> [!WARNING]
> Server mit Anti-Cheat können veränderte Bewegung in der Luft erkennen – das
> kann zu einem Bann führen.

**Im Sprung seitwärts steuern** *(Nr. 40, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*

Wie der vorige Patch, nur für seitliche Bewegung (Strafen): zwei Sprünge in der
Seitwärts-Eingabe des Clients plus der Byte-Patch aus 0x539wowmod, der die
Bewegung bei gesetztem Fall-Flag nicht mehr vorzeitig abbricht.

> [!WARNING]
> Server mit Anti-Cheat können veränderte Bewegung in der Luft erkennen – das
> kann zu einem Bann führen.

**Im Sprung drehen ändert die Flugrichtung** *(Nr. 41, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*

Dreht man sich im Sprung (Maus oder Tasten), behält der Charakter im Original
seine Flugrichtung. Mit dem Patch setzt der Client die Bewegungsrichtung auch in
der Luft neu, wie es die DLL von 0x539wowmod tut. Passt am besten zusammen mit
den beiden vorigen Patches.

> [!WARNING]
> Server mit Anti-Cheat können veränderte Bewegung in der Luft erkennen – das
> kann zu einem Bann führen.

**Doppelsprung (weitere Sprünge in der Luft)** *(Nr. 42, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*

Erlaubt weitere Sprünge, während der Charakter in der Luft ist. Der Patcher fragt
nach der Auswahl, wie viele zusätzliche Sprünge es sein sollen (1 bis 9, `1` =
Doppelsprung); der Wert wird wie bei den Client-Info-Patches gemerkt.

Die Sprungfunktion des Clients (VA `0x9883F0`) lehnt jeden Sprung ab, solange der
Charakter fällt. 0x539wowmod ersetzt sie per DLL und zählt Sprungladungen mit.
Hier geschieht dasselbe in einer kleinen Code-Höhle: Beim Sprung vom Boden wird
ein Zähler auf die gewählte Anzahl gesetzt, in der Luft ist ein Sprung erlaubt,
solange der Zähler nicht 0 ist. Festgewurzelt oder fliegend bleibt Springen
gesperrt. Jeder Luftsprung nutzt dieselbe Sprunghöhe wie ein normaler Sprung
(also auch den Wert aus „Sprunghöhe ändern“, Nr. 38). Den doppelten Sprung aus
0x539wowmod mit eigener zweiter Sprunghöhe gibt es hier nicht. Der Zähler wird
erst beim nächsten Sprung vom Boden neu gesetzt, nicht beim Landen: Wer nach
einem Sprung landet und dann von einer Kante läuft, hat in der Luft wieder die
gewählte Anzahl Sprünge.

Der Zähler ist ein Byte, das der Client beschreiben muss. Darum bekommt der Patch
eine eigene kleine Sektion `.djump` am Dateiende (die Lücke in `.text` ist nicht
beschreibbar); die `Wow.exe` wird dadurch etwas größer.

> [!WARNING]
> Server mit Anti-Cheat können Sprünge in der Luft erkennen – das kann zu einem
> Bann führen.
>
> Dieser Patch hängt eine eigene Sektion an, die `Wow.exe` wird dadurch größer.
> **Viele Server tolerieren eine veränderte Dateigröße der `Wow.exe` nicht – das
> kann zu einem Bann führen.**

### Grafik & Sichtweite

**CVar farclip unlock (max 10000)** *(Nr. 43, Autor: Alastor StrixEfuartus)*

Entsperrt die maximale Sichtweite (Farclip) auf 10000 Yards. Der Client klemmt
den Wert beim Setzen in einer einzigen Funktion (VA `0x780770`) nach oben ab
und hält dafür zwei Grenzen bereit: 1583 Yards im Normalfall und 791 Yards als
Rückfallwert. Die 791 greifen auf den alten Vanilla-Zonen sowie auf Rechnern
mit höchstens 1 GB Arbeitsspeicher – der Client fragt die RAM-Größe an dieser
Stelle tatsächlich ab. Der Patch hebt beide Grenzen auf 10000, sonst fällt die
Sichtweite je nach Zone wieder auf 791 zurück.
Die Untergrenze von 183 Yards bleibt unangetastet, und ein davon getrenntes
Eingabelimit für das CVar gibt es nicht – diese Klemme ist das Limit.
Nicht zu verwechseln mit der 1277 aus dem Video-Menü: Das ist die Obergrenze
des Sichtweite-Reglers und eine völlig andere Stelle in der EXE (siehe
Patch Nr. 47 „Grafikoptionen: Slider-Maxima erweitern“).

**CVar horizonFarclipScale unlock (max 12)** *(Nr. 44, Autor: St0ny)*

Entsperrt das CVar `horizonFarclipScale` und setzt den maximalen Wert auf 12.
Erhöht die Sichtweite des Horizonts deutlich.

**CVar environmentDetail unlock (kein Limit statt 1.5)** *(Nr. 45, Autor: St0ny)*

Entfernt die Obergrenze des CVars `environmentDetail` komplett. Original wird
der Wert auf den Bereich 0.5 bis 1.5 begrenzt; der Patch ersetzt am gemeinsamen
Ausgang der Prüfung den geklemmten Wert durch den Rohwert – damit fällt auch
die Untergrenze 0.5 weg, beliebige Werte werden durchgereicht (sinnvoll sind
Werte ab 0.5).
Wichtig: Dieses CVar tut nichts anderes, als die GameObject-Sichtweiten zu
multiplizieren (siehe Patch Nr. 48) – im Original nur die der Kategorien 1 bis
3, mit Patch Nr. 48 alle fünf. Es ist damit der bequemste FPS-Hebel im
Objekt-Rendering, weil er ohne Neupatchen im Spiel wirkt.

**CVar groundEffectDist unlock (max 3166 statt 140)** *(Nr. 46)*

Erhöht die maximale Sichtweite für Bodeneffekte (Gras, Blumen, Bodendeko) von
140 auf 3166 Yards.

**Grafikoptionen: Slider-Maxima erweitern** *(Nr. 47, standardmäßig aus, Autor: St0ny)*

Hebt die Obergrenzen von vier Reglern im Video-Menü an, Reiter „Effekte“. Die
CVars selbst sind durch die Unlock-Patches längst entsperrt – die Regler
blieben trotzdem auf Blizzards Werten stehen, weil sie ihr Maximum nicht aus
dem CVar-Limit beziehen.

| CVar                  | Regler vorher | Regler nachher |
|-----------------------|--------------:|---------------:|
| `farclip`             | 1277          | 2477           |
| `environmentDetail`   | 1.5           | 2.5            |
| `groundEffectDist`    | 140           | 250            |
| `groundEffectDensity` | 64            | 256            |

Die Untergrenzen bleiben unverändert (177 / 0.5 / 70 / 16), ebenso die
Schrittweiten aus dem Interface. Sie gehen glatt auf: bei `environmentDetail`
8 Stufen, bei `groundEffectDist` 18, bei `groundEffectDensity` 30. Beim
Sichtweiten-Regler rechnet das Interface die Schrittweite ohnehin selbst als
(max−min)/10 aus, hier also 230 Yards pro Raste.

<details>
<summary><b>Hintergrund: Warum die Regler nicht schon vorher mitgewachsen sind</b></summary>

Das Interface baut jeden Regler nach diesem Muster auf:

```lua
minValue = GetCVarMin(cvar)  -- oder Ersatzwert aus der Lua
maxValue = GetCVarMax(cvar)  -- oder Ersatzwert aus der Lua
```

Es fragt also zuerst die EXE und nimmt nur dann den in
`VideoOptionsPanels.lua` hinterlegten Ersatzwert, wenn die EXE nichts liefert.
Die Funktion `GetCVarMax` kennt im Original aber nur zwei CVars:
`extShadowQuality` und `farclip`. Für alles andere gibt sie nichts zurück, und
dann greifen die fest verdrahteten Lua-Werte 1.5 / 140 / 64. Bei `farclip`
lieferte sie eine feste 1277 – ebenfalls unabhängig davon, wie weit das CVar
entsperrt ist.

Der Patch ersetzt den festen farclip-Vergleich durch den Aufruf einer kleinen
Such-Routine, die eine Liste von CVar-Namen durchläuft. Steht ein CVar drin,
bekommt das Interface das zugehörige Maximum; steht es nicht drin, läuft alles
wie bisher. Die Routine (18 Byte) liegt in einer freien Lücke zwischen zwei
Funktionen der Code-Sektion, die Liste mit den Maxima im ungenutzten Rest von
`.rdata` – die Datei wächst dadurch nicht.

Wichtig: `GetCVarMax` liegt zweimal in der EXE – einmal für den
Anmelde-/Charakterbildschirm und einmal für das laufende Spiel. Beide Stellen
rufen dieselbe Such-Routine auf. Wird nur eine davon gepatcht, bleiben die
Regler im Spiel unverändert auf 1277 / 1.5 / 140 / 64 stehen, ohne dass
irgendetwas auffällt.

</details>

**Zwei Einschränkungen**

- Der Regler setzt nur das CVar. Ohne die Unlock-Patches klemmt der Client den
  Wert beim Setzen sofort wieder auf sein Original zurück – die Patches
  „CVar farclip unlock“ (Nr. 43), „CVar environmentDetail unlock“ (Nr. 45) und
  „CVar groundEffectDist unlock“ (Nr. 46) gehören also dazu. Fehlen sie in der
  Auswahl, weist der Patcher darauf hin.
- Bei `groundEffectDensity` wirkt oberhalb von 64 nichts mehr: Der Vertexbuffer
  der Bodendeko ist im Client fest auf Dichte × 64 ≤ 4096 geklemmt. Der Regler
  läuft dann bis 256, sichtbar ändert sich ab 64 aber nichts.

**Das Ultra-Preset bleibt auf Blizzards Werten**

Der Master-Regler „Grafikqualität“ setzt auf Ultra weiterhin 1277 / 1.5 / 140 /
64, nicht die neuen Maxima. Das lässt sich von der EXE aus nicht ändern: Die
Preset-Werte stehen als reine Lua-Konstanten in
`Interface\FrameXML\GraphicsQualityLevels.lua` und werden von dort direkt in
die Regler geschrieben. Der einzige Draht von der EXE in diesen Pfad ist
`VideoOptionsEffectsPanel_FixupQualityLevels`, und die Funktion kann nur
klemmen – Werte über dem Maximum runter, Werte unter dem Minimum hoch. Beides
gilt pro CVar für alle sechs Qualitätsstufen gleichzeitig, eine einzelne Stufe
ist nicht ansprechbar.

> [!CAUTION]
> Verlockende Sackgasse: Über das Minimum ließe sich Ultra zwar hochziehen
> (`GetCVarMin("farclip")` ist der double bei `0x9F5798`, original 177.0), aber
> dann werden ALLE sechs Stufen auf diesen Wert gezogen – Niedrig wie Ultra –
> und der Regler bekommt Minimum über Maximum, klebt am Anschlag und hat eine
> negative Schrittweite. Genau das ist bei einem früheren Versuch passiert und
> hat über die `Config.wtf` Startabstürze verursacht. Den Minimum-Double also
> in Ruhe lassen.

Wer Ultra wirklich auf die neuen Maxima heben will, braucht die
Interface-Seite, also eine MPQ mit geänderter `GraphicsQualityLevels.lua` –
dann liegen die Werte fest im Client, statt nachträglich von einem Addon
gesetzt zu werden. Das ist bewusst nicht Teil dieses Patchers: Er bleibt ein
reiner EXE-Patcher, der außer der `Wow.exe` nichts anfasst.

**Kein Regler für horizonFarclipScale**

Für dieses CVar gibt es im Video-Menü überhaupt keinen Regler – es kommt im
gesamten Interface nicht vor. Ein EXE-Patch kann hier nichts anheben, weil es
nichts anzuheben gibt. Der Wert lässt sich weiterhin nur über die
`Config.wtf`, `/console horizonFarclipScale 12` oder ein CVar-Addon setzen
(entsperrt ist er bis 12, siehe oben).

> [!NOTE]
> Die Dateigröße ändert sich nicht: Die kleine Such-Routine liegt in einer
> freien Lücke zwischen zwei Funktionen, die Tabelle mit den Maxima im
> ungenutzten Rest von `.rdata`. Mit Nr. 4 und Nr. 53 gibt es keine Überschneidung.

**GameObject Sichtweite: Cat 0 und Cat 4 auf environmentDetail reagieren lassen** *(Nr. 48, standardmäßig aus, Autor: St0ny)*

Behebt eine Auslassung im Client: Die Funktion, die aus den Basiswerten die
Laufzeit-Sichtweiten rechnet, multipliziert nur Cat 1 bis 3 mit dem CVar
`environmentDetail`. Cat 0 (Kleinkram) und Cat 4 (riesige Gebäude) übernehmen
ihren Basiswert unverändert – der Regler lässt sie schlicht kalt.
Der Patch ergänzt die fehlende Multiplikation in beiden Blöcken. Platz dafür
entsteht, indem eine redundante Kopie der Größen-Schwellen entfällt (die beiden
Tabellen sind identisch und werden nie verändert). Danach skaliert
`environmentDetail` alle fünf Kategorien gleichmäßig – der Regler wird zum
echten Gesamtregler. Die Basis-Sichtweiten bleiben auf den Blizzard-Werten,
geregelt wird über das CVar:

| environmentDetail | Cat 0 | Cat 1 | Cat 2 | Cat 3 | Cat 4 |
|------------------:|------:|------:|------:|------:|------:|
| 1.0               | 30    | 100   | 200   | 750   | 1250  |
| 2.0               | 60    | 200   | 400   | 1500  | 2500  |
| 10                | 300   | 1000  | 2000  | 7500  | 12500 |

Mit Patch Nr. 49 liegt Cat 0 bei 50 statt 30 Yards (in der Tabelle oben also
50 / 100 / 500). Werte über 1.5 setzen den Patch „CVar environmentDetail
unlock“ (Nr. 45) voraus.

**GameObject Sichtweite: Cat 0 von 30 auf 50 Yards** *(Nr. 49, standardmäßig aus, Autor: St0ny)*

Wer die Sichtweiten komplett auf Blizzards Werten lassen möchte, wählt diesen
Patch ab. Er kostet Leistung: Es ist deutlich mehr Kleinkram gleichzeitig
sichtbar, und die Anzahl der gezeichneten Objekte ist der Performance-Hebel.
Der Patch hebt ausschließlich die kleinste Objektkategorie an: Kerzen, Bücher,
Säcke, Werkzeug. Cat 0 ist im Original mit 30 Yards so knapp bemessen, dass
Kleinkram deutlich früher verschwindet als alles andere; 50 verbessert das
Verhältnis zu Cat 1 von 1:3.3 auf 1:2, und der `environmentDetail`-Regler zieht
ihn proportional mit. Cat 1 bis 4 werden nicht angefasst – geregelt wird die
Sichtweite über das CVar, das mit dem Code-Patch Nr. 48 alle fünf Kategorien
gleichmäßig streckt.

Geändert werden fünf zusammengehörige Werte:

| Wert                    | Blizzard | Patch |
|-------------------------|---------:|------:|
| Basis-Sichtweite        | 30       | 50    |
| Laufzeit-Sichtweite     | 30       | 50    |
| Sichtweite im Quadrat   | 900      | 2500  |
| Fade-Start              | 25       | 45    |
| Fade-Start im Quadrat   | 625      | 2025  |

Der Laufzeitwert muss dem Basiswert entsprechen, die Quadrate sind die Quadrate
davon, der Fade-Start ist Sichtweite minus Fade-Band. Das Fade-Band bleibt auf
Blizzards 5 Yards.

<details>
<summary><b>Hintergrund: Wie die Kategorien zustande kommen</b></summary>

Der Client nimmt die Bounding-Box eines Objekts, bildet die **längste Kante**
(nicht den Radius, nicht das Volumen) und sucht die erste Schwelle, die größer
oder gleich dieser Kante ist:

| Kategorie | Längste Kante  | Beispiele                                |
|-----------|----------------|------------------------------------------|
| Cat 0     | bis 1 Yard     | Kerzen, Bücher, Säcke, Werkzeug          |
| Cat 1     | 1 bis 4 Yards  | Kisten, Fässer, Schränke, Feuerschalen   |
| Cat 2     | 4 bis 15 Yards | große Tische, Banner, Kanonen            |
| Cat 3     | 15 bis 100 Yards | Tore, Käfige, Throne, Raid-Türen       |
| Cat 4     | ab 100 Yards   | Zeppeline, schwebende Plattformen        |

Die Schwellen stehen als eigene Tabelle in der EXE und werden von diesem Patch
NICHT angetastet. Die Beispiele stammen aus `GameObjectDisplayInfo.dbc` des
Clients. Achtung: Klassifiziert wird die fertig transformierte Box, ein
hochskaliertes Objekt kann also eine Kategorie höher landen, als sein Modell
vermuten lässt.

**Zusammenspiel mit dem CVar environmentDetail**

Die Werte in diesem Patch sind Basiswerte. Der Client rechnet sie bei jedem
Setzen von `environmentDetail` um:

```
Sichtweite = Basiswert * environmentDetail
```

Im Original gilt das NUR für Cat 1, 2 und 3 – bei Cat 0 und Cat 4 fehlt die
Multiplikation im Code. Der Patch „Cat 0 und Cat 4 auf environmentDetail
reagieren lassen“ (Nr. 48) ergänzt sie, sodass alle fünf Kategorien gleichmäßig
mitwachsen.

Wichtig beim Nachrechnen: Die beiden Faktoren **multiplizieren** sich.
Basiswert ×2 bei CVar 1.5 ergibt ×3, nicht ×2. Wer einen Zielfaktor Z am
CVar-Wert E erreichen will, trägt Z/E als Basiswert ein.
Ohne Patch Nr. 48 gilt das nur für Cat 1–3, und dann laufen die Kategorien
bei hohen CVar-Werten auseinander: Cat 3 würde irgendwann Cat 4 überholen,
mittelgroße Objekte wären also weiter sichtbar als riesige.

Zu beachten: Liegt eine Kategorie-Distanz oberhalb des CVars `farclip`,
schneidet die allgemeine Sichtweite vorher ab und die Kategorie hat keinen
sichtbaren Effekt mehr. Bei farclip 1100 ist Cat 4 also faktisch auf 1100
gedeckelt – höhere Werte wirken erst, wenn farclip entsprechend mitwächst.

**Abgeleitete Tabellen**

Sichtweite und Fade-Band liegen als je eine Tabelle in der EXE, dazu kommen
vier weitere, die der Client daraus selbst berechnet – bei jedem Setzen von
`environmentDetail`:

```
Laufzeit-Sichtweite = Basiswert * environmentDetail
Fade-Start          = Laufzeit-Sichtweite - Fade-Band
Quadrat-Tabellen    = jeweils das Quadrat davon
                      (über die Quadrate cullt die Engine, das spart die Wurzel)
```

Echte Eingangswerte sind also nur die Basis-Sichtweiten und die Fade-Bänder.
Wer die vier abgeleiteten Tabellen trotzdem schreibt, muss sie konsistent
halten, sonst springen die Werte beim ersten Umrechnen.

**Fade-Bänder**

Die Fade-Band-Breiten stehen auf Blizzard-Original (5/10/15/20/50) und werden
nicht mitskaliert. Das Band ist die Strecke, über die ein Objekt vor der
Cull-Grenze ausblendet – enge Bänder halten Objekte bis kurz davor deckend,
statt sie über viele Yards halbtransparent auslaufen zu lassen.
Der Fade-Start ergibt sich immer als Sichtweite minus Band und wandert mit
`environmentDetail` mit: bei 1.0 sind es 25/90/185/730/1200, bei 2.0 dann
55/190/385/1480/2450. Weil das Band gleich bleibt, wächst der Fade-Start etwas
stärker als die Sichtweite selbst.

Hinweis: Die Sichtweite bestimmt, wie viele Objekte gleichzeitig gezeichnet
werden, und ist damit der Performance-Hebel. Die Fade-Bänder kosten praktisch
keine FPS – wer Pop-in störender findet als ein paar Bilder pro Sekunde, kann
sie unabhängig von den Distanzen verbreitern.

</details>

**Occluder Fix für Stormwind (Open Azeroth)** *(Nr. 50, standardmäßig aus, Autor: Robinsch)*

Schaltet die fest in den Client eingebauten Occluder (Sichtblocker) für
Stormwind ab: Der Karten-Schlüssel des Tabelleneintrags für die Östlichen
Königreiche wird auf 99999 gesetzt, sodass er zu keiner Karte mehr passt. So
werden auf Custom-Servern mit umgebautem Stormwind keine Gebäude und Objekte
mehr fälschlich ausgeblendet.

**Blauer Mond am Nachthimmel reaktiviert** *(Nr. 51, Autor: Robinsch)*

Stellt ein entferntes Legacy-Feature wieder her: den blauen Mond, der früher
am Nachthimmel sichtbar war.

**Keine Transparenz beim Heranzoomen** *(Nr. 52, Autor: Alastor StrixEfuartus)*

Der eigene Charakter wird nicht mehr durchsichtig, wenn die Kamera nah
herangezoomt wird. Der Patch entfernt die Transparenz-Zuweisung für den
Normalfall; sitzt der Charakter in einem Fahrzeug oder hängt an einem anderen
Objekt, kann er beim Heranzoomen weiterhin durchsichtig werden (so auch im
Original-Patch).

**Kein Ausblenden für NPCs mit Flag DO_NOT_FADE_IN** *(Nr. 53, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*

Beim Entfernen eines NPCs (z. B. Despawn) blendet der Client das Modell
normalerweise langsam aus. Mit dem Patch verschwinden NPCs sofort, bei denen der
Server in `UNIT_FIELD_FLAGS_2` das Flag `UNIT_FLAG2_DO_NOT_FADE_IN` (`0x20`) setzt –
passend zum fehlenden Einblenden. Spieler und NPCs ohne das Flag verhalten sich
wie bisher.

> [!IMPORTANT]
> Wirkt nur, wenn der Server das Flag setzt. Ohne Unterstützung durch den Server
> ändert sich nichts.
>
> Der Code liegt wie bei Nr. 4 in der freien Lücke am Ende von `.text`. Beide
> passen zusammen hinein, die Dateigröße ändert sich nicht.

**HD Unit-Frame Portraits: Renderauflösung 256 statt 64 Pixel** *(Nr. 54, standardmäßig aus, Autor: Badgermilk0)*

Die Unit-Frames (Spieler, Ziel, Gruppe, Bosse usw.) zeigen im Client schon im
Original das 3D-Modell des jeweiligen Charakters. Der Patch erzeugt also
**keine neuen Portraits, keine Bilder und keine Animationen** – er ändert nur
eine Zahl: Der Client rendert dieses Modell für den Frame in eine Textur, und
die ist im Original 64×64 Pixel groß. Der Patch hebt genau diese
Renderauflösung auf 256×256 Pixel an, fest eingebaut über den Aufruf
`Add-HdPortraits 256` in `apply_patches.ps1`. Das Original von Badgermilk0
lässt bis zu 4096×4096 zu; hier ist bewusst 256 gewählt, weil mehr nur Speicher
kostet, ohne sichtbar besser auszusehen. Bildausschnitt, Neigung und Zoom
bleiben unverändert, die Portraits werden nur deutlich schärfer.
Nur der 3D-Modell-Pfad wird angehoben; der Icon-/Datei-Pfad (feste
64×64-Bilder für Item-/Zauber-Icons) bleibt bewusst auf 64, da dessen
Kopierschleife sonst über die Quelle hinaus liest.

> [!WARNING]
> Dieser Patch hängt eine neue PE-Sektion `.hdp` an die `Wow.exe` an (generierte
> 256er-Alphamaske + Code-Höhlen + Detour des Masken-Builders), die Datei wächst
> dadurch um ca. 69 KB. **Viele Server tolerieren eine veränderte Dateigröße der
> `Wow.exe` nicht – das kann zu einem Bann führen.**

### Interface & Komfort

**Quest-Tracker automatisch sortieren** *(Nr. 55, standardmäßig aus)*

Setzt das CVar `trackerSorting` standardmäßig auf 1. Quests im Tracker werden
automatisch sortiert.

**Erweiterte Weltkarte standardmäßig aktiv** *(Nr. 56, standardmäßig aus)*

Setzt das CVar `advancedWorldMap` standardmäßig auf 1. Die erweiterte
Kartenansicht ist von Anfang an aktiviert.

**Cast Bars auf allen Frames** *(Nr. 57, Autor: Kebabstorm)*

Ermöglicht die Anzeige von Zauberbalken auf allen Unit-Frames (Party, Arena,
Boss etc.), nicht nur auf Target und Focus, sowie auf allen
Standard-Nameplates. Entspricht dem Verhalten ab Cataclysm.

**Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert** *(Nr. 58, standardmäßig aus, Autor: MacWarrior)*

Der Client hält die Anzahl der wählbaren Tabard-Varianten in einer kleinen
Tabelle (VA `0xA14908`, Datei-Offset `0x613108`): 170 Embleme, 17 Emblemfarben,
6 Bordüren, 17 Bordürenfarben, 51 Hintergrundfarben. Der Tabard-Designer
schaltet mit „Index modulo Zähler“ durch, das Zufalls-Tabard zieht
„rand() mal Zähler“ – beide lesen den Wert zur Laufzeit, eine zweite fest
verdrahtete 170 gibt es nirgends. Der Patch hebt den Emblem-Zähler auf die 196
von Retail an, damit fällt die Grenze vollständig.

> [!WARNING]
> **Zusätzliches MPQ-Patch-Archiv nötig.** Dieser Patch hebt ausschließlich
> den Zähler in der EXE an, er bringt keine Grafiken mit. Die 26 neuen Wappen
> (Index 170 bis 195) müssen als eigenes MPQ-Archiv im `Data`-Ordner liegen.
> Ohne dieses Archiv sind die neuen Plätze im Tabard-Designer zwar anwählbar,
> bleiben aber leer.
>
> Das passende Archiv ist **Patch-G**: [Discord](https://discord.com/channels/407664041016688662/1541873346608889936)

Der Client setzt die Dateinamen aus Emblem-Index und Farbindex zusammen, in
dieser Reihenfolge:

```
Textures\GuildEmblems\Emblem_<Index>_<Farbe>_TU_U   (obere Hälfte)
Textures\GuildEmblems\Emblem_<Index>_<Farbe>_TL_U   (untere Hälfte)
```

Die Endung `.blp` hängt der Texturlader an. Pro Wappen sind das 17 Farben × 2
Hälften = 34 Dateien, für alle 26 neuen Wappen zusammen 884. Der Archivname
ist frei wählbar (`patch-*.MPQ`), dafür sorgt der Patch
„Erweiterte MPQ-Namen erlauben“ (Nr. 16).

**FlashWindow Patch** *(Nr. 59, Autor: Kebabstorm)*

Lässt das WoW-Fenster in der Taskleiste blinken, wenn ein relevantes Ereignis
eintritt und das Spiel im Hintergrund läuft. Dafür wird die in 3.3.5a
funktionslose Lua-Funktion `BNRemoveFriend` durch `FlashWindow()` ersetzt, die
Addons aufrufen können (Windows-API `FlashWindow(hwnd, FALSE)`, genau wie die
Fassung in der `AwesomeWotlkLib.dll`).
**Benötigt** ein Addon, das `FlashWindow()` aufruft, z. B. das
[Flash-Addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash) aus awesome_wotlk –
das braucht zusätzlich `IsWindowFocused()` aus der `AwesomeWotlkLib.dll`
(Nr. 22).

**Charaktererstellung: Aussehen nicht automatisch auswürfeln** *(Nr. 60, standardmäßig aus, Autor: Alyst3r (0x539wowmod))*

Beim Öffnen der Charaktererstellung (Klick auf „Neuer Charakter“) und beim
Wechsel von Volk oder Geschlecht würfelt der Client Gesicht, Haut, Frisur usw.
nicht mehr automatisch aus, man startet mit dem Standard-Aussehen. Der
Zufall-Knopf funktioniert weiter – er nutzt im Client einen eigenen Weg.

### Fenster, Maus & Kamera

**Fenstermodus als Standard setzen** *(Nr. 61, standardmäßig aus, Autor: St0ny)*

Setzt das CVar `gxWindow` standardmäßig auf 1. Das Spiel startet im
Fenstermodus statt im Vollbild.

**Fenstermodus maximiert als Standard setzen** *(Nr. 62, standardmäßig aus, Autor: St0ny)*

Setzt das CVar `gxMaximize` standardmäßig auf 1. Das Fenster wird beim Start
automatisch maximiert.

**Kein schwarzer Bildschirm beim Wechsel in den Fenstermodus** *(Nr. 63, Autor: Robinsch)*

Wer im laufenden Spiel in den Fenstermodus wechselt, bekommt danach keinen
schwarzen Bildschirm mehr. Technisch nimmt der Callback des CVars
`DesktopGamma` immer den Weg über die Spiel-Gamma; der Desktop-Gamma-Weg und
damit das CVar `DesktopGamma` sind ohne Wirkung.

**Mausflackern / Kamerasprünge Fix** *(Nr. 64, Autor: Robinsch)*

Ein umfangreicher Patch (4 Teile), der Probleme mit Mäusen behebt, die eine
hohe Abtastrate (Polling-Rate) verwenden. Verhindert Flackern des Mauszeigers
und unkontrollierte Kamerabewegungen.

**CameraReforged [BETA]: Kamerahöhe und Zoom-Grenzen** *(Nr. 65, standardmäßig aus, Autor: Stormhand / St0ny)*

Portierung von [CameraReforged](https://github.com/Zendevve/CameraReforged)
von **Stormhand** in diesen Patcher, damit
alles in einem Durchgang läuft – eingebaut mit seiner ausdrücklichen Erlaubnis
(„Of course! Take whatever you need. I appreciate your work.“). Die Portierung
und ihre Anpassungen stammen von St0ny. Der Client bekommt zwei komplett neue
CVars eingebaut, zwei vorhandene bekommen neue Startwerte.

> [!WARNING]
> **BETA** – dieser Patch funktioniert noch nicht zu 100 %, hier fließt noch
> Arbeit hinein. Deshalb ist er standardmäßig abgewählt. Der Schulterversatz
> (`test_cameraOverShoulder`) hat derzeit keine Wirkung: Die vier Lesestellen,
> die die Vorlage dafür umbiegt, gehören nicht zur Kamera, sondern zum
> Chat-Fenster (Anzeigedauer der Nachrichten). Sie bleiben hier unangetastet.

| CVar                      | Blizzard | hier  | Bereich       |
|---------------------------|----------|-------|---------------|
| `test_cameraHeight`       | (fehlt)  | 0.50  | 0.0 bis 3.0   |
| `test_cameraOverShoulder` | (fehlt)  | 0.00  | -2.0 bis 2.0 (ohne Wirkung) |
| `cameraDistanceMaxFactor` | 1.0      | 2.60  | 1.0 bis 5.0   |
| `cameraDistanceMoveSpeed` | 8.33     | 20.00 | 1.0 bis 100.0 |

- `test_cameraHeight` hebt den Punkt an, auf den die Kamera zielt. Der Client
  legt ihn auf Brusthöhe; 0.5 Yards bringen ihn auf Kopfhöhe.
- `test_cameraOverShoulder` soll die Kamera seitlich verschieben, negative
  Werte nach links – derzeit ohne Wirkung (siehe oben).
- `cameraDistanceMaxFactor` ist der Faktor, um den man über die normale
  Zoomgrenze hinaus herausfahren kann, `cameraDistanceMoveSpeed` das Zoom-Tempo.

Beide neuen CVars gab es in 3.3.5a bisher nur über `ConsoleXP.dll` samt
Injector – der Patch registriert sie direkt in der EXE. Alle vier sind im Spiel
über die Konsole erreichbar und wirken sofort, also auch aus Makros und Addons
wie DynamicCam, z. B. `/console test_cameraHeight 0.8`. Sie werden mit Flag
`0x10` registriert und landen in der `Config.wtf`, eine Änderung überlebt also
den Neustart. Die Startwerte lassen sich im Aufruf
`Add-CameraReforged -Height 0.5 -Shoulder 0.0 -MaxFactor 2.6 -ZoomSpeed 20.0`
in `apply_patches.ps1` ändern; Werte außerhalb der Bereiche lehnt der Patcher ab.

<details>
<summary><b>Hintergrund: Wie der Patch eingebaut ist</b></summary>

Der Patch hängt eine eigene Sektion `.camr` an die EXE an (etwa +1 KB,
lesen/schreiben/ausführen) mit Code und Daten. Angebunden wird das über einen
Detour auf `CVars_Initialize` (dort werden die neuen CVars angemeldet), einen
Detour auf den Kamera-Fokuspfad (dort kommt die Höhe drauf) und zwei umgebogene
Vorgabewert-Zeiger.

Zwei Abweichungen vom Original-Tool, beide notwendig:

1. *Eigene Sektion statt `.rdata`-Padding.* Das Original legt Code und Daten
   ins Padding der `.rdata`-Sektion und macht diese ausführbar – genau das lässt
   diesen Client beim Start mit dem Runtimefehler R6002 abbrechen.
2. *Zeiger statt Callback.* Der Callback des Originals ist ein Prüf-Callback und
   läuft, bevor der neue Wert gespeichert ist; der Wert hinkt dadurch jeder
   Änderung hinterher. Hier merkt sich der Init-Hook den Zeiger auf das
   CVar-Objekt, und der Kamera-Hook liest den Wert bei jedem Bild frisch.

Nicht zusätzlich `CameraReforged.exe` laufen lassen: Das holt den
R6002-Absturz zurück und überschreibt die Tabelle des Slider-Patches.

</details>

> [!WARNING]
> Dieser Patch hängt wie die HD-Portraits eine eigene Sektion an (etwa +1 KB),
> die `Wow.exe` wird dadurch größer. **Viele Server tolerieren eine veränderte
> Dateigröße der `Wow.exe` nicht – das kann zu einem Bann führen.**

### Sound

**Sound-Einstellungen optimieren** *(Nr. 66, standardmäßig aus, Autor: St0ny)*

Umfasst folgende Änderungen:

- Sound-Kanal-Hardware-Limit auf 126 angehoben
- `Sound_OutputQuality` auf Maximum (2) gesetzt
- `Sound_NumChannels` von 32 auf 64 erhöht
- `Sound_EnableReverb` aktiviert (Hall-Effekt)
- `Sound_EnableHardware` aktiviert (Hardware-Audiobeschleunigung)

Das Kanal-Limit von 126 steht fest im Initialisierungscode; der Startwert 64
für `Sound_NumChannels` gilt nur an der zweiten Stelle, an der der Client das
CVar liest.

> [!IMPORTANT]
> Damit diese Einstellungen überhaupt greifen, wird **OpenAL** benötigt, z. B.
> [OpenAL Soft](https://github.com/kcat/openal-soft).

### Client-Infos: Version, Build, Titel, Datum, Icon

Diese fünf Patches von MacWarrior (portiert aus seinen Python-Skripten
`edit_version.py`, `edit_revision.py`, `edit_title.py`, `edit_date.py` und
`edit_icon.py`) ändern, wie sich der Client ausweist. Sind sie ausgewählt,
**fragt der Patcher nach der Auswahl die gewünschten Werte ab**. In eckigen
Klammern steht ein Vorschlag, ENTER übernimmt ihn. Ungültige Eingaben werden mit
einer Meldung neu abgefragt, und alle Werte werden geprüft, bevor irgendetwas
geschrieben wird. Die Werte merkt sich der Patcher in `patcher_selection.ini`
(`value.<Id>=…`); mit `-Unattended` gelten die gemerkten Werte, ohne gemerkten
Wert die Originalwerte – Ausnahmen: Build-Datum (heutiges Datum) und Icon
(Abbruch), siehe Nr. 70 und 71. Steckt ein Patch schon in der `Wow.exe`, ist
sein aktueller Wert der Vorschlag.
Bei der Abfrage steht er auch hinter dem Patchnamen (`-> Vorschlag: …`, bei einem
bereits eingespielten Patch `-> aktuell: …`).

> [!NOTE]
> Server können die Client-Version bzw. Build-Nummer prüfen. Ein geänderter Wert
> muss also zum Server passen.

**Client-Version ändern (Original 3.3.5)** *(Nr. 67, standardmäßig aus, Autor: MacWarrior)*

Setzt eine neue Version im Format `x.y.z` (z. B. `3.3.6` oder `3.3.123`, höchstens
7 Zeichen). Geändert werden die Version, die der Client im Spiel anzeigt, die
FileVersion und die ProductVersion (`Version x.y`) der Versionsressource sowie
`VS_FIXEDFILEINFO`. Die Build-Nummer in `VS_FIXEDFILEINFO` bleibt erhalten; der
FileVersion-Text (`3, 3, 5, 12340`) wird zur reinen Version (`3.3.6`). Haupt-
und Nebenversion müssen zusammen in das ProductVersion-Feld passen (z. B. `3.3`).

**Build-Nummer ändern (Original 12340)** *(Nr. 68, standardmäßig aus, Autor: MacWarrior)*

Setzt eine neue Build-Nummer (6142 bis 65535, Original `12340`): die interne
Build-Nummer, die sichtbare Build-Nummer und den vierten Teil der FileVersion
in `VS_FIXEDFILEINFO`. Die Texte `3, 3, 5, 12340` (FileVersion-Text) und
`WoW [Release] Build 12340 (…)` bleiben unverändert.
Builds bis 6141 lässt der Patcher nicht zu: Server wie AzerothCore oder
TrinityCore halten den Client dann für einen Classic-Client (Pre-BC) und
verwenden ein anderes Login-Protokoll – ein 3.3.5-Client kommt so nicht mehr auf
den Server.

> [!TIP]
> **AzerothCore:** Der Authserver lässt nur Builds zu, die in der Tabelle
> `build_info` der Auth-Datenbank stehen. Für einen eigenen Build, z. B. `12341`:
>
> ```sql
> INSERT INTO build_info (majorVersion, minorVersion, bugfixVersion, hotfixVersion, build, winChecksumSeed, macChecksumSeed)
> VALUES (3, 3, 5, 'a', 12341, NULL, NULL);
> UPDATE realmlist SET gamebuild = 12341 WHERE id = 1;
> ```
>
> `winChecksumSeed` leer lassen (wird nur mit `StrictVersionCheck = 1` in der
> `authserver.conf` geprüft und passt zu einer gepatchten Exe ohnehin nicht).
> Major/Minor/Bugfix sind nur Anzeige in der Realmliste. Danach den Authserver
> neu starten – er liest `build_info` nur beim Start. Ein Realm nimmt nur den
> Build aus `realmlist.gamebuild` an; Spieler mit älterem Client sehen ihn als
> offline.

**Programmtitel in den Dateieigenschaften ändern** *(Nr. 69, standardmäßig aus, Autor: MacWarrior / St0ny)*

Setzt FileDescription, InternalName und ProductName der Versionsressource, also
das, was Windows z. B. in den Dateieigenschaften und im Task-Manager anzeigt.
Höchstens 17 Zeichen, nur ASCII.

**Build-Datum ändern (Original Jun 24 2010)** *(Nr. 70, standardmäßig aus, Autor: MacWarrior)*

Setzt das Build-Datum (Original `Jun 24 2010`) an allen drei Stellen in der EXE
und das Jahr im Copyright-Vermerk. Eingabe als `JJJJ-MM-TT`, optional mit `FR`
dahinter für französische Monatsnamen (z. B. `2026-09-28 FR` → `Sep 28 2026`).
Als Vorschlag steht das **heutige Datum** in den Klammern (mit `FR`, wenn du das
zuletzt gewählt hast); mit `-Unattended` gilt der gemerkte Wert, ohne gemerkten
Wert das heutige Datum. Ist der Patch schon eingespielt, steht dort das aktuelle
Datum der `Wow.exe`.

**Programm-Icon ändern (Symbol der Wow.exe)** *(Nr. 71, standardmäßig aus, Autor: MacWarrior / St0ny)*

Tauscht das Icon aus, das Windows für die `Wow.exe` anzeigt (Explorer,
Taskleiste, Verknüpfungen). Der Patcher fragt nach dem Pfad einer `.ico`-
oder `.png`-Datei, absolut oder relativ zum WoW-Ordner. Aus der Datei baut er
die vier Größen, die in der `Wow.exe` stecken (48, 32, 24 und 16 Pixel, je
32 Bit mit Alphakanal): Ist eine Größe in der ICO enthalten, wird sie direkt
übernommen, sonst wird das nächstgrößere Bild per Flächenmittelung
herunterskaliert (zur Not das größte hochskaliert). Eine PNG liefert alle vier
Größen durch Skalieren. Transparenz bleibt erhalten.

MacWarriors `edit_icon.py` tauscht die Ressourcen über die Windows-API aus, was
die `.rsrc`-Sektion neu schreibt. Hier werden stattdessen nur die Bilddaten der
acht vorhandenen Icon-Bitmaps (vier Größen in zwei Sprachvarianten) an Ort und
Stelle überschrieben – gleiche Größe, gleiche Bittiefe, gleicher Platz.
Ressourcenverzeichnis, Offsets und Dateigröße bleiben unverändert, und der
Patch lässt sich wie jeder andere wieder zurücknehmen. ICO-Bilder in BMP-Form
(1, 4, 8, 16, 24 oder 32 Bit) und PNG (nicht interlaced) liest der Patcher
selbst, ohne Zusatzmodule. Der Pfad wird in `patcher_selection.ini` gemerkt;
mit `-Unattended` muss er dort stehen, sonst bricht der Patcher mit einer
Meldung ab.

> [!NOTE]
> Zeigt der Explorer danach noch das alte Icon, liegt das am Icon-Cache von
> Windows: `Wow.exe` kurz umbenennen oder in einen anderen Ordner kopieren,
> Verknüpfungen neu anlegen oder den Explorer neu starten. Das Icon im Spiel
> selbst (Fenstertitel) kommt ebenfalls aus diesen Ressourcen.

---

## Hinweise

- **Bann-Gefahr:** Zwei Gruppen von Patches können auf vielen Servern zu einem
  Bann führen. Erstens Patches, die Server mit Anti-Cheat als Cheat oder Botting
  werten können: LUA Unlock (Nr. 18 und 19), Steigwinkel (37), Sprunghöhe (38),
  die Sprungsteuerung (39–41) und der Doppelsprung (42). Zweitens Patches, die eine
  Sektion an die `Wow.exe` anhängen und die Datei damit größer machen: Nr. 42,
  54 und 65 – viele Server tolerieren eine veränderte Dateigröße nicht. Beide
  Gruppen sind in der Übersicht mit „Bann-Gefahr“ markiert, und der Patcher
  zeigt vor der Sicherheitsabfrage eine rote Warnung. Alle anderen Patches
  ändern die Dateigröße nicht.
- **Wasserzeichen:** Jede gepatchte `Wow.exe` enthält den Text
  `Patched with St0nys AIO WoW.exe Patcher by St0ny (Raz0r1337) - https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher`.
  Daran erkennt der Patcher eine `Wow.exe` eindeutig als seine eigene: So
  vermischt er nie seine Patches mit denen anderer Patcher, und er kann seinen
  Patchstand auch dann aus der Exe auslesen, wenn `patcher_state.ini` gelöscht
  wurde. Der Text steht im ungenutzten Füllbereich hinter der `.tls`-Sektion
  (Datei-Offset `0x72DE20`), wird nie in den Speicher geladen und ändert die
  Dateigröße nicht. Beim Zurücknehmen aller Patches verschwindet er wieder.
  Nebeneffekt: Man kann jederzeit nachsehen, ob eine `Wow.exe` mit diesem
  Patcher erstellt wurde – z. B. per Hex-Editor oder in der Eingabeaufforderung
  mit `findstr /m /c:"St0nys AIO" Wow.exe` (gibt den Dateinamen aus, wenn er drin
  ist).
- **Original wiederherstellen:** Patcher starten, `N` und ENTER drücken – mit
  oder ohne `patcher_state.ini`. Alternativ gepatchte `Wow.exe` löschen und
  `Wow.exe.ORI` in `Wow.exe` umbenennen. `Wow.exe.BAK` ist dagegen die `Wow.exe`
  von vor dem letzten Lauf.
- **Für Entwickler:** Die Original-Byte-Tabelle im Skript wird mit
  `apply_patches.ps1 -BuildTable -Path <originale Wow.exe>` neu erzeugt. Das ist
  nach jeder Änderung an einem Patch nötig; passt sie nicht mehr, weist der
  Patcher nach dem Patchen darauf hin.
- Nutzung auf eigene Gefahr. Dieses Projekt steht in keiner Verbindung zu
  Blizzard Entertainment.

## Entfernte Patches

Zwei Patches aus Robinschs Sammlung, die frühere Versionen dieses Patchers
enthielten, sind nach der Codeprüfung entfernt – ihre Offsets passen nicht zu
dieser `Wow.exe`:

- **„Geister“-Angriff von NPCs beim Evade behoben** (`0x355BF`: `E8` → `EB`).
  Das Byte macht aus einem `call` in einer String-Hilfsfunktion (VA `0x4361BF`)
  einen Rücksprung um 5 Byte – eine Endlosschleife, die bei jedem Durchlauf
  4 Byte auf den Stack legt, bis der Client abstürzt. Die Funktion wird selten
  aufgerufen, deshalb fiel das im Spiel nicht auf.
- **Nackter-Charakter-Bug behoben** (`0x1DDC5D`: `00` → `EB`). Das Byte ist
  das Argument eines `push 0` in der Lua-Funktion `GetTradeSkillTools`
  (VA `0x5DE85C`) und macht daraus `push -21` – es verfälscht nur einen
  Parameter der Berufe-Werkzeugprüfung und hat nichts mit `SPELL_AURA_X_RAY`
  zu tun.

Eine `Wow.exe`, die noch mit diesen beiden Patches erstellt wurde, erkennt der
Patcher ohne `patcher_state.ini` nicht mehr: dann `Wow.exe.ORI` zurückkopieren
und neu patchen.

## Danksagung

Ein ganz besonderer Dank geht an **Billy Hoyle** – für all seine Hilfe und
seine Tipps in den letzten Monaten und für die Unterstützung beim
Zusammentragen der Patches. Sein Patch-Set steckt als Preset „Billy's_Wow.exe“
in diesem Patcher und ist die Standard-Auswahl.

Beim Zusammentragen der Patches hat auch **MacWarrior** geholfen und dazu
einige eigene Patches beigesteuert – vielen Dank auch dafür!

Danke auch an **Stormhand** für die Erlaubnis, seinen CameraReforged-Patch
einzubauen.

Danke an **Moroes**, der den Patch [#21](#patch-21) aufgespürt und mir
zugespielt hat.

Und natürlich danke an alle Autoren der Patches, die in der
[Patch-Übersicht](#patch-übersicht) genannt sind.

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).
Copyright (c) 2026 St0ny (Raz0r1337).

Kurz gesagt: Jeder darf den Patcher nutzen, verändern und weitergeben – auch in
eigenen Projekten –, solange der Copyright-Hinweis und der Lizenztext erhalten
bleiben (Namensnennung).
