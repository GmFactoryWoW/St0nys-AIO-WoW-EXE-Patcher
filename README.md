# St0nys-AIO-WoW-EXE-Patcher

🇩🇪 Deutsch | [🇬🇧 English](README.en.md)

Ein All-in-One-Patcher (AIO) für die `Wow.exe` von **World of Warcraft 3.3.5a (Build 12340)**.
Er spielt Bugfixes, Performance-Optimierungen, erweiterte Sichtweiten,
verbesserte Sound-Einstellungen und einige Komfort-Funktionen direkt in die
EXE ein – in einem Durchgang, ohne zusätzliche Tools oder DLL-Injector.

Beim Start wählst du die **Sprache** (Deutsch / English) und danach in einem
Menü, **welche Patches** eingespielt werden sollen.

> [!IMPORTANT]
> Dieses Repository enthält **keine** `Wow.exe` und keine anderen Dateien von
> Blizzard. Du brauchst deine eigene, unveränderte `Wow.exe` 3.3.5a (12340).

---

## Inhalt

- [Voraussetzungen](#voraussetzungen)
- [Benutzung](#benutzung)
- [Ablauf](#ablauf)
- [Patch-Auswahl](#patch-auswahl)
- [Parameter für den unbeaufsichtigten Betrieb](#parameter-für-den-unbeaufsichtigten-betrieb)
- [Dateien](#dateien)
- [Patch-Übersicht](#patch-übersicht)
- [Patch-Beschreibungen](#patch-beschreibungen)
- [Hinweise](#hinweise)
- [Lizenz](#lizenz)

---

## Voraussetzungen

- Windows mit PowerShell (Windows PowerShell 5.1 ist ab Windows 10 vorinstalliert)
- Eine **originale, unmodifizierte** `Wow.exe` 3.3.5a, Build 12340 mit
  SHA256 `AA63A5750D60EF16746C686B3D5E26876D98953EAB08B1C026CD0FAF78E88CB8`

## Benutzung

1. `patcher.bat` und `apply_patches.ps1` in den WoW-Ordner kopieren
   (dorthin, wo die `Wow.exe` liegt).
2. WoW beenden, falls es noch läuft.
3. `patcher.bat` per Doppelklick starten.
4. Sprache wählen, Patches auswählen, bestätigen – fertig.

Zum **Wiederherstellen** einfach `Wow.exe` löschen und `Wow.exe.BAK` in
`Wow.exe` umbenennen.

## Ablauf

1. ASCII-Banner wird angezeigt.
2. **Sprachauswahl:** `1` = Deutsch, `2` = English.
3. Begrüßung, ENTER zum Starten.
4. Prüfung, ob eine `Wow.exe` im Ordner vorhanden ist.
5. SHA256-Integritätsprüfung, ob die `Wow.exe` original/unmodifiziert ist.
6. **Patch-Auswahl** im Menü (siehe unten). Die Auswahl vom letzten Mal ist
   bereits vorausgewählt.
7. Zusammenfassung der gewählten Patches, Hinweise auf fehlende oder
   überflüssige Ergänzungs-Patches und Sicherheitsabfrage (J/N).
8. Automatisches Backup als `Wow.exe.BAK`.
9. Alle gewählten Patches werden im Speicher eingespielt (mit Fortschrittsanzeige)
   und die `Wow.exe` danach **einmal** zurückgeschrieben. Tritt dabei ein Fehler
   auf, bleibt die `Wow.exe` unverändert.
10. Abschlussmeldung mit der Anzahl der eingespielten Patches.

## Patch-Auswahl

Das Menü listet alle Patches mit Nummer auf. `[X]` = wird eingespielt,
`[ ]` = wird übersprungen. Das Menü ist in dieselben Kategorien gegliedert wie
die [Patch-Übersicht](#patch-übersicht). Vorausgewählt ist die empfohlene
Standard-Auswahl (Spalte „Standard“ in der Übersicht). Patches, die
zusätzlich etwas benötigen, zeigen das in Klammern hinter dem Namen, der Link
dazu steht direkt darunter.

| Eingabe            | Wirkung                                     |
|--------------------|---------------------------------------------|
| `5`                | Patch 5 an-/abwählen                        |
| `3 7 12` / `3,7,12`| mehrere Patches an-/abwählen                |
| `10-15`            | einen Bereich an-/abwählen                  |
| `A`                | alle Patches an                             |
| `N`                | alle Patches aus                            |
| `S` (oder `D`)     | zurück zur Standard-Auswahl                 |
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
  von Hand bearbeitet werden.
- **Zurücksetzen:** im Menü `S` drücken oder `patcher_selection.ini` löschen –
  dann gilt wieder die Standard-Auswahl.

Die Standard-Auswahl ist in `apply_patches.ps1` festgelegt: Jeder Patch hat dort
einen Eintrag `On = $true` (vorausgewählt) bzw. `On = $false` (abgewählt).

## Parameter für den unbeaufsichtigten Betrieb

Alle Parameter sind optional und werden von `patcher.bat` an
`apply_patches.ps1` durchgereicht.

| Parameter              | Bedeutung                                                                   |
|------------------------|-----------------------------------------------------------------------------|
| `-Language de\|en`     | Sprachabfrage überspringen                                                  |
| `-Select <Auswahl>`    | Auswahlmenü überspringen: `saved` (gespeicherte Auswahl), `default`, `all` oder Nummern/Bereiche wie `"1,3,5-8"`. Mit `-Select` wird die gespeicherte Auswahl nicht verändert. |
| `-Unattended`          | keine Rückfragen und keine Pausen. Ohne `-Language` gilt Deutsch, ohne `-Select` die gespeicherte bzw. die Standard-Auswahl. |
| `-Path <Datei>`        | eine andere `Wow.exe` als die im Skriptordner patchen                        |

Beispiel:

```bat
patcher.bat -Language de -Select saved -Unattended
```

Exit-Codes: `0` = erfolgreich, `1` = Fehler, `2` = abgebrochen (vom Benutzer oder weil keine Eingabe mehr möglich ist).

## Dateien

| Datei               | Zweck |
|---------------------|-------|
| `patcher.bat`       | Startdatei, ruft `apply_patches.ps1` auf |
| `apply_patches.ps1` | Patch-Engine: Sprachwahl, Prüfungen, Auswahlmenü, Backup; liest die EXE einmal, patcht im Speicher, schreibt einmal zurück |
| `README.md`         | Diese Datei |
| `README.en.md`      | Englische Anleitung |
| `patcher_selection.ini` | Wird angelegt, sobald du eine Auswahl übernimmst, und speichert sie |
| `LICENSE`           | MIT-Lizenz |

---

## Patch-Übersicht

| Nr. | Patch | Autor | Standard |
|----:|-------|-------|:--------:|
|    | **System & Leistung** |  |  |
| 1  | 4GB-Patch (Large Address Aware) | Kebabstorm | ✅ |
| 2  | CACHE-Ordner-Erstellung deaktivieren | Kebabstorm | – |
| 3  | Item-Cache sofort aktualisieren | Robinsch | ✅ |
|    | **Sicherheit & Datenschutz** |  |  |
| 4  | Remote Code Execution Exploit Fix | Robinsch | – |
| 5  | Warden komplett abschalten, RCE-Fix *(Kick-Gefahr bei aktivem Warden)* | Robinsch | ✅ |
| 6  | Scan.dll deaktivieren | 12th Gen exe | ✅ |
| 7  | Client-Patches vom Server verbieten | Kebabstorm | – |
| 8  | Hardware-Umfragen vom Server verbieten | Kebabstorm | – |
|    | **Login & Verbindung** |  |  |
| 9  | Battle.net-Login überspringen | Kebabstorm | ✅ |
| 10 | Remote-Desktop-Prüfung überspringen | Kebabstorm | ✅ |
| 11 | HTTP-Anfragen an Battle.net deaktivieren | Kebabstorm | ✅ |
| 12 | AFK-Timer / IDLE-Check deaktivieren *(wird für Character-Autologin benötigt, [Discord](https://discord.com/channels/858041817043042364/1515439916878663701))* | St0ny | – |
|    | **Modding: Interface, MPQs & Addons** |  |  |
| 13 | Custom Glue-XML erlauben | Kebabstorm | ✅ |
| 14 | Falsch/Nicht signierte MPQs zulassen | 12th Gen exe | ✅ |
| 15 | Erweiterte MPQ-Namen erlauben |  | ✅ |
| 16 | Daten direkt aus dem Data-Ordner laden (ohne MPQ) | 12th Gen exe | – |
| 17 | LUA Unlock (geschützte Funktionen freigeben) *(kann als Botting gewertet werden)* | 12th Gen exe | – |
| 18 | AwesomeWotlkLib.dll Unterstützung aktivieren *(benötigt [awesome_wotlk](https://github.com/noname08662/awesome_wotlk))* | FrostAtom | – |
|    | **Gameplay-Fixes** |  |  |
| 19 | Area-Trigger-Timer genauer (50 ms statt 250 ms) | Robinsch | ✅ |
| 20 | Nahkampf-Schwung bei Rechtsklick entfernt | Robinsch | ✅ |
| 21 | NPC-Angriffsanimation beim Drehen unterdrückt | Robinsch | ✅ |
| 22 | Zauber-Animation nach Abbruch repariert | Robinsch | ✅ |
| 23 | „Geister“-Angriff von NPCs beim Evade behoben | Robinsch | ✅ |
| 24 | Nackter-Charakter-Bug behoben | Robinsch | ✅ |
| 25 | Force-Reaction bei /reload erhalten | Robinsch | ✅ |
| 26 | Neue Post ohne 60 Sekunden Wartezeit | Robinsch | – |
| 27 | Chat-Befehle auch im Tod erlauben | Robinsch | – |
| 28 | Level 101+ Fix (Druiden-Grundwerte und Barbierstuhl) | 12th Gen exe | – |
| 29 | Unbegrenzte Rasse/Klasse-Kombinationen *(Server muss es unterstützen)* | Robinsch | – |
| 30 | Max. Charaktere pro Server auf 255 erhöht | St0ny | – |
|    | **Grafik & Sichtweite** |  |  |
| 31 | CVar farclip unlock (max 10000) | 12th Gen exe | ✅ |
| 32 | CVar horizonFarclipScale unlock (max 12) | St0ny | ✅ |
| 33 | CVar environmentDetail unlock (kein Limit statt 1.5) | St0ny | ✅ |
| 34 | CVar groundEffectDist unlock (max 3166 statt 140) |  | ✅ |
| 35 | Grafikoptionen: Slider-Maxima erweitern | St0ny | ✅ |
| 36 | GameObject Sichtweite: Cat 0 und Cat 4 auf environmentDetail reagieren lassen | St0ny | ✅ |
| 37 | GameObject Sichtweite: Cat 0 von 30 auf 50 Yards | St0ny | ✅ |
| 38 | Occluder Fix für Stormwind (Open Azeroth) | Robinsch | ✅ |
| 39 | Blauer Mond am Nachthimmel reaktiviert | Robinsch | ✅ |
| 40 | Keine Transparenz beim Heranzoomen | 12th Gen exe | – |
| 41 | HD Unit-Frame Portraits: 256x256 (live 3D-Portraits) | Badgermilk0 | ✅ |
|    | **Interface & Komfort** |  |  |
| 42 | Quest-Tracker automatisch sortieren |  | ✅ |
| 43 | Erweiterte Weltkarte standardmäßig aktiv |  | ✅ |
| 44 | Cast Bars auf allen Frames | Kebabstorm | ✅ |
| 45 | Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert *(benötigt [Patch-G](https://discord.com/channels/407664041016688662/1541873346608889936))* | MacWarrior | – |
| 46 | FlashWindow Patch *(benötigt [FlashWindow-Addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash))* | Kebabstorm | – |
|    | **Fenster & Maus** |  |  |
| 47 | Fenstermodus als Standard setzen | St0ny | ✅ |
| 48 | Fenstermodus maximiert als Standard setzen | St0ny | ✅ |
| 49 | Kein schwarzer Bildschirm beim Wechsel in den Fenstermodus | Robinsch | – |
| 50 | Mausflackern / Kamerasprünge Fix | Robinsch | ✅ |
|    | **Sound** |  |  |
| 51 | Sound-Einstellungen optimieren | St0ny | ✅ |

> [!NOTE]
> **Urheber gesucht:** Bei Patches ohne Eintrag in der Spalte „Autor“ ist der
> Urheber noch nicht bekannt. Wenn du weißt, von wem einer dieser Patches
> stammt, schreib es bitte als [Issue](https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher/issues) – dann wird es nachgetragen.

---

## Patch-Beschreibungen

### System & Leistung

**4GB-Patch (Large Address Aware)** *(Nr. 1, Autor: Kebabstorm)*
Ermöglicht der `Wow.exe`, bis zu 4 GB RAM zu nutzen statt der
standardmäßigen 2-GB-Grenze für 32-Bit-Anwendungen.

**CACHE-Ordner-Erstellung deaktivieren** *(Nr. 2, standardmäßig aus, Autor: Kebabstorm)*
Verhindert, dass der Client automatisch einen `CACHE`-Ordner anlegt.

**Item-Cache sofort aktualisieren** *(Nr. 3, Autor: Robinsch)*
Entfernt die 30-Sekunden-Verzögerung beim Aktualisieren des Item-Caches.
Änderungen an Items werden sofort sichtbar.

### Sicherheit & Datenschutz

**Remote Code Execution Exploit Fix** *(Nr. 4, standardmäßig aus, Autor: Robinsch)*
Schließt eine Sicherheitslücke, die Remote-Code-Ausführung über manipulierte
Pakete ermöglichen konnte: Die Sektion `.zdata` verliert ihr Ausführungsrecht,
und Warden-Module werden nicht mehr aus dem lokalen Cache geladen. Warden selbst
läuft weiter, auf Servern mit aktivem Warden gibt es also keine Probleme.

**Warden komplett abschalten, RCE-Fix** *(Nr. 5, Autor: Robinsch)*
Der Client verwirft alle Warden-Pakete des Servers (`SMSG_WARDEN_DATA`).
Warden-Module sind Code, den der Server im Client ausführen lässt – mit diesem
Patch ist das überhaupt nicht mehr möglich, auch nicht über künftige Tricks.
Macht den RCE-Fix (Nr. 4) überflüssig; beide zusammen schaden aber nicht,
der Patcher weist dann nur darauf hin.

> [!WARNING]
> Der Client antwortet danach nicht mehr auf Warden. Server mit aktivem Warden
> (z. B. AzerothCore oder TrinityCore in der Standardeinstellung) können dich
> deshalb kicken.

**Scan.dll deaktivieren** *(Nr. 6, Autor: 12th Gen exe)*
Deaktiviert den Warden-Scan-DLL-Mechanismus im Client.

**Client-Patches vom Server verbieten** *(Nr. 7, standardmäßig aus, Autor: Kebabstorm)*
Der Server kann dem Client keine Patch-Dateien mehr schicken und installieren
lassen.

**Hardware-Umfragen vom Server verbieten** *(Nr. 8, standardmäßig aus, Autor: Kebabstorm)*
Der Server kann keine Hardware-Umfrage (Informationen über deinen PC) mehr beim
Client anfordern.

### Login & Verbindung

**Battle.net-Login überspringen** *(Nr. 9, Autor: Kebabstorm)*
Der Client überspringt den Battle.net-Login-Schritt und nutzt direkt den
klassischen Login.

**Remote-Desktop-Prüfung überspringen** *(Nr. 10, Autor: Kebabstorm)*
Der Client prüft nicht mehr, ob er über eine Remote-Desktop-Verbindung läuft –
WoW lässt sich damit z. B. per RDP spielen.

**HTTP-Anfragen an Battle.net deaktivieren** *(Nr. 11, Autor: Kebabstorm)*
Der Client ruft keine News, Hilfe-Artikel und Nutzungsbedingungen mehr von
Blizzards Servern ab – die gibt es für 3.3.5 ohnehin nicht mehr.

**AFK-Timer / IDLE-Check deaktivieren** *(Nr. 12, standardmäßig aus, Autor: St0ny)*
Deaktiviert den IDLE-Login-Check, lässt den automatischen
AFK-Disconnect-Timer aber aktiv. Verhindert gleichzeitig den
CharAutoLogin-Bug.
**Wird für Character-Autologin benötigt** – Details im [Discord](https://discord.com/channels/858041817043042364/1515439916878663701).

### Modding: Interface, MPQs & Addons

**Custom Glue-XML erlauben** *(Nr. 13, Autor: Kebabstorm)*
Ermöglicht Änderungen am Login- und Charakterauswahl-Bildschirm durch eigene
XML/Lua-Dateien (Glue-Screen-Modding).

**Falsch/Nicht signierte MPQs zulassen** *(Nr. 14, Autor: 12th Gen exe)*
Erlaubt das Laden von MPQ-Archiven ohne gültige Signatur. Notwendig für
Custom-Content auf privaten Servern.

**Erweiterte MPQ-Namen erlauben** *(Nr. 15)*
Ermöglicht die Nutzung von Wildcard-Namen für MPQ-Archive
(`patch-*.MPQ` und `patch-locale-*.MPQ`).

**Daten direkt aus dem Data-Ordner laden (ohne MPQ)** *(Nr. 16, standardmäßig aus, Autor: 12th Gen exe)*
Der Client liest Dateien direkt aus dem Data-Ordner, ohne dass sie in ein MPQ
gepackt werden müssen – z. B. `Data\DBFilesClient\ItemDisplayInfo.dbc`.
Praktisch für Modder.

**LUA Unlock (geschützte Funktionen freigeben)** *(Nr. 17, standardmäßig aus, Autor: 12th Gen exe)*
Addons und Makros dürfen geschützte Funktionen aufrufen, z. B.
`CastSpellByName`, `CastSpellByID`, `TargetUnit`, `FocusUnit`, `InteractUnit`,
Bewegungsfunktionen oder `ReloadUI`. `AttackTarget` meldet weiterhin einen
Fehler.

> [!WARNING]
> Das ermöglicht Automatisierung. Server mit Anti-Cheat können das als Botting
> werten.

**AwesomeWotlkLib.dll Unterstützung aktivieren** *(Nr. 18, standardmäßig aus, Autor: FrostAtom)*
Ermöglicht das Laden der `AwesomeWotlkLib.dll` beim Client-Start. Diese DLL
erweitert den Client um zusätzliche Funktionen und Verbesserungen für private
Server.
**Benötigt** die `AwesomeWotlkLib.dll` aus [awesome_wotlk](https://github.com/noname08662/awesome_wotlk).

### Gameplay-Fixes

**Verbesserung der Genauigkeit des Area-Trigger-Timers** *(Nr. 19, Autor: Robinsch)*
Erhöht die Prüffrequenz für Area-Trigger von 250 ms auf 50 ms. Dadurch werden
Zonen-Übergänge und Trigger präziser erkannt.

**Nahkampf-Schwung bei Rechtsklick entfernt** *(Nr. 20, Autor: Robinsch)*
Verhindert den fehlerhaften Auto-Attack-Swing, der beim Rechtsklick auf ein
Ziel ausgelöst wurde.

**NPC-Angriffsanimation beim Drehen unterdrückt** *(Nr. 21, Autor: Robinsch)*
Unterdrückt die Angriffsanimation von NPCs beim Drehen, wenn kein echter
Angriff stattfindet.

**Zaubervorbereitungs-Animation nach Abbruch kanalisierter Spells repariert** *(Nr. 22, Autor: Robinsch)*
Behebt einen Bug, bei dem nach dem Abbrechen eines kanalisierten Zaubers die
Vorbereitungsanimation hängen blieb.

**„Geister“-Angriff von NPCs beim Evade behoben** *(Nr. 23, Autor: Robinsch)*
Behebt den „Geister“-Angriff, den NPCs ausführen, wenn sie aus dem Kampf
evaden.

**Nackter-Charakter-Bug behoben** *(Nr. 24, Autor: Robinsch)*
Deaktiviert den `SPELL_AURA_X_RAY`-Effekt, der dazu führen konnte, dass
Charaktere ohne Ausrüstung dargestellt wurden.

**Force-Reaction bleibt bei /reload erhalten** *(Nr. 25, Autor: Robinsch)*
Verhindert, dass Force-Reaction-Werte (z. B. Fraktionsstatus) beim Neuladen
der UI zurückgesetzt werden. Wichtig für Custom-Server.

**Neue Post ohne 60 Sekunden Wartezeit** *(Nr. 26, standardmäßig aus, Autor: Robinsch)*
Der Client fragt neue Post sofort ab – kein Warten mehr von 60 Sekunden und kein
Relog, um neue Post zu bekommen.

**Chat-Befehle auch im Tod erlauben** *(Nr. 27, standardmäßig aus, Autor: Robinsch)*
Slash-Befehle funktionieren auch, während der Charakter tot ist.

**Level 101+ Fix für Druiden-Grundwerte und Barbierstuhl** *(Nr. 28, standardmäßig aus, Autor: 12th Gen exe)*
Druiden ab Level 101 können ihre Grundwerte wieder ansehen, und der
Barbierstuhl funktioniert für alle Charaktere ab Level 101.
**Benötigt** den Patch „Custom Glue-XML erlauben“ (Nr. 13). In der Quelle
heißt er „Disable XML SIG MD5“, daher der dortige Hinweis „Use XML MD5“.

**Unbegrenzte Rasse/Klasse-Kombinationen** *(Nr. 29, standardmäßig aus, Autor: Robinsch)*
Die Charaktererstellung lässt jede Rasse mit jeder Klasse zu. Der Server muss
das ebenfalls unterstützen.

**Max. Charaktere pro Server auf 255 erhöht** *(Nr. 30, standardmäßig aus, Autor: St0ny)*
Hebt die clientseitige Begrenzung von 10 auf 255 Charaktere pro Server an.
Der Server muss dies ebenfalls unterstützen. Zusätzliche
Interface-Anpassungen (Glue-XML) sind nötig, damit der
Charakterauswahl-Bildschirm mehr als 10 Slots anzeigt.

### Grafik & Sichtweite

**Farclip unlock auf max 10000** *(Nr. 31, Autor: 12th Gen exe)*
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
Patch Nr. 35 „Slider-Maxima im Video-Menü erweitern“).

**CVar horizonFarclipScale auf max. Wert 12 entsperrt** *(Nr. 32, Autor: St0ny)*
Entsperrt den CVar `horizonFarclipScale` und setzt den maximalen Wert auf 12.
Erhöht die Sichtweite des Horizonts deutlich.

**CVar environmentDetail unlock (kein Limit statt 1.5)** *(Nr. 33, Autor: St0ny)*
Entfernt die Obergrenze des CVars `environmentDetail` komplett. Original wird
der Wert auf den Bereich 0.5 bis 1.5 begrenzt; der Patch hebelt die obere
Begrenzung aus, sodass beliebig hohe Werte durchgereicht werden.
Wichtig: Dieses CVar tut nichts anderes, als die GameObject-Sichtweiten zu
multiplizieren (siehe Patch Nr. 36 und 37) – im
Original nur die der Kategorien 1 bis 3, mit Patch Nr. 36 alle fünf. Es ist
damit der bequemste FPS-Hebel im Objekt-Rendering, weil er ohne Neupatchen im
Spiel wirkt.

**CVar groundEffectDist unlock (max 3166 statt 140)** *(Nr. 34)*
Erhöht die maximale Sichtweite für Bodeneffekte (Gras, Blumen, Bodendeko) von
140 auf 3166 Yards.

**Slider-Maxima im Video-Menü erweitern** *(Nr. 35, Autor: St0ny)*
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
  „Farclip unlock“ (Nr. 31), „CVar environmentDetail unlock“ (Nr. 33) und
  „CVar groundEffectDist unlock“ (Nr. 34) gehören also dazu. Fehlen sie in der
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

**GameObject Sichtweite: Cat 0 und Cat 4 auf environmentDetail reagieren lassen** *(Nr. 36, Autor: St0ny)*
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

Mit Patch Nr. 37 liegt Cat 0 bei 50 statt 30 Yards (in der Tabelle oben also
50 / 100 / 500). Werte über 1.5 setzen den Patch „CVar environmentDetail
unlock“ (Nr. 33) voraus.

**GameObject Sichtweite: Cat 0 von 30 auf 50 Yards** *(Nr. 37, Autor: St0ny)*
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

**Occluder Fix für Stormwind (Open Azeroth)** *(Nr. 38, Autor: Robinsch)*
Erhöht den Occluder-Schwellenwert für Stormwind, damit Gebäude und Objekte
nicht fälschlicherweise ausgeblendet werden. Behebt Grafikfehler auf
Custom-Servern mit umgebautem Stormwind.

**Blauer Mond am Nachthimmel reaktiviert** *(Nr. 39, Autor: Robinsch)*
Stellt ein entferntes Legacy-Feature wieder her: den blauen Mond, der früher
am Nachthimmel sichtbar war.

**Keine Transparenz beim Heranzoomen** *(Nr. 40, standardmäßig aus, Autor: 12th Gen exe)*
Der eigene Charakter wird nicht mehr durchsichtig, wenn die Kamera nah
herangezoomt wird.

**HD Unit-Frame Portraits: 256x256 statt 64x64** *(Nr. 41, Autor: Badgermilk0)*
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

**Quest-Tracker automatisch sortieren** *(Nr. 42)*
Setzt den CVar `trackerSorting` standardmäßig auf 1. Quests im Tracker werden
automatisch sortiert.

**Erweiterte Weltkarte standardmäßig aktiv** *(Nr. 43)*
Setzt den CVar `advancedWorldMap` standardmäßig auf 1. Die erweiterte
Kartenansicht ist von Anfang an aktiviert.

**Cast Bars auf allen Frames (wie Cataclysm)** *(Nr. 44, Autor: Kebabstorm)*
Ermöglicht die Anzeige von Zauberbalken auf allen Unit-Frames (Party, Arena,
Boss etc.), nicht nur auf Target und Focus, sowie auf allen
Standard-Nameplates. Entspricht dem Verhalten ab Cataclysm.

**Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert** *(Nr. 45, standardmäßig aus, Autor: MacWarrior)*
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
„Erweiterte MPQ-Namen erlauben“ (Nr. 15).

**FlashWindow Patch** *(Nr. 46, standardmäßig aus, Autor: Kebabstorm)*
FlashWindow: Lässt das WoW-Fenster in der Taskleiste blinken, wenn ein
relevantes Ereignis eintritt und das Spiel im Hintergrund läuft.
Die Funktion kann per Addon angesprochen werden.
**Benötigt** das [FlashWindow-Addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash) aus awesome_wotlk.

### Fenster & Maus

**Fenstermodus als Standard setzen** *(Nr. 47, Autor: St0ny)*
Setzt den CVar `gxWindow` standardmäßig auf 1. Das Spiel startet im
Fenstermodus statt im Vollbild.

**Fenstermodus maximiert als Standard setzen** *(Nr. 48, Autor: St0ny)*
Setzt den CVar `gxMaximize` standardmäßig auf 1. Das Fenster wird beim Start
automatisch maximiert.

**Kein schwarzer Bildschirm beim Wechsel in den Fenstermodus** *(Nr. 49, standardmäßig aus, Autor: Robinsch)*
Wer im laufenden Spiel in den Fenstermodus wechselt, bekommt danach keinen
schwarzen Bildschirm mehr.

**Behebung des Mausflackerns und der Kamerasprünge** *(Nr. 50, Autor: Robinsch)*
Ein umfangreicher Patch (4 Teile), der Probleme mit Mäusen behebt, die eine
hohe Abtastrate (Polling-Rate) verwenden. Verhindert Flackern des Mauszeigers
und unkontrollierte Kamerabewegungen.

### Sound

**Sound-Einstellungen optimieren** *(Nr. 51, Autor: St0ny)*
Umfasst folgende Änderungen:

- Sound-Kanal-Hardware-Limit auf 126 angehoben
- `Sound_OutputQuality` auf Maximum (2) gesetzt
- `Sound_NumChannels` von 32 auf 64 erhöht
- `Sound_EnableReverb` aktiviert (Hall-Effekt)
- `Sound_EnableHardware` aktiviert (Hardware-Audiobeschleunigung)

---

## Hinweise

- Vor dem Patchen wird die `Wow.exe` per SHA256-Hash geprüft. Nur eine
  originale, unmodifizierte `Wow.exe` wird akzeptiert – eine bereits gepatchte
  Datei wird abgelehnt.
- Das Backup `Wow.exe.BAK` wird erst erstellt, wenn die Integritätsprüfung
  bestanden und die Auswahl bestätigt ist. Ein vorhandenes Backup wird dabei
  überschrieben (es ist ja nachweislich wieder das Original).
- Falls keine `Wow.exe` im Ordner liegt, bricht der Patcher ab.
- Zum Wiederherstellen die gepatchte `Wow.exe` löschen und `Wow.exe.BAK` in
  `Wow.exe` umbenennen.
- Um eine andere Auswahl einzuspielen, zuerst das Original wiederherstellen und
  den Patcher erneut starten.
- Nutzung auf eigene Gefahr. Dieses Projekt steht in keiner Verbindung zu
  Blizzard Entertainment.

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).
Copyright (c) 2026 St0ny (Raz0r1337).

Kurz gesagt: Jeder darf den Patcher nutzen, verändern und weitergeben – auch in
eigenen Projekten –, solange der Copyright-Hinweis und der Lizenztext erhalten
bleiben (Namensnennung).
