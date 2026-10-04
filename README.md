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

> [!NOTE]
> Windows warnt beim Start der gepatchten `Wow.exe` wahrscheinlich vor einer
> nicht signierten, möglicherweise schädlichen App. Das ist bei jeder
> veränderten `Wow.exe` so: Jede Änderung macht Blizzards digitale Signatur
> ungültig, und eine neue, von Windows anerkannte Signatur lässt sich für eine
> veränderte Blizzard-Datei nicht erstellen. Starten lässt sie sich trotzdem,
> z. B. über „Weitere Informationen“ → „Trotzdem ausführen“. Mehr dazu unter
> [Hinweise](#hinweise).

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
| `B`                | Preset „Billy's_Wow.exe“ laden (= Standard) (**Sicher** auf öffentlichen Servern) |
| `S`                | Preset „St0nys_Wow.exe“ laden (**Nicht sicher**, nur auf eigenen Servern verwenden) |
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
  Patches mit eigenem Wert – Client-Infos, Sprunghöhe, Doppelsprung
  (`value.clientversion=3.3.6` usw.).
- Auch die Sprache wird dort gemerkt (`language=de` bzw. `en`).
- **Zurücksetzen:** im Menü `B` drücken oder `patcher_selection.ini` löschen –
  dann gilt wieder das Preset „Billy's_Wow.exe“ (beim Löschen der Datei werden
  auch Sprache und gemerkte Werte wieder abgefragt).

Das Preset „Billy's_Wow.exe“ ist das Patch-Set von Billy Hoyle und zugleich die
Standard-Auswahl. Es ist in `apply_patches.ps1` festgelegt: Jeder Patch hat dort
einen Eintrag `On = $true` (im Preset) bzw. `On = $false` (nicht im Preset).

Damit lässt sich die erprobte `Wow.exe` aus Billys Paket jederzeit
nachbauen: Wer experimentiert, kommt mit `B` immer wieder zu einem Stand
zurück, der seit Jahren auf öffentlichen Servern läuft.

Das zweite Preset „St0nys_Wow.exe“ (Taste `S`) ist St0nys eigene Auswahl für
eigene Server. Es enthält auch Patches mit Bann-Gefahr und solche, die die
`Wow.exe` vergrößern – **nur auf eigenen Servern verwenden**. Welche Patches
dazugehören, zeigt die Spalte „St0ny“ in der
[Patch-Übersicht](#patch-übersicht); im Skript steht die Liste unter
`$PRESET_STONY`. **Achtung: Dieses Preset sollte unter keinen Umständen
auf öffentlichen Servern verwendet werden – das führt wahrscheinlich zu einem
Bann!** Der Patcher zeigt das beim Laden mit `S` als gelben Hinweis an.

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
| `PATCHES.md`        | Ausführliche Beschreibungen aller Patches |
| `PATCHES.en.md`     | Patch-Beschreibungen auf Englisch |
| `patcher_selection.ini` | Wird beim ersten Start angelegt (gemerkte Sprache) und speichert die übernommene Auswahl samt eingegebenen Werten |
| `patcher_state.ini` | Wird beim Patchen angelegt: Hash der gepatchten `Wow.exe`, eingespielte Patches, Werte und Original-Bytes – beschleunigt den nächsten Start, ist aber nicht zwingend nötig |
| `Wow.exe.ORI`       | Sicherung der originalen `Wow.exe`, angelegt beim ersten Patchen |
| `Wow.exe.BAK`       | Sicherung der bisherigen `Wow.exe` vor dem letzten Lauf |
| `LICENSE`           | MIT-Lizenz |

---

## Patch-Übersicht

Ein Klick auf die Nummer eines Patches springt zu seiner Beschreibung.

<details>
<summary><b>Übersicht aller Patches mit Autor und Preset-Zuordnung anzeigen</b></summary>

| Nr. | Patch | Autor | Standard | St0ny |
|----:|-------|-------|:--------:|:-----:|
|    | **System & Leistung** |  |  |  |
| [1](PATCHES.md#patch-laa) | 4GB-Patch (Large Address Aware) | Alastor StrixEfuartus / Kebabstorm / Robinsch | ✅ | ✅ |
| [2](PATCHES.md#patch-cache) | CACHE-Ordner-Erstellung deaktivieren | Alastor StrixEfuartus / Kebabstorm | – | – |
| [3](PATCHES.md#patch-itemcache) | Item-Cache sofort aktualisieren | Robinsch | ✅ | ✅ |
| [4](PATCHES.md#patch-worldcrash) | WorldFrame-Absturzfix (ungültige Dreiecks-Indizes) | Alyst3r (0x539wowmod) (fixed by St0ny) | – | ✅ |
|    | **Sicherheit & Datenschutz** |  |  |  |
| [5](PATCHES.md#patch-rce) | Remote Code Execution Exploit Fix | Robinsch | – | ✅ |
| [6](PATCHES.md#patch-wardenoff) | Warden komplett abschalten, RCE-Fix *(Kick-Gefahr bei aktivem Warden)* | Robinsch | – | – |
| [7](PATCHES.md#patch-scandll) | Scan.dll deaktivieren | Alastor StrixEfuartus | – | ✅ |
| [8](PATCHES.md#patch-noserverpatch) | Client-Patches vom Server verbieten | Kebabstorm | – | ✅ |
| [9](PATCHES.md#patch-nosurvey) | Hardware-Umfragen vom Server verbieten | Kebabstorm | – | ✅ |
|    | **Login & Verbindung** |  |  |  |
| [10](PATCHES.md#patch-skipbnet) | Battle.net-Login überspringen | Kebabstorm | – | ✅ |
| [11](PATCHES.md#patch-skiprdp) | Remote-Desktop-Prüfung überspringen | Kebabstorm | – | ✅ |
| [12](PATCHES.md#patch-nohttp) | HTTP-Anfragen an Battle.net deaktivieren | Kebabstorm | – | ✅ |
| [13](PATCHES.md#patch-afk) | Idle-Kick nach Character-Autologin verhindern *(wird für Character-Autologin benötigt; AFK- und Idle-Timer bleiben aktiv, [Discord](https://discord.com/channels/858041817043042364/1515439916878663701))* | St0ny | – | ✅ |
|    | **Modding: Interface, MPQs & Addons** |  |  |  |
| [14](PATCHES.md#patch-glue) | Custom Glue-XML erlauben | Alastor StrixEfuartus / Kebabstorm (fixed by St0ny) | ✅ | ✅ |
| [15](PATCHES.md#patch-mpqsig) | Falsch/Nicht signierte MPQs zulassen | Alastor StrixEfuartus | – | ✅ |
| [16](PATCHES.md#patch-mpqnames) | Erweiterte MPQ-Namen erlauben |  | ✅ | ✅ |
| [17](PATCHES.md#patch-localdata) | Daten direkt aus dem Data-Ordner laden (ohne MPQ) | Alastor StrixEfuartus | ✅ | ✅ |
| [18](PATCHES.md#patch-luaunlock) | LUA Unlock (Zauber, Bewegung, Makros) *(kann als Botting gewertet werden – Bann-Gefahr)* | Alastor StrixEfuartus | – | – |
| [19](PATCHES.md#patch-luaunlockfull) | LUA Unlock (vollständig): alle geschützten Funktionen freigeben *(kann als Botting gewertet werden – Bann-Gefahr)* | St0ny | – | – |
| [20](PATCHES.md#patch-keyprop) | Alle Tastatur-Ereignisse an Addons weiterreichen (OnKeyDown) | Alyst3r (0x539wowmod) | – | – |
| [21](PATCHES.md#patch-globalsv) | Addon-Daten aller Accounts zusammenlegen (SavedVariables) *(gemeinsamer Ordner `WTF\Account\global`)* | St0ny (original by boredatom) | – | – |
|    | **DLL-Loader** |  |  |  |
| [22](PATCHES.md#patch-awesome) | AwesomeWotlkLib.dll Unterstützung aktivieren *(benötigt [awesome_wotlk](https://github.com/noname08662/awesome_wotlk))* | FrostAtom | ✅ | ✅ |
| [23](PATCHES.md#patch-voicedll) | voice.dll beim Start laden (mod-voicechat) [ALPHA] *(Modul noch unfertig, [mod-voicechat](https://github.com/Raz0r1337/mod-voicechat))* | St0ny | – | – |
|    | **Gameplay-Fixes** |  |  |  |
| [24](PATCHES.md#patch-areatrigger) | Area-Trigger-Timer genauer (50 ms statt 100 ms) | Robinsch | ✅ | ✅ |
| [25](PATCHES.md#patch-swing) | Nahkampf-Schwung bei Rechtsklick entfernt | Robinsch | ✅ | ✅ |
| [26](PATCHES.md#patch-npcanim) | NPC-Angriffsanimation beim Drehen unterdrückt | Robinsch | ✅ | ✅ |
| [27](PATCHES.md#patch-spellanim) | Zauber-Animation nach Abbruch repariert | Robinsch | ✅ | ✅ |
| [28](PATCHES.md#patch-ghostattack) | „Geister“-Angriff von NPCs beim Evade behoben | Robinsch (fixed by St0ny) | ✅ | ✅ |
| [29](PATCHES.md#patch-naked) | Nackter-Charakter-Bug behoben | Robinsch (fixed by St0ny) | ✅ | ✅ |
| [30](PATCHES.md#patch-forcereaction) | Force-Reaction bei /reload erhalten | Robinsch | ✅ | ✅ |
| [31](PATCHES.md#patch-mail) | Neue Post ohne 60 Sekunden Wartezeit | Robinsch | ✅ | ✅ |
| [32](PATCHES.md#patch-deadchat) | Chat-Befehle auch im Tod erlauben | Robinsch | ✅ | ✅ |
| [33](PATCHES.md#patch-follow) | /follow auch bei NPCs erlauben | St0ny (original by Alastor StrixEfuartus) | – | ✅ |
| [34](PATCHES.md#patch-level101) | Level 101+ Fix (Spielwert-Tabellen, Barbierstuhl, Grundwerte) | Alastor StrixEfuartus (fixed by St0ny) | – | ✅ |
| [35](PATCHES.md#patch-raceclass) | Charaktererstellung: mehr als 10 Klassen (Zufallsklasse) *(für eigene Klassen; Server muss es unterstützen)* | Alastor StrixEfuartus / Robinsch | – | – |
| [36](PATCHES.md#patch-namecheck) | Namensprüfung bei der Charaktererstellung abschalten (z. B. Zahlen im Namen) *(Server muss die Namen ebenfalls erlauben)* | Alyst3r (0x539wowmod) (fixed by St0ny) | – | – |
| [37](PATCHES.md#patch-maxchars) | Max. Charaktere pro Server auf 255 erhöht | St0ny | ✅ | – |
| [38](PATCHES.md#patch-customitem) | Custom Item Fix (BETA) v2 *(Custom-Items ohne DBC-Anpassung: Modell, Icon und Item-Typ aus den Serverdaten)* | Kebabstorm (fixed by St0ny) | – | ✅ |
| [39](PATCHES.md#patch-climb) | Steigwinkel-Begrenzung aufheben (jeden Hang hochlaufen) *(kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alastor StrixEfuartus | – | – |
| [40](PATCHES.md#patch-jump) | Sprunghöhe ändern (Original -7.9555473) *(fragt den Wert ab, kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alastor StrixEfuartus | – | – |
| [41](PATCHES.md#patch-airforward) | Im Sprung vorwärts/rückwärts steuern *(kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alyst3r (0x539wowmod) (ported by St0ny) | – | ✅ |
| [42](PATCHES.md#patch-airlateral) | Im Sprung seitwärts steuern *(kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alyst3r (0x539wowmod) (ported by St0ny) | – | ✅ |
| [43](PATCHES.md#patch-airturn) | Im Sprung drehen ändert die Flugrichtung *(kann vom Server als Cheat erkannt werden – Bann-Gefahr)* | Alyst3r (0x539wowmod) (ported by St0ny) | – | ✅ |
| [44](PATCHES.md#patch-doublejump) | Doppelsprung (weitere Sprünge in der Luft) *(fragt den Wert ab, kann vom Server als Cheat erkannt werden, Exe wird größer – Bann-Gefahr)* | Alyst3r (0x539wowmod) (ported by St0ny) | – | ✅ |
|    | **Grafik & Sichtweite** |  |  |  |
| [45](PATCHES.md#patch-farclip) | CVar farclip unlock (max 10000) | Alastor StrixEfuartus | ✅ | ✅ |
| [46](PATCHES.md#patch-horizon) | CVar horizonFarclipScale unlock (max 12) | St0ny | ✅ | ✅ |
| [47](PATCHES.md#patch-envdetail) | CVar environmentDetail unlock (kein Limit statt 1.5) | St0ny | ✅ | ✅ |
| [48](PATCHES.md#patch-grounddist) | CVar groundEffectDist unlock (max 3166 statt 140) |  | ✅ | ✅ |
| [49](PATCHES.md#patch-sliders) | Grafikoptionen: Slider-Maxima erweitern | St0ny | – | ✅ |
| [50](PATCHES.md#patch-goscale) | GameObject Sichtweite: Cat 0 und Cat 4 auf environmentDetail reagieren lassen | St0ny | – | ✅ |
| [51](PATCHES.md#patch-cat0) | GameObject Sichtweite: Cat 0 von 30 auf 50 Yards *(kostet Leistung, mehr Kleinkram sichtbar)* | St0ny | – | ✅ |
| [52](PATCHES.md#patch-occluder) | Occluder Fix für Stormwind (Open Azeroth) | Robinsch | – | ✅ |
| [53](PATCHES.md#patch-bluemoon) | Blauer Mond am Nachthimmel reaktiviert | Robinsch | ✅ | ✅ |
| [54](PATCHES.md#patch-notransparency) | Keine Transparenz beim Heranzoomen | Alastor StrixEfuartus | ✅ | ✅ |
| [55](PATCHES.md#patch-nofade) | Kein Ausblenden für NPCs mit Flag DO_NOT_FADE_IN *(Server muss das Flag setzen)* | Alyst3r (0x539wowmod) (ported by St0ny) | – | – |
| [56](PATCHES.md#patch-hdportraits) | HD Unit-Frame Portraits: Renderauflösung 256 statt 64 Pixel *(Exe wird größer – Bann-Gefahr)* | St0ny (original by Badgermilk0) | – | ✅ |
|    | **Interface & Komfort** |  |  |  |
| [57](PATCHES.md#patch-tracker) | Quest-Tracker automatisch sortieren |  | – | ✅ |
| [58](PATCHES.md#patch-worldmap) | Erweiterte Weltkarte standardmäßig aktiv |  | – | ✅ |
| [59](PATCHES.md#patch-castbars) | Cast Bars auf allen Frames | Kebabstorm | ✅ | ✅ |
| [60](PATCHES.md#patch-emblems) | Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert *(benötigt [Patch-G](https://discord.com/channels/407664041016688662/1541873346608889936))* | MacWarrior | – | ✅ |
| [61](PATCHES.md#patch-flash) | FlashWindow Patch *(benötigt [FlashWindow-Addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash))* | Kebabstorm | ✅ | ✅ |
| [62](PATCHES.md#patch-charrandom) | Charaktererstellung: Aussehen nicht automatisch auswürfeln | Alyst3r (0x539wowmod) | – | – |
|    | **Fenster, Maus & Kamera** |  |  |  |
| [63](PATCHES.md#patch-window) | Fenstermodus als Standard setzen | St0ny | – | ✅ |
| [64](PATCHES.md#patch-maximize) | Fenstermodus maximiert als Standard setzen | St0ny | – | ✅ |
| [65](PATCHES.md#patch-windowfix) | Kein schwarzer Bildschirm beim Wechsel in den Fenstermodus | Robinsch | ✅ | ✅ |
| [66](PATCHES.md#patch-mouse) | Mausflackern / Kamerasprünge Fix | Robinsch | ✅ | ✅ |
| [67](PATCHES.md#patch-camera) | CameraReforged [BETA]: Kamerahöhe und Zoom-Grenzen *(Schulterversatz noch ohne Wirkung; Exe wird größer – Bann-Gefahr)* | Stormhand (fixed by St0ny) | – | – |
|    | **Sound** |  |  |  |
| [68](PATCHES.md#patch-sound) | Sound-Einstellungen optimieren *(benötigt [OpenAL](https://github.com/kcat/openal-soft), sonst wirken die Einstellungen nicht)* | St0ny | – | ✅ |
|    | **Client-Infos: Version, Build, Titel, Datum, Icon** |  |  |  |
| [69](PATCHES.md#patch-clientversion) | Client-Version ändern (Original 3.3.5) *(fragt den Wert ab)* | MacWarrior | – | – |
| [70](PATCHES.md#patch-clientbuild) | Build-Nummer ändern (Original 12340) *(fragt den Wert ab)* | MacWarrior | – | – |
| [71](PATCHES.md#patch-clienttitle) | Programmtitel in den Dateieigenschaften ändern *(fragt den Wert ab)* | MacWarrior (fixed by St0ny) | – | – |
| [72](PATCHES.md#patch-clientdate) | Build-Datum ändern (Original Jun 24 2010) *(fragt den Wert ab)* | St0ny (original by MacWarrior) | – | – |
| [73](PATCHES.md#patch-clienticon) | Programm-Icon ändern (Symbol der Wow.exe) *(fragt den Wert ab)* | St0ny (original by MacWarrior) | – | – |

</details>

> [!NOTE]
> **Urheber gesucht:** Bei Patches ohne Eintrag in der Spalte „Autor“ ist der
> Urheber noch nicht bekannt. Wenn du weißt, von wem einer dieser Patches
> stammt, schreib es bitte als [Issue](https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher/issues) – dann wird es nachgetragen.

---

## Patch-Beschreibungen

Die ausführlichen Beschreibungen aller Patches stehen in einer eigenen Datei:
**[PATCHES.md](PATCHES.md)**. In der [Patch-Übersicht](#patch-übersicht) führt
ein Klick auf die Nummer eines Patches direkt zu seiner Beschreibung.

---

## Hinweise

- **Bann-Gefahr:** Zwei Gruppen von Patches können auf vielen Servern zu einem
  Bann führen. Erstens Patches, die Server mit Anti-Cheat als Cheat oder Botting
  werten können: LUA Unlock (Nr. 18 und 19), Steigwinkel (39), Sprunghöhe
  (40), die Sprungsteuerung (41–43) und der Doppelsprung (44). Zweitens
  Patches, die eine Sektion an die `Wow.exe` anhängen und die Datei damit
  größer machen: Nr. 44, 56 und 67 – viele Server tolerieren eine veränderte Dateigröße nicht. Beide
  Gruppen sind in der Übersicht mit „Bann-Gefahr“ markiert, und der Patcher
  zeigt vor der Sicherheitsabfrage eine rote Warnung. Alle anderen Patches
  ändern die Dateigröße nicht.
- **Signatur:** Die originale `Wow.exe` ist von Blizzard digital signiert. Jeder
  Patch macht diese Signatur ungültig. Windows warnt deshalb wahrscheinlich
  beim Start vor einer nicht signierten, möglicherweise schädlichen App; mit
  „Weitere Informationen“ → „Trotzdem ausführen“ startet WoW ganz normal. Eine
  neue Signatur, der Windows vertraut, gibt es nur von Zertifizierungsstellen
  mit Identitätsprüfung – für eine veränderte Blizzard-Datei bekommt man sie
  nicht. Die Patches, die eine Sektion anhängen (Nr. 44, 56 und 67), entfernen
  zusätzlich den Verweis auf die Signatur im Header: Die neue Sektion liegt hinter der
  Signatur, und manche Werkzeuge würden die Datei sonst als beschädigt melden.
  Die Signatur-Bytes selbst bleiben unangetastet, die Rücknahme stellt das
  Original samt Signatur wieder her. Eine Download-Markierung („Diese Datei
  stammt von einem anderen Computer“) entfernt der Patcher unter Windows nach
  dem Schreiben von der `Wow.exe`, wie das Häkchen „Zulassen“ in den
  Dateieigenschaften.
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

## Danksagung

- Ein ganz besonderer Dank geht an **Billy Hoyle** – für all seine Hilfe und
  seine Tipps in den letzten Monaten und für die Unterstützung beim
  Zusammentragen der Patches. Sein Patch-Set steckt als Preset
  „Billy's_Wow.exe“ in diesem Patcher und ist die Standard-Auswahl.
- Beim Zusammentragen der Patches hat auch **MacWarrior** geholfen und dazu
  einige eigene Patches beigesteuert – vielen Dank auch dafür!
- Danke auch an **Stormhand** für die Erlaubnis, seinen CameraReforged-Patch
  einzubauen.
- Danke an **Moroes**, der den Patch [#21](PATCHES.md#patch-globalsv)
  aufgespürt und mir zugespielt hat.
- Und natürlich danke an alle Autoren der Patches, die in der
  [Patch-Übersicht](#patch-übersicht) genannt sind.

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).
Copyright (c) 2026 St0ny (Raz0r1337).

Kurz gesagt: Jeder darf den Patcher nutzen, verändern und weitergeben – auch in
eigenen Projekten –, solange der Copyright-Hinweis und der Lizenztext erhalten
bleiben (Namensnennung).
