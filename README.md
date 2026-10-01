# St0nys-AIO-WoW-EXE-Patcher

🇩🇪 Deutsch | [🇬🇧 English](README.en.md)

Ein All-in-One-Patcher (AIO) für die `Wow.exe` von **World of Warcraft 3.3.5a (Build 12340)**.
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
  (beim ersten Start; danach die zuletzt vom Patcher erzeugte `Wow.exe`)

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
5. SHA256-Integritätsprüfung: Beim ersten Start muss die `Wow.exe` original und
   unmodifiziert sein, danach exakt die Datei, die der Patcher zuletzt erzeugt
   hat. Alles andere führt zum Abbruch.
6. **Patch-Auswahl** im Menü (siehe unten). Vorausgewählt ist die Auswahl vom
   letzten Mal bzw. bei einer gepatchten `Wow.exe` die Patches, die gerade
   darin stecken.
7. Zusammenfassung der gewählten Patches (bei einer gepatchten `Wow.exe`: was
   neu dazukommt, was zurückgenommen wird), Hinweise auf fehlende oder
   überflüssige Ergänzungs-Patches und Sicherheitsabfrage (J/N).
8. Automatisches Backup als `Wow.exe.BAK` – nur vom Original, also beim ersten
   Patchen.
9. Alle gewählten Patches werden im Speicher eingespielt (mit Fortschrittsanzeige)
   und die `Wow.exe` danach **einmal** zurückgeschrieben. Tritt dabei ein Fehler
   auf, bleibt die `Wow.exe` unverändert.
10. Der Patcher merkt sich den Hash der neuen `Wow.exe` samt Original-Bytes in
    `patcher_state.ini` und zeigt eine Abschlussmeldung.

## Patch-Auswahl

Das Menü listet alle Patches mit Nummer auf. `[X]` = wird eingespielt,
`[ ]` = wird übersprungen. Das Menü ist in dieselben Kategorien gegliedert wie
die [Patch-Übersicht](#patch-übersicht). Vorausgewählt ist die Standard-Auswahl,
das **Preset „Billy's_Wow.exe“** (Spalte „Standard“ in der Übersicht). Patches, die
zusätzlich etwas benötigen, zeigen das in Klammern hinter dem Namen, der Link
dazu steht direkt darunter.

| Eingabe            | Wirkung                                     |
|--------------------|---------------------------------------------|
| `5`                | Patch 5 an-/abwählen                        |
| `3 7 12` / `3,7,12`| mehrere Patches an-/abwählen                |
| `10-15`            | einen Bereich an-/abwählen                  |
| `A`                | alle Patches an                             |
| `N`                | alle Patches aus (bei gepatchter `Wow.exe` + ENTER: Original wiederherstellen) |
| `L`                | Sprache umschalten (Deutsch ↔ English)      |
| `B`                | Preset „Billy's_Wow.exe“ laden (= Standard) |
| `Q`                | abbrechen, die `Wow.exe` bleibt unverändert |
| `ENTER`            | Auswahl übernehmen und weiter               |

Einige Patches wirken nur zusammen mit anderen voll (z. B. die erweiterten
Slider-Maxima brauchen die CVar-Unlocks). Fehlt so ein Ergänzungs-Patch in der
Auswahl, zeigt der Patcher vor der Sicherheitsabfrage einen **Hinweis** an –
gesperrt wird nichts. Ebenso weist er darauf hin, wenn ein Patch einen anderen
überflüssig macht (Warden komplett abschalten ersetzt den RCE-Fix).

### Auswahl wird gespeichert

Sobald du die Auswahl mit ENTER übernimmst, speichert der Patcher sie in der
Datei `patcher_selection.ini` neben dem Script. Beim nächsten Start ist genau
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
  dann gilt wieder das Preset „Billy's_Wow.exe“.

Das Preset „Billy's_Wow.exe“ ist das Patch-Set von Billy Hoyle und zugleich die
Standard-Auswahl. Es ist in `apply_patches.ps1` festgelegt: Jeder Patch hat dort
einen Eintrag `On = $true` (im Preset) bzw. `On = $false` (nicht im Preset).

## Patches ändern oder zurücknehmen

Eingespielte Patches sind nicht endgültig. Starte `patcher.bat` einfach erneut:
Im Menü sind dann genau die Patches angehakt, die gerade in der `Wow.exe`
stecken. Neu angehakte Patches sind mit **(neu)** markiert, abgewählte mit
**(wird zurückgenommen)**. So kannst du beliebig Patches dazunehmen, abwählen
oder bei den Client-Info-Patches die Werte ändern. Mit `N` und ENTER nimmst du
alle Patches zurück – danach ist die `Wow.exe` wieder **byte-genau das
Original**.

So funktioniert es:

- **Erster Start:** Die `Wow.exe` muss original sein (SHA256-Prüfung), sonst
  bricht der Patcher ab. Beim Patchen wird `Wow.exe.BAK` angelegt.
- **Nach dem Patchen** merkt sich der Patcher in `patcher_state.ini` den
  SHA256 der erzeugten `Wow.exe`, die eingespielten Patches mit ihren Werten
  und die Original-Bytes an allen Stellen, die die Patches verändert haben.
- **Jeder weitere Start:** Die `Wow.exe` muss exakt die zuletzt erzeugte Datei
  sein (gleicher Hash), sonst bricht der Patcher ab – etwa wenn sie inzwischen
  von einem anderen Tool verändert wurde. Passt der Hash, baut der Patcher
  daraus im Speicher das Original wieder auf, prüft es noch einmal per SHA256
  gegen das Original und spielt darauf die neue Auswahl ein.
- Vor dem Schreiben prüft der Patcher außerdem, dass sich das neue Ergebnis
  wieder sauber zum Original zurücknehmen lässt.
- Ein vorhandenes `Wow.exe.BAK` wird bei weiteren Läufen nicht angefasst und
  bleibt das Original.

> [!WARNING]
> `patcher_state.ini` nicht löschen oder von Hand ändern, solange die `Wow.exe`
> gepatcht ist – ohne diese Datei lassen sich die Patches nicht mehr
> zurücknehmen. Dann hilft nur noch das Backup: `Wow.exe` löschen und
> `Wow.exe.BAK` in `Wow.exe` umbenennen. Liegt ein originales `Wow.exe.BAK`
> im Ordner, weist der Patcher bei einem Abbruch selbst darauf hin.

## Parameter für den unbeaufsichtigten Betrieb

Alle Parameter sind optional und werden von `patcher.bat` an
`apply_patches.ps1` durchgereicht.

| Parameter              | Bedeutung                                                                   |
|------------------------|-----------------------------------------------------------------------------|
| `-Language de\|en`     | Sprache für diesen Lauf festlegen (ändert die gemerkte Sprache nicht)       |
| `-Select <Auswahl>`    | Auswahlmenü überspringen: `saved` (gespeicherte Auswahl), `billy` (Preset „Billy's_Wow.exe“, auch `default`), `all`, `none` (alle Patches zurücknehmen, Original wiederherstellen) oder Nummern/Bereiche wie `"1,3,5-8"`. Die Auswahl ersetzt die Patches in der `Wow.exe` komplett. Mit `-Select` wird die gespeicherte Auswahl nicht verändert. |
| `-Unattended`          | keine Rückfragen und keine Pausen. Ohne `-Language` gilt die gemerkte Sprache bzw. Deutsch, ohne `-Select` die gespeicherte Auswahl bzw. das Preset „Billy's_Wow.exe“. |
| `-Path <Datei>`        | eine andere `Wow.exe` als die im Skriptordner patchen                        |

Beispiel:

```bat
patcher.bat -Language de -Select saved -Unattended
```

Exit-Codes: `0` = erfolgreich (oder nichts zu tun), `1` = Fehler, `2` = abgebrochen (vom Benutzer oder weil keine Eingabe mehr möglich ist).

## Dateien

| Datei               | Zweck |
|---------------------|-------|
| `patcher.bat`       | Startdatei, ruft `apply_patches.ps1` auf |
| `apply_patches.ps1` | Patch-Engine: Sprachwahl, Prüfungen, Auswahlmenü, Backup; liest die EXE einmal, patcht im Speicher, schreibt einmal zurück |
| `README.md`         | Diese Datei |
| `README.en.md`      | Englische Anleitung |
| `patcher_selection.ini` | Wird angelegt, sobald du eine Auswahl übernimmst, und speichert sie |
| `patcher_state.ini` | Wird beim Patchen angelegt: Hash der gepatchten `Wow.exe`, eingespielte Patches und Original-Bytes zum Zurücknehmen |
| `LICENSE`           | MIT-Lizenz |

---

## Patch-Übersicht

| Nr. | Patch | Autor | Standard |
|----:|-------|-------|:--------:|
|    | **System & Leistung** |  |  |
| 1  | 4GB-Patch (Large Address Aware) | Alastor StrixEfuartus / Kebabstorm / Robinsch | ✅ |
| 2  | CACHE-Ordner-Erstellung deaktivieren | Alastor StrixEfuartus / Kebabstorm | – |
| 3  | Item-Cache sofort aktualisieren | Robinsch | ✅ |
| 4  | WorldFrame-Absturzfix (ungültige Dreiecks-Indizes) *(teilt Code-Höhle mit Slider-Patch)* | Alyst3r (0x539wowmod) / St0ny | – |
|    | **Sicherheit & Datenschutz** |  |  |
| 5  | Remote Code Execution Exploit Fix | Robinsch | – |
| 6  | Warden komplett abschalten, RCE-Fix *(Kick-Gefahr bei aktivem Warden)* | Robinsch | – |
| 7  | Scan.dll deaktivieren | Alastor StrixEfuartus | – |
| 8  | Client-Patches vom Server verbieten | Kebabstorm | – |
| 9  | Hardware-Umfragen vom Server verbieten | Kebabstorm | – |
|    | **Login & Verbindung** |  |  |
| 10 | Battle.net-Login überspringen | Kebabstorm | – |
| 11 | Remote-Desktop-Prüfung überspringen | Kebabstorm | – |
| 12 | HTTP-Anfragen an Battle.net deaktivieren | Kebabstorm | – |
| 13 | AFK-Timer / IDLE-Check deaktivieren *(wird für Character-Autologin benötigt, [Discord](https://discord.com/channels/858041817043042364/1515439916878663701))* | St0ny | – |
|    | **Modding: Interface, MPQs & Addons** |  |  |
| 14 | Custom Glue-XML erlauben | Alastor StrixEfuartus / Kebabstorm | ✅ |
| 15 | Falsch/Nicht signierte MPQs zulassen | Alastor StrixEfuartus | – |
| 16 | Erweiterte MPQ-Namen erlauben |  | ✅ |
| 17 | Daten direkt aus dem Data-Ordner laden (ohne MPQ) | Alastor StrixEfuartus | ✅ |
| 18 | LUA Unlock (geschützte Funktionen freigeben) *(kann als Botting gewertet werden)* | Alastor StrixEfuartus | – |
| 19 | AwesomeWotlkLib.dll Unterstützung aktivieren *(benötigt [awesome_wotlk](https://github.com/noname08662/awesome_wotlk))* | FrostAtom | ✅ |
| 20 | voice.dll beim Start laden (mod-voicechat) [ALPHA] *(Modul ungetestet und unfertig, [mod-voicechat](https://github.com/Raz0r1337/mod-voicechat))* | St0ny | – |
| 21 | Alle Tastatur-Ereignisse an Addons weiterreichen (OnKeyDown) | Alyst3r (0x539wowmod) | – |
|    | **Gameplay-Fixes** |  |  |
| 22 | Area-Trigger-Timer genauer (50 ms statt 250 ms) | Robinsch | ✅ |
| 23 | Nahkampf-Schwung bei Rechtsklick entfernt | Robinsch | ✅ |
| 24 | NPC-Angriffsanimation beim Drehen unterdrückt | Robinsch | ✅ |
| 25 | Zauber-Animation nach Abbruch repariert | Robinsch | ✅ |
| 26 | „Geister“-Angriff von NPCs beim Evade behoben | Robinsch | ✅ |
| 27 | Nackter-Charakter-Bug behoben | Robinsch | ✅ |
| 28 | Force-Reaction bei /reload erhalten | Robinsch | ✅ |
| 29 | Neue Post ohne 60 Sekunden Wartezeit | Robinsch | ✅ |
| 30 | Chat-Befehle auch im Tod erlauben | Robinsch | ✅ |
| 31 | /follow auch bei NPCs erlauben | Alastor StrixEfuartus / St0ny | – |
| 32 | Level 101+ Fix (Druiden-Grundwerte und Barbierstuhl) | Alastor StrixEfuartus | – |
| 33 | Unbegrenzte Rasse/Klasse-Kombinationen *(Server muss es unterstützen)* | Alastor StrixEfuartus / Robinsch | – |
| 34 | Namensprüfung bei der Charaktererstellung abschalten (z. B. Zahlen im Namen) *(Server muss die Namen ebenfalls erlauben)* | Alyst3r (0x539wowmod) / St0ny | – |
| 35 | Max. Charaktere pro Server auf 255 erhöht | St0ny | ✅ |
| 36 | Steigwinkel-Begrenzung aufheben (jeden Hang hochlaufen) *(kann vom Server als Cheat erkannt werden)* | Alastor StrixEfuartus | – |
| 37 | Sprunghöhe ändern (Original -7.9555473) *(fragt den Wert ab, kann vom Server als Cheat erkannt werden)* | Alastor StrixEfuartus | – |
| 38 | Im Sprung vorwärts/rückwärts steuern [TEST] *(kann vom Server als Cheat erkannt werden)* | Alyst3r (0x539wowmod) / St0ny | – |
| 39 | Im Sprung seitwärts steuern [TEST] *(kann vom Server als Cheat erkannt werden)* | Alyst3r (0x539wowmod) / St0ny | – |
| 40 | Im Sprung drehen ändert die Flugrichtung [TEST] *(kann vom Server als Cheat erkannt werden)* | Alyst3r (0x539wowmod) / St0ny | – |
|    | **Grafik & Sichtweite** |  |  |
| 41 | CVar farclip unlock (max 10000) | Alastor StrixEfuartus | ✅ |
| 42 | CVar horizonFarclipScale unlock (max 12) | St0ny | ✅ |
| 43 | CVar environmentDetail unlock (kein Limit statt 1.5) | St0ny | ✅ |
| 44 | CVar groundEffectDist unlock (max 3166 statt 140) |  | ✅ |
| 45 | Grafikoptionen: Slider-Maxima erweitern | St0ny | – |
| 46 | GameObject Sichtweite: Cat 0 und Cat 4 auf environmentDetail reagieren lassen | St0ny | – |
| 47 | GameObject Sichtweite: Cat 0 von 30 auf 50 Yards | St0ny | – |
| 48 | Occluder Fix für Stormwind (Open Azeroth) | Robinsch | – |
| 49 | Blauer Mond am Nachthimmel reaktiviert | Robinsch | ✅ |
| 50 | Keine Transparenz beim Heranzoomen | Alastor StrixEfuartus | ✅ |
| 51 | Kein Ausblenden für NPCs mit Flag DO_NOT_FADE_IN *(Server muss das Flag setzen, teilt Code-Höhle mit Slider-Patch)* | Alyst3r (0x539wowmod) / St0ny | – |
| 52 | HD Unit-Frame Portraits: 256x256 (live 3D-Portraits) | Badgermilk0 | – |
|    | **Interface & Komfort** |  |  |
| 53 | Quest-Tracker automatisch sortieren |  | – |
| 54 | Erweiterte Weltkarte standardmäßig aktiv |  | – |
| 55 | Cast Bars auf allen Frames | Kebabstorm | ✅ |
| 56 | Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert *(benötigt [Patch-G](https://discord.com/channels/407664041016688662/1541873346608889936))* | MacWarrior | – |
| 57 | FlashWindow Patch *(benötigt [FlashWindow-Addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash))* | Kebabstorm | ✅ |
| 58 | Charaktererstellung: Aussehen nicht automatisch auswürfeln | Alyst3r (0x539wowmod) | – |
|    | **Fenster, Maus & Kamera** |  |  |
| 59 | Fenstermodus als Standard setzen | St0ny | – |
| 60 | Fenstermodus maximiert als Standard setzen | St0ny | – |
| 61 | Kein schwarzer Bildschirm beim Wechsel in den Fenstermodus | Robinsch | ✅ |
| 62 | Mausflackern / Kamerasprünge Fix | Robinsch | ✅ |
| 63 | CameraReforged [BETA]: Kamerahöhe, Schulterversatz, Zoom-Grenzen *(noch nicht 100 % fertig)* | Stormhand / St0ny | – |
|    | **Sound** |  |  |
| 64 | Sound-Einstellungen optimieren *(benötigt [OpenAL](https://github.com/kcat/openal-soft))* | St0ny | – |
|    | **Client-Infos: Version, Build, Titel, Datum** |  |  |
| 65 | Client-Version ändern (Original 3.3.5) *(fragt den Wert ab)* | MacWarrior | – |
| 66 | Build-Nummer ändern (Original 12340) *(fragt den Wert ab)* | MacWarrior | – |
| 67 | Programmtitel in den Dateieigenschaften ändern *(fragt den Wert ab)* | MacWarrior | – |
| 68 | Build-Datum ändern (Original Jun 24 2010) *(fragt den Wert ab)* | MacWarrior | – |

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
Verhindert einen Absturz in einer Funktion der Weltdarstellung (VA `0x81D510`). Sie
läuft über Dreiecke aus je drei Vertex-Indizes und rechnet „Index minus Basis“ in
eine Speicheradresse um. Ist ein Index kleiner als die Basis, zeigt die Adresse
vor den Puffer und der Client stürzt ab. Der Patch prüft vorher die drei Indizes
des ersten Dreiecks und überspringt die Funktion in diesem Fall. Gegenüber dem
Original sind die drei Sprungweiten korrigiert und der Code ist kürzer.

> [!IMPORTANT]
> **Teilt sich die Code-Höhle mit dem Slider-Patch (Nr. 45).** Der Code liegt in der freien Lücke am Ende von `.text`, die
> auch Nr. 51 nutzt. Nr. 4 und Nr. 51 passen
> zusammen hinein, nicht aber neben den Slider-Patch: Ist Nr. 45 gewählt, weicht der
> Patch automatisch auf eine eigene kleine Sektion `.wfcfix` am Dateiende aus, und
> der Patcher weist vor der Sicherheitsabfrage darauf hin. Die `Wow.exe` wird
> dadurch etwas größer: Jede ausgelagerte Höhle bekommt eine 512-Byte-Sektion,
> dazu kommt das Auffüllen des Dateiendes – mit Nr. 4 und 48 zusammen rund 1,4 KB.
> Beim Zurücknehmen fällt das wieder weg.

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

**Warden komplett abschalten, RCE-Fix** *(Nr. 6, standardmäßig aus, Autor: Robinsch)*
Der Client verwirft alle Warden-Pakete des Servers (`SMSG_WARDEN_DATA`).
Warden-Module sind Code, den der Server im Client ausführen lässt – mit diesem
Patch ist das überhaupt nicht mehr möglich, auch nicht über künftige Tricks.
Macht den RCE-Fix (Nr. 5) überflüssig; beide zusammen schaden aber nicht,
der Patcher weist dann nur darauf hin.

> [!WARNING]
> Der Client antwortet danach nicht mehr auf Warden. Server mit aktivem Warden
> (z. B. AzerothCore oder TrinityCore in der Standardeinstellung) können dich
> deshalb kicken.

**Scan.dll deaktivieren** *(Nr. 7, standardmäßig aus, Autor: Alastor StrixEfuartus)*
Deaktiviert den Warden-Scan-DLL-Mechanismus im Client.

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

**AFK-Timer / IDLE-Check deaktivieren** *(Nr. 13, standardmäßig aus, Autor: St0ny)*
Deaktiviert den IDLE-Login-Check, lässt den automatischen
AFK-Disconnect-Timer aber aktiv. Verhindert gleichzeitig den
CharAutoLogin-Bug.
**Wird für Character-Autologin benötigt** – Details im [Discord](https://discord.com/channels/858041817043042364/1515439916878663701).

### Modding: Interface, MPQs & Addons

**Custom Glue-XML erlauben** *(Nr. 14, Autor: Alastor StrixEfuartus / Kebabstorm)*
Ermöglicht Änderungen am Login- und Charakterauswahl-Bildschirm durch eigene
XML/Lua-Dateien (Glue-Screen-Modding).

**Falsch/Nicht signierte MPQs zulassen** *(Nr. 15, standardmäßig aus, Autor: Alastor StrixEfuartus)*
Erlaubt das Laden von MPQ-Archiven ohne gültige Signatur. Notwendig für
Custom-Content auf privaten Servern.

**Erweiterte MPQ-Namen erlauben** *(Nr. 16)*
Ermöglicht die Nutzung von Wildcard-Namen für MPQ-Archive
(`patch-*.MPQ` und `patch-locale-*.MPQ`).

**Daten direkt aus dem Data-Ordner laden (ohne MPQ)** *(Nr. 17, Autor: Alastor StrixEfuartus)*
Der Client liest Dateien direkt aus dem Data-Ordner, ohne dass sie in ein MPQ
gepackt werden müssen – z. B. `Data\DBFilesClient\ItemDisplayInfo.dbc`.
Praktisch für Modder.

**LUA Unlock (geschützte Funktionen freigeben)** *(Nr. 18, standardmäßig aus, Autor: Alastor StrixEfuartus)*
Addons und Makros dürfen geschützte Funktionen aufrufen, z. B.
`CastSpellByName`, `CastSpellByID`, `TargetUnit`, `FocusUnit`, `InteractUnit`,
Bewegungsfunktionen oder `ReloadUI`. `AttackTarget` meldet weiterhin einen
Fehler.

> [!WARNING]
> Das ermöglicht Automatisierung. Server mit Anti-Cheat können das als Botting
> werten.

**AwesomeWotlkLib.dll Unterstützung aktivieren** *(Nr. 19, Autor: FrostAtom)*
Ermöglicht das Laden der `AwesomeWotlkLib.dll` beim Client-Start. Diese DLL
erweitert den Client um zusätzliche Funktionen und Verbesserungen für private
Server.
**Benötigt** die `AwesomeWotlkLib.dll` aus [awesome_wotlk](https://github.com/noname08662/awesome_wotlk).

**voice.dll beim Start laden (mod-voicechat) [ALPHA]** *(Nr. 20, standardmäßig aus, Autor: St0ny)*
Lädt beim Start die `voice.dll` aus dem WoW-Ordner – den Client-Teil von
[mod-voicechat](https://github.com/Raz0r1337/mod-voicechat), einem Voice-Chat-Modul für AzerothCore. Fehlt die DLL,
startet WoW ganz normal.

> [!CAUTION]
> **ALPHA** – das Modul mod-voicechat ist noch komplett ungetestet und nicht
> fertig. Es ist nicht zum Spielen freigegeben. Deshalb ist dieser Patch
> standardmäßig abgewählt.

Dateigröße und PE-Header bleiben unverändert: Der Sprung am Einstiegspunkt
(VA `0x401005`) wird in eine freie 27-Byte-Lücke zwischen zwei Funktionen
(VA `0x944B45`) umgebogen. Dort stehen `push "voice.dll"` → `call [LoadLibraryA]`
→ Sprung zum ursprünglichen Ziel. Vor dem Schreiben prüft der Patcher
Einstiegspunkt, Lücke und den `LoadLibraryA`-Import.

**Alle Tastatur-Ereignisse an Addons weiterreichen (OnKeyDown)** *(Nr. 21, standardmäßig aus, Autor: Alyst3r (0x539wowmod))*
Hat ein Frame ein OnKeyDown-Skript, meldet der Client die Taste danach als
erledigt – sie erreicht die Tastenbelegungen dann nicht mehr. Mit dem Patch läuft
jede Taste nach dem OnKeyDown-Skript weiter zu den Tastenbelegungen. So können
Addons alle Tastendrücke mitlesen, ohne die normale Steuerung zu blockieren.

> [!NOTE]
> Addons, die sich darauf verlassen, dass OnKeyDown eine Taste „schluckt“, lösen
> damit zusätzlich die belegte Aktion aus.

### Gameplay-Fixes

**Verbesserung der Genauigkeit des Area-Trigger-Timers** *(Nr. 22, Autor: Robinsch)*
Erhöht die Prüffrequenz für Area-Trigger von 250 ms auf 50 ms. Dadurch werden
Zonen-Übergänge und Trigger präziser erkannt.

**Nahkampf-Schwung bei Rechtsklick entfernt** *(Nr. 23, Autor: Robinsch)*
Verhindert den fehlerhaften Auto-Attack-Swing, der beim Rechtsklick auf ein
Ziel ausgelöst wurde.

**NPC-Angriffsanimation beim Drehen unterdrückt** *(Nr. 24, Autor: Robinsch)*
Unterdrückt die Angriffsanimation von NPCs beim Drehen, wenn kein echter
Angriff stattfindet.

**Zaubervorbereitungs-Animation nach Abbruch kanalisierter Spells repariert** *(Nr. 25, Autor: Robinsch)*
Behebt einen Bug, bei dem nach dem Abbrechen eines kanalisierten Zaubers die
Vorbereitungsanimation hängen blieb.

**„Geister“-Angriff von NPCs beim Evade behoben** *(Nr. 26, Autor: Robinsch)*
Behebt den „Geister“-Angriff, den NPCs ausführen, wenn sie aus dem Kampf
evaden.

**Nackter-Charakter-Bug behoben** *(Nr. 27, Autor: Robinsch)*
Deaktiviert den `SPELL_AURA_X_RAY`-Effekt, der dazu führen konnte, dass
Charaktere ohne Ausrüstung dargestellt wurden.

**Force-Reaction bleibt bei /reload erhalten** *(Nr. 28, Autor: Robinsch)*
Verhindert, dass Force-Reaction-Werte (z. B. Fraktionsstatus) beim Neuladen
der UI zurückgesetzt werden. Wichtig für Custom-Server.

**Neue Post ohne 60 Sekunden Wartezeit** *(Nr. 29, Autor: Robinsch)*
Der Client fragt neue Post sofort ab – kein Warten mehr von 60 Sekunden und kein
Relog, um neue Post zu bekommen.

**Chat-Befehle auch im Tod erlauben** *(Nr. 30, Autor: Robinsch)*
Slash-Befehle funktionieren auch, während der Charakter tot ist.

**/follow auch bei NPCs erlauben** *(Nr. 31, standardmäßig aus, Autor: Alastor StrixEfuartus / St0ny)*
Mit `/follow` lässt sich auch NPCs folgen, nicht nur Spielern. Basiert auf
dem /follow-Patch aus der 12th Generation EXE von Alastor StrixEfuartus,
Portierung und Anpassung von St0ny: Das Original leitet die Prüfung in
eine Code-Höhle um, die ihr Ergebnis ignoriert. Diese Höhle läge aber genau
dort, wo der Slider-Patch (Nr. 45) seinen Code ablegt. Hier wird
stattdessen der bedingte Sprung hinter der Prüfung unbedingt gemacht – ein
einziges Byte, gleiche Wirkung, und beide Patches vertragen sich.

**Level 101+ Fix für Druiden-Grundwerte und Barbierstuhl** *(Nr. 32, standardmäßig aus, Autor: Alastor StrixEfuartus)*
Druiden ab Level 101 können ihre Grundwerte wieder ansehen, und der
Barbierstuhl funktioniert für alle Charaktere ab Level 101.
**Benötigt** den Patch „Custom Glue-XML erlauben“ (Nr. 14). In der Quelle
heißt er „Disable XML SIG MD5“, daher der dortige Hinweis „Use XML MD5“.

**Unbegrenzte Rasse/Klasse-Kombinationen** *(Nr. 33, standardmäßig aus, Autor: Alastor StrixEfuartus / Robinsch)*
Die Charaktererstellung lässt jede Rasse mit jeder Klasse zu. Der Server muss
das ebenfalls unterstützen.

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

**Steigwinkel-Begrenzung aufheben (jeden Hang hochlaufen)** *(Nr. 36, standardmäßig aus, Autor: Alastor StrixEfuartus)*
Der Charakter kommt jeden Hang hoch, egal wie steil. Im Original ist bei 50°
Schluss: Der Client vergleicht die Neigung mit dem Kosinus dieses Winkels
(`0.6427876` bei VA `0xA37F0C`). Der Patch setzt ihn auf `0.0` = cos 90°.

> [!WARNING]
> Server mit Anti-Cheat können das als Climb-Hack erkennen.

**Sprunghöhe ändern** *(Nr. 37, standardmäßig aus, Autor: Alastor StrixEfuartus)*
Ändert die Anfangsgeschwindigkeit des Sprungs (VA `0xAA33DC`, Original
`-7.9555473`). Der Patcher fragt den Wert nach der Auswahl ab: eine negative
Zahl von `-100` bis knapp unter `0`, Komma oder Punkt als Dezimaltrenner. Je
kleiner der Wert, desto höher der Sprung; die Höhe wächst mit dem Quadrat, d. h.
`-11.25` ergibt etwa die doppelte, `-15.91` etwa die vierfache Sprunghöhe. Der
Wert wird wie bei den Client-Info-Patches gemerkt.

> [!WARNING]
> Server mit Anti-Cheat können das als Jump-Hack erkennen.

**Im Sprung vorwärts/rückwärts steuern [TEST]** *(Nr. 38, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*
Normalerweise ignoriert der Client Vorwärts- und Rückwärts-Eingaben, solange der
Charakter springt oder fällt. Mit dem Patch lässt sich die Richtung auch in der
Luft ändern, bis hin zur Gegenrichtung. 0x539wowmod ersetzt dafür per DLL die
Vorwärts-Eingabe des Clients; deren Version weicht vom Original nur in zwei
Sprüngen ab (in der Luft nicht abbrechen, Geschwindigkeit neu berechnen), die
hier direkt in der EXE geändert werden – ohne DLL und ohne Code-Höhle. Dazu kommt
der Byte-Patch aus 0x539wowmod, der die Bewegung in der Luft aktualisiert.

> [!WARNING]
> **TEST:** Noch nicht im Spiel bestätigt. Server mit Anti-Cheat können veränderte
> Bewegung in der Luft erkennen.

**Im Sprung seitwärts steuern [TEST]** *(Nr. 39, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*
Wie der vorige Patch, nur für seitliche Bewegung (Strafen): zwei Sprünge in der
Seitwärts-Eingabe des Clients plus der Byte-Patch aus 0x539wowmod, der die
Bewegung bei gesetztem Fall-Flag nicht mehr vorzeitig abbricht.

> [!WARNING]
> **TEST:** Noch nicht im Spiel bestätigt. Server mit Anti-Cheat können veränderte
> Bewegung in der Luft erkennen.

**Im Sprung drehen ändert die Flugrichtung [TEST]** *(Nr. 40, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*
Dreht man sich im Sprung (Maus oder Tasten), behält der Charakter im Original
seine Flugrichtung. Mit dem Patch setzt der Client die Bewegungsrichtung auch in
der Luft neu, wie es die DLL von 0x539wowmod tut. Passt am besten zusammen mit
den beiden vorigen Patches.

> [!WARNING]
> **TEST:** Noch nicht im Spiel bestätigt. Server mit Anti-Cheat können veränderte
> Bewegung in der Luft erkennen.

### Grafik & Sichtweite

**Farclip unlock auf max 10000** *(Nr. 41, Autor: Alastor StrixEfuartus)*
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
Patch Nr. 45 „Slider-Maxima im Video-Menü erweitern“).

**CVar horizonFarclipScale auf max. Wert 12 entsperrt** *(Nr. 42, Autor: St0ny)*
Entsperrt den CVar `horizonFarclipScale` und setzt den maximalen Wert auf 12.
Erhöht die Sichtweite des Horizonts deutlich.

**CVar environmentDetail unlock (kein Limit statt 1.5)** *(Nr. 43, Autor: St0ny)*
Entfernt die Obergrenze des CVars `environmentDetail` komplett. Original wird
der Wert auf den Bereich 0.5 bis 1.5 begrenzt; der Patch hebelt die obere
Begrenzung aus, sodass beliebig hohe Werte durchgereicht werden.
Wichtig: Dieses CVar tut nichts anderes, als die GameObject-Sichtweiten zu
multiplizieren (siehe Patch Nr. 46 und 45) – im
Original nur die der Kategorien 1 bis 3, mit Patch Nr. 46 alle fünf. Es ist
damit der bequemste FPS-Hebel im Objekt-Rendering, weil er ohne Neupatchen im
Spiel wirkt.

**CVar groundEffectDist unlock (max 3166 statt 140)** *(Nr. 44)*
Erhöht die maximale Sichtweite für Bodeneffekte (Gras, Blumen, Bodendeko) von
140 auf 3166 Yards.

**Slider-Maxima im Video-Menü erweitern** *(Nr. 45, standardmäßig aus, Autor: St0ny)*
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
Such-Routine, die eine Tabelle {CVar-Name, Maximum} durchläuft. Steht ein CVar
drin, bekommt das Interface den Wert; steht es nicht drin, läuft alles wie
bisher. Die Routine liegt im Padding am Ende der Code-Sektion, die Tabelle im
Padding der Datensektion – die Datei wächst dadurch nicht.

Wichtig: `GetCVarMax` liegt zweimal in der EXE – einmal für den
Anmelde-/Charakterbildschirm und einmal für das laufende Spiel. Beide Stellen
rufen dieselbe Such-Routine auf. Wird nur eine davon gepatcht, bleiben die
Regler im Spiel unverändert auf 1277 / 1.5 / 140 / 64 stehen, ohne dass
irgendetwas auffällt.

</details>

**Zwei Einschränkungen**

- Der Regler setzt nur das CVar. Ohne die Unlock-Patches klemmt der Client den
  Wert beim Setzen sofort wieder auf sein Original zurück – die Patches
  „Farclip unlock“ (Nr. 41), „CVar environmentDetail unlock“ (Nr. 43) und
  „CVar groundEffectDist unlock“ (Nr. 44) gehören also dazu. Fehlen sie in der
  Auswahl, weist der Patcher darauf hin.
- Bei `groundEffectDensity` wirkt oberhalb von 64 nichts mehr: Der Vertexbuffer
  der Bodendeko ist im Client fest auf Dichte × 64 ≤ 4096 geklemmt. Der Regler
  läuft dann bis 256, sichtbar ändert sich ab 64 aber nichts.

**Das Ultra-Preset bleibt auf Blizzards Werten**

Der Master-Regler „Grafikqualität“ setzt auf Ultra weiterhin 1277 / 1.5 / 64 /
140, nicht die neuen Maxima. Das lässt sich von der EXE aus nicht ändern: Die
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
> Die Code-Höhle am Ende von `.text` nutzen auch Nr. 4 und Nr. 51. Sind sie
> zusammen mit diesem Patch gewählt, weichen sie automatisch auf eigene kleine
> Sektionen am Dateiende aus – die `Wow.exe` wird dadurch etwas größer.

**GameObject Sichtweite: Cat 0 und Cat 4 auf environmentDetail reagieren lassen** *(Nr. 46, standardmäßig aus, Autor: St0ny)*
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

Mit Patch Nr. 47 liegt Cat 0 bei 50 statt 30 Yards (in der Tabelle oben also
50 / 100 / 500). Werte über 1.5 setzen den Patch „CVar environmentDetail
unlock“ (Nr. 43) voraus.

**GameObject Sichtweite: Cat 0 von 30 auf 50 Yards** *(Nr. 47, standardmäßig aus, Autor: St0ny)*
Wer die Sichtweiten komplett auf Blizzards Werten lassen möchte, wählt diesen
Patch ab.
Der Patch hebt ausschließlich die kleinste Objektkategorie an: Kerzen, Bücher,
Säcke, Werkzeug. Cat 0 ist im Original mit 30 Yards so knapp bemessen, dass
Kleinkram deutlich früher verschwindet als alles andere; 50 verbessert das
Verhältnis zu Cat 1 von 1:3.3 auf 1:2, und der `environmentDetail`-Regler zieht
ihn proportional mit. Cat 1 bis 4 werden nicht angefasst – geregelt wird die
Sichtweite über das CVar (siehe Patch davor), das mit dem Code-Patch alle fünf
Kategorien gleichmäßig streckt.

Geändert werden fünf zusammengehörige Werte:

| Wert                    | Blizzard | Patch |
|-------------------------|---------:|------:|
| Sichtweite              | 30       | 50    |
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
reagieren lassen“ ergänzt sie, sodass alle fünf Kategorien gleichmäßig
mitwachsen.

Wichtig beim Nachrechnen: Die beiden Faktoren **multiplizieren** sich.
Basiswert ×2 bei CVar 1.5 ergibt ×3, nicht ×2. Wer einen Zielfaktor Z am
CVar-Wert E erreichen will, trägt Z/E als Basiswert ein.
Ohne den Code-Patch gilt das nur für Cat 1–3, und dann laufen die Kategorien
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

**Occluder Fix für Stormwind (Open Azeroth)** *(Nr. 48, standardmäßig aus, Autor: Robinsch)*
Erhöht den Occluder-Schwellenwert für Stormwind, damit Gebäude und Objekte
nicht fälschlicherweise ausgeblendet werden. Behebt Grafikfehler auf
Custom-Servern mit umgebautem Stormwind.

**Blauer Mond am Nachthimmel reaktiviert** *(Nr. 49, Autor: Robinsch)*
Stellt ein entferntes Legacy-Feature wieder her: den blauen Mond, der früher
am Nachthimmel sichtbar war.

**Keine Transparenz beim Heranzoomen** *(Nr. 50, Autor: Alastor StrixEfuartus)*
Der eigene Charakter wird nicht mehr durchsichtig, wenn die Kamera nah
herangezoomt wird.

**Kein Ausblenden für NPCs mit Flag DO_NOT_FADE_IN** *(Nr. 51, standardmäßig aus, Autor: Alyst3r (0x539wowmod) / St0ny)*
Beim Entfernen eines NPCs (z. B. Despawn) blendet der Client das Modell
normalerweise langsam aus. Mit dem Patch verschwinden NPCs sofort, bei denen der
Server in `UNIT_FIELD_FLAGS_2` das Flag `UNIT_FLAG2_DO_NOT_FADE_IN` (`0x20`) setzt –
passend zum fehlenden Einblenden. Spieler und NPCs ohne das Flag verhalten sich
wie bisher.

> [!IMPORTANT]
> Wirkt nur, wenn der Server das Flag setzt. Ohne Unterstützung durch den Server
> ändert sich nichts.
>
> **Teilt sich die Code-Höhle mit dem Slider-Patch (Nr. 45).** Wie bei Nr. 4: Mit
> dem Slider-Patch weicht der Patch automatisch auf eine eigene kleine Sektion
> `.nofade` am Dateiende aus. Auch hier wird die `Wow.exe` dadurch etwas größer
> (siehe Nr. 4).

**HD Unit-Frame Portraits: 256x256 statt 64x64** *(Nr. 52, standardmäßig aus, Autor: Badgermilk0)*
Rendert die Live-3D-Portraits (Spieler, Ziel, Gruppe, Bosse usw.) in 256×256
statt der Standard-64×64. Bildausschnitt, Neigung und Zoom bleiben unverändert
– nur die Renderauflösung steigt, die Portraits werden also deutlich schärfer.
Nur der 3D-Modell-Pfad wird angehoben; der Icon-/Datei-Pfad (feste
64×64-Bilder für Item-/Zauber-Icons) bleibt bewusst auf 64, da dessen
Kopierschleife sonst über die Quelle hinaus liest.

> [!NOTE]
> Dieser Patch hängt eine neue PE-Sektion (`.hdp`) an die `Wow.exe` an
> (generierte 256er-Alphamaske + Code-Caves + Detour des Masken-Builders). Die
> Datei wächst dadurch um ca. 69 KB.

### Interface & Komfort

**Quest-Tracker automatisch sortieren** *(Nr. 53, standardmäßig aus)*
Setzt den CVar `trackerSorting` standardmäßig auf 1. Quests im Tracker werden
automatisch sortiert.

**Erweiterte Weltkarte standardmäßig aktiv** *(Nr. 54, standardmäßig aus)*
Setzt den CVar `advancedWorldMap` standardmäßig auf 1. Die erweiterte
Kartenansicht ist von Anfang an aktiviert.

**Cast Bars auf allen Frames (wie Cataclysm)** *(Nr. 55, Autor: Kebabstorm)*
Ermöglicht die Anzeige von Zauberbalken auf allen Unit-Frames (Party, Arena,
Boss etc.), nicht nur auf Target und Focus, sowie auf allen
Standard-Nameplates. Entspricht dem Verhalten ab Cataclysm.

**Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert** *(Nr. 56, standardmäßig aus, Autor: MacWarrior)*
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

**FlashWindow Patch** *(Nr. 57, Autor: Kebabstorm)*
FlashWindow: Lässt das WoW-Fenster in der Taskleiste blinken, wenn ein
relevantes Ereignis eintritt und das Spiel im Hintergrund läuft.
Die Funktion kann per Addon angesprochen werden.
**Benötigt** das [FlashWindow-Addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash) aus awesome_wotlk.

**Charaktererstellung: Aussehen nicht automatisch auswürfeln** *(Nr. 58, standardmäßig aus, Autor: Alyst3r (0x539wowmod))*
Beim Öffnen der Charaktererstellung (Klick auf „Neuer Charakter“) und beim
Wechsel von Volk oder Geschlecht würfelt der Client Gesicht, Haut, Frisur usw.
nicht mehr automatisch aus, man startet mit dem Standard-Aussehen. Der Zufall-Knopf funktioniert weiter – er nutzt im Client einen
eigenen Weg.

### Fenster, Maus & Kamera

**Fenstermodus als Standard setzen** *(Nr. 59, standardmäßig aus, Autor: St0ny)*
Setzt den CVar `gxWindow` standardmäßig auf 1. Das Spiel startet im
Fenstermodus statt im Vollbild.

**Fenstermodus maximiert als Standard setzen** *(Nr. 60, standardmäßig aus, Autor: St0ny)*
Setzt den CVar `gxMaximize` standardmäßig auf 1. Das Fenster wird beim Start
automatisch maximiert.

**Kein schwarzer Bildschirm beim Wechsel in den Fenstermodus** *(Nr. 61, Autor: Robinsch)*
Wer im laufenden Spiel in den Fenstermodus wechselt, bekommt danach keinen
schwarzen Bildschirm mehr.

**Behebung des Mausflackerns und der Kamerasprünge** *(Nr. 62, Autor: Robinsch)*
Ein umfangreicher Patch (4 Teile), der Probleme mit Mäusen behebt, die eine
hohe Abtastrate (Polling-Rate) verwenden. Verhindert Flackern des Mauszeigers
und unkontrollierte Kamerabewegungen.

**CameraReforged [BETA]: Kamerahöhe, Schulterversatz, Zoom-Grenzen** *(Nr. 63, standardmäßig aus, Autor: Stormhand / St0ny)*
Portierung von [CameraReforged](https://github.com/Zendevve/CameraReforged) von **Stormhand** in diesen Patcher, damit
alles in einem Durchgang läuft – eingebaut mit seiner ausdrücklichen Erlaubnis
(„Of course! Take whatever you need. I appreciate your work.“). Die Portierung
und ihre Anpassungen stammen von St0ny. Der Client bekommt zwei komplett neue
CVars eingebaut und zwei vorhandene neue Startwerte.

> [!WARNING]
> **BETA** – dieser Patch funktioniert noch nicht zu 100 %, hier fließt noch
> Arbeit hinein. Deshalb ist er standardmäßig abgewählt.

| CVar                      | Blizzard | hier  | Bereich       |
|---------------------------|----------|-------|---------------|
| `test_cameraHeight`       | (fehlt)  | 0.50  | 0.0 bis 3.0   |
| `test_cameraOverShoulder` | (fehlt)  | 0.00  | -2.0 bis 2.0  |
| `cameraDistanceMaxFactor` | 1.0      | 2.60  | 1.0 bis 5.0   |
| `cameraDistanceMoveSpeed` | 8.33     | 20.00 | 1.0 bis 100.0 |

- `test_cameraHeight` hebt den Punkt an, auf den die Kamera zielt. Der Client
  legt ihn auf Brusthöhe; 0.5 Yards bringen ihn auf Kopfhöhe.
- `test_cameraOverShoulder` verschiebt die Kamera seitlich, negative Werte nach
  links. 0 lässt sie mittig, alles andere ergibt eine Schulterperspektive.
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
Detour auf den Kamera-Fokuspfad (dort kommt die Höhe drauf), zwei umgebogene
Vorgabewert-Zeiger und vier umgebogene Lesestellen für den Schulterversatz.

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

> [!NOTE]
> Dieser Patch verändert wie die HD-Portraits die Dateigröße und die
> PE-Struktur, weil er eine Sektion anhängt. Server, die den Client auf Größe
> oder Sektionsaufbau prüfen, können das bemerken.

### Sound

**Sound-Einstellungen optimieren** *(Nr. 64, standardmäßig aus, Autor: St0ny)*
Umfasst folgende Änderungen:

- Sound-Kanal-Hardware-Limit auf 126 angehoben
- `Sound_OutputQuality` auf Maximum (2) gesetzt
- `Sound_NumChannels` von 32 auf 64 erhöht
- `Sound_EnableReverb` aktiviert (Hall-Effekt)
- `Sound_EnableHardware` aktiviert (Hardware-Audiobeschleunigung)

> [!IMPORTANT]
> Damit diese Einstellungen überhaupt greifen, wird **OpenAL** benötigt, z. B.
> [OpenAL Soft](https://github.com/kcat/openal-soft).


### Client-Infos: Version, Build, Titel, Datum

Diese vier Patches von MacWarrior (portiert aus seinen Python-Scripten
`edit_version.py`, `edit_revision.py`, `edit_title.py` und `edit_date.py`)
ändern, wie sich der Client ausweist. Sind sie ausgewählt, **fragt der Patcher
nach der Auswahl die gewünschten Werte ab**. In eckigen Klammern steht ein
Vorschlag, ENTER übernimmt ihn. Ungültige Eingaben werden mit einer Meldung neu
abgefragt, und alle Werte werden geprüft, bevor irgendetwas geschrieben wird.
Die Werte merkt sich der Patcher in `patcher_selection.ini` (`value.<Id>=…`);
mit `-Unattended` werden die gemerkten Werte bzw. die Originalwerte genommen.
Steckt ein Patch schon in der `Wow.exe`, ist sein aktueller Wert der Vorschlag.
Bei der Abfrage steht der Vorschlag hinter dem Patchnamen mit dem Originalwert.

> [!NOTE]
> Server können die Client-Version bzw. Build-Nummer prüfen. Ein geänderter Wert
> muss also zum Server passen.

**Client-Version ändern** *(Nr. 65, standardmäßig aus, Autor: MacWarrior)*
Setzt eine neue Version im Format `x.y.z` (z. B. `3.3.6` oder `3.3.123`, höchstens
7 Zeichen). Geändert werden die Version, die der Client im Spiel anzeigt, die
FileVersion und die ProductVersion (`Version x.y`) der Versionsressource sowie
`VS_FIXEDFILEINFO`. Die Build-Nummer bleibt erhalten. Haupt- und Nebenversion
müssen zusammen in das ProductVersion-Feld passen (z. B. `3.3`).

**Build-Nummer ändern** *(Nr. 66, standardmäßig aus, Autor: MacWarrior)*
Setzt eine neue Build-Nummer (0 bis 65535, Original `12340`): die interne
Build-Nummer, die sichtbare Build-Nummer und den vierten Teil der FileVersion.

**Programmtitel in den Dateieigenschaften ändern** *(Nr. 67, standardmäßig aus, Autor: MacWarrior)*
Setzt FileDescription, InternalName und ProductName der Versionsressource, also
das, was Windows z. B. in den Dateieigenschaften und im Task-Manager anzeigt.
Höchstens 17 Zeichen, nur ASCII.

**Build-Datum ändern** *(Nr. 68, standardmäßig aus, Autor: MacWarrior)*
Setzt das Build-Datum (Original `Jun 24 2010`) an allen drei Stellen in der EXE
und das Jahr im Copyright-Vermerk. Eingabe als `JJJJ-MM-TT`, optional mit `FR`
dahinter für französische Monatsnamen (z. B. `2026-09-28 FR` → `Sep 28 2026`).
Als Vorschlag steht das **heutige Datum** in den Klammern (mit `FR`, wenn du das
zuletzt gewählt hast); mit `-Unattended` gilt der gemerkte Wert. Ist der Patch
schon eingespielt, steht dort das aktuelle Datum der `Wow.exe`. Bei der Abfrage
steht der Vorschlag außerdem hinter dem Originaldatum, z. B.
`Build-Datum aendern (Original Jun 24 2010) -> Vorschlag: 2026-10-01` bzw.
`-> aktuell: …`, wenn der Patch bereits eingespielt ist.

---

## Hinweise

- Vor dem Patchen wird die `Wow.exe` per SHA256-Hash geprüft. Akzeptiert wird
  nur die originale, unmodifizierte `Wow.exe` oder die Datei, die der Patcher
  zuletzt selbst erzeugt hat. Eine mit anderen Tools oder älteren
  Patcher-Versionen gepatchte Datei wird abgelehnt.
- Das Backup `Wow.exe.BAK` wird nur vom Original erstellt, also beim ersten
  Patchen, und erst wenn die Auswahl bestätigt ist. Ein vorhandenes Backup wird
  dabei überschrieben (es ist ja nachweislich wieder das Original).
- Falls keine `Wow.exe` im Ordner liegt, bricht der Patcher ab.
- Zum Wiederherstellen des Originals den Patcher starten `N` und ENTER drücken. Ohne
  `patcher_state.ini` geht es nur über das Backup: gepatchte `Wow.exe` löschen
  und `Wow.exe.BAK` in `Wow.exe` umbenennen.
- Nutzung auf eigene Gefahr. Dieses Projekt steht in keiner Verbindung zu
  Blizzard Entertainment.

## Danksagung

Ein ganz besonderer Dank geht an **Billy Hoyle** – für seine viele Hilfe und
seine Tipps in den letzten Monaten und für die Hilfe beim Zusammentragen der
Patches. Sein Patch-Set steckt als Preset „Billy's_Wow.exe“ in diesem Patcher
und ist die Standard-Auswahl.

Beim Zusammentragen der Patches hat auch **MacWarrior** geholfen und dazu
einige eigene Patches beigesteuert – vielen Dank auch dafür!

Danke auch an **Stormhand** für die Erlaubnis, seinen CameraReforged-Patch
einzubauen.

Und natürlich danke an alle Autoren der Patches, die in der
[Patch-Übersicht](#patch-übersicht) genannt sind.

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).
Copyright (c) 2026 St0ny (Raz0r1337).

Kurz gesagt: Jeder darf den Patcher nutzen, verändern und weitergeben – auch in
eigenen Projekten –, solange der Copyright-Hinweis und der Lizenztext erhalten
bleiben (Namensnennung).
