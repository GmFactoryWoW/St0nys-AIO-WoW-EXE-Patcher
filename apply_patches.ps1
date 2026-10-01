# ============================================================
#  St0nys-AIO-WoW-EXE-Patcher - Patch Engine
#  Copyright (c) 2026 St0ny (Raz0r1337) - MIT-Lizenz, siehe LICENSE
#
#  Interaktiver Ablauf:
#    1. Sprache waehlen (Deutsch / English)
#    2. Pruefen: Wow.exe vorhanden und original (SHA256)
#    3. Patches auswaehlen (Menue mit Vorauswahl)
#    4. Bestaetigen, Backup Wow.exe.BAK anlegen, patchen
#
#  Die Auswahl aus dem Menue wird in patcher_selection.ini neben dem Skript
#  gespeichert und beim naechsten Start wieder vorausgewaehlt.
#
#  Optionale Parameter fuer den unbeaufsichtigten Betrieb:
#    -Language de|en          Sprachabfrage ueberspringen
#    -Select   <Auswahl>      Auswahlmenue ueberspringen. Erlaubt sind
#                             "saved" (gespeicherte Auswahl), "billy" (Preset
#                             Billy's_Wow.exe = Standard), "all" oder
#                             Nummern/Bereiche wie "1,3,5-8"
#    -Unattended              Keine Rueckfragen und keine Pausen. Ohne
#                             -Language die gemerkte Sprache bzw. Deutsch, ohne -Select die
#                             gespeicherte Auswahl bzw. das Preset Billy's_Wow.exe
#    -Path     <Datei>        Andere Wow.exe als die im Skriptordner
# ============================================================

param(
    [ValidateSet('de', 'en')][string]$Language,
    [string]$Select,
    [switch]$Unattended,
    [string]$Path
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $Path) {
    $Path = Join-Path $scriptDir 'Wow.exe'
} elseif (-not [System.IO.Path]::IsPathRooted($Path)) {
    # .NET loest relative Pfade gegen das Prozessverzeichnis auf, nicht gegen
    # das aktuelle PowerShell-Verzeichnis - daher selbst absolut machen.
    $Path = Join-Path (Get-Location).ProviderPath $Path
}

# -Unattended stellt keine Rueckfragen: ohne -Language Deutsch, ohne -Select
# die gespeicherte Auswahl (bzw. die Standard-Auswahl, wenn es keine gibt).
if ($Unattended) {
    if (-not $Select) { $Select = 'saved' }
}
$file = $Path
$backup = $file + '.BAK'
$settingsFile = Join-Path $scriptDir 'patcher_selection.ini'
$stateFile = Join-Path $scriptDir 'patcher_state.ini'

# SHA256 der originalen Wow.exe 3.3.5a (Build 12340)
$EXPECTED_HASH = 'AA63A5750D60EF16746C686B3D5E26876D98953EAB08B1C026CD0FAF78E88CB8'

# Datei-Inhalt, wird einmal gelesen, im Speicher gepatcht und einmal geschrieben
$f = $null

# Gepatchte Wow.exe aus einem frueheren Lauf? Dann die dort aktiven Patch-Ids.
$patchedMode = $false
$appliedIds = @()

# Jeder Schreibzugriff ins Original geht ueber Patch() und wird als
# Offset/Laenge-Paar mitgeschrieben. Daraus entsteht nach dem Patchen die
# Liste der Original-Bytes, mit der sich die Patches wieder zuruecknehmen
# lassen (siehe patcher_state.ini). Angehaengte Sektionen liegen hinter dem
# Ende des Originals und fallen beim Zuruecknehmen einfach weg.
$writes = New-Object System.Collections.Generic.List[int64]

function Patch([int64]$offset, [byte[]]$bytes) {
    [System.Array]::Copy($bytes, 0, $script:f, $offset, $bytes.Length)
    $script:writes.Add($offset)
    $script:writes.Add($bytes.Length)
}

# ============================================================
#  Texte (Deutsch / English)
# ============================================================
$TEXT = @{
    de = @{
        Welcome1      = 'Willkommen. Dieses Tool patcht deine Wow.exe mit'
        Welcome2      = 'Verbesserungen: Bugfixes, Performance-Optimierungen,'
        Welcome3      = 'erweiterte Sichtweiten und verbesserte Sound-Einstellungen.'
        Welcome4      = 'Beim ersten Patchen wird ein Backup als Wow.exe.BAK erstellt.'
        Welcome5      = 'Eingespielte Patches lassen sich spaeter wieder abwaehlen - bis zurueck zum Original.'
        Thanks        = 'Danke an Billy Hoyle und MacWarrior fuer ihre Hilfe!'
        PressStart    = 'ENTER druecken um zu starten'
        NotFound      = '[FEHLER] Keine Wow.exe gefunden: {0}'
        Checking      = 'Pruefe Wow.exe Integritaet...'
        HashBad1      = '[FEHLER] Die Wow.exe ist nicht die originale Datei.'
        HashBad2      = '         Sie wurde bereits gepatcht (anderes Tool, alte Patcher-Version) oder ist eine andere Version.'
        HashBad3      = 'Beim ersten Start wird eine unmodifizierte Wow.exe benoetigt.'
        HashBadState1 = '[FEHLER] Die Wow.exe ist weder das Original noch die zuletzt von diesem Patcher erzeugte Datei.'
        HashBadState2 = '         Sie wurde seitdem veraendert (anderes Tool, Client-Update o.ae.).'
        HashBadState3 = 'Bitte die zuletzt gepatchte oder eine unmodifizierte Wow.exe verwenden.'
        Expected      = 'Original:  {0}'
        ExpectedLast  = 'Zuletzt:   {0}'
        Found         = 'Gefunden:  {0}'
        BakHint       = 'Tipp: {0} ist die originale Wow.exe. Zurueck nach Wow.exe kopieren und den Patcher neu starten.'
        HashOk        = '[OK] Wow.exe ist original und unmodifiziert.'
        HashKnown     = '[OK] Wow.exe ist die zuletzt von diesem Patcher erzeugte Datei ({0} Patches aktiv).'
        RevertOk      = '[OK] Original aus patcher_state.ini rekonstruiert und per SHA256 geprueft.'
        StateBroken1  = '[FEHLER] patcher_state.ini passt zur Wow.exe, das Original laesst sich daraus aber nicht'
        StateBroken2  = '         wiederherstellen (Datei beschaedigt oder von Hand geaendert?).'
        MenuTitle     = 'PATCH-AUSWAHL  ({0} von {1} ausgewaehlt)'
        MenuHelp1     = 'Nummer(n) eingeben um Patches an-/abzuwaehlen, z.B.:  5   oder  3 7 12   oder  10-15'
        MenuHelp2     = 'A = alle an    N = alle aus    B = Preset Billy''s_Wow.exe    L = English    Q = abbrechen'
        LangInfo      = 'Sprache: Deutsch (gemerkt, im Menue mit L umschaltbar)'
        MenuHelp3     = 'ENTER = Auswahl uebernehmen, speichern und weiter'
        SavedLoaded   = 'Deine gespeicherte Auswahl vom letzten Mal wurde geladen.'
        AppliedLoaded = 'Ausgewaehlt sind die Patches, die gerade in der Wow.exe stecken. Abwaehlen nimmt einen Patch zurueck.'
        MarkNew       = '(neu)'
        MarkRemove    = '(wird zurueckgenommen)'
        ValueSuggest  = '-> Vorschlag: {0}'
        ValueNow      = '-> aktuell: {0}'
        Saved         = 'Auswahl fuer den naechsten Start gespeichert.'
        SaveFail      = 'HINWEIS: Auswahl konnte nicht gespeichert werden: {0}'
        Prompt        = 'Eingabe'
        BadInput      = 'Ungueltige Eingabe: {0}'
        NoneSelected  = 'Es ist kein Patch ausgewaehlt.'
        BadSelect     = '[FEHLER] Ungueltiger Wert fuer -Select: {0}'
        Summary       = 'Folgende {0} Patches werden eingespielt:'
        SumAdd        = 'Neu einspielen ({0}):'
        SumChange     = 'Wert aendern ({0}):'
        SumRemove     = 'Zuruecknehmen ({0}):'
        SumKeep       = 'Bleiben unveraendert aktiv: {0}'
        SumOriginal   = 'Danach ist die Wow.exe wieder die originale Datei.'
        NoChange      = 'Keine Aenderung gegenueber der aktuellen Wow.exe - es gibt nichts zu tun.'
        AlreadyOrig   = 'Die Wow.exe ist bereits original - es gibt nichts zurueckzunehmen.'
        InputHead     = 'Werte fuer die gewaehlten Patches (ENTER = Vorschlag in Klammern):'
        BadValue      = '[FEHLER] Ungueltiger gemerkter Wert fuer "{0}": {1}'
        HintHead      = 'HINWEIS zu "{0}":'
        Hint          = 'wirkt nur vollstaendig zusammen mit:'
        Obsolete      = 'macht diese Patches ueberfluessig (beide zusammen schaden nicht):'
        Conflict      = 'nutzt dieselbe Code-Hoehle wie diese Patches und weicht darum auf eine eigene Sektion am Dateiende aus (die Wow.exe wird dadurch etwas groesser):'
        ConflictBan   = 'Zusammen funktionieren sie, aber viele Server tolerieren eine veraenderte Groesse der Wow.exe nicht - das kann zu einem Bann fuehren!'
        GrowHead      = 'HINWEIS: Diese Patches haengen eine Sektion an und machen die Wow.exe groesser:'
        GrowBan       = 'Viele Server tolerieren eine veraenderte Groesse der Wow.exe nicht - das kann zu einem Bann fuehren!'
        Confirm       = 'Patchen jetzt starten? (J/N)'
        Yes           = 'J'
        Aborted       = 'Abgebrochen. Die Wow.exe wurde nicht veraendert.'
        BackupFail    = '[FEHLER] Konnte Wow.exe nicht sichern. Abbruch.'
        BackupOk      = 'Backup der Wow.exe erfolgreich erstellt: {0}'
        BackupSkip    = 'Kein neues Backup: Die Wow.exe ist bereits gepatcht, die Original-Bytes stehen in patcher_state.ini.'
        Starting      = 'Starte Patch-Vorgang...'
        PatchFail     = '[FEHLER] Beim Patchen ist ein Fehler aufgetreten:'
        NotWritten    = 'Die Wow.exe wurde nicht veraendert.'
        WriteFail     = '[FEHLER] Konnte die Wow.exe nicht schreiben (laeuft WoW noch?):'
        UndoFail      = '[FEHLER] Selbsttest fehlgeschlagen: Die Patches liessen sich nicht sauber zuruecknehmen.'
        StateFail     = '[FEHLER] Konnte patcher_state.ini nicht schreiben:'
        StateWarn1    = 'WARNUNG: Die Wow.exe ist gepatcht, patcher_state.ini konnte aber nicht gespeichert werden:'
        StateWarn2    = 'Ohne diese Datei lassen sich die Patches nicht mehr zuruecknehmen - dafuer Wow.exe.BAK verwenden.'
        Done1         = '[FERTIG] Wow.exe wurde erfolgreich gepatcht.'
        Done2         = 'Gesamt: {0} Patches eingespielt.'
        Done3         = 'Neu: {0}   Geaendert: {1}   Zurueckgenommen: {2}   Aktiv: {3}'
        DoneOrig      = '[FERTIG] Alle Patches zurueckgenommen, die Wow.exe ist wieder original.'
        StateSaved    = 'Zustand in patcher_state.ini gemerkt - beim naechsten Start kannst du Patches dazu- oder abwaehlen.'
        PressEnter    = 'ENTER druecken zum Beenden'
    }
    en = @{
        Welcome1      = 'Welcome. This tool patches your Wow.exe with'
        Welcome2      = 'improvements: bug fixes, performance optimizations,'
        Welcome3      = 'extended view distances and improved sound settings.'
        Welcome4      = 'The first patch run creates a backup as Wow.exe.BAK.'
        Welcome5      = 'Applied patches can be deselected later - all the way back to the original.'
        Thanks        = 'Thanks to Billy Hoyle and MacWarrior for their help!'
        PressStart    = 'Press ENTER to start'
        NotFound      = '[ERROR] No Wow.exe found: {0}'
        Checking      = 'Checking Wow.exe integrity...'
        HashBad1      = '[ERROR] This Wow.exe is not the original file.'
        HashBad2      = '        It has already been patched (another tool, old patcher version) or is a different version.'
        HashBad3      = 'The first run requires an unmodified Wow.exe.'
        HashBadState1 = '[ERROR] This Wow.exe is neither the original nor the file last produced by this patcher.'
        HashBadState2 = '        It has been changed since (another tool, client update or similar).'
        HashBadState3 = 'Please use the last patched or an unmodified Wow.exe.'
        Expected      = 'Original:  {0}'
        ExpectedLast  = 'Last run:  {0}'
        Found         = 'Found:     {0}'
        BakHint       = 'Tip: {0} is the original Wow.exe. Copy it back to Wow.exe and start the patcher again.'
        HashOk        = '[OK] Wow.exe is original and unmodified.'
        HashKnown     = '[OK] Wow.exe is the file last produced by this patcher ({0} patches active).'
        RevertOk      = '[OK] Original reconstructed from patcher_state.ini and verified by SHA256.'
        StateBroken1  = '[ERROR] patcher_state.ini matches Wow.exe, but the original cannot be restored from it'
        StateBroken2  = '        (file damaged or edited by hand?).'
        MenuTitle     = 'PATCH SELECTION  ({0} of {1} selected)'
        MenuHelp1     = 'Enter number(s) to toggle patches, e.g.:  5   or  3 7 12   or  10-15'
        MenuHelp2     = 'A = all on    N = all off    B = preset Billy''s_Wow.exe    L = Deutsch    Q = quit'
        LangInfo      = 'Language: English (remembered, switch with L in the menu)'
        MenuHelp3     = 'ENTER = accept and save selection, continue'
        SavedLoaded   = 'Your saved selection from last time has been loaded.'
        AppliedLoaded = 'Selected are the patches currently in Wow.exe. Deselecting a patch removes it.'
        MarkNew       = '(new)'
        MarkRemove    = '(will be removed)'
        ValueSuggest  = '-> suggestion: {0}'
        ValueNow      = '-> current: {0}'
        Saved         = 'Selection saved for next time.'
        SaveFail      = 'NOTE: Could not save the selection: {0}'
        Prompt        = 'Input'
        BadInput      = 'Invalid input: {0}'
        NoneSelected  = 'No patch is selected.'
        BadSelect     = '[ERROR] Invalid value for -Select: {0}'
        Summary       = 'The following {0} patches will be applied:'
        SumAdd        = 'Apply ({0}):'
        SumChange     = 'Change value ({0}):'
        SumRemove     = 'Remove ({0}):'
        SumKeep       = 'Stay active unchanged: {0}'
        SumOriginal   = 'Afterwards Wow.exe is the original file again.'
        NoChange      = 'No change compared to the current Wow.exe - nothing to do.'
        AlreadyOrig   = 'Wow.exe is already original - nothing to remove.'
        InputHead     = 'Values for the selected patches (ENTER = suggestion in brackets):'
        BadValue      = '[ERROR] Invalid saved value for "{0}": {1}'
        HintHead      = 'NOTE on "{0}":'
        Hint          = 'only takes full effect together with:'
        Obsolete      = 'makes these patches unnecessary (both together do no harm):'
        Conflict      = 'uses the same code cave as these patches and therefore moves to a section of its own at the end of the file (Wow.exe becomes slightly larger):'
        ConflictBan   = 'They work together, but many servers do not tolerate a changed size of Wow.exe - this can lead to a ban!'
        GrowHead      = 'NOTE: These patches append a section and make Wow.exe larger:'
        GrowBan       = 'Many servers do not tolerate a changed size of Wow.exe - this can lead to a ban!'
        Confirm       = 'Start patching now? (Y/N)'
        Yes           = 'Y'
        Aborted       = 'Aborted. Wow.exe has not been modified.'
        BackupFail    = '[ERROR] Could not back up Wow.exe. Aborting.'
        BackupOk      = 'Backup of Wow.exe created successfully: {0}'
        BackupSkip    = 'No new backup: Wow.exe is already patched, the original bytes are stored in patcher_state.ini.'
        Starting      = 'Starting patch process...'
        PatchFail     = '[ERROR] An error occurred while patching:'
        NotWritten    = 'Wow.exe has not been modified.'
        WriteFail     = '[ERROR] Could not write Wow.exe (is WoW still running?):'
        UndoFail      = '[ERROR] Self-test failed: the patches could not be removed cleanly.'
        StateFail     = '[ERROR] Could not write patcher_state.ini:'
        StateWarn1    = 'WARNING: Wow.exe is patched, but patcher_state.ini could not be saved:'
        StateWarn2    = 'Without this file the patches cannot be removed anymore - use Wow.exe.BAK for that.'
        Done1         = '[DONE] Wow.exe has been patched successfully.'
        Done2         = 'Total: {0} patches applied.'
        Done3         = 'New: {0}   Changed: {1}   Removed: {2}   Active: {3}'
        DoneOrig      = '[DONE] All patches removed, Wow.exe is original again.'
        StateSaved    = 'State remembered in patcher_state.ini - next time you can add or deselect patches.'
        PressEnter    = 'Press ENTER to exit'
    }
}

function T([string]$key) {
    $s = $TEXT[$script:lang][$key]
    if ($args.Count -gt 0) { $s = $s -f $args }
    return $s
}

function Say([string]$text, [string]$color) {
    if ($color) { Write-Host "  $text" -ForegroundColor $color } else { Write-Host "  $text" }
}

function PatchName($p) {
    if ($script:lang -eq 'en') { $n = $p.En; $note = $p.NoteEn } else { $n = $p.De; $note = $p.NoteDe }
    if ($note) { $n = "$n ($note)" }
    return $n
}

# Eingabe lesen. Read-Host liefert bei Strg+Z bzw. geschlossener Eingabe $null -
# dann gibt es keine Antwort mehr, also abbrechen (Exit-Code 2, nichts geaendert).
function Ask([string]$prompt) {
    $r = Read-Host $prompt
    if ($null -eq $r) {
        Write-Host ''
        exit 2
    }
    return ([string]$r).Trim()
}

function Exit-Patcher([int]$code) {
    if (-not $Unattended) {
        Write-Host ''
        [void](Read-Host "  $(T 'PressEnter')")
    }
    exit $code
}

# ============================================================
#  Helfer fuer den HD-Portrait-Patch
#  Haengt eine neue PE-Sektion ".hdp" an die EXE an (256x256-Alphamaske
#  + Code-Caves + Detour des Masken-Builders). Originalgetreuer Port von
#  apply_hd_portraits.py, byte-fuer-byte gegen dessen Ausgabe verifiziert.
#  Wie CameraReforged veraendert dieser Patch die Dateigroesse/PE-Struktur.
# ============================================================
function RU32([byte[]]$a, [int]$o) { return [int64][BitConverter]::ToUInt32($a, $o) }
function RU16([byte[]]$a, [int]$o) { return [int][BitConverter]::ToUInt16($a, $o) }
function AlignUp([int64]$v, [int64]$a) { $r = $v % $a; if ($r -eq 0) { return $v } else { return ($v + $a - $r) } }
function AddRaw($list, [byte[]]$bytes) { foreach ($b in $bytes) { [void]$list.Add([byte]$b) } }
function AddLE32($list, [int64]$v) { $b = [BitConverter]::GetBytes([int32]$v); for ($i = 0; $i -lt 4; $i++) { [void]$list.Add($b[$i]) } }

function New-PortraitMask([int]$N) {
    # Row-major NxN, 1 Byte/Pixel: kreisfoermige Alpha, 255 innen (1px Feather), 0 aussen.
    $R = $N / 2.0 - 1.0
    $c = ($N - 1) / 2.0
    $m = New-Object byte[] ($N * $N)
    for ($y = 0; $y -lt $N; $y++) {
        $row = $y * $N
        $dy = [double]$y - $c
        for ($x = 0; $x -lt $N; $x++) {
            $dx = [double]$x - $c
            $d = [Math]::Sqrt($dx * $dx + $dy * $dy)
            $a = [Math]::Round(($R - $d + 0.5) * 255.0, [System.MidpointRounding]::ToEven)
            if ($a -lt 0) { $a = 0 } elseif ($a -gt 255) { $a = 255 }
            $m[$row + $x] = [byte]$a
        }
    }
    return , $m
}

function Add-HdPortraits([int]$SIZE) {
    # --- Engine-Adressen (VA, build 12340) ---
    $TEX_LOW = 0x4B8C80; $TEX_WRP = 0x4B9200; $MASKFN = 0x6176A0; $MASKFN_CONT = 0x6176A9
    $S_RT = 0x6180E8; $S_TEX = 0x619B72; $S_READ = 0x616E09; $S_MASK = 0x619FAE
    $IB = 0x400000

    # --- PE-Header / Sektionstabelle lesen ---
    $e = RU32 $script:f 0x3C
    $nsec = RU16 $script:f ($e + 6)
    $opt = RU16 $script:f ($e + 20)
    $SA = RU32 $script:f ($e + 24 + 32)
    $FA = RU32 $script:f ($e + 24 + 36)
    $sectBase = $e + 24 + $opt
    $TVA = 0; $TRO = 0
    for ($i = 0; $i -lt $nsec; $i++) {
        $so = $sectBase + 40 * $i
        $nm = ''
        for ($k = 0; $k -lt 8; $k++) { $bb = $script:f[$so + $k]; if ($bb -ne 0) { $nm += [char]$bb } }
        if ($nm -eq '.text') { $TVA = $IB + (RU32 $script:f ($so + 12)); $TRO = RU32 $script:f ($so + 20) }
    }
    $lastSo = $sectBase + 40 * ($nsec - 1)
    $lastVA = RU32 $script:f ($lastSo + 12)
    $lastVS = RU32 $script:f ($lastSo + 8)
    $new_rva = AlignUp ($lastVA + $lastVS) $SA
    $new_sva = $IB + $new_rva

    # --- Maske + Adressen der Caves ---
    $MASK_OFF = 0x10
    $maskCore = New-PortraitMask $SIZE
    $maskLen = $maskCore.Length + 0x1000          # + Ueberlese-Sicherheitspuffer
    $CODE_OFF = AlignUp ($MASK_OFF + $maskLen) 16
    $mask_va = $new_sva + $MASK_OFF
    $slot_va = $new_sva
    $cA = $new_sva + $CODE_OFF
    $cB = $cA + 21
    $det_va = $cB + 21

    # --- Code-Caves zusammenbauen ---
    $code = New-Object System.Collections.Generic.List[byte]
    # caveA: mov [esp+08],SIZE ; mov [esp+0C],SIZE ; jmp TEX_LOW
    AddRaw $code @(0xC7, 0x44, 0x24, 0x08); AddLE32 $code $SIZE
    AddRaw $code @(0xC7, 0x44, 0x24, 0x0C); AddLE32 $code $SIZE
    AddRaw $code @(0xE9);                   AddLE32 $code ($TEX_LOW - ($cA + 16 + 5))
    # caveB: mov [esp+04],SIZE ; mov [esp+08],SIZE ; jmp TEX_WRP
    AddRaw $code @(0xC7, 0x44, 0x24, 0x04); AddLE32 $code $SIZE
    AddRaw $code @(0xC7, 0x44, 0x24, 0x08); AddLE32 $code $SIZE
    AddRaw $code @(0xE9);                   AddLE32 $code ($TEX_WRP - ($cB + 16 + 5))
    # detour: cmp eax,SIZE ; jne +6 ; mov eax,slot ; ret ; <verschobene Prologue> ; jmp MASKFN_CONT
    AddRaw $code @(0x3D);                   AddLE32 $code $SIZE
    AddRaw $code @(0x75, 0x06)
    AddRaw $code @(0xB8);                   AddLE32 $code $slot_va
    AddRaw $code @(0xC3)
    AddRaw $code @(0x55, 0x8B, 0xEC, 0x81, 0xEC, 0x04, 0x05, 0x00, 0x00)
    AddRaw $code @(0xE9);                   AddLE32 $code ($MASKFN_CONT - ($det_va + 22 + 5))
    $codeArr = $code.ToArray()

    $vsize = $MASK_OFF + $maskLen + $codeArr.Length
    $raw_size = AlignUp ($CODE_OFF + $codeArr.Length) $FA

    # --- Sektions-Rohdaten: [slot][maske][pad][code][pad] ---
    $sec = New-Object byte[] $raw_size
    [Array]::Copy([BitConverter]::GetBytes([int32]0), 0, $sec, 0, 4)                 # slot.flags = 0
    [Array]::Copy([BitConverter]::GetBytes([int32]($SIZE * $SIZE)), 0, $sec, 4, 4)   # slot.count = N*N
    [Array]::Copy([BitConverter]::GetBytes([int32]$mask_va), 0, $sec, 8, 4)          # slot.ptr   = &maske
    [Array]::Copy($maskCore, 0, $sec, $MASK_OFF, $maskCore.Length)
    [Array]::Copy($codeArr, 0, $sec, $CODE_OFF, $codeArr.Length)

    # --- Datei vergroessern: padding bis FileAlignment, dann Sektion anhaengen ---
    $oldLen = $script:f.Length
    $new_raw = AlignUp $oldLen $FA
    $nf = New-Object byte[] ($new_raw + $raw_size)
    [Array]::Copy($script:f, 0, $nf, 0, $oldLen)
    [Array]::Copy($sec, 0, $nf, $new_raw, $sec.Length)
    $script:f = $nf

    # --- PE-Header anpassen (NumberOfSections, SizeOfImage, neuer Sektionsheader) ---
    Patch ($e + 6) ([BitConverter]::GetBytes([uint16]($nsec + 1)))
    Patch ($e + 24 + 56) ([BitConverter]::GetBytes([uint32](AlignUp ($new_rva + $vsize) $SA)))
    $hoff = $sectBase + 40 * $nsec
    $sh = New-Object byte[] 40
    [Array]::Copy([System.Text.Encoding]::ASCII.GetBytes('.hdp'), 0, $sh, 0, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$vsize), 0, $sh, 8, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$new_rva), 0, $sh, 12, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$raw_size), 0, $sh, 16, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$new_raw), 0, $sh, 20, 4)
    [Array]::Copy([byte[]](0x60, 0x00, 0x00, 0xE0), 0, $sh, 36, 4)                    # chars = 0xE0000060 (RWX | init data)
    Patch $hoff $sh

    # --- In-Place-Edits: Aufruf-Sites auf die Caves umbiegen, Groessen auf SIZE ---
    $toRT = $TRO + ($S_RT - $TVA); $toTEX = $TRO + ($S_TEX - $TVA)
    $toRD = $TRO + ($S_READ - $TVA); $toMK = $TRO + ($S_MASK - $TVA); $toMF = $TRO + ($MASKFN - $TVA)
    Patch ($toRT + 1) ([BitConverter]::GetBytes([int32]($cA - ($S_RT + 5))))
    Patch ($toTEX + 1) ([BitConverter]::GetBytes([int32]($cB - ($S_TEX + 5))))
    Patch ($toRD + 1) ([BitConverter]::GetBytes([int32]$SIZE))
    Patch ($toMK + 1) ([BitConverter]::GetBytes([int32]$SIZE))
    $hook = New-Object byte[] 9
    $hook[0] = 0xE9
    [Array]::Copy([BitConverter]::GetBytes([int32]($det_va - ($MASKFN + 5))), 0, $hook, 1, 4)
    $hook[5] = 0x90; $hook[6] = 0x90; $hook[7] = 0x90; $hook[8] = 0x90
    Patch $toMF $hook
}

# ============================================================
#  Helfer fuer den CameraReforged-Patch
#  Portierung von CameraReforged (Stormhand) in die Patch-Engine dieses Tools,
#  eingebaut mit seiner ausdruecklichen Erlaubnis.
#  Quelle: https://github.com/Zendevve/CameraReforged
#  BETA: funktioniert noch nicht zu 100 Prozent.
#
#  Haengt eine eigene Sektion ".camr" an (RWX, etwa +1 KB), registriert darin
#  beim Start test_cameraHeight und test_cameraOverShoulder als echte CVars
#  und biegt die Kamera-Lesestellen darauf um. Anders als alle uebrigen Patches
#  ausser Add-HdPortraits veraendert dieser die Dateigroesse und die
#  PE-Struktur. Beide vertragen sich: die Sektionsdaten werden bei jedem Aufruf
#  frisch aus dem aktuellen Header berechnet, die Reihenfolge spielt keine Rolle.
#
#  ZWEI ABWEICHUNGEN VON DER VORLAGE, BEIDE NOTWENDIG
#
#  1. EIGENE SEKTION STATT .rdata-PADDING
#  Der Original-Patcher legt Code und Daten ins ungenutzte Padding am Ende der
#  .rdata-Sektion und hebt diese dafuer im PE-Header auf ausfuehrbar. Genau das
#  laesst diesen Client beim Start mit dem MSVC-Runtimefehler R6002
#  ("floating point support not loaded") abbrechen - nachgewiesen mit einem
#  Build, der NUR dieses eine Byte aenderte und sonst nichts. Umgekehrt liefen
#  Builds, die die Cave-Bytes ins Padding schrieben ohne die Sektion
#  umzuflaggen, einwandfrei. Das Padding traegt also Daten, laesst sich aber
#  nicht ausfuehrbar machen. Eine angehaengte Sektion umgeht das vollstaendig
#  und ist auch der Fallback, den die Vorlage selbst vorsieht.
#
#  2. ZEIGER STATT CALLBACK
#  Die Vorlage haengt an jedes CVar einen Callback, der den geparsten float aus
#  dem CVar-Objekt (+0x2C) in den Datenblock kopieren soll. Das kann nicht
#  funktionieren: der Callback bei VA 0x7668EC ist ein PRUEF-Callback und laeuft,
#  BEVOR der neue Wert gespeichert wird - er sieht also immer noch den alten.
#  Bei der Anlage steht dort ausserdem eine glatte 0 (fldz/fstp bei 0x76812B),
#  der eingebackene Startwert wird beim Start also sofort ueberschrieben. In der
#  Praxis hinkt der Wert damit jeder Aenderung um einen Schritt hinterher, was
#  sich wie eine willkuerlich reagierende Kamera anfuehlt.
#  Hier merkt sich der Init-Hook stattdessen den Zeiger auf das CVar-Objekt, den
#  CVars_Register in eax zurueckgibt, und der Kamera-Hook liest den float bei
#  jedem Bild frisch von dort. Damit wirkt /console sofort und exakt.
# ============================================================
function Add-CameraReforged([double]$Height, [double]$Shoulder, [double]$MaxFactor, [double]$ZoomSpeed) {

    # Grenzen wie in der Vorlage. Sie sichern nebenbei ab, dass die als Text
    # abgelegten Vorgabewerte in ihre Slots passen (siehe Feldlage unten).
    if ($Height    -lt  0.0 -or $Height    -gt   3.0) { throw 'CameraReforged: Height muss zwischen 0.0 und 3.0 liegen.' }
    if ($Shoulder  -lt -2.0 -or $Shoulder  -gt   2.0) { throw 'CameraReforged: Shoulder muss zwischen -2.0 und 2.0 liegen.' }
    if ($MaxFactor -lt  1.0 -or $MaxFactor -gt   5.0) { throw 'CameraReforged: MaxFactor muss zwischen 1.0 und 5.0 liegen.' }
    if ($ZoomSpeed -lt  1.0 -or $ZoomSpeed -gt 100.0) { throw 'CameraReforged: ZoomSpeed muss zwischen 1.0 und 100.0 liegen.' }

    # --- Engine-Adressen (VA, build 12340) ---
    $REGISTER    = 0x767FC0   # CVars_Register(name, desc, flags, default, callback, 0,0,0,0) - cdecl, 9 Argumente
    $INIT_VA     = 0x51D9B0   # CVars_Initialize, Prolog (push ebp / mov ebp,esp / sub esp,80h)
    $INIT_CONT   = 0x51D9B9   # dahinter, dort steht schon die erste eigene Registrierung
    $HEIGHT_VA   = 0x6070CB   # fld [0x9F1670] im Kamera-Fokuspfad
    $HEIGHT_CONT = 0x6070D1   # dahinter
    $IB          = 0x400000

    # --- Platz fuer die neue Sektion hinter der letzten vorhandenen suchen ---
    $e = RU32 $script:f 0x3C
    $nsec = RU16 $script:f ($e + 6)
    $opt = RU16 $script:f ($e + 20)
    $SA = RU32 $script:f ($e + 24 + 32)
    $FA = RU32 $script:f ($e + 24 + 36)
    $sectBase = $e + 24 + $opt
    $lastSo = $sectBase + 40 * ($nsec - 1)
    $new_rva = AlignUp ((RU32 $script:f ($lastSo + 12)) + (RU32 $script:f ($lastSo + 8))) $SA
    $new_sva = $IB + $new_rva

    $SEC_SIZE = 0x200         # 512 Byte: Code ab +0, Daten ab +0x100
    $CODE_VA  = $new_sva
    $DATA_VA  = $new_sva + 0x100

    # --- Feldlage im Datenblock (Byte-Offsets ab $DATA_VA) ---
    #   0x00 dword    Zeiger auf das CVar-Objekt test_cameraHeight
    #   0x04 dword    Zeiger auf das CVar-Objekt test_cameraOverShoulder
    #   0x08 float    Schulterversatz, vom Kamera-Hook je Bild aufgefrischt
    #   0x0C char[8]  Vorgabetext cameraDistanceMaxFactor
    #   0x14 char[8]  Vorgabetext cameraDistanceMoveSpeed
    #   0x20 char[18] "test_cameraHeight"
    #   0x32 char[5]  Vorgabetext Hoehe      -> max. 4 Zeichen, daher Height <= 3.0
    #   0x37 char[24] "test_cameraOverShoulder"
    #   0x4F char[9]  Vorgabetext Schulter   -> "-2.00" passt
    $P_HEIGHT = 0x00; $P_SHOULDER = 0x04; $O_SHOULDER = 0x08
    $O_MAXF = 0x0C; $O_ZOOM = 0x14
    $O_HNAME = 0x20; $O_HDEF = 0x32; $O_SNAME = 0x37; $O_SDEF = 0x4F

    $c = New-Object System.Collections.Generic.List[byte]

    # --- cvar_init_hook ---
    # Haengt sich vor CVars_Initialize, meldet beide CVars an und legt die
    # zurueckgegebenen Objektzeiger im Datenblock ab. Der Zeitpunkt ist
    # unkritisch - CVars_Initialize registriert direkt hinter dem Prolog selbst
    # ihr erstes CVar ueber genau diese Funktion, die Registry steht also.
    $initHook = $CODE_VA + $c.Count
    AddRaw $c @(0x60)                                                 # pushad
    $regs = @( ,@($O_HNAME, $O_HDEF, $P_HEIGHT) ) + @( ,@($O_SNAME, $O_SDEF, $P_SHOULDER) )
    foreach ($r in $regs) {
        AddRaw $c @(0x6A, 0x00, 0x6A, 0x00, 0x6A, 0x00, 0x6A, 0x00)   # push 0 x4 (Argumente 6 bis 9)
        AddRaw $c @(0x6A, 0x00)                                       # push callback = 0, siehe Kopf
        AddRaw $c @(0x68); AddLE32 $c ($DATA_VA + $r[1])              # push default (Text)
        AddRaw $c @(0x6A, 0x10, 0x6A, 0x00)                           # push flags=0x10 ; push desc=0
        #  ^^^^ Die Flags landen im CVar-Objekt bei +0x1C, Bits 4 und 5 bilden
        #  darin eine Kategorie. Der Client schreibt beim Beenden nur die
        #  Kategorien 0x10 und 0x20 in die Config.wtf, Blizzards eigene CVars
        #  werden mit 0x10 registriert. Mit der 1 der Vorlage waere die Kategorie
        #  0 und der Wert nach jedem Neustart wieder auf dem Startwert.
        AddRaw $c @(0x68); AddLE32 $c ($DATA_VA + $r[0])              # push name
        $site = $CODE_VA + $c.Count
        AddRaw $c @(0xE8); AddLE32 $c ($REGISTER - ($site + 5))       # call CVars_Register -> eax = CVar*
        AddRaw $c @(0x83, 0xC4, 0x24)                                 # add esp,24h (9 Argumente, cdecl)
        AddRaw $c @(0xA3); AddLE32 $c ($DATA_VA + $r[2])              # mov [zeiger], eax
    }
    AddRaw $c @(0x61)                                                 # popad
    AddRaw $c @(0xDB, 0xE3)                                           # fninit - popad rettet die FPU nicht,
                                                                      # und am Funktionseingang ist der
                                                                      # x87-Stack per Konvention leer
    AddRaw $c @(0x55, 0x8B, 0xEC, 0x81, 0xEC, 0x80, 0x00, 0x00, 0x00) # verschobener Prolog
    $site = $CODE_VA + $c.Count
    AddRaw $c @(0xE9); AddLE32 $c ($INIT_CONT - ($site + 5))

    # --- camera_height_hook ---
    # Sitzt im Kamera-Fokuspfad. [ebp-2Ch] ist dort die Z-Koordinate des Punkts,
    # auf den die Kamera zielt (der Vektor beginnt bei [ebp-34h], gefuellt von
    # call 0x603090 kurz davor). Der Client legt ihn auf Brusthoehe.
    #
    # Zuerst wird der Schulterversatz aufgefrischt: die vier Lesestellen weiter
    # unten koennen nur ein festes "fld [adresse]" aufnehmen (6 Byte), fuer eine
    # Zeiger-Dereferenzierung ist dort kein Platz. Also holt der Hook den Wert
    # hier je Bild aus dem CVar-Objekt und legt ihn an der festen Adresse ab.
    # Danach kommt die Hoehe auf [ebp-2Ch]. Beide Zugriffe sind gegen einen
    # Nullzeiger abgesichert, falls eine Registrierung fehlschlagen sollte.
    $heightHook = $CODE_VA + $c.Count
    AddRaw $c @(0xA1); AddLE32 $c ($DATA_VA + $P_SHOULDER)            # mov eax,[zeiger schulter]
    AddRaw $c @(0x85, 0xC0, 0x74, 0x09)                               # test eax,eax ; je ueberspringen
    AddRaw $c @(0xD9, 0x40, 0x2C)                                     # fld [eax+2Ch]
    AddRaw $c @(0xD9, 0x1D); AddLE32 $c ($DATA_VA + $O_SHOULDER)      # fstp [schulterwert]
    AddRaw $c @(0xA1); AddLE32 $c ($DATA_VA + $P_HEIGHT)              # mov eax,[zeiger hoehe]
    AddRaw $c @(0x85, 0xC0, 0x74, 0x09)                               # test eax,eax ; je ueberspringen
    AddRaw $c @(0xD9, 0x40, 0x2C)                                     # fld [eax+2Ch]
    AddRaw $c @(0xD8, 0x45, 0xD4, 0xD9, 0x5D, 0xD4)                   # fadd [ebp-2Ch] ; fstp [ebp-2Ch]
    AddRaw $c @(0xD9, 0x05, 0x70, 0x16, 0x9F, 0x00)                   # verschobene fld [0x9F1670]
    $site = $CODE_VA + $c.Count
    AddRaw $c @(0xE9); AddLE32 $c ($HEIGHT_CONT - ($site + 5))

    if ($c.Count -gt 0x100) { throw "CameraReforged: Code-Cave zu gross ($($c.Count) Byte, Platz bis 0x100)." }

    # --- Sektionsinhalt: [code][pad bis 0x100][daten] ---
    $sec = New-Object byte[] $SEC_SIZE
    [Array]::Copy($c.ToArray(), 0, $sec, 0, $c.Count)
    # Startwert des Schulterversatzes, bis der Hook ihn das erste Mal auffrischt
    [Array]::Copy([BitConverter]::GetBytes([float]$Shoulder), 0, $sec, (0x100 + $O_SHOULDER), 4)
    $inv = [System.Globalization.CultureInfo]::InvariantCulture
    $strings = @(
        ,@($O_MAXF,  $MaxFactor.ToString('0.00', $inv))
        ,@($O_ZOOM,  $ZoomSpeed.ToString('0.00', $inv))
        ,@($O_HNAME, 'test_cameraHeight')
        ,@($O_HDEF,  $Height.ToString('0.00', $inv))
        ,@($O_SNAME, 'test_cameraOverShoulder')
        ,@($O_SDEF,  $Shoulder.ToString('0.00', $inv))
    )
    foreach ($s in $strings) {
        $b = [System.Text.Encoding]::ASCII.GetBytes([string]$s[1])
        [Array]::Copy($b, 0, $sec, (0x100 + [int]$s[0]), $b.Length)   # Terminator: Array ist genullt
    }

    # --- Datei vergroessern: padding bis FileAlignment, dann Sektion anhaengen ---
    $raw_size = AlignUp $SEC_SIZE $FA
    $oldLen = $script:f.Length
    $new_raw = AlignUp $oldLen $FA
    $nf = New-Object byte[] ($new_raw + $raw_size)
    [Array]::Copy($script:f, 0, $nf, 0, $oldLen)
    [Array]::Copy($sec, 0, $nf, $new_raw, $sec.Length)
    $script:f = $nf

    # --- PE-Header anpassen (NumberOfSections, SizeOfImage, neuer Sektionsheader) ---
    Patch ($e + 6) ([BitConverter]::GetBytes([uint16]($nsec + 1)))
    Patch ($e + 24 + 56) ([BitConverter]::GetBytes([uint32](AlignUp ($new_rva + $SEC_SIZE) $SA)))
    $hoff = $sectBase + 40 * $nsec
    if (($hoff + 40) -gt (RU32 $script:f ($sectBase + 20))) { throw 'CameraReforged: kein Platz im PE-Header fuer einen weiteren Sektionseintrag.' }
    $sh = New-Object byte[] 40
    [Array]::Copy([System.Text.Encoding]::ASCII.GetBytes('.camr'), 0, $sh, 0, 5)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$SEC_SIZE), 0, $sh, 8, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$new_rva), 0, $sh, 12, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$raw_size), 0, $sh, 16, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$new_raw), 0, $sh, 20, 4)
    [Array]::Copy([byte[]](0x40, 0x00, 0x00, 0xE0), 0, $sh, 36, 4)     # 0xE0000040 = init data | RWX
    Patch $hoff $sh

    # --- Detour auf CVars_Initialize (VA 0x51D9B0 -> Datei 0x11CDB0) ---
    $j = New-Object byte[] 9
    $j[0] = 0xE9
    [Array]::Copy([BitConverter]::GetBytes([int32]($initHook - ($INIT_VA + 5))), 0, $j, 1, 4)
    $j[5] = 0x90; $j[6] = 0x90; $j[7] = 0x90; $j[8] = 0x90
    Patch 0x11CDB0 $j

    # --- Detour auf den Kamera-Fokuspfad (VA 0x6070CB -> Datei 0x2064CB) ---
    $j = New-Object byte[] 6
    $j[0] = 0xE9
    [Array]::Copy([BitConverter]::GetBytes([int32]($heightHook - ($HEIGHT_VA + 5))), 0, $j, 1, 4)
    $j[5] = 0x90
    Patch 0x2064CB $j

    # --- Vorgabewerte der beiden vorhandenen Kamera-CVars umbiegen ---
    # Beide Registrierungen bekommen ihren Standardwert als Textzeiger. Statt
    # der Blizzard-Strings ("1.0" bei VA 0x9E1340, "8.33" bei VA 0xA1E7E0)
    # zeigen sie jetzt auf die Texte im Datenblock. Die CVars selbst existieren
    # im Client, bleiben also unabhaengig davon per /console regelbar.
    $j = New-Object byte[] 5; $j[0] = 0x68
    [Array]::Copy([BitConverter]::GetBytes([int32]($DATA_VA + $O_MAXF)), 0, $j, 1, 4)
    Patch 0x1FD5B2 $j                                  # cameraDistanceMaxFactor, VA 0x5FE1B2
    [Array]::Copy([BitConverter]::GetBytes([int32]($DATA_VA + $O_ZOOM)), 0, $j, 1, 4)
    Patch 0x1FCE36 $j                                  # cameraDistanceMoveSpeed, VA 0x5FDA36

    # --- Schulterversatz: vier Lesestellen auf den Datenblock umbiegen ---
    # Alle vier lesen das Feld +0x2E4 des Kameraobjekts, das im Client nie
    # beschrieben wird und darum immer 0 ist. Ersetzt durch einen festen Zeiger
    # auf den Wert im Datenblock, den der Kamera-Hook je Bild auffrischt -
    # beide Formen sind 6 Byte lang.
    #   fld [reg+2E4h]  ->  fld [DATA+O_SHOULDER]
    $j = New-Object byte[] 6; $j[0] = 0xD9; $j[1] = 0x05
    [Array]::Copy([BitConverter]::GetBytes([int32]($DATA_VA + $O_SHOULDER)), 0, $j, 2, 4)
    Patch 0x568792 $j                                  # VA 0x969392
    Patch 0x56884F $j                                  # VA 0x96944F
    Patch 0x569EE1 $j                                  # VA 0x96AAE1
    Patch 0x572DD8 $j                                  # VA 0x9739D8
}

# ============================================================
#  Helfer fuer die Client-Info-Patches von MacWarrior
#  Portierung von edit_version.py, edit_revision.py, edit_title.py und
#  edit_date.py. Die Werte fragt der Patcher nach der Auswahl ab (Felder
#  PromptDe/PromptEn/Default/Check bei den Patches) und merkt sie sich in
#  patcher_selection.ini. Alle Felder werden vor dem Schreiben komplett
#  geprueft, damit die EXE nie halb geaendert wird.
# ============================================================
function L([string]$de, [string]$en) { if ($script:lang -eq 'en') { return $en } else { return $de } }

function PatchU16([int64]$offset, [int64]$value) { Patch $offset ([BitConverter]::GetBytes([uint16]$value)) }
function PatchU32([int64]$offset, [int64]$value) { Patch $offset ([BitConverter]::GetBytes([uint32]$value)) }

# Text in ein Feld fester Groesse schreiben, Rest mit Nullbytes auffuellen.
function PatchText([int64]$offset, [int]$size, [string]$text, [System.Text.Encoding]$enc) {
    $t = $enc.GetBytes($text)
    if ($t.Length -gt $size) { throw ('"{0}" passt nicht in das Feld bei 0x{1:X} ({2} Byte).' -f $text, $offset, $size) }
    $b = New-Object byte[] $size
    [Array]::Copy($t, 0, $b, 0, $t.Length)
    Patch $offset $b
}
function PatchAscii([int64]$offset, [int]$size, [string]$text) { PatchText $offset $size $text ([System.Text.Encoding]::ASCII) }
function PatchUtf16([int64]$offset, [int]$size, [string]$text) {
    # Inklusive UTF-16-Nullterminator, daher muessen 2 Byte frei bleiben.
    if (($text.Length + 1) * 2 -gt $size) { throw ('"{0}" passt nicht in das Feld bei 0x{1:X}.' -f $text, $offset) }
    PatchText $offset $size $text ([System.Text.Encoding]::Unicode)
}

# VS_FIXEDFILEINFO der Versionsressource (Datei 0x7576C0):
#   +0x00 Signatur 0xFEEF04BD   +0x08 FileVersionMS    +0x0C FileVersionLS
#   +0x10 ProductVersionMS      +0x14 ProductVersionLS
#   FileVersionLS: unteres Wort = Build (12340), oberes Wort = Patch (5)
$VSFFI = 0x7576C0
function Assert-VersionInfo {
    if ((RU32 $script:f $VSFFI) -ne 4277077181) { throw 'VS_FIXEDFILEINFO nicht an der erwarteten Stelle gefunden.' }
}

function Test-ClientVersion([string]$v) {
    if ($v -notmatch '^\d{1,5}\.\d{1,5}\.\d{1,5}$') { return (L 'Format: drei Zahlen mit Punkten, z.B. 3.3.6' 'Format: three numbers with dots, e.g. 3.3.6') }
    if ($v.Length -gt 7) { return (L 'Hoechstens 7 Zeichen (z.B. 3.3.123).' 'At most 7 characters (e.g. 3.3.123).') }
    $p = $v.Split('.')
    foreach ($x in $p) { if ([int]$x -gt 65535) { return (L 'Jede Zahl darf hoechstens 65535 sein.' 'Each number must be at most 65535.') } }
    if (('Version {0}.{1}' -f [int]$p[0], [int]$p[1]).Length -gt 11) {
        return (L 'Haupt- und Nebenversion passen so nicht in das ProductVersion-Feld (max. z.B. 3.3).' 'Major and minor version do not fit into the ProductVersion field (max. e.g. 3.3).')
    }
    return $null
}

function Set-ClientVersion([string]$v) {
    Assert-VersionInfo
    $p = $v.Split('.')
    $maj = [int]$p[0]; $min = [int]$p[1]; $pat = [int]$p[2]
    $pv = 'Version {0}.{1}' -f $maj, $min
    PatchAscii 0x5F3A08 8 $v                          # Version im Spiel ("3.3.5")
    PatchU32 ($VSFFI + 0x08) ($maj * 65536 + $min)    # FileVersionMS
    PatchU16 ($VSFFI + 0x0E) $pat                     # FileVersionLS oben, Build bleibt
    PatchU32 ($VSFFI + 0x10) ($maj * 65536 + $min)    # ProductVersionMS
    PatchU32 ($VSFFI + 0x14) 0                        # ProductVersionLS
    PatchU16 0x7577F6 ($v.Length + 1)                 # FileVersion: wValueLength (wLength bleibt)
    PatchUtf16 0x757814 30 $v                         # FileVersion-Text
    PatchU16 0x757986 ($pv.Length + 1)                # ProductVersion: wValueLength
    PatchUtf16 0x7579A8 24 $pv                        # ProductVersion-Text ("Version 3.3")
}

function Test-ClientBuild([string]$v) {
    if ($v -notmatch '^\d{1,5}$' -or [int]$v -gt 65535) { return (L 'Eine Zahl von 0 bis 65535.' 'A number from 0 to 65535.') }
    return $null
}

function Set-ClientBuild([string]$v) {
    Assert-VersionInfo
    $r = [int]$v
    PatchU16 0x4C99F0 $r                              # interne Build-Nummer
    PatchAscii 0x5F3A00 6 ([string]$r)                # sichtbare Build-Nummer ("12340")
    PatchU16 ($VSFFI + 0x0C) $r                       # FileVersionLS unten
}

function Test-ClientTitle([string]$v) {
    if ($v -eq '') { return (L 'Der Titel darf nicht leer sein.' 'The title must not be empty.') }
    if ($v -notmatch '^[\x20-\x7E]+$') { return (L 'Nur ASCII-Zeichen (keine Umlaute).' 'ASCII characters only.') }
    if ($v.Length -gt 17) { return (L 'Hoechstens 17 Zeichen.' 'At most 17 characters.') }
    return $null
}

function Set-ClientTitle([string]$v) {
    PatchUtf16 0x7577C0 50 $v                         # FileDescription
    PatchUtf16 0x757854 36 $v                         # InternalName
    PatchUtf16 0x757960 36 $v                         # ProductName
}

# Wert: "JJJJ-MM-TT", optional mit " FR" fuer franzoesische Monatsnamen.
function Get-ClientDateParts([string]$v) {
    if ($v -notmatch '^\s*(\d{4}-\d{2}-\d{2})(?:\s+(EN|FR))?\s*$') { return $null }
    $d = [datetime]::MinValue
    $ok = [datetime]::TryParseExact($matches[1], 'yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$d)
    if (-not $ok -or $d.Year -lt 1000) { return $null }
    $lng = 'EN'; if ($matches[2]) { $lng = $matches[2].ToUpperInvariant() }
    return @($d, $lng)
}

# Vorschlag im Dialog: immer das heutige Datum, die Sprache (FR) vom gemerkten Wert.
function Get-ClientDateSuggestion([string]$saved) {
    $today = (Get-Date).ToString('yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture)
    if ($saved -match '\sFR\s*$') { return "$today FR" }
    return $today
}

function Test-ClientDate([string]$v) {
    if ($null -eq (Get-ClientDateParts $v)) { return (L 'Format: JJJJ-MM-TT, optional mit FR dahinter (z.B. 2026-09-28 FR).' 'Format: YYYY-MM-DD, optionally followed by FR (e.g. 2026-09-28 FR).') }
    return $null
}

function Set-ClientDate([string]$v) {
    $parts = Get-ClientDateParts $v
    $d = $parts[0]
    if ($parts[1] -eq 'FR') {
        $months = @('Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aou', 'Sep', 'Oct', 'Nov', 'Dec')
    } else {
        $months = @('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
    }
    $text = '{0} {1:00} {2:0000}' -f $months[$d.Month - 1], $d.Day, $d.Year   # immer 11 Zeichen
    foreach ($o in @(0x5F39F4, 0x62F3F3, 0x636F5F)) {
        $old = [System.Text.Encoding]::ASCII.GetString($script:f, $o, 11)
        if ($old -notmatch '^[A-Za-z]{3} \d{2} \d{4}$') { throw ('Unerwartetes Datumsfeld bei 0x{0:X}: {1}' -f $o, $old) }
        PatchAscii $o 11 $text
    }
    Patch 0x7578B4 ([System.Text.Encoding]::Unicode.GetBytes(('{0:0000}' -f $d.Year)))   # Jahr im LegalCopyright
}

# ============================================================
#  Helfer fuer den voice.dll-Loader (mod-voicechat, ALPHA)
#  Uebernommen aus Add-VoiceLoader.ps1 aus https://github.com/Raz0r1337/mod-voicechat
#  Dateigroesse und PE-Header bleiben unveraendert. Genutzt wird eine
#  27-Byte-int3-Luecke zwischen zwei Funktionen (VA 0x944B45, Datei 0x543F45);
#  der Sprung am Einstiegspunkt (VA 0x401005: jmp 0x40BA9B, direkt vor
#  __security_init_cookie/__tmainCRTStartup) wird dorthin umgebogen:
#      push "voice.dll" / call [LoadLibraryA] / jmp 0x40BA9B
#  eax/ecx/edx/Flags sind an dieser Stelle tot, ebx/esi/edi/ebp sichert
#  LoadLibraryA selbst. Fehlt die DLL, startet WoW ganz normal.
# ============================================================
function Add-VoiceLoader([string]$DllName) {
    $IB        = 0x400000
    $TEXT_DIFF = 0x400C00          # VA - Dateioffset in .text
    $RDATA_DIFF = 0x401800         # VA - Dateioffset in .rdata
    $JMP_VA    = 0x401005          # jmp in die __tmainCRTStartup-Kette
    $CRT_VA    = 0x40BA9B          # urspruengliches Sprungziel
    $CAVE_VA   = 0x944B45          # int3-Luecke
    $CAVE_LEN  = 27
    $IAT_LLA   = 0x9DF248          # KERNEL32!LoadLibraryA (IAT)
    $jmpOff  = $JMP_VA - $TEXT_DIFF
    $caveOff = $CAVE_VA - $TEXT_DIFF

    # --- Pruefen: Einstiegspunkt, Einstiegscode, freie Luecke, Import ---
    $e = RU32 $script:f 0x3C
    if ((RU32 $script:f ($e + 24 + 16)) -ne ($JMP_VA - 5 - $IB)) { throw 'voice.dll-Loader: unerwarteter Einstiegspunkt.' }
    if ($script:f[$jmpOff - 5] -ne 0xE8 -or $script:f[$jmpOff] -ne 0xE9) { throw 'voice.dll-Loader: Einstiegscode unbekannt.' }
    $target = $JMP_VA + 5 + [BitConverter]::ToInt32($script:f, $jmpOff + 1)
    if ($target -ne $CRT_VA) { throw ('voice.dll-Loader: Einstiegssprung ist bereits umgebogen (0x{0:X}).' -f $target) }
    for ($i = 0; $i -lt $CAVE_LEN; $i++) {
        if ($script:f[$caveOff + $i] -ne 0xCC) { throw 'voice.dll-Loader: Luecke bei 0x944B45 ist belegt.' }
    }
    $thunk = RU32 $script:f ($IAT_LLA - $RDATA_DIFF)
    if ($thunk -ge 2147483648 -or [System.Text.Encoding]::ASCII.GetString($script:f, ($thunk + $IB - $RDATA_DIFF + 2), 12) -cne 'LoadLibraryA') {
        throw 'voice.dll-Loader: IAT-Eintrag LoadLibraryA nicht gefunden.'
    }

    # --- Payload: push str / call [LoadLibraryA] / jmp CRT / "voice.dll\0" ---
    $nameBytes = [System.Text.Encoding]::ASCII.GetBytes($DllName)
    if ($nameBytes.Length -lt 1 -or $nameBytes.Length -gt ($CAVE_LEN - 17)) { throw 'voice.dll-Loader: DLL-Name max. 10 Zeichen.' }
    $p = New-Object System.Collections.Generic.List[byte]
    AddRaw $p @(0x68);       AddLE32 $p ($CAVE_VA + 16)              # push offset Name
    AddRaw $p @(0xFF, 0x15); AddLE32 $p $IAT_LLA                     # call [LoadLibraryA]
    AddRaw $p @(0xE9);       AddLE32 $p ($CRT_VA - ($CAVE_VA + 16))  # jmp urspruengliches Ziel
    AddRaw $p $nameBytes;    AddRaw $p @(0x00)                       # "voice.dll\0"
    Patch $caveOff $p.ToArray()
    Patch ($jmpOff + 1) ([BitConverter]::GetBytes([int32]($CAVE_VA - ($JMP_VA + 5))))
}

# ============================================================
#  Eigene Code-Sektion fuer kleine Code-Hoehlen
#  In .text gibt es keine freie Luecke mehr, die gross genug und nicht schon
#  von einem anderen Patch belegt ist. Patches mit Code-Hoehle bekommen darum
#  wie HD-Portraits und CameraReforged eine eigene Sektion am Dateiende:
#  Padding bis FileAlignment, Sektion anhaengen, PE-Header anpassen
#  (NumberOfSections, SizeOfImage, neuer Sektionsheader, ausfuehrbar).
#  Liefert @(VA der Sektion, Dateioffset der Sektion).
# ============================================================
function Add-CodeSection([string]$Name, [int]$Size, [switch]$Writable) {
    $e = RU32 $script:f 0x3C
    $nsec = RU16 $script:f ($e + 6)
    $opt = RU16 $script:f ($e + 20)
    $IB = RU32 $script:f ($e + 24 + 28)
    $SA = RU32 $script:f ($e + 24 + 32)
    $FA = RU32 $script:f ($e + 24 + 36)
    $sectBase = $e + 24 + $opt
    $lastSo = $sectBase + 40 * ($nsec - 1)
    $new_rva = AlignUp ((RU32 $script:f ($lastSo + 12)) + (RU32 $script:f ($lastSo + 8))) $SA
    $hoff = $sectBase + 40 * $nsec
    if (($hoff + 40) -gt (RU32 $script:f ($sectBase + 20))) { throw "${Name}: kein Platz im PE-Header fuer einen weiteren Sektionseintrag." }

    $raw_size = AlignUp $Size $FA
    $oldLen = $script:f.Length
    $new_raw = AlignUp $oldLen $FA
    $nf = New-Object byte[] ($new_raw + $raw_size)
    [Array]::Copy($script:f, 0, $nf, 0, $oldLen)
    for ($i = $new_raw; $i -lt $nf.Length; $i++) { $nf[$i] = 0xCC }
    $script:f = $nf

    Patch ($e + 6) ([BitConverter]::GetBytes([uint16]($nsec + 1)))
    Patch ($e + 24 + 56) ([BitConverter]::GetBytes([uint32](AlignUp ($new_rva + $Size) $SA)))
    $sh = New-Object byte[] 40
    $nm = [System.Text.Encoding]::ASCII.GetBytes($Name)
    [Array]::Copy($nm, 0, $sh, 0, [Math]::Min(8, $nm.Length))
    [Array]::Copy([BitConverter]::GetBytes([uint32]$Size), 0, $sh, 8, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$new_rva), 0, $sh, 12, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$raw_size), 0, $sh, 16, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$new_raw), 0, $sh, 20, 4)
    if ($Writable) {
        [Array]::Copy([byte[]](0x20, 0x00, 0x00, 0xE0), 0, $sh, 36, 4) # 0xE0000020 = Code | ausfuehrbar | lesbar | schreibbar
    } else {
        [Array]::Copy([byte[]](0x20, 0x00, 0x00, 0x60), 0, $sh, 36, 4) # 0x60000020 = Code | ausfuehrbar | lesbar
    }
    Patch $hoff $sh
    return , @(($IB + $new_rva), $new_raw)
}

# ============================================================
#  Code-Hoehle am Ende von .text
#  Hinter dem Code von .text liegen 77 freie Bytes (Datei 0x5DD7B3-0x5DD7FF,
#  Nullen). Der Slider-Patch legt dort seinen Code ab (0x5DD7B8-0x5DD7E2).
#  WorldFrame-Absturzfix (38 Byte) und NPC-Ausblenden (37 Byte) passen
#  zusammen ebenfalls hinein - aber nicht neben den Slider-Patch. Ist der
#  Slider-Patch gewaehlt, weichen beide automatisch auf eine eigene kleine
#  Sektion am Dateiende aus (Ausweichmodus, siehe Add-CodeSection).
#  Liefert @(VA, Dateioffset) der Hoehle.
# ============================================================
$TEXT_CAVE = @{ worldcrash = 0x5DD7B3; nofade = 0x5DD7D9 }

function Get-CodeCave([string]$Id, [int]$Size, [string]$SectionName) {
    if ($script:chosenIds -contains 'sliders') { return , (Add-CodeSection $SectionName $Size) }
    $off = $TEXT_CAVE[$Id]
    for ($i = 0; $i -lt $Size; $i++) {
        if ($script:f[$off + $i] -ne 0) { throw ('Code-Hoehle bei 0x{0:X} ist belegt.' -f ($off + $i)) }
    }
    # VirtualSize von .text bis hinter die Hoehle anheben, damit der Lader sie
    # sicher mit einblendet (bleibt innerhalb von SizeOfRawData).
    $e = RU32 $script:f 0x3C
    $textSo = $e + 24 + (RU16 $script:f ($e + 20))
    $need = $off + $Size - (RU32 $script:f ($textSo + 20))
    if ((RU32 $script:f ($textSo + 8)) -lt $need) { Patch ($textSo + 8) ([BitConverter]::GetBytes([uint32]$need)) }
    return , @(($off + 0x400C00), $off)
}

# Relativer Sprung/Aufruf: Opcode + rel32 von $FromVA nach $ToVA.
function Get-Rel32([byte[]]$Op, [int64]$FromVA, [int64]$ToVA) {
    $b = New-Object byte[] ($Op.Length + 4)
    [Array]::Copy($Op, 0, $b, 0, $Op.Length)
    [Array]::Copy([BitConverter]::GetBytes([int32]($ToVA - ($FromVA + $b.Length))), 0, $b, $Op.Length, 4)
    return , $b
}

function Assert-Bytes([int64]$Off, [byte[]]$Expected, [string]$What) {
    for ($i = 0; $i -lt $Expected.Length; $i++) {
        if ($script:f[$Off + $i] -ne $Expected[$i]) { throw "${What}: Code bei Datei 0x$('{0:X}' -f $Off) unbekannt." }
    }
}

# ============================================================
#  WorldFrame-Absturzfix (0x539wowmod, Alyst3r)
#  Die Funktion bei VA 0x81D510 laeuft ueber Dreiecke aus Index-Tripeln
#  (WORDs) und rechnet Index minus Basis ([ebp+10h]) in eine Vertex-Adresse
#  um. Ist ein Index kleiner als die Basis, landet die Adresse vor dem Puffer
#  und der Client stuerzt ab. Die Hoehle prueft die drei Indizes des ersten
#  Dreiecks und springt in dem Fall zum Funktionsende (VA 0x81D66E).
#  Einstieg ist das jae bei VA 0x81D51B, das genau dorthin springt (leere
#  Liste) - es wird in der Hoehle nachgebildet, der Stack ist derselbe.
#  edx ist hier frei (wird erst bei VA 0x81D547 gesetzt).
#  Neu umgesetzt: Im Original sind die Sprungweiten der drei jg falsch
#  berechnet, ausserdem ist diese Form kuerzer (38 statt 59 Byte).
# ============================================================
function Add-WorldFrameCrashFix {
    $HOOK_VA = 0x81D51B; $BACK_VA = 0x81D521; $EXIT_VA = 0x81D66E
    Assert-Bytes ($HOOK_VA - 0x400C00) @(0x0F, 0x83, 0x4D, 0x01, 0x00, 0x00) 'WorldFrame-Absturzfix'
    $loc = Get-CodeCave 'worldcrash' 38 '.wfcfix'
    $CAVE = $loc[0]
    $c = New-Object System.Collections.Generic.List[byte]
    AddRaw $c @(0x73, 0x1F)                      # jae Ausgang (leere Liste, wie im Original)
    AddRaw $c @(0x8B, 0x55, 0x10)                # mov edx, [ebp+10h]   (Basis)
    AddRaw $c @(0x0F, 0xB7, 0x07)                # movzx eax, word [edi]
    AddRaw $c @(0x3B, 0xD0, 0x7F, 0x15)          # cmp edx, eax / jg Ausgang
    AddRaw $c @(0x0F, 0xB7, 0x47, 0x02)          # movzx eax, word [edi+2]
    AddRaw $c @(0x3B, 0xD0, 0x7F, 0x0D)          # cmp edx, eax / jg Ausgang
    AddRaw $c @(0x0F, 0xB7, 0x47, 0x04)          # movzx eax, word [edi+4]
    AddRaw $c @(0x3B, 0xD0, 0x7F, 0x05)          # cmp edx, eax / jg Ausgang
    AddRaw $c (Get-Rel32 @(0xE9) ($CAVE + $c.Count) $BACK_VA)     # jmp zurueck
    AddRaw $c (Get-Rel32 @(0xE9) ($CAVE + $c.Count) $EXIT_VA)     # Ausgang: jmp Funktionsende
    if ($c.Count -ne 38) { throw 'WorldFrame-Absturzfix: Hoehle hat die falsche Groesse.' }
    Patch $loc[1] $c.ToArray()
    $hook = (Get-Rel32 @(0xE9) $HOOK_VA $CAVE) + [byte[]](0x90)
    Patch ($HOOK_VA - 0x400C00) ([byte[]]$hook)
}

# ============================================================
#  Kein Ausblenden fuer NPCs mit UNIT_FLAG2_DO_NOT_FADE_IN (0x539wowmod, Alyst3r)
#  Beim Entfernen eines Objekts (Funktion bei VA 0x743D50) blendet der
#  Client das Modell normalerweise aus. Die Hoehle prueft vorher: Ist es
#  ein CGUnit (vtable 0xA34D90, Spieler haben eine eigene) und ist in
#  UNIT_FIELD_FLAGS_2 das Bit 0x20 (DO_NOT_FADE_IN) gesetzt, geht es direkt
#  zum Zweig ohne Ausblenden (VA 0x743DE3), sonst normal weiter. Das Flag
#  muss der Server setzen. Ersetzt werden die 5 Byte "mov eax, [esi] /
#  mov edx, [eax+40h]" bei VA 0x743DA3; edx ist bis dahin frei.
# ============================================================
function Add-NoFadeOutFlag {
    $HOOK_VA = 0x743DA3; $BACK_VA = 0x743DA8; $NOFADE_VA = 0x743DE3
    Assert-Bytes ($HOOK_VA - 0x400C00) @(0x8B, 0x06, 0x8B, 0x50, 0x40) 'NPC-Ausblenden'
    $loc = Get-CodeCave 'nofade' 37 '.nofade'
    $CAVE = $loc[0]
    $c = New-Object System.Collections.Generic.List[byte]
    AddRaw $c @(0x8B, 0x06)                                  # mov eax, [esi]          (Original)
    AddRaw $c @(0x3D); AddLE32 $c 0xA34D90                   # cmp eax, CGUnit-vtable
    AddRaw $c @(0x75, 0x0F)                                  # jne normal
    AddRaw $c @(0x8B, 0x96, 0xD0, 0x00, 0x00, 0x00)          # mov edx, [esi+0D0h]     (Unit-Felder)
    AddRaw $c @(0xF6, 0x82, 0xD8, 0x00, 0x00, 0x00, 0x20)    # test byte [edx+0D8h], 20h (FLAGS_2)
    AddRaw $c @(0x75, 0x08)                                  # jnz ohne Ausblenden
    AddRaw $c @(0x8B, 0x50, 0x40)                            # normal: mov edx, [eax+40h] (Original)
    AddRaw $c (Get-Rel32 @(0xE9) ($CAVE + $c.Count) $BACK_VA)     # jmp zurueck
    AddRaw $c (Get-Rel32 @(0xE9) ($CAVE + $c.Count) $NOFADE_VA)   # jmp ohne Ausblenden
    if ($c.Count -ne 37) { throw 'NPC-Ausblenden: Hoehle hat die falsche Groesse.' }
    Patch $loc[1] $c.ToArray()
    Patch ($HOOK_VA - 0x400C00) (Get-Rel32 @(0xE9) $HOOK_VA $CAVE)
}

# ============================================================
#  Doppelsprung (nach 0x539wowmod, Alyst3r)
#  Die Sprungfunktion (VA 0x9883F0) lehnt bei VA 0x98842A jeden Sprung ab,
#  solange eines der Flags ROOT (0x800), FALLING (0x1000) oder FLYING
#  (0x2000000) gesetzt ist. 0x539wowmod ersetzt sie per DLL und zaehlt
#  Sprungladungen mit. Hier dasselbe als Code-Hoehle: Beim Sprung vom Boden
#  wird der Zaehler auf N gesetzt, in der Luft ist ein Sprung erlaubt,
#  solange der Zaehler > 0 ist (dann -1). ROOT und FLYING sperren weiter.
#  Der Zaehler ist ein Byte in derselben Sektion, die darum beschreibbar
#  sein muss - deshalb eine eigene Sektion (.djump) statt der Luecke in .text.
# ============================================================
function Add-DoubleJump([int]$Extra) {
    $HOOK_VA = 0x98842A; $OK_VA = 0x988435; $FAIL_VA = 0x988479
    Assert-Bytes ($HOOK_VA - 0x400C00) @(0x8B, 0x7E, 0x44, 0xF7, 0xC7, 0x00, 0x18, 0x00, 0x02, 0x75, 0x44) 'Doppelsprung'
    $loc = Add-CodeSection '.djump' 0x44 -Writable
    $CAVE = $loc[0]; $DATA = $CAVE + 0x40
    $c = New-Object System.Collections.Generic.List[byte]
    AddRaw $c @(0x8B, 0x7E, 0x44)                                  # mov edi, [esi+44h]      (Original)
    AddRaw $c @(0xF7, 0xC7, 0x00, 0x10, 0x00, 0x00)                # test edi, 1000h         (in der Luft?)
    AddRaw $c @(0x75, 0x14)                                        # jnz Luft
    AddRaw $c @(0xC6, 0x05); AddLE32 $c $DATA; AddRaw $c @([byte]$Extra)   # mov byte [Zaehler], N
    AddRaw $c @(0xF7, 0xC7, 0x00, 0x18, 0x00, 0x02)                # test edi, 2001800h      (Original)
    AddRaw $c @(0x75, 0x21)                                        # jnz Abbruch
    AddRaw $c (Get-Rel32 @(0xE9) ($CAVE + $c.Count) $OK_VA)        # jmp weiter
    # Luft:
    AddRaw $c @(0xF7, 0xC7, 0x00, 0x08, 0x00, 0x02)                # test edi, 2000800h      (ROOT/FLYING)
    AddRaw $c @(0x75, 0x14)                                        # jnz Abbruch
    AddRaw $c @(0x80, 0x3D); AddLE32 $c $DATA; AddRaw $c @(0x00)   # cmp byte [Zaehler], 0
    AddRaw $c @(0x74, 0x0B)                                        # je Abbruch
    AddRaw $c @(0xFE, 0x0D); AddLE32 $c $DATA                      # dec byte [Zaehler]
    AddRaw $c (Get-Rel32 @(0xE9) ($CAVE + $c.Count) $OK_VA)        # jmp weiter
    # Abbruch:
    AddRaw $c (Get-Rel32 @(0xE9) ($CAVE + $c.Count) $FAIL_VA)      # jmp Sprung ablehnen
    AddRaw $c @(0x00, 0x00, 0x00, 0x00)                            # Zaehler, beginnt bei 0
    if ($c.Count -ne 0x44) { throw 'Doppelsprung: Hoehle hat die falsche Groesse.' }
    Patch $loc[1] $c.ToArray()
    $hook = (Get-Rel32 @(0xE9) $HOOK_VA $CAVE) + [byte[]](0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    Patch ($HOOK_VA - 0x400C00) ([byte[]]$hook)
}

function Test-DoubleJump([string]$v) {
    if ($v -notmatch '^[1-9]$') { return (L 'Eine Zahl von 1 bis 9.' 'A number from 1 to 9.') }
    return $null
}

# ============================================================
#  Wasserzeichen
#  Jede gepatchte Wow.exe bekommt einen Text, an dem man spaeter erkennt,
#  dass sie mit diesem Patcher erstellt wurde. Er steht im Fuellbereich
#  hinter der .tls-Sektion (Datei 0x72DE19-0x72DFFF, 487 Byte Nullen):
#  ausserhalb der VirtualSize, wird also nie geladen, und kein Patch nutzt
#  diesen Bereich. Die Dateigroesse bleibt gleich. Geschrieben wird ueber
#  Patch(), beim Zuruecknehmen verschwindet das Wasserzeichen also wieder.
# ============================================================
$WATERMARK_OFF = 0x72DE20
$WATERMARK = 'Patched with St0nys AIO WoW.exe Patcher by St0ny (Raz0r1337) - https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher'

function Add-Watermark {
    $b = [System.Text.Encoding]::ASCII.GetBytes($WATERMARK)
    for ($i = 0; $i -le $b.Length; $i++) {
        if ($script:f[$WATERMARK_OFF + $i] -ne 0) { throw ('Wasserzeichen: Bereich bei 0x{0:X} ist belegt.' -f ($WATERMARK_OFF + $i)) }
    }
    Patch $WATERMARK_OFF $b
}

# ============================================================
#  Helfer fuer den Sprunghoehen-Patch
#  Der Wert ist die Anfangsgeschwindigkeit des Sprungs (float, im Original
#  -7.9555473). Negativ heisst nach oben; die Sprunghoehe waechst mit dem
#  Quadrat des Betrags. Komma oder Punkt als Dezimaltrenner.
# ============================================================
function ConvertTo-JumpValue([string]$v) {
    $d = 0.0
    $ok = [double]::TryParse($v.Trim().Replace(',', '.'), [System.Globalization.NumberStyles]::Float,
        [System.Globalization.CultureInfo]::InvariantCulture, [ref]$d)
    if (-not $ok -or $d -ge 0 -or $d -lt -100) { return $null }
    return [float]$d
}

function Test-JumpValue([string]$v) {
    if ($null -eq (ConvertTo-JumpValue $v)) { return (L 'Eine negative Zahl von -100 bis knapp unter 0, z.B. -11.25.' 'A negative number from -100 to just below 0, e.g. -11.25.') }
    return $null
}

# ============================================================
#  PATCH-DEFINITIONEN
#  Jeder Patch ist eine Hashtable:
#    Id    - interner Kurzname (fuer Abhaengigkeiten und patcher_selection.ini)
#    Cat   - Kategorie (siehe $CATEGORIES), Ueberschrift im Menue
#    De/En - Anzeigename je Sprache
#    On    - Teil des Presets "Billy's_Wow.exe", das zugleich die Standard-
#            Auswahl ist: vorausgewaehlt ($true) oder nicht ($false)
#    NoteDe/NoteEn - optional: Hinweis in Klammern hinter dem Namen, z.B. was
#            zusaetzlich benoetigt wird
#    Url   - optional: Link zum Hinweis, wird im Menue unter dem Namen gezeigt
#    Author - optional: Urheber bzw. Quelle des Patches (nur zur Dokumentation)
#    Obsoletes - optional: Ids von Patches, die dieser ueberfluessig macht
#            (erzeugt nur einen Hinweis, wenn beide ausgewaehlt sind)
#    Conflicts - optional: Ids von Patches, die dieselbe Code-Hoehle nutzen;
#            sind sie gewaehlt, weicht dieser Patch auf eine eigene Sektion aus
#            (erzeugt einen Hinweis)
#    GrowsExe - optional: $true, wenn der Patch immer eine Sektion anhaengt und
#            die Wow.exe damit groesser macht (erzeugt einen Bann-Hinweis)
#    Needs - optional: Ids von Patches, ohne die dieser nicht voll wirkt
#            (erzeugt nur einen Hinweis, keine Sperre)
#    PromptDe/PromptEn, Default, Check - optional, fuer Patches mit eigenem
#            Wert: der Patcher fragt ihn nach der Auswahl ab (Vorschlag =
#            gemerkter Wert oder Default), prueft ihn mit Check (liefert $null
#            oder eine Fehlermeldung) und legt ihn in $VALUES[Id] ab
#    Suggest - optional: Scriptblock, der den Vorschlag im Dialog aus dem
#            gemerkten Wert berechnet (z.B. heutiges Datum)
#    Code  - Scriptblock mit den Patch-Aufrufen
#  Die Reihenfolge hier ist die Reihenfolge im Menue und beim Einspielen,
#  Patches einer Kategorie stehen zusammen.
# ============================================================

$CATEGORIES = @{
    system   = @{ De = 'System & Leistung';                 En = 'System & performance' }
    security = @{ De = 'Sicherheit & Datenschutz';          En = 'Security & privacy' }
    login    = @{ De = 'Login & Verbindung';                En = 'Login & connection' }
    modding  = @{ De = 'Modding: Interface, MPQs & Addons'; En = 'Modding: interface, MPQs & addons' }
    gameplay = @{ De = 'Gameplay-Fixes';                    En = 'Gameplay fixes' }
    graphics = @{ De = 'Grafik & Sichtweite';               En = 'Graphics & view distance' }
    ui       = @{ De = 'Interface & Komfort';               En = 'Interface & comfort' }
    window   = @{ De = 'Fenster, Maus & Kamera';            En = 'Window, mouse & camera' }
    sound    = @{ De = 'Sound';                             En = 'Sound' }
    client   = @{ De = 'Client-Infos: Version, Build, Titel, Datum'; En = 'Client info: version, build, title, date' }
}

$patches = @(

    # --- System & Leistung ---

    @{ Id = 'laa'; Cat = 'system'; On = $true
       Author = 'Alastor StrixEfuartus / Kebabstorm / Robinsch'
       De = '4GB-Patch (Large Address Aware)'
       En = '4GB patch (Large Address Aware)'
       Code = {
        Patch 0x126 @(0x23)
    }}

    @{ Id = 'cache'; Cat = 'system'; On = $false
       Author = 'Alastor StrixEfuartus / Kebabstorm'
       De = 'CACHE-Ordner-Erstellung deaktivieren'
       En = 'Disable CACHE folder creation'
       Code = {
        Patch 0x61BE58 @(0x7C, 0x7C)
    }}

    @{ Id = 'itemcache'; Cat = 'system'; On = $true
       Author = 'Robinsch'
       De = 'Item-Cache sofort aktualisieren'
       En = 'Refresh item cache immediately'
       Code = {
        Patch 0x2689FD @(0x00, 0x00)
    }}

    @{ Id = 'worldcrash'; Cat = 'system'; On = $false; Conflicts = @('sliders')
       Author = 'Alyst3r (0x539wowmod) / St0ny'
       De = 'WorldFrame-Absturzfix (ungueltige Dreiecks-Indizes)'
       En = 'WorldFrame crash fix (invalid triangle indices)'
       NoteDe = 'teilt Code-Hoehle mit Slider-Patch; zusammen wird die Exe groesser - Bann-Gefahr'
       NoteEn = 'shares code cave with the slider patch; together the exe grows - ban risk'
       Code = {
        # Code-Hoehle am Ende von .text, mit Slider-Patch eigene Sektion
        # (.wfcfix), siehe Get-CodeCave / Add-WorldFrameCrashFix.
        Add-WorldFrameCrashFix
    }}

    # --- Sicherheit & Datenschutz ---

    @{ Id = 'rce'; Cat = 'security'; On = $false
       Author = 'Robinsch'
       De = 'Remote Code Execution Exploit Fix'
       En = 'Remote code execution exploit fix'
       NoteDe = 'nur einen der beiden RCE-Patches aktivieren'
       NoteEn = 'enable only one of the two RCE patches'
       Code = {
        Patch 0x2A7 @(0xC0)
        Patch 0x3D9D7C @(0x90, 0x90)
    }}

    @{ Id = 'wardenoff'; Cat = 'security'; On = $false; Obsoletes = @('rce')
       Author = 'Robinsch'
       De = 'Warden komplett abschalten, RCE-Fix'
       En = 'Disable Warden completely, RCE fix'
       NoteDe = 'Kick-Gefahr bei aktivem Warden; nur einen der beiden RCE-Patches aktivieren'
       NoteEn = 'may get you kicked if Warden is active; enable only one of the two RCE patches'
       Code = {
        # Verwirft SMSG_WARDEN_DATA (Opcode 0x2E6) direkt am Eingang des
        # Paket-Handlers (VA 0x7DA850): je -> nop, der Handler kehrt sofort mit 0
        # zurueck. Damit kann der Server ueber Warden keinerlei Code mehr im
        # Client ausfuehren. Der Client antwortet aber auch nicht mehr auf
        # Warden - Server mit aktivem Warden koennen deshalb kicken.
        # Macht den RCE-Fix (rce) ueberfluessig, beide zusammen schaden nicht.
        Patch 0x3D9C5B @(0x90, 0x90)
    }}

    @{ Id = 'scandll'; Cat = 'security'; On = $false
       Author = 'Alastor StrixEfuartus'
       De = 'Scan.dll deaktivieren'
       En = 'Disable Scan.dll'
       Code = {
        # Macht aus ".\Scan.dll" und ".\Scan.dll.new" ".\||an.dll" usw. - '|' ist
        # in Dateinamen verboten, das Laden schlaegt damit garantiert fehl.
        Patch 0x5F4D56 @(0x7C, 0x7C)
        Patch 0x5F4D62 @(0x7C, 0x7C)
    }}

    @{ Id = 'noserverpatch'; Cat = 'security'; On = $false
       Author = 'Kebabstorm'
       De = 'Client-Patches vom Server verbieten'
       En = 'Disallow client patches from the server'
       Code = {
        Patch 0xDA2A8 @(0x90, 0x90, 0xEB)
    }}

    @{ Id = 'nosurvey'; Cat = 'security'; On = $false
       Author = 'Kebabstorm'
       De = 'Hardware-Umfragen vom Server verbieten'
       En = 'Disallow hardware surveys from the server'
       Code = {
        Patch 0xDA2BD @(0xE9, 0xEB, 0x0A, 0x00, 0x00)
    }}

    # --- Login & Verbindung ---

    @{ Id = 'skipbnet'; Cat = 'login'; On = $false
       Author = 'Kebabstorm'
       De = 'Battle.net-Login ueberspringen'
       En = 'Skip Battle.net login'
       Code = {
        Patch 0x2B1F48 @(0xEB)
    }}

    @{ Id = 'skiprdp'; Cat = 'login'; On = $false
       Author = 'Kebabstorm'
       De = 'Remote-Desktop-Pruefung ueberspringen'
       En = 'Skip Remote Desktop check'
       Code = {
        Patch 0x36AE40 @(0xEB)
    }}

    @{ Id = 'nohttp'; Cat = 'login'; On = $false
       Author = 'Kebabstorm'
       De = 'HTTP-Anfragen an Battle.net deaktivieren'
       En = 'Disable HTTP requests to Battle.net'
       Code = {
        # News, Hilfe-Artikel und Nutzungsbedingungen werden nicht mehr abgerufen.
        Patch 0x46F28F @(0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'afk'; Cat = 'login'; On = $false
       Author = 'St0ny'
       De = 'AFK-Timer / IDLE-Check deaktivieren'
       En = 'Disable AFK timer idle check'
       NoteDe = 'wird fuer Character-Autologin benoetigt'
       NoteEn = 'required for character auto-login'
       Url = 'https://discord.com/channels/858041817043042364/1515439916878663701'
       Code = {
        Patch 0x12A3AF @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
        Patch 0x12A64C @(0xE9, 0xB1, 0x06, 0x42, 0x00)
        Patch 0x54AD02 @(0xE8, 0x19, 0xF5, 0xF1, 0xFF, 0x83, 0x3D, 0xA4, 0x99, 0xB4, 0x00, 0x00, 0x75, 0x05, 0xA3, 0xA4, 0x99, 0xB4, 0x00, 0xE9, 0x37, 0xF9, 0xBD, 0xFF)
    }}

    # --- Modding: Interface, MPQs & Addons ---

    @{ Id = 'glue'; Cat = 'modding'; On = $true
       Author = 'Alastor StrixEfuartus / Kebabstorm'
       De = 'Custom Glue-XML erlauben'
       En = 'Allow custom GlueXML'
       Code = {
        Patch 0x1F41BF @(0xEB)
        Patch 0x415A25 @(0xEB)
        Patch 0x415A3F @(0x03)
        Patch 0x415A95 @(0x03)
        Patch 0x415B46 @(0xEB)
        Patch 0x415B5F @(0xB8, 0x03, 0x00, 0x00, 0x00, 0xEB, 0xED)
    }}

    @{ Id = 'mpqsig'; Cat = 'modding'; On = $false
       Author = 'Alastor StrixEfuartus'
       De = 'Falsch/Nicht signierte MPQs zulassen'
       En = 'Allow unsigned / incorrectly signed MPQs'
       Code = {
        Patch 0x021350 @(0x55, 0x8B, 0xEC, 0xB9, 0x05, 0x00, 0x00, 0x00, 0x8B, 0x45, 0x0C, 0x89, 0x08, 0xB8, 0x01, 0x00, 0x00, 0x00, 0x5D, 0xC2, 0x18, 0x00)
    }}

    @{ Id = 'mpqnames'; Cat = 'modding'; On = $true
       De = 'Erweiterte MPQ-Namen erlauben'
       En = 'Allow extended MPQ names'
       Code = {
        Patch 0x5E0F09 @(0x2A)
        Patch 0x5E0F16 @(0x2A)
    }}

    @{ Id = 'localdata'; Cat = 'modding'; On = $true
       Author = 'Alastor StrixEfuartus'
       De = 'Daten direkt aus dem Data-Ordner laden (ohne MPQ)'
       En = 'Load data directly from the Data folder (no MPQ)'
       Code = {
        # Z.B. Data\DBFilesClient\ItemDisplayInfo.dbc wird direkt aus dem Ordner gelesen.
        Patch 0x1F2A @(0x90, 0x90, 0x90, 0x90, 0x90, 0x6A, 0xFF)
    }}

    @{ Id = 'luaunlock'; Cat = 'modding'; On = $false
       Author = 'Alastor StrixEfuartus'
       De = 'LUA Unlock (geschuetzte Funktionen freigeben)'
       En = 'LUA unlock (allow protected functions)'
       NoteDe = 'kann als Botting gewertet werden'
       NoteEn = 'may be treated as botting'
       Code = {
        # Gibt geschuetzte Lua-Funktionen fuer Addons/Makros frei, z.B.
        # CastSpellByName, CastSpellByID, TargetUnit, FocusUnit, InteractUnit,
        # Bewegungsfunktionen, ReloadUI. AttackTarget meldet weiterhin einen Fehler.
        Patch 0x1185E7 @(0xB8, 0x01, 0x00, 0x00, 0x00, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'awesome'; Cat = 'modding'; On = $true; Needs = @('laa')
       Author = 'FrostAtom'
       De = 'AwesomeWotlkLib.dll Unterstuetzung aktivieren'
       En = 'Enable AwesomeWotlkLib.dll support'
       NoteDe = 'benoetigt awesome_wotlk'
       NoteEn = 'requires awesome_wotlk'
       Url = 'https://github.com/noname08662/awesome_wotlk'
       Code = {
        Patch 0xABD0 @(0xE9, 0xDB, 0xA4, 0x0D, 0x00, 0x90, 0x90, 0x90)
        Patch 0xDC0F0 @(0xB8, 0x00, 0x00, 0x00, 0x00, 0xC3)
        Patch 0xE50B0 @(0xB8, 0x01, 0x00, 0x00, 0x00, 0xA3, 0x74, 0xB4, 0xB6, 0x00, 0x68, 0xE0, 0x5C, 0x4E, 0x00, 0xE8, 0x1C, 0x68, 0x38, 0x00, 0x83, 0xC4, 0x04, 0x55, 0x8B, 0xEC, 0xE8, 0xA1, 0x10, 0xF2, 0xFF, 0xE9, 0x04, 0x5B, 0xF2, 0xFF, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0x41, 0x77, 0x65, 0x73, 0x6F, 0x6D, 0x65, 0x57, 0x6F, 0x74, 0x6C, 0x6B, 0x4C, 0x69, 0x62, 0x2E, 0x64, 0x6C, 0x6C, 0x00)
    }}

    @{ Id = 'voicedll'; Cat = 'modding'; On = $false
       Author = 'St0ny'
       De = 'voice.dll beim Start laden (mod-voicechat) [ALPHA]'
       En = 'Load voice.dll at startup (mod-voicechat) [ALPHA]'
       NoteDe = 'Modul ungetestet und unfertig'
       NoteEn = 'module untested and unfinished'
       Url = 'https://github.com/Raz0r1337/mod-voicechat'
       Code = {
        # ALPHA - das Modul mod-voicechat ist noch komplett ungetestet und nicht
        # fertig. Laedt beim Start die voice.dll aus dem WoW-Ordner; fehlt sie,
        # startet WoW ganz normal. Dateigroesse und PE-Header bleiben gleich.
        Add-VoiceLoader 'voice.dll'
    }}

    @{ Id = 'keyprop'; Cat = 'modding'; On = $false
       Author = 'Alyst3r (0x539wowmod)'
       De = 'Alle Tastatur-Ereignisse an Addons weiterreichen (OnKeyDown)'
       En = 'Pass all keyboard events on to addons (OnKeyDown)'
       Code = {
        # CSimpleFrame::OnKeyDown (VA 0x48FB80) meldet nach dem OnKeyDown-Skript
        # eines Frames "erledigt" (mov eax, 1 bei VA 0x48FBD8). Mit 0 laeuft die
        # Taste danach weiter zu den Tastenbelegungen.
        Patch 0x8EFD9 @(0x00)
    }}

    # --- Gameplay-Fixes ---

    @{ Id = 'areatrigger'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'Area-Trigger-Timer genauer (50 ms statt 250 ms)'
       En = 'More precise area trigger timer (50 ms instead of 250 ms)'
       Code = {
        Patch 0x2DB241 @(0x32)
    }}

    @{ Id = 'swing'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'Nahkampf-Schwung bei Rechtsklick entfernt'
       En = 'Remove melee swing on right-click'
       Code = {
        Patch 0x2E1C67 @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'npcanim'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'NPC-Angriffsanimation beim Drehen unterdrueckt'
       En = 'Suppress NPC attack animation when turning'
       Code = {
        Patch 0x33D7C9 @(0xEB)
    }}

    @{ Id = 'spellanim'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'Zauber-Animation nach Abbruch repariert'
       En = 'Fix spell animation after cancelled channel'
       Code = {
        Patch 0x33E0D6 @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'ghostattack'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'Geister-Angriff von NPCs beim Evade behoben'
       En = 'Fix "ghost" attack when NPCs evade from combat'
       Code = {
        Patch 0x0355BF @(0xEB)
    }}

    @{ Id = 'naked'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'Nackter-Charakter-Bug behoben'
       En = 'Fix naked character bug'
       Code = {
        Patch 0x1DDC5D @(0xEB)
    }}

    @{ Id = 'forcereaction'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'Force-Reaction bei /reload erhalten'
       En = 'Keep force reaction on /reload'
       Code = {
        Patch 0x12811E @(0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'mail'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'Neue Post ohne 60 Sekunden Wartezeit'
       En = 'New mail without the 60-second wait'
       Code = {
        Patch 0x16D899 @(0x05, 0x01, 0x00, 0x00, 0x00)
    }}

    @{ Id = 'deadchat'; Cat = 'gameplay'; On = $true
       Author = 'Robinsch'
       De = 'Chat-Befehle auch im Tod erlauben'
       En = 'Allow chat commands while dead'
       Code = {
        Patch 0x10CA41 @(0xEB)
    }}

    @{ Id = 'follow'; Cat = 'gameplay'; On = $false
       Author = 'Alastor StrixEfuartus / St0ny'
       De = '/follow auch bei NPCs erlauben'
       En = 'Allow /follow on NPCs'
       Code = {
        # Portierung des /follow-Patches aus der 12th Generation EXE (Alastor
        # StrixEfuartus, hier aus patch-007-allow_follow.bat), angepasst von St0ny.
        # Vor dem Folgen ruft der Client eine Pruefung auf (call 0x729BD0 bei VA
        # 0x72B525) und bricht bei "nein" ab. Das Original lenkt den Aufruf in eine
        # Code-Hoehle um, die die Pruefung zwar ausfuehrt, ihr Ergebnis aber
        # ignoriert und immer zum Erfolgsweg 0x72B546 springt. Diese Hoehle liegt
        # im .text-Padding bei 0x9DE3B8 - genau dort, wo der Slider-Patch seine
        # Such-Routine ablegt; beide zusammen waeren nicht moeglich.
        # Gleiche Wirkung ohne Hoehle: den bedingten Sprung direkt hinter der
        # Pruefung (jne 0x72B546 bei VA 0x72B52C) unbedingt machen. Der Code am
        # Ziel setzt die Flags selbst neu, haengt also nicht davon ab.
        Patch 0x32A92C @(0xEB)
    }}

    @{ Id = 'level101'; Cat = 'gameplay'; On = $false; Needs = @('glue')
       Author = 'Alastor StrixEfuartus'
       De = 'Level 101+ Fix (Druiden-Grundwerte und Barbierstuhl)'
       En = 'Level 101+ fix (druid base stats and barber chair)'
       Code = {
        # Druiden koennen ihre Grundwerte wieder ansehen und der Barbierstuhl
        # funktioniert fuer alle Charaktere ab Level 101.
        # Braucht laut Quelle "XML MD5" = den Patch "Disable XML SIG MD5", das ist
        # hier der Patch "Custom Glue-XML erlauben" (glue).
        Patch 0x3F5DC2 @(0x90, 0x90, 0x90)
    }}

    @{ Id = 'raceclass'; Cat = 'gameplay'; On = $false
       Author = 'Alastor StrixEfuartus / Robinsch'
       De = 'Unbegrenzte Rasse/Klasse-Kombinationen'
       En = 'Unlimited race/class combinations'
       NoteDe = 'Server muss es unterstuetzen'
       NoteEn = 'server must support it'
       Code = {
        Patch 0xE0355 @(0x78)
        Patch 0xE038E @(0x88)
        Patch 0xE03A3 @(0x88)
        Patch 0xE03C3 @(0x88)
    }}

    @{ Id = 'namecheck'; Cat = 'gameplay'; On = $false
       Author = 'Alyst3r (0x539wowmod) / St0ny'
       De = 'Namenspruefung bei der Charaktererstellung abschalten (z.B. Zahlen im Namen)'
       En = 'Disable the name check in character creation (e.g. digits in names)'
       NoteDe = 'Server muss die Namen ebenfalls erlauben'
       NoteEn = 'server must allow the names as well'
       Code = {
        # Die Pruefung bei VA 0x6B0F90 (cdecl) liefert sofort 0x57 = Name gueltig:
        # mov eax, 57h / ret. Im Original (0x539wowmod) per Detour mit falscher
        # Aufrufkonvention (stdcall), hier direkt in der Funktion.
        Patch 0x2B0390 @(0xB8, 0x57, 0x00, 0x00, 0x00, 0xC3)
    }}

    @{ Id = 'maxchars'; Cat = 'gameplay'; On = $true
       Author = 'St0ny'
       De = 'Max. Charaktere pro Server auf 255 erhoeht'
       En = 'Max characters per realm raised to 255'
       Code = {
        Patch 0x6404F @(0xFF)
    }}

    @{ Id = 'climb'; Cat = 'gameplay'; On = $false
       Author = 'Alastor StrixEfuartus'
       De = 'Steigwinkel-Begrenzung aufheben (jeden Hang hochlaufen)'
       En = 'Remove the climb angle limit (walk up any slope)'
       NoteDe = 'kann vom Server als Cheat erkannt werden'
       NoteEn = 'may be detected as cheating by the server'
       Code = {
        # Aus der 12th Generation EXE (Alastor StrixEfuartus). VA 0xA37F0C ist
        # der Kosinus des steilsten begehbaren Hangs, im Original 0.6427876 =
        # cos(50 Grad). Die Bewegungs-/Kollisionsroutinen vergleichen die
        # Neigung damit; 0.0 = cos(90 Grad) macht jeden Hang begehbar.
        Patch 0x63670C @(0x00, 0x00, 0x00, 0x00)
    }}

    @{ Id = 'jump'; Cat = 'gameplay'; On = $false
       Author = 'Alastor StrixEfuartus'
       De = 'Sprunghoehe aendern (Original -7.9555473)'
       En = 'Change jump height (original -7.9555473)'
       NoteDe = 'kann vom Server als Cheat erkannt werden'
       NoteEn = 'may be detected as cheating by the server'
       PromptDe = 'Neuer Wert, negativ - je kleiner, desto hoeher (z.B. -11.25 = doppelte Hoehe)'
       PromptEn = 'New value, negative - the lower, the higher (e.g. -11.25 = double height)'
       Default = '-7.9555473'
       Check = { param($v) Test-JumpValue $v }
       Code = {
        # Aus der 12th Generation EXE (Alastor StrixEfuartus). VA 0xAA33DC ist
        # die Anfangsgeschwindigkeit des Sprungs (float, einzige Lesestelle
        # fld bei VA 0x98845C), im Original -7.9555473 = D8 93 FE C0.
        Patch 0x6A1BDC ([BitConverter]::GetBytes([float](ConvertTo-JumpValue $script:VALUES['jump'])))
    }}

    @{ Id = 'airforward'; Cat = 'gameplay'; On = $false
       Author = 'Alyst3r (0x539wowmod) / St0ny'
       De = 'Im Sprung vorwaerts/rueckwaerts steuern'
       En = 'Steer forward/backward while jumping'
       NoteDe = 'kann vom Server als Cheat erkannt werden'
       NoteEn = 'may be detected as cheating by the server'
       Code = {
        # Nach 0x539wowmod. Dort ersetzt die DLL die Vorwaerts-Eingabe
        # (VA 0x988A20) durch eine eigene Funktion; die unterscheidet sich vom
        # Original nur in zwei Spruengen, die hier direkt geaendert werden:
        #  - VA 0x988A3D je -> jmp: in der Luft (Fall-Flag 0x1000) nicht mehr
        #    abbrechen, sondern die Richtung wie am Boden setzen
        #  - VA 0x988AD2 je -> jmp: Geschwindigkeit auch in der Luft neu berechnen
        # Dazu aus der DLL: VA 0x987EFD je -> jmp, die Bewegung wird auch in der
        # Luft aktualisiert.
        Patch 0x587E3D @(0xEB)
        Patch 0x587ED2 @(0xEB)
        Patch 0x5872FD @(0xEB)
    }}

    @{ Id = 'airlateral'; Cat = 'gameplay'; On = $false
       Author = 'Alyst3r (0x539wowmod) / St0ny'
       De = 'Im Sprung seitwaerts steuern'
       En = 'Steer sideways while jumping'
       NoteDe = 'kann vom Server als Cheat erkannt werden'
       NoteEn = 'may be detected as cheating by the server'
       Code = {
        # Nach 0x539wowmod, wie oben fuer die Seitwaerts-Eingabe
        # (VA 0x988B00):
        #  - VA 0x988B25 je -> jmp: in der Luft nicht mehr abbrechen
        #  - VA 0x988B81 je -> jmp: Geschwindigkeit auch in der Luft neu berechnen
        # Dazu aus der DLL: VA 0x988BEF jne -> 6x NOP (Funktion bei VA 0x988BA0
        # bricht bei gesetztem Fall-Flag nicht mehr vor der Neuberechnung ab).
        Patch 0x587F25 @(0xEB)
        Patch 0x587F81 @(0xEB)
        Patch 0x587FEF @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'airturn'; Cat = 'gameplay'; On = $false
       Author = 'Alyst3r (0x539wowmod) / St0ny'
       De = 'Im Sprung drehen aendert die Flugrichtung'
       En = 'Turning while jumping changes the flight direction'
       NoteDe = 'kann vom Server als Cheat erkannt werden'
       NoteEn = 'may be detected as cheating by the server'
       Code = {
        # Nach 0x539wowmod. Beim Drehen (VA 0x989B70) setzt der Client
        # die Bewegungsrichtung nur am Boden neu; in der Luft springt er bei
        # VA 0x989B97 (jne) daran vorbei. 2x NOP: auch in der Luft.
        Patch 0x588F97 @(0x90, 0x90)
    }}

    @{ Id = 'doublejump'; Cat = 'gameplay'; On = $false; GrowsExe = $true
       Author = 'Alyst3r (0x539wowmod) / St0ny'
       De = 'Doppelsprung (weitere Spruenge in der Luft)'
       En = 'Double jump (more jumps in the air)'
       NoteDe = 'kann vom Server als Cheat erkannt werden; Exe wird groesser - Bann-Gefahr'
       NoteEn = 'may be detected as cheating by the server; exe grows - ban risk'
       PromptDe = 'Anzahl zusaetzlicher Spruenge in der Luft, 1 bis 9 (1 = Doppelsprung)'
       PromptEn = 'Number of extra jumps in the air, 1 to 9 (1 = double jump)'
       Default = '1'
       Check = { param($v) Test-DoubleJump $v }
       Code = {
        # Eigene beschreibbare Sektion (.djump), siehe Add-DoubleJump.
        Add-DoubleJump ([int]$script:VALUES['doublejump'])
    }}

    # --- Grafik & Sichtweite ---

    @{ Id = 'farclip'; Cat = 'graphics'; On = $true
       Author = 'Alastor StrixEfuartus'
       De = 'CVar farclip unlock (max 10000)'
       En = 'CVar farclip unlock (max 10000)'
       Code = {
        # Beide Floats sind Obergrenzen derselben Klemme in ClampFarclip
        # (VA 0x780770), die den Wert beim Setzen des CVars kappt.
        # Normalfall 1583.33 Yards:
        Patch 0x63CF10 @(0x00, 0x40, 0x1C, 0x46)
        # Rueckfallwert 791.67 Yards - greift auf den alten Vanilla-Zonen
        # (mapId < 530 sowie 543 und 575) und bei <= 1 GB RAM, das prueft
        # die Funktion per GlobalMemoryStatusEx. Muss mit hoch, sonst faellt
        # die Sichtweite dort wieder auf 791 zurueck.
        Patch 0x63CF0C @(0x00, 0x40, 0x1C, 0x46)
    }}

    @{ Id = 'horizon'; Cat = 'graphics'; On = $true
       Author = 'St0ny'
       De = 'CVar horizonFarclipScale unlock (max 12)'
       En = 'CVar horizonFarclipScale unlock (max 12)'
       Code = {
        Patch 0x38CBDF @(0x7C, 0x04, 0xA1, 0x00)
    }}

    @{ Id = 'envdetail'; Cat = 'graphics'; On = $true
       Author = 'St0ny'
       De = 'CVar environmentDetail unlock (kein Limit statt 1.5)'
       En = 'CVar environmentDetail unlock (no limit instead of 1.5)'
       Code = {
        Patch 0x38D08E @(0xD8)
    }}

    @{ Id = 'grounddist'; Cat = 'graphics'; On = $true
       De = 'CVar groundEffectDist unlock (max 3166 statt 140)'
       En = 'CVar groundEffectDist unlock (max 3166 instead of 140)'
       Code = {
        Patch 0x5E74FC @(0xAB, 0xEA, 0x45, 0x45)
    }}

    @{ Id = 'sliders'; Cat = 'graphics'; On = $false; Needs = @('farclip', 'envdetail', 'grounddist')
       Author = 'St0ny'
       De = 'Grafikoptionen: Slider-Maxima erweitern'
       En = 'Graphics options: extend slider maximums'
       Code = {
        # Hebt die Obergrenzen der Regler im Video-Menue an (Reiter "Effekte").
        # Die CVar-Sperren sind mit den Patches darueber laengst offen - die Regler
        # selbst blieben trotzdem auf Blizzards Werten stehen, weil sie ihr Maximum
        # woanders herholen.
        #
        # WO DAS MAXIMUM HERKOMMT
        # Interface\FrameXML\OptionsPanelTemplates.lua baut jeden Regler so auf:
        #     minValue = BlizzardOptionsPanel_GetCVarMinSafe(cvar) or entry.minValue
        #     maxValue = BlizzardOptionsPanel_GetCVarMaxSafe(cvar) or entry.maxValue
        # Also erst die EXE fragen, und nur wenn die nichts liefert, den in der Lua
        # hinterlegten Ersatzwert nehmen. GetCVarMax kennt aber nur zwei CVars:
        # "extShadowQuality" (zaehlt die verfuegbaren Schattenstufen aus) und
        # "farclip" (liefert den festen double 1277.0 aus 0x9F57D8). Fuer alles
        # andere kommt nil zurueck, und dann greifen die Konstanten aus
        # VideoOptionsPanels.lua: environmentDetail 1.5, groundEffectDist 140,
        # groundEffectDensity 64. Genau das sind die Werte, an denen die Regler
        # bisher endeten.
        #
        # ACHTUNG: GetCVarMax liegt ZWEIMAL in der EXE, einmal fuer den
        # Glue-Screen (VA 0x4DDF80) und einmal fuer das laufende Spiel
        # (VA 0x514E30). Beide sind bis auf die Registerbelegung gleich gebaut;
        # im Spiel haelt ebx den Lua-State, im Glue-Screen edi. Wer nur eine der
        # beiden patcht, sieht im Spiel keinerlei Wirkung. Dasselbe gilt fuer
        # GetCVarMin (0x4DDEA0 / 0x514D40), das hier aber unangetastet bleibt.
        #
        # WAS DER PATCH TUT
        # In beiden Funktionen wird der farclip-Vergleich durch einen Aufruf einer
        # gemeinsamen Such-Routine ersetzt, die eine Tabelle {Name, Maximum}
        # durchlaeuft. Treffer -> Wert auf den FPU-Stack und weiter im vorhandenen
        # lua_pushnumber-Pfad. Kein Treffer -> in den vorhandenen nil-Pfad, alle
        # uebrigen CVars verhalten sich also unveraendert.
        #
        #   CVar                  vorher   nachher
        #   farclip               1277     2477
        #   environmentDetail      1.5      2.5
        #   groundEffectDist       140      250
        #   groundEffectDensity     64      256
        #
        # Die Untergrenzen bleiben unangetastet: GetCVarMin wird nicht angefasst,
        # gibt fuer diese drei weiter nil zurueck, und damit gelten die Lua-Minima
        # 0.5 / 70 / 16 (bei farclip die 177.0 aus der EXE, VA 0x9F5798).
        # Die Schrittweiten stehen ebenfalls in der Lua und gehen ohne Nacharbeit
        # glatt auf: environmentDetail 0.25 -> 8 Stufen, groundEffectDist 10 -> 18,
        # groundEffectDensity 8 -> 30. Bei farclip rechnet
        # VideoOptionsEffectsPanel_OnEvent die Schrittweite bei jedem
        # PLAYER_ENTERING_WORLD ohnehin als (max-min)/10 neu, hier also 230.
        #
        # ZWEI EINSCHRAENKUNGEN
        # 1. Der Regler setzt nur das CVar. Ohne die Unlock-Patches darueber klemmt
        #    der Client den Wert beim Setzen sofort wieder auf sein Original.
        # 2. Bei groundEffectDensity wirkt oberhalb von 64 nichts mehr: der
        #    Vertexbuffer der Detail-Doodads ist bei VA 0x7B2A9D auf
        #    density*64 <= 4096 geklemmt. Der Regler laeuft dann zwar bis 256,
        #    optisch aendert sich ab 64 aber nichts.

        # 1) Such-Routine im .text-Padding (VA 0x9DE3B8, 77 freie Bytes ab
        #    0x5DD7B3). Eingang esi = CVar-Name aus dem CVar-Objekt ([obj+0x14]),
        #    Ausgang eax = Zeiger auf den Tabelleneintrag oder 0.
        #    [ebp-4] ist der freie Slot aus dem Prolog beider Funktionen und
        #    dient als Laufzeiger; ebx/edi bleiben unberuehrt, damit beide
        #    Aufrufer ihren Lua-State behalten.
        #      mov  dword [ebp-4], 0xAB5680     Tabellenanfang
        #    L:mov  eax, [ebp-4]
        #      mov  ecx, [eax]                  Namenszeiger
        #      test ecx, ecx / je notfound      0x00000000 = Endmarke
        #      push 0x7FFFFFFF / push ecx / push esi
        #      call SStrCmpI (0x76E780)         stdcall, raeumt selbst auf
        #      test eax, eax / je hit
        #      add  dword [ebp-4], 12 / jmp L
        #    hit:      mov eax, [ebp-4] / ret
        #    notfound: xor eax, eax / ret
        Patch 0x5DD7B8 @(0xC7, 0x45, 0xFC, 0x80, 0x56, 0xAB, 0x00, 0x8B, 0x45, 0xFC, 0x8B, 0x08, 0x85, 0xC9, 0x74, 0x1A, 0x68, 0xFF, 0xFF, 0xFF, 0x7F, 0x51, 0x56, 0xE8, 0xAC, 0x03, 0xD9, 0xFF, 0x85, 0xC0, 0x74, 0x06, 0x83, 0x45, 0xFC, 0x0C, 0xEB, 0xE1, 0x8B, 0x45, 0xFC, 0xC3, 0x33, 0xC0, 0xC3)

        # 2) Aufrufstelle im Glue-Screen: ersetzt den farclip-Vergleich bei
        #    0x4DE046. 21 Byte Stub, Rest bis 0x4DE060 mit int3 gefuellt.
        #      call 0x9DE3B8 / test eax,eax / je 0x4DE07A (nil-Pfad)
        #      fld qword [eax+4] / jmp 0x4DE060 (lua_pushnumber-Pfad)
        Patch 0xDD446 @(0xE8, 0x6D, 0x03, 0x50, 0x00, 0x85, 0xC0, 0x0F, 0x84, 0x27, 0x00, 0x00, 0x00, 0xDD, 0x40, 0x04, 0xE9, 0x05, 0x00, 0x00, 0x00, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC)

        # 3) Dieselbe Aufrufstelle im Spiel, bei 0x514EEA. Gleicher Stub, nur
        #    andere Ziele: nil-Pfad 0x514F1E, Fortsetzung 0x514F04.
        Patch 0x1142EA @(0xE8, 0xC9, 0x94, 0x4C, 0x00, 0x85, 0xC0, 0x0F, 0x84, 0x27, 0x00, 0x00, 0x00, 0xDD, 0x40, 0x04, 0xE9, 0x05, 0x00, 0x00, 0x00, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC)

        # 4) Tabelle im .rdata-Padding (VA 0xAB5680, 384 freie Bytes ab 0x6B3E80).
        #    Je 12 Byte: char* Name, double Maximum. Endmarke 0x00000000.
        #    Als Namen dienen die CVar-Namen, die ohnehin in der EXE stehen:
        #      0x9F57A0 "farclip"              2477.0
        #      0xA3F3BC "environmentDetail"       2.5
        #      0xA3F438 "groundEffectDist"      250.0
        #      0xA3F460 "groundEffectDensity"   256.0
        Patch 0x6B3E80 @(0xA0, 0x57, 0x9F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5A, 0xA3, 0x40, 0xBC, 0xF3, 0xA3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x40, 0x38, 0xF4, 0xA3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x6F, 0x40, 0x60, 0xF4, 0xA3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x40, 0x00, 0x00, 0x00, 0x00)
    }}

    @{ Id = 'goscale'; Cat = 'graphics'; On = $false; Needs = @('envdetail')
       Author = 'St0ny'
       De = 'GameObject Sichtweite: Cat 0 und Cat 4 auf environmentDetail reagieren lassen'
       En = 'GameObject view distance: Cat 0 and Cat 4 scale with environmentDetail'
       Code = {
        # Ergaenzt einen im Client fehlenden Rechenschritt.
        #
        # Die Funktion bei VA 0x78F570 bildet aus den Basiswerten die Laufzeitwerte neu,
        # jedes Mal wenn environmentDetail gesetzt wird. Fuer Cat 1, 2 und 3 lautet sie
        #     Laufzeit-Sichtweite = Basiswert * environmentDetail
        # fuer Cat 0 und Cat 4 dagegen nur
        #     Laufzeit-Sichtweite = Basiswert
        # Dort fehlt die Multiplikation schlicht, der Regler erreicht diese beiden
        # Kategorien also gar nicht.
        #
        # Beide Bloecke beginnen mit einer Kopie der Groessen-Schwellen (Default nach
        # Runtime). Die beiden Tabellen sind byte-gleich und werden von nichts veraendert,
        # die Kopie ist damit wirkungslos. Ihre 12 Byte werden hier frei und reichen fuer
        # den fehlenden Schritt:
        #
        #   vorher (24 Byte)                 nachher (24 Byte)
        #   fld  [SizeThresh_def]   6        fld  [ebp+8]        3   Faktor laden
        #   fstp [SizeThresh_rt]    6        fmul [BaseDist]     6   damit multiplizieren
        #   fld  [BaseDist]         6        fst  [RuntimeDist]  6   Ergebnis ablegen
        #   fst  [RuntimeDist]      6        9x nop              9   Rest auffuellen
        #
        # Danach ist der FPU-Stack genauso belegt wie vorher (st0 = Laufzeit-Sichtweite),
        # der Folgecode ab "fld [FadeBand]" laeuft unveraendert weiter.
        #
        # WIRKUNG: die Sichtweiten-Tabellen bleiben auf den Blizzard-Werten
        # (30/100/200/750/1250), environmentDetail wird zum sauberen Gesamtregler:
        #   ED 1.0  ->   30 / 100 / 200 /  750 / 1250   = x1 gegenueber Blizzard
        #   ED 2.0  ->   60 / 200 / 400 / 1500 / 2500   = x2
        #   ED 2.4  ->   72 / 240 / 480 / 1800 / 3000   = x2.4
        # Alle fuenf Kategorien behalten dabei ihr Verhaeltnis zueinander. Werte ueber 1.5
        # brauchen zusaetzlich den Patch "CVar environmentDetail unlock".
        #
        # Der folgende Patch "Cat 0 von 30 auf 50 Yards" setzt zusaetzlich einen festen
        # Basiswert fuer Cat 0. Er wird nur gebraucht, wenn die Kategorien UNTERSCHIEDLICH
        # skaliert werden sollen - fuer gleichmaessiges Hoch- und Runterregeln reicht
        # dieser Patch hier allein.
        # Cat 0, VA 0x78F573
        Patch 0x38E973 @(0xD9, 0x45, 0x08, 0xD8, 0x0D, 0x64, 0xF3, 0xAD, 0x00, 0xD9, 0x15, 0xA0, 0xF3, 0xAD, 0x00, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
        # Cat 4, VA 0x78F664
        Patch 0x38EA64 @(0xD9, 0x45, 0x08, 0xD8, 0x0D, 0x74, 0xF3, 0xAD, 0x00, 0xD9, 0x15, 0xB0, 0xF3, 0xAD, 0x00, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'cat0'; Cat = 'graphics'; On = $false
       Author = 'St0ny'
       De = 'GameObject Sichtweite: Cat 0 von 30 auf 50 Yards'
       En = 'GameObject view distance: Cat 0 from 30 to 50 yards'
       Code = {
        # Hebt ausschliesslich die kleinste Objektkategorie an (Kerzen, Buecher, Saecke,
        # Werkzeug). Cat 1 bis 4 werden von diesem Patcher ohnehin nicht angefasst,
        # geregelt wird die Sichtweite ueber das CVar environmentDetail (Patch davor).
        # Cat 0 ist im Original mit 30 Yards so knapp bemessen, dass Kleinkram deutlich
        # frueher verschwindet als alles andere; 50 verbessert das Verhaeltnis zu Cat 1
        # von 1:3.3 auf 1:2, und der Regler zieht den Kleinkram proportional mit.
        #
        # Geschrieben werden nur die Cat-0-Felder, jeweils die ersten 4 Byte der Tabelle.
        # Beim Aendern muessen alle fuenf zusammenpassen:
        #   Basis == Laufzeit
        #   Sichtweite^2 == Basis * Basis        (darueber cullt die Engine, spart die Wurzel)
        #   Fade-Start   == Basis - Fade-Band    (Fade-Band Cat 0 = 5, bleibt unangetastet)
        #   Fade-Start^2 == Fade-Start * Fade-Start
        #
        #   hier:      Basis 50   Laufzeit 50   Quadrat 2500  Fade-Start 45  Fade-Quadrat 2025
        #   Blizzard:  Basis 30   Laufzeit 30   Quadrat  900  Fade-Start 25  Fade-Quadrat  625
        #
        # Der Client rechnet die vier abgeleiteten Werte zwar neu, sobald environmentDetail
        # gesetzt wird - steht das CVar aber gar nicht in der Config.wtf, bleiben die
        # Tabellenwerte stehen und muessen dann zur Basis passen.
        # Basis-Sichtweite Cat 0: 50
        Patch 0x6DD364 @(0x00, 0x00, 0x48, 0x42)
        # Laufzeit-Sichtweite Cat 0: 50
        Patch 0x6DD3A0 @(0x00, 0x00, 0x48, 0x42)
        # Sichtweite im Quadrat Cat 0: 2500
        Patch 0x6DD3B4 @(0x00, 0x40, 0x1C, 0x45)
        # Fade-Start Cat 0: 45 (= 50 minus Fade-Band 5)
        Patch 0x6DD3C8 @(0x00, 0x00, 0x34, 0x42)
        # Fade-Start im Quadrat Cat 0: 2025
        Patch 0x6DD3DC @(0x00, 0x20, 0xFD, 0x44)
    }}

    @{ Id = 'occluder'; Cat = 'graphics'; On = $false
       Author = 'Robinsch'
       De = 'Occluder Fix fuer Stormwind (Open Azeroth)'
       En = 'Occluder fix for Stormwind (Open Azeroth)'
       Code = {
        Patch 0x6EE040 @(0x9F, 0x86, 0x01, 0x00)
    }}

    @{ Id = 'bluemoon'; Cat = 'graphics'; On = $true
       Author = 'Robinsch'
       De = 'Blauer Mond am Nachthimmel reaktiviert'
       En = 'Re-enable the blue moon in the night sky'
       Code = {
        Patch 0x5CFBC0 @(0xC7, 0x05, 0x74, 0x8E, 0xD3, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xC3)
    }}

    @{ Id = 'notransparency'; Cat = 'graphics'; On = $true
       Author = 'Alastor StrixEfuartus'
       De = 'Keine Transparenz beim Heranzoomen'
       En = 'No character transparency when zooming in'
       Code = {
        Patch 0x336841 @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'nofade'; Cat = 'graphics'; On = $false; Conflicts = @('sliders')
       Author = 'Alyst3r (0x539wowmod) / St0ny'
       De = 'Kein Ausblenden fuer NPCs mit Flag DO_NOT_FADE_IN'
       En = 'No fade-out for NPCs with flag DO_NOT_FADE_IN'
       NoteDe = 'Server muss das Flag setzen, teilt Code-Hoehle mit Slider-Patch; zusammen wird die Exe groesser - Bann-Gefahr'
       NoteEn = 'server must set the flag, shares code cave with the slider patch; together the exe grows - ban risk'
       Code = {
        # Code-Hoehle am Ende von .text, mit Slider-Patch eigene Sektion
        # (.nofade), siehe Get-CodeCave / Add-NoFadeOutFlag.
        Add-NoFadeOutFlag
    }}

    @{ Id = 'hdportraits'; Cat = 'graphics'; On = $false; GrowsExe = $true
       Author = 'Badgermilk0'
       De = 'HD Unit-Frame Portraits: 256x256 (live 3D-Portraits)'
       En = 'HD unit frame portraits: 256x256 (live 3D portraits)'
       NoteDe = 'Exe wird groesser - Bann-Gefahr'
       NoteEn = 'exe grows - ban risk'
       Code = {
        # Haengt die .hdp-Sektion an und biegt den Model-Render-Pfad auf 256px um.
        Add-HdPortraits 256
    }}

    # --- Interface & Komfort ---

    @{ Id = 'tracker'; Cat = 'ui'; On = $false
       De = 'Quest-Tracker automatisch sortieren'
       En = 'Auto-sort quest tracker'
       Code = {
        Patch 0x11D4C5 @(0x64, 0x14, 0x9E, 0x00)
    }}

    @{ Id = 'worldmap'; Cat = 'ui'; On = $false
       De = 'Erweiterte Weltkarte standardmaessig aktiv'
       En = 'Advanced world map enabled by default'
       Code = {
        Patch 0x11D462 @(0x64, 0x14, 0x9E, 0x00)
    }}

    @{ Id = 'castbars'; Cat = 'ui'; On = $true
       Author = 'Kebabstorm'
       De = 'Cast Bars auf allen Frames'
       En = 'Cast bars on all frames'
       Code = {
        Patch 0x123676 @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'emblems'; Cat = 'ui'; On = $false; Needs = @('mpqnames')
       Author = 'MacWarrior'
       De = 'Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert'
       En = 'Retail guild emblems: selection extended from 170 to 196'
       NoteDe = 'benoetigt Patch-G'
       NoteEn = 'requires Patch-G'
       Url = 'https://discord.com/channels/407664041016688662/1541873346608889936'
       Code = {
        # Entspricht dem Pattern-Replace "73 00 00 AA 00 00" -> "73 00 00 C4 00 00".
        # Das Muster kommt in der Original-EXE genau einmal vor, ab Datei-Offset
        # 0x613105: "73 00" ist das 's' samt Terminator des Lua-Namens
        # "InitializeTabardColors", das dritte Byte Ausrichtungs-Padding. Erst
        # danach faengt der eigentliche Wert an, gepatcht wird also 0x613108.
        #
        # DIE TABELLE (VA 0xA14908, Datei 0x613108) - fuenf DWORDs, je einer pro
        # Tabard-Kategorie:
        #   Idx  VA         Kategorie            Wert
        #    0   0xA14908   Embleme               170   <- dieser Patch
        #    1   0xA1490C   Emblemfarben           17
        #    2   0xA14910   Bordueren               6
        #    3   0xA14914   Borduerenfarben        17
        #    4   0xA14918   Hintergrundfarben      51
        #
        # Beide Stellen, die die Tabelle nutzen, lesen den Zaehler zur Laufzeit:
        #   VA 0x599481  mov edi,[esi*4+0xA14908]
        #                Durchschalten im Tabard-Designer (Lua-Seite:
        #                TabardModel:CycleVariation(Kategorie+1, Schritt), esi ist
        #                der auf 0..4 gepruefte Index). Der neue Index wird direkt
        #                danach per idiv gegen denselben Zaehler modulo genommen -
        #                alles ab 170 war damit gar nicht erst erreichbar.
        #   VA 0x599729  mov esi,0xA14908
        #                Zufalls-Tabard, zieht je Kategorie rand() * Zaehler. Die
        #                Schleife laeuft bis 0xA1491C, daher genau fuenf Eintraege.
        # Eine zweite, fest verdrahtete 170 gibt es im Emblem-Pfad nicht - der
        # Zaehler ist die einzige Stelle, die Grenze faellt also vollstaendig.
        #
        # 196 (0xC4) ist die Emblemzahl von Retail.
        #
        # VORAUSSETZUNG: ZUSAETZLICHES MPQ-PATCH-ARCHIV NOETIG
        # Dieser Patch hebt nur den Zaehler an, er bringt keine Grafiken mit. Die
        # 26 neuen Wappen (Index 170 bis 195) muessen als eigenes MPQ-Archiv im
        # Data-Ordner liegen. Fehlt es, sind die neuen Plaetze im Tabard-Designer
        # zwar anwaehlbar, bleiben aber leer.
        # Die Dateinamen baut der Client bei VA 0x4E8210 aus zwei Zahlen -
        # Emblem-Index und Farbindex, in dieser Reihenfolge:
        #   Textures\GuildEmblems\Emblem_<Index>_<Farbe>_TU_U   (obere Haelfte)
        #   Textures\GuildEmblems\Emblem_<Index>_<Farbe>_TL_U   (untere Haelfte)
        # So stehen die Formatstrings in der EXE, die Endung .blp haengt der
        # Texturlader an. Pro Wappen also 17 Farben x 2 Haelften = 34 Dateien,
        # fuer die 26 neuen Wappen zusammen 884.
        # Der Archivname ist frei waehlbar (patch-*.MPQ), dafuer sorgt der Patch
        # "Erweiterte MPQ-Namen erlauben" (mpqnames).
        Patch 0x613108 @(0xC4)
    }}

    @{ Id = 'flash'; Cat = 'ui'; On = $true
       Author = 'Kebabstorm'
       De = 'FlashWindow Patch'
       En = 'FlashWindow patch'
       NoteDe = 'benoetigt FlashWindow-Addon'
       NoteEn = 'requires the FlashWindow addon'
       Url = 'https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash'
       Code = {
        # Datei-Offsets: VA 0x134ED5 -> File 0x1342D5 / VA 0x6086E4 -> File 0x606EE4
        Patch 0x1342D5 @(0x14, 0x68, 0xD8, 0x4C, 0x9E, 0x00, 0xFF, 0x15, 0xB0, 0xF1, 0x9D, 0x00, 0x68, 0xE4, 0x86, 0xA0, 0x00, 0x50, 0xE8, 0xCD, 0x7E, 0xEE, 0xFF, 0x6A, 0x00, 0xB9, 0x20, 0x16, 0xD4, 0x00, 0xFF, 0x31, 0xFF, 0xD0, 0xB8, 0x00, 0x00, 0x00, 0x00, 0xC9, 0xC3, 0xCC)
        Patch 0x606EE4 @(0x46, 0x6C, 0x61, 0x73, 0x68, 0x57, 0x69, 0x6E, 0x64, 0x6F, 0x77, 0x00, 0x00, 0x00)
    }}

    @{ Id = 'charrandom'; Cat = 'ui'; On = $false
       Author = 'Alyst3r (0x539wowmod)'
       De = 'Charaktererstellung: Aussehen nicht automatisch auswuerfeln'
       En = 'Character creation: do not randomize the appearance automatically'
       Code = {
        # VA 0x4E147B: je -> jmp, die automatischen Zufallsaufrufe beim Oeffnen
        # (ResetCharCustomize) bzw. Volk-/Geschlechtswechsel werden
        # uebersprungen. Der Zufall-Knopf
        # (RandomizeCharCustomization, VA 0x4E1B60) nutzt einen eigenen Weg.
        Patch 0xE087B @(0xEB)
    }}

    # --- Fenster & Maus ---

    @{ Id = 'window'; Cat = 'window'; On = $false
       Author = 'St0ny'
       De = 'Fenstermodus als Standard setzen'
       En = 'Windowed mode by default'
       Code = {
        Patch 0x369A7D @(0x64, 0x14, 0x9E)
    }}

    @{ Id = 'maximize'; Cat = 'window'; On = $false
       Author = 'St0ny'
       De = 'Fenstermodus maximiert als Standard setzen'
       En = 'Maximized window by default'
       Code = {
        Patch 0x369AB2 @(0x64, 0x14, 0x9E)
    }}

    @{ Id = 'windowfix'; Cat = 'window'; On = $true
       Author = 'Robinsch'
       De = 'Kein schwarzer Bildschirm beim Wechsel in den Fenstermodus'
       En = 'No black screen when switching to windowed mode'
       Code = {
        Patch 0xE94 @(0xEB)
    }}

    @{ Id = 'mouse'; Cat = 'window'; On = $true
       Author = 'Robinsch'
       De = 'Mausflackern / Kameraspruenge Fix'
       En = 'Mouse flicker / camera jump fix'
       Code = {
        Patch 0x469A2C @(0xE9, 0x71, 0xF0, 0x0B, 0x00, 0xF8, 0x13, 0xD4, 0x00, 0x8B, 0x1D, 0xFC)
        Patch 0x528AA2 @(0x8D, 0x4D, 0xF0, 0x51, 0x57, 0xFF, 0x15, 0xDC, 0xF5, 0x9D, 0x00, 0x8B, 0x45, 0xF0, 0x8B, 0x15, 0xF8, 0x13, 0xD4, 0x00, 0xE9, 0x7A, 0x0F, 0xF4, 0xFF)
        Patch 0x4691B1 @(0x89, 0xE5, 0x8B, 0x05, 0xFC, 0x13, 0xD4, 0x00, 0x8B, 0x0D, 0xF8, 0x13, 0xD4, 0x00, 0xEB, 0xC2, 0x7D, 0x03, 0x83, 0xC1, 0x01, 0x83, 0xC0, 0x32, 0x83, 0xC1, 0x32, 0x3B, 0x0D, 0xEC, 0xBC, 0xCA, 0x00, 0x7E, 0x03, 0x83, 0xE9, 0x01, 0x3B, 0x05, 0xF0, 0xBC, 0xCA, 0x00, 0x7E, 0x03, 0x83, 0xE8, 0x01, 0x83, 0xE9, 0x32, 0x83, 0xE8, 0x32, 0x89, 0x0D, 0xF8, 0x13, 0xD4, 0x00, 0x89, 0x05, 0xFC, 0x13, 0xD4, 0x00, 0x89, 0xEC, 0x5D, 0xE9, 0xB4, 0xF7, 0xFF, 0xFF, 0xEC, 0x5D, 0xC3, 0xC3)
        Patch 0x469183 @(0x83, 0xF8, 0x32, 0x7D, 0x03, 0x83, 0xC0, 0x01, 0x83, 0xF9, 0x32, 0xEB, 0x31)
    }}

    @{ Id = 'camera'; Cat = 'window'; On = $false; GrowsExe = $true
       Author = 'Stormhand / St0ny'
       De = 'CameraReforged [BETA]: Kamerahoehe, Schulterversatz, Zoom-Grenzen'
       En = 'CameraReforged [BETA]: camera height, shoulder offset, zoom limits'
       NoteDe = 'noch nicht 100% fertig; Exe wird groesser - Bann-Gefahr'
       NoteEn = 'not 100% finished yet; exe grows - ban risk'
       Code = {
        # BETA - funktioniert noch nicht zu 100 Prozent, hier fliesst noch Arbeit rein.
        #
        # Portierung von CameraReforged (Stormhand), mit seiner Erlaubnis eingebaut.
        # Der Original-Patcher ist ein eigenstaendiges Tool mit GUI; hier steckt
        # nur seine Patch-Logik, damit alles in einem Durchgang laeuft.
        #
        # WAS DER PATCH TUT
        # 1. Er registriert beim Start zwei neue CVars direkt im Client, die es
        #    in 3.3.5a gar nicht gibt. Bisher brauchte man dafuer ConsoleXP.dll
        #    samt Injector - das faellt damit weg.
        #      test_cameraHeight        Hoehe des Fokuspunkts in Yards. Der Client
        #                               zielt auf die Brust; der Wert hebt die
        #                               Kamera auf Kopfhoehe an. Bereich 0.0 - 3.0.
        #      test_cameraOverShoulder  Seitlicher Versatz in Yards, negativ =
        #                               links. 0 laesst die Kamera mittig.
        #                               Bereich -2.0 - 2.0.
        # 2. Er tauscht die Vorgabewerte zweier vorhandener CVars aus:
        #      cameraDistanceMaxFactor  max. Zoom-Faktor, Blizzard 1.0  -> 2.6
        #      cameraDistanceMoveSpeed  Zoom-Tempo,      Blizzard 8.33 -> 20.0
        #
        # Alle vier sind zur Laufzeit ueber /console <name> <wert> erreichbar und
        # wirken sofort, also auch aus Makros und Addons wie DynamicCam heraus.
        # Die hier gesetzten Werte sind die Startwerte; alle vier werden mit
        # Flag 0x10 registriert und landen damit in der Config.wtf, eine
        # Aenderung per /console ueberlebt also den Neustart.
        #
        # WERTE AENDERN
        # Einfach die vier Zahlen unten anpassen und neu patchen. Die Funktion
        # baut Texte, Zeiger und Sprungziele daraus neu auf und prueft die
        # Bereiche; ausserhalb bricht sie mit Meldung ab.
        #
        # WO DAS IM BINARY LANDET
        # Eine eigene, angehaengte Sektion ".camr" (RWX) mit Code und Daten,
        # Detours auf CVars_Initialize und den Kamera-Fokuspfad, dazu sechs
        # umgebogene Lesestellen. Details stehen bei Add-CameraReforged oben.
        #
        # EINE EINSCHRAENKUNG
        # Dieser Patch veraendert wie die HD-Portraits die
        # Dateigroesse und die PE-Struktur (etwa +1 KB), weil er eine Sektion
        # anhaengt. Das ist unvermeidbar: der Weg der Vorlage - Caves ins
        # .rdata-Padding und die Sektion dafuer ausfuehrbar machen - laesst
        # diesen Client beim Start mit R6002 abbrechen, nachgewiesen mit einem
        # Build, der nur dieses eine Header-Byte aenderte. Auf Servern, die den
        # Client auf Groesse oder Sektionsaufbau pruefen, kann das auffallen.
        # Die SHA256-Pruefung des Patchers betrifft nur die Eingabe und bleibt
        # davon unberuehrt.
        Add-CameraReforged -Height 0.5 -Shoulder 0.0 -MaxFactor 2.6 -ZoomSpeed 20.0
    }}

    # --- Sound ---

    @{ Id = 'sound'; Cat = 'sound'; On = $false
       Author = 'St0ny'
       De = 'Sound-Einstellungen optimieren'
       En = 'Optimize sound settings'
       NoteDe = 'benoetigt OpenAL, sonst wirken die Einstellungen nicht'
       NoteEn = 'requires OpenAL, otherwise the settings have no effect'
       Url = 'https://github.com/kcat/openal-soft'
       Code = {
        Patch 0x0C77C2 @(0xC7, 0x45, 0xF8, 0x7E, 0x00, 0x00, 0x00, 0x90, 0x90, 0x90)
        Patch 0x6B3F80 @(0x36, 0x34, 0x00)
        Patch 0x6B3F84 @(0x32, 0x00)
        Patch 0x0D0604 @(0x68, 0x84, 0x57, 0xAB, 0x00)
        Patch 0x0D0624 @(0x68, 0x80, 0x57, 0xAB, 0x00)
        Patch 0x0D064A @(0x68, 0x64, 0x14, 0x9E, 0x00)
        Patch 0x0D077F @(0x68, 0x64, 0x14, 0x9E, 0x00)
    }}


    # --- Client-Infos ---

    @{ Id = 'clientversion'; Cat = 'client'; On = $false
       Author = 'MacWarrior'
       De = 'Client-Version aendern (Original 3.3.5)'
       En = 'Change client version (original 3.3.5)'
       PromptDe = 'Neue Client-Version, Format x.y.z, max. 7 Zeichen'
       PromptEn = 'New client version, format x.y.z, max. 7 characters'
       Default = '3.3.5'
       Check = { param($v) Test-ClientVersion $v }
       Code = {
        # Portierung von edit_version.py (MacWarrior): Version im Spiel, die
        # Versionsressource (FileVersion/ProductVersion) und VS_FIXEDFILEINFO.
        # Die Build-Nummer bleibt erhalten.
        Set-ClientVersion $script:VALUES['clientversion']
    }}

    @{ Id = 'clientbuild'; Cat = 'client'; On = $false
       Author = 'MacWarrior'
       De = 'Build-Nummer aendern (Original 12340)'
       En = 'Change build number (original 12340)'
       PromptDe = 'Neue Build-Nummer, 0 bis 65535'
       PromptEn = 'New build number, 0 to 65535'
       Default = '12340'
       Check = { param($v) Test-ClientBuild $v }
       Code = {
        # Portierung von edit_revision.py (MacWarrior): interne und sichtbare
        # Build-Nummer sowie der vierte Teil der FileVersion.
        Set-ClientBuild $script:VALUES['clientbuild']
    }}

    @{ Id = 'clienttitle'; Cat = 'client'; On = $false
       Author = 'MacWarrior'
       De = 'Programmtitel in den Dateieigenschaften aendern'
       En = 'Change program title in the file properties'
       PromptDe = 'Neuer Titel, max. 17 Zeichen, nur ASCII'
       PromptEn = 'New title, max. 17 characters, ASCII only'
       Default = 'World of Warcraft'
       Check = { param($v) Test-ClientTitle $v }
       Code = {
        # Portierung von edit_title.py (MacWarrior): FileDescription,
        # InternalName und ProductName der Versionsressource.
        Set-ClientTitle $script:VALUES['clienttitle']
    }}

    @{ Id = 'clientdate'; Cat = 'client'; On = $false
       Author = 'MacWarrior'
       De = 'Build-Datum aendern (Original Jun 24 2010)'
       En = 'Change build date (original Jun 24 2010)'
       PromptDe = 'Neues Build-Datum JJJJ-MM-TT, optional mit FR fuer franzoesische Monatsnamen'
       PromptEn = 'New build date YYYY-MM-DD, optionally followed by FR for French month names'
       Default = '2010-06-24'
       Suggest = { param($saved) Get-ClientDateSuggestion $saved }
       Check = { param($v) Test-ClientDate $v }
       Code = {
        # Portierung von edit_date.py (MacWarrior): die drei Datumsfelder
        # ("Jun 24 2010") und das Jahr im LegalCopyright.
        Set-ClientDate $script:VALUES['clientdate']
    }}
)

# ============================================================
#  Auswahl-Logik
# ============================================================

# Zerlegt "1,3 5-8" in Indizes (0-basiert). Liefert $null bei ungueltiger Eingabe.
function ConvertTo-Indices([string]$text, [int]$max) {
    $result = New-Object System.Collections.Generic.List[int]
    foreach ($tok in ($text -split '[\s,;]+')) {
        if ($tok -eq '') { continue }
        if ($tok -match '^(\d+)-(\d+)$') {
            $a = [int]$matches[1]; $b = [int]$matches[2]
            if ($a -gt $b) { $t = $a; $a = $b; $b = $t }
        } elseif ($tok -match '^\d+$') {
            $a = [int]$tok; $b = $a
        } else {
            return $null
        }
        if ($a -lt 1 -or $b -gt $max) { return $null }
        for ($i = $a; $i -le $b; $i++) { $result.Add($i - 1) }
    }
    if ($result.Count -eq 0) { return $null }
    return , $result.ToArray()
}

function Get-DefaultSelection {
    $sel = New-Object bool[] $patches.Count
    for ($i = 0; $i -lt $patches.Count; $i++) { $sel[$i] = [bool]$patches[$i].On }
    return , $sel
}

# Gespeicherte Auswahl aus patcher_selection.ini lesen. Liefert $null, wenn es
# keine gibt. Gespeichert wird pro Patch-Id, nicht pro Nummer: Patches, die in
# der Datei fehlen (z.B. in einer neueren Version hinzugekommen), bekommen
# ihren On-Wert, unbekannte Eintraege werden ignoriert.
function Get-SavedSelection {
    if (-not (Test-Path -LiteralPath $settingsFile -PathType Leaf)) { return $null }
    try { $lines = [System.IO.File]::ReadAllLines($settingsFile) } catch { return $null }
    $saved = @{}
    foreach ($l in $lines) {
        if ($l -match '^\s*([A-Za-z0-9_]+)\s*=\s*([01])\s*$') { $saved[$matches[1]] = ($matches[2] -eq '1') }
    }
    if ($saved.Count -eq 0) { return $null }
    $sel = Get-DefaultSelection
    for ($i = 0; $i -lt $patches.Count; $i++) {
        if ($saved.ContainsKey($patches[$i].Id)) { $sel[$i] = $saved[$patches[$i].Id] }
    }
    return , $sel
}

# Gemerkte Sprache (Zeile "language=de|en") aus patcher_selection.ini lesen.
function Get-SavedLanguage {
    if (-not (Test-Path -LiteralPath $settingsFile -PathType Leaf)) { return $null }
    try { $lines = [System.IO.File]::ReadAllLines($settingsFile) } catch { return $null }
    foreach ($l in $lines) {
        if ($l -match '^\s*language\s*=\s*(de|en)\s*$') { return $matches[1].ToLowerInvariant() }
    }
    return $null
}

# Nur die Sprache in patcher_selection.ini setzen, alles andere bleibt stehen.
# Fehler beim Schreiben sind hier unkritisch und werden ignoriert.
function Save-Language([string]$language) {
    try {
        $lines = New-Object System.Collections.Generic.List[string]
        if (Test-Path -LiteralPath $settingsFile -PathType Leaf) {
            foreach ($l in [System.IO.File]::ReadAllLines($settingsFile)) {
                if ($l -notmatch '^\s*language\s*=') { $lines.Add($l) }
            }
        }
        $lines.Add("language=$language")
        [System.IO.File]::WriteAllLines($settingsFile, $lines.ToArray())
    } catch { }
}

# Gemerkte Werte (Zeilen "value.<Id>=<Wert>") aus patcher_selection.ini lesen.
function Get-SavedValues {
    $vals = @{}
    if (-not (Test-Path -LiteralPath $settingsFile -PathType Leaf)) { return $vals }
    try { $lines = [System.IO.File]::ReadAllLines($settingsFile) } catch { return $vals }
    foreach ($l in $lines) {
        if ($l -match '^\s*value\.([A-Za-z0-9_]+)\s*=\s*(.*?)\s*$') { $vals[$matches[1]] = $matches[2] }
    }
    return $vals
}

# Auswahl und Werte in patcher_selection.ini schreiben. Liefert $null oder die Fehlermeldung.
function Save-Selection($sel, $values) {
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# St0nys-AIO-WoW-EXE-Patcher - gespeicherte Patch-Auswahl / saved patch selection")
    $lines.Add('# 1 = an / on, 0 = aus / off')
    $lines.Add('# Datei loeschen setzt die Auswahl zurueck / delete this file to reset the selection')
    for ($i = 0; $i -lt $patches.Count; $i++) {
        $v = 0; if ($sel[$i]) { $v = 1 }
        $lines.Add("$($patches[$i].Id)=$v")
    }
    foreach ($k in ($values.Keys | Sort-Object)) { $lines.Add("value.$k=$($values[$k])") }
    $lines.Add("language=$script:lang")
    try {
        [System.IO.File]::WriteAllLines($settingsFile, $lines.ToArray())
        return $null
    } catch {
        return $_.Exception.Message
    }
}

# ============================================================
#  Zustand der gepatchten Wow.exe (patcher_state.ini)
#  Nach jedem Patchen merkt sich der Patcher den SHA256 der erzeugten Datei,
#  die eingespielten Patches samt Werten, die Groesse des Originals und die
#  Original-Bytes an allen Stellen, die die Patches beschrieben haben. Passt
#  die Wow.exe beim naechsten Start zu diesem Hash, wird daraus das Original
#  rekonstruiert (und per SHA256 geprueft) und die neue Auswahl darauf
#  eingespielt. So lassen sich Patches beliebig dazu- und abwaehlen.
# ============================================================
function Get-Sha256([byte[]]$data) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($data))).Replace('-', '') } finally { $sha.Dispose() }
}

function ConvertFrom-Hex([string]$hex) {
    $b = New-Object byte[] ($hex.Length / 2)
    for ($i = 0; $i -lt $b.Length; $i++) { $b[$i] = [Convert]::ToByte($hex.Substring(2 * $i, 2), 16) }
    return , $b
}

# Liefert $null, wenn es keine lesbare Zustandsdatei gibt. Undo-Eintraege
# sind Paare @(Offset, Original-Bytes).
function Read-State {
    if (-not (Test-Path -LiteralPath $stateFile -PathType Leaf)) { return $null }
    try { $lines = [System.IO.File]::ReadAllLines($stateFile) } catch { return $null }
    $st = @{ Hash = $null; Size = [int64]-1; Ids = @(); Values = @{}; Undo = New-Object System.Collections.Generic.List[object] }
    foreach ($l in $lines) {
        if ($l -match '^hash=([0-9A-Fa-f]{64})$') { $st.Hash = $matches[1].ToUpperInvariant() }
        elseif ($l -match '^size=(\d+)$') { $st.Size = [int64]$matches[1] }
        elseif ($l -match '^patches=(.*)$') { $st.Ids = @($matches[1] -split ',' | Where-Object { $_ -ne '' }) }
        elseif ($l -match '^value\.([A-Za-z0-9_]+)=(.*)$') { $st.Values[$matches[1]] = $matches[2] }
        elseif ($l -match '^undo=0x([0-9A-Fa-f]+):((?:[0-9A-Fa-f]{2})+)$') {
            $st.Undo.Add(@([Convert]::ToInt64($matches[1], 16), (ConvertFrom-Hex $matches[2])))
        }
    }
    if (-not $st.Hash -or $st.Size -le 0) { return $null }
    return $st
}

# Rekonstruiert aus einer gepatchten Datei das Original: auf die alte Groesse
# kuerzen (angehaengte Sektionen fallen weg), Original-Bytes zurueckschreiben.
# Liefert $null, wenn das Ergebnis nicht exakt die originale Wow.exe ist.
function Restore-Original([byte[]]$data, $st) {
    if ($st.Size -gt $data.Length) { return $null }
    $o = New-Object byte[] $st.Size
    [Array]::Copy($data, 0, $o, 0, $st.Size)
    foreach ($u in $st.Undo) {
        if ($u[0] + $u[1].Length -gt $o.Length) { return $null }
        [Array]::Copy($u[1], 0, $o, $u[0], $u[1].Length)
    }
    if ((Get-Sha256 $o) -ne $EXPECTED_HASH) { return $null }
    return , $o
}

# Original-Bytes zu allen Schreibzugriffen von Patch(), die im Original liegen.
function Get-UndoEntries([byte[]]$orig) {
    $undo = New-Object System.Collections.Generic.List[object]
    $seen = @{}
    for ($i = 0; $i -lt $script:writes.Count; $i += 2) {
        $off = $script:writes[$i]
        $end = $off + $script:writes[$i + 1]
        if ($off -ge $orig.Length) { continue }
        if ($end -gt $orig.Length) { $end = $orig.Length }
        if ($seen.ContainsKey("$off/$end")) { continue }
        $seen["$off/$end"] = $true
        $b = New-Object byte[] ($end - $off)
        [Array]::Copy($orig, $off, $b, 0, $b.Length)
        $undo.Add(@($off, $b))
    }
    return , $undo
}

# Zustandsdatei schreiben. Liefert $null oder die Fehlermeldung.
function Write-State([string]$path, [string]$hash, [int64]$size, $ids, $values, $undo) {
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add('# St0nys-AIO-WoW-EXE-Patcher - Zustand der gepatchten Wow.exe / state of the patched Wow.exe')
    $lines.Add('# Nicht von Hand aendern! Ohne diese Datei lassen sich die Patches nicht mehr zuruecknehmen.')
    $lines.Add('# Do not edit! Without this file the patches can no longer be removed.')
    $lines.Add("hash=$hash")
    $lines.Add("size=$size")
    $lines.Add("patches=$($ids -join ',')")
    foreach ($k in ($values.Keys | Sort-Object)) { $lines.Add("value.$k=$($values[$k])") }
    foreach ($u in $undo) {
        $lines.Add(('undo=0x{0:X}:{1}' -f $u[0], ([BitConverter]::ToString($u[1])).Replace('-', '')))
    }
    try {
        [System.IO.File]::WriteAllLines($path, $lines.ToArray())
        return $null
    } catch {
        return $_.Exception.Message
    }
}

# Hinweis auf Wow.exe.BAK, wenn sie das Original enthaelt.
function Show-BakHint {
    try {
        if (-not (Test-Path -LiteralPath $backup -PathType Leaf)) { return }
        if ((Get-Sha256 ([System.IO.File]::ReadAllBytes($backup))) -ne $EXPECTED_HASH) { return }
        Write-Host ''
        Say (T 'BakHint' $backup) 'Yellow'
    } catch { }
}

function Get-PatchById([string]$id) {
    foreach ($q in $patches) { if ($q.Id -eq $id) { return $q } }
    return $null
}

# Anzeigename auch fuer Ids, die es in dieser Version nicht mehr gibt.
function Get-NameById([string]$id) {
    $q = Get-PatchById $id
    if ($q) { return PatchName $q }
    return $id
}

# Vorschlag fuer einen Patch mit eigener Eingabe: der gemerkte Wert, sonst der
# Default; Patches mit Suggest berechnen ihren Vorschlag selbst (Build-Datum:
# heute). Ohne Rueckfragen (-Unattended) gilt der gemerkte Wert. Ist der Patch
# schon in der Wow.exe, ist sein aktueller Wert der Vorschlag.
function Test-ValueActive($p) {
    return ($script:patchedMode -and ($script:appliedIds -contains $p.Id) -and $script:state.Values.ContainsKey($p.Id))
}

function Get-ValueSuggestion($p) {
    $active = Test-ValueActive $p
    $saved = $script:savedValues[$p.Id]
    if ($active) { $saved = $script:state.Values[$p.Id] }
    $def = $saved
    if (-not $def) { $def = $p.Default }
    if ($p.Suggest -and -not $active -and -not ($Unattended -and $saved)) { $def = & $p.Suggest $saved }
    return $def
}

function Get-SelectedCount($sel) {
    $n = 0
    foreach ($s in $sel) { if ($s) { $n++ } }
    return $n
}

function Show-Menu($sel, [string]$message) {
    Clear-Host
    $total = $patches.Count
    $width = ([string]$total).Length
    Write-Host ''
    Say (T 'MenuTitle' (Get-SelectedCount $sel) $total) 'Cyan'
    Say ('=' * 70) 'Cyan'
    $lastCat = ''
    for ($i = 0; $i -lt $total; $i++) {
        if ($patches[$i].Cat -ne $lastCat) {
            $lastCat = $patches[$i].Cat
            $c = $CATEGORIES[$lastCat]
            if ($script:lang -eq 'en') { $title = $c.En } else { $title = $c.De }
            Write-Host "   -- $title --" -ForegroundColor Yellow
        }
        $nr = ([string]($i + 1)).PadLeft($width)
        $was = $script:patchedMode -and ($script:appliedIds -contains $patches[$i].Id)
        $name = PatchName $patches[$i]
        if ($sel[$i]) {
            $mark = ''; if ($script:patchedMode -and -not $was) { $mark = ' ' + (T 'MarkNew') }
            Write-Host "   $nr  [X]  $name$mark" -ForegroundColor Green
        } elseif ($was) {
            Write-Host "   $nr  [ ]  $name $(T 'MarkRemove')" -ForegroundColor Yellow
        } else {
            Write-Host "   $nr  [ ]  $name" -ForegroundColor DarkGray
        }
        if ($patches[$i].Url) {
            Write-Host "$(' ' * ($width + 10))$($patches[$i].Url)" -ForegroundColor DarkCyan
        }
    }
    Say ('=' * 70) 'Cyan'
    Say (T 'MenuHelp1')
    Say (T 'MenuHelp2')
    Say (T 'MenuHelp3')
    if ($message) {
        Write-Host ''
        Say $message 'Yellow'
    }
    Write-Host ''
}

# Interaktive Auswahl, beginnend mit $sel. Liefert das bool-Array oder $null
# bei Abbruch. Eine leere Auswahl gibt es nur fuer eine gepatchte Wow.exe -
# sie bedeutet: alle Patches zuruecknehmen.
function Select-Patches([bool[]]$sel, [string]$message) {
    while ($true) {
        Show-Menu $sel $message
        $message = ''
        $in = Ask "  $(T 'Prompt')"
        switch -regex ($in) {
            '^$' {
                if ((Get-SelectedCount $sel) -eq 0 -and -not $script:patchedMode) { $message = T 'NoneSelected'; break }
                return , $sel
            }
            '^[aA]$'   { for ($i = 0; $i -lt $sel.Length; $i++) { $sel[$i] = $true };  break }
            '^[nN]$'   { for ($i = 0; $i -lt $sel.Length; $i++) { $sel[$i] = $false }; break }
            '^[bB]$'   { $sel = Get-DefaultSelection; break }
            '^[lL]$'   {
                if ($script:lang -eq 'de') { $script:lang = 'en' } else { $script:lang = 'de' }
                Save-Language $script:lang
                break
            }
            '^[qQxX]$' { return $null }
            default {
                $idx = ConvertTo-Indices $in $sel.Length
                if ($null -eq $idx) { $message = T 'BadInput' $in; break }
                foreach ($i in $idx) { $sel[$i] = -not $sel[$i] }
            }
        }
    }
}

# Nicht-interaktive Auswahl ueber -Select. Liefert $null bei ungueltigem Wert.
function Get-SelectionFromParam([string]$value) {
    $v = $value.Trim().ToLowerInvariant()
    if ($v -eq 'billy' -or $v -eq 'default' -or $v -eq 'standard') { return , (Get-DefaultSelection) }
    if ($v -eq 'saved' -or $v -eq 'gespeichert') {
        $sel = Get-SavedSelection
        if ($null -eq $sel) { $sel = Get-DefaultSelection }
        return , $sel
    }
    $sel = New-Object bool[] $patches.Count
    if ($v -eq 'none' -or $v -eq 'keine' -or $v -eq 'original') { return , $sel }
    if ($v -eq 'all' -or $v -eq 'alle') {
        for ($i = 0; $i -lt $sel.Length; $i++) { $sel[$i] = $true }
        return , $sel
    }
    $idx = ConvertTo-Indices $v $sel.Length
    if ($null -eq $idx) { return $null }
    foreach ($i in $idx) { $sel[$i] = $true }
    return , $sel
}

# ============================================================
#  Banner in der figlet-Schrift "big"
#  Einzeilig ist es 136 Zeichen breit, das Standard-Konsolenfenster hat aber
#  nur 120 Spalten. Ist das Fenster schmaler als das Banner, kommt dieselbe
#  Schrift zweizeilig (max. 78 Zeichen), damit nichts umbricht.
#  Das Fenster wird bewusst NICHT per Skript verbreitert: Beim Start per
#  Doppelklick unter Windows 11 uebernimmt Windows Terminal das Fenster, die
#  Konsole meldet die neue Breite dann zwar, das Fenster bleibt aber schmal.
# ============================================================
$BANNER_WIDE = @'
  _____ _    ___                             _____ ____   __          ____          __               _____      _       _
 / ____| |  / _ \                      /\   |_   _/ __ \  \ \        / /\ \        / /              |  __ \    | |     | |
| (___ | |_| | | |_ __  _   _ ___     /  \    | || |  | |  \ \  /\  / /__\ \  /\  / / _____  _____  | |__) |_ _| |_ ___| |__   ___ _ __
 \___ \| __| | | | '_ \| | | / __|   / /\ \   | || |  | |   \ \/  \/ / _ \\ \/  \/ / / _ \ \/ / _ \ |  ___/ _` | __/ __| '_ \ / _ \ '__|
 ____) | |_| |_| | | | | |_| \__ \  / ____ \ _| || |__| |    \  /\  / (_) |\  /\  / |  __/>  <  __/ | |  | (_| | || (__| | | |  __/ |
|_____/ \__|\___/|_| |_|\__, |___/ /_/    \_\_____\____/      \/  \/ \___/  \/  \/ (_)___/_/\_\___| |_|   \__,_|\__\___|_| |_|\___|_|
                         __/ |
                        |___/
'@

$BANNER_NARROW = @'
  _____ _    ___                             _____ ____
 / ____| |  / _ \                      /\   |_   _/ __ \
| (___ | |_| | | |_ __  _   _ ___     /  \    | || |  | |
 \___ \| __| | | | '_ \| | | / __|   / /\ \   | || |  | |
 ____) | |_| |_| | | | | |_| \__ \  / ____ \ _| || |__| |
|_____/ \__|\___/|_| |_|\__, |___/ /_/    \_\_____\____/
                         __/ |
                        |___/

__          ____          __               _____      _       _
\ \        / /\ \        / /              |  __ \    | |     | |
 \ \  /\  / /__\ \  /\  / / _____  _____  | |__) |_ _| |_ ___| |__   ___ _ __
  \ \/  \/ / _ \\ \/  \/ / / _ \ \/ / _ \ |  ___/ _` | __/ __| '_ \ / _ \ '__|
   \  /\  / (_) |\  /\  / |  __/>  <  __/ | |  | (_| | || (__| | | |  __/ |
    \/  \/ \___/  \/  \/ (_)___/_/\_\___| |_|   \__,_|\__\___|_| |_|\___|_|
'@

function Show-Banner {
    $width = 0
    try { $width = [int]$Host.UI.RawUI.WindowSize.Width } catch { }
    if ($width -gt 0 -and $width -le 136) {
        Write-Host $BANNER_NARROW
    } else {
        Write-Host $BANNER_WIDE
    }
}

# ============================================================
#  ABLAUF
# ============================================================

Write-Host ''
Show-Banner
Write-Host ''

# --- 1. Sprache ---
# -Language geht vor, sonst die gemerkte Sprache; nur ohne beides wird gefragt
# (bei -Unattended gilt dann Deutsch). Die Wahl wird gemerkt.
$lang = $Language
$langFromSettings = $false
if (-not $lang) {
    $lang = Get-SavedLanguage
    if ($lang) { $langFromSettings = $true }
}
if (-not $lang -and $Unattended) { $lang = 'de' }
$askedLanguage = -not $lang
while (-not $lang) {
    Say 'Sprache waehlen / Choose language:'
    Say '  1 = Deutsch'
    Say '  2 = English'
    $in = (Ask '  [1/2]').ToLowerInvariant()
    switch ($in) {
        { $_ -eq '1' -or $_ -eq 'd' -or $_ -eq 'de' } { $lang = 'de' }
        { $_ -eq '2' -or $_ -eq 'e' -or $_ -eq 'en' } { $lang = 'en' }
    }
    Write-Host ''
}
if ($askedLanguage) { Save-Language $lang }

if ($langFromSettings) {
    Say (T 'LangInfo') 'DarkGray'
    Write-Host ''
}
Say (T 'Welcome1')
Say (T 'Welcome2')
Say (T 'Welcome3')
Write-Host ''
Say (T 'Welcome4')
Say (T 'Welcome5')
Write-Host ''
Say (T 'Thanks') 'Magenta'
Write-Host ''
if (-not $Unattended) {
    [void](Read-Host "  $(T 'PressStart')")
    Write-Host ''
}

# --- 2. Wow.exe vorhanden und original oder zuletzt von hier gepatcht? ---
# Beim ersten Start muss die Wow.exe original sein. Danach muss sie exakt die
# Datei sein, die der letzte Lauf erzeugt hat (Hash in patcher_state.ini);
# aus ihr wird dann das Original im Speicher rekonstruiert.
if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
    Say (T 'NotFound' $file) 'Red'
    Exit-Patcher 1
}

Say (T 'Checking')
$f = [System.IO.File]::ReadAllBytes($file)
$hash = Get-Sha256 $f
$state = $null
if ($hash -eq $EXPECTED_HASH) {
    Say (T 'HashOk') 'Green'
} else {
    $state = Read-State
    if ($null -eq $state -or $state.Hash -ne $hash) {
        Write-Host ''
        if ($null -eq $state) {
            Say (T 'HashBad1') 'Red'
            Say (T 'HashBad2') 'Red'
        } else {
            Say (T 'HashBadState1') 'Red'
            Say (T 'HashBadState2') 'Red'
        }
        Write-Host ''
        Say (T 'Expected' $EXPECTED_HASH)
        if ($null -ne $state) { Say (T 'ExpectedLast' $state.Hash) }
        Say (T 'Found' $hash)
        Write-Host ''
        if ($null -eq $state) { Say (T 'HashBad3') } else { Say (T 'HashBadState3') }
        Show-BakHint
        Exit-Patcher 1
    }
    $orig = Restore-Original $f $state
    if ($null -eq $orig) {
        Write-Host ''
        Say (T 'StateBroken1') 'Red'
        Say (T 'StateBroken2') 'Red'
        Show-BakHint
        Exit-Patcher 1
    }
    $f = $orig
    $patchedMode = $true
    $appliedIds = @($state.Ids)
    Say (T 'HashKnown' $appliedIds.Count) 'Green'
    Say (T 'RevertOk') 'Green'
}
Write-Host ''

# --- 3. Patches auswaehlen ---
$savedValues = Get-SavedValues
$fromMenu = $false
if ($Select) {
    $selection = Get-SelectionFromParam $Select
    if ($null -eq $selection) {
        Say (T 'BadSelect' $Select) 'Red'
        Exit-Patcher 1
    }
} else {
    $message = ''
    if ($patchedMode) {
        $initial = New-Object bool[] $patches.Count
        for ($i = 0; $i -lt $patches.Count; $i++) { $initial[$i] = $appliedIds -contains $patches[$i].Id }
        $message = T 'AppliedLoaded'
    } else {
        $initial = Get-SavedSelection
        if ($null -eq $initial) { $initial = Get-DefaultSelection } else { $message = T 'SavedLoaded' }
    }
    $selection = Select-Patches $initial $message
    if ($null -eq $selection) {
        Write-Host ''
        Say (T 'Aborted') 'Yellow'
        Exit-Patcher 2
    }
    Clear-Host
    $fromMenu = $true
}

$chosen = @()
$chosenIds = @()
for ($i = 0; $i -lt $patches.Count; $i++) {
    if ($selection[$i]) { $chosen += , $patches[$i]; $chosenIds += $patches[$i].Id }
}
if ($chosen.Count -eq 0 -and -not $patchedMode) {
    Say (T 'AlreadyOrig') 'Green'
    Exit-Patcher 0
}

# --- 3b. Werte fuer Patches mit eigener Eingabe (Vorschlag: Get-ValueSuggestion) ---
$VALUES = @{}
$asked = $false
foreach ($p in $chosen) {
    if (-not $p.Check) { continue }
    $def = Get-ValueSuggestion $p
    if ($Unattended) {
        $err = & $p.Check $def
        if ($err) {
            Say (T 'BadValue' (PatchName $p) $def) 'Red'
            Say $err 'Red'
            Exit-Patcher 1
        }
        $VALUES[$p.Id] = $def
        continue
    }
    if (-not $asked) {
        Write-Host ''
        Say (T 'InputHead') 'Cyan'
        $asked = $true
    }
    # Vorschlag bzw. aktuellen Wert hinter den Namen mit dem Originalwert schreiben
    $label = 'ValueSuggest'; if (Test-ValueActive $p) { $label = 'ValueNow' }
    Write-Host ''
    Say "$(PatchName $p) $(T $label $def)"
    while ($true) {
        $v = Ask "  $(L $p.PromptDe $p.PromptEn) [$def]"
        if ($v -eq '') { $v = $def }
        $err = & $p.Check $v
        if (-not $err) { break }
        Say $err 'Yellow'
    }
    $VALUES[$p.Id] = $v
}

if ($fromMenu) {
    $allValues = @{}
    foreach ($k in $savedValues.Keys) { $allValues[$k] = $savedValues[$k] }
    foreach ($k in $VALUES.Keys) { $allValues[$k] = $VALUES[$k] }
    Write-Host ''
    $saveError = Save-Selection $selection $allValues
    if ($saveError) { Say (T 'SaveFail' $saveError) 'Yellow' } else { Say (T 'Saved') 'DarkGray' }
}

# --- 4. Zusammenfassung, Hinweise, Bestaetigung ---
Write-Host ''
$added = @(); $changed = @(); $removed = @(); $kept = 0
if (-not $patchedMode) {
    Say (T 'Summary' $chosen.Count) 'Cyan'
    foreach ($p in $chosen) {
        if ($VALUES.ContainsKey($p.Id)) { Say "  - $(PatchName $p): $($VALUES[$p.Id])" } else { Say "  - $(PatchName $p)" }
        if ($p.Url) { Say "    $($p.Url)" 'DarkCyan' }
    }
} else {
    foreach ($p in $chosen) {
        if ($appliedIds -notcontains $p.Id) { $added += , $p }
        elseif ($VALUES.ContainsKey($p.Id) -and $VALUES[$p.Id] -cne $state.Values[$p.Id]) { $changed += , $p }
        else { $kept++ }
    }
    foreach ($id in $appliedIds) { if ($chosenIds -notcontains $id) { $removed += $id } }
    if ($added.Count + $changed.Count + $removed.Count -eq 0) {
        Say (T 'NoChange') 'Green'
        Exit-Patcher 0
    }
    if ($added.Count -gt 0) {
        Say (T 'SumAdd' $added.Count) 'Cyan'
        foreach ($p in $added) {
            if ($VALUES.ContainsKey($p.Id)) { Say "  + $(PatchName $p): $($VALUES[$p.Id])" 'Green' } else { Say "  + $(PatchName $p)" 'Green' }
            if ($p.Url) { Say "    $($p.Url)" 'DarkCyan' }
        }
    }
    if ($changed.Count -gt 0) {
        Say (T 'SumChange' $changed.Count) 'Cyan'
        foreach ($p in $changed) { Say "  ~ $(PatchName $p): $($state.Values[$p.Id]) -> $($VALUES[$p.Id])" 'Green' }
    }
    if ($removed.Count -gt 0) {
        Say (T 'SumRemove' $removed.Count) 'Cyan'
        foreach ($id in $removed) { Say "  - $(Get-NameById $id)" 'Yellow' }
    }
    Say (T 'SumKeep' $kept)
    if ($chosen.Count -eq 0) {
        Write-Host ''
        Say (T 'SumOriginal') 'Yellow'
    }
}

foreach ($p in $chosen) {
    if (-not $p.Needs) { continue }
    $missing = @()
    foreach ($id in $p.Needs) {
        if ($chosenIds -notcontains $id) {
            foreach ($q in $patches) { if ($q.Id -eq $id) { $missing += PatchName $q } }
        }
    }
    if ($missing.Count -gt 0) {
        Write-Host ''
        Say (T 'HintHead' (PatchName $p)) 'Yellow'
        Say (T 'Hint') 'Yellow'
        foreach ($m in $missing) { Say "  - $m" 'Yellow' }
    }
}
foreach ($p in $chosen) {
    if (-not $p.Obsoletes) { continue }
    $both = @()
    foreach ($id in $p.Obsoletes) {
        if ($chosenIds -contains $id) {
            foreach ($q in $patches) { if ($q.Id -eq $id) { $both += PatchName $q } }
        }
    }
    if ($both.Count -gt 0) {
        Write-Host ''
        Say (T 'HintHead' (PatchName $p)) 'Yellow'
        Say (T 'Obsolete') 'Yellow'
        foreach ($m in $both) { Say "  - $m" 'Yellow' }
    }
}
foreach ($p in $chosen) {
    if (-not $p.Conflicts) { continue }
    $both = @()
    foreach ($id in $p.Conflicts) {
        if ($chosenIds -contains $id) { $both += Get-NameById $id }
    }
    if ($both.Count -gt 0) {
        Write-Host ''
        Say (T 'HintHead' (PatchName $p)) 'Yellow'
        Say (T 'Conflict') 'Yellow'
        foreach ($m in $both) { Say "  - $m" 'Yellow' }
        Say (T 'ConflictBan') 'Red'
    }
}
$grow = @()
foreach ($p in $chosen) { if ($p.GrowsExe) { $grow += PatchName $p } }
if ($grow.Count -gt 0) {
    Write-Host ''
    Say (T 'GrowHead') 'Yellow'
    foreach ($m in $grow) { Say "  - $m" 'Yellow' }
    Say (T 'GrowBan') 'Red'
}
Write-Host ''

if (-not $Unattended) {
    $answer = (Ask "  $(T 'Confirm')").ToUpperInvariant()
    if ($answer -ne (T 'Yes') -and $answer -ne 'Y' -and $answer -ne 'J') {
        Write-Host ''
        Say (T 'Aborted') 'Yellow'
        Exit-Patcher 2
    }
    Write-Host ''
}

# --- 5. Backup (nur vom Original, eine vorhandene Sicherung bleibt sonst stehen) ---
if ($patchedMode) {
    Say (T 'BackupSkip')
} else {
    try {
        Copy-Item -LiteralPath $file -Destination $backup -Force
    } catch {
        Say (T 'BackupFail') 'Red'
        Say $_.Exception.Message 'Red'
        Exit-Patcher 1
    }
    Say (T 'BackupOk' $backup)
}
Write-Host ''
Say (T 'Starting')
Write-Host ''

# --- 6. Patchen (im Speicher) ---
# $f ist hier immer das Original (gelesen oder rekonstruiert); abgewaehlte
# Patches sind damit schon zurueckgenommen, die Auswahl wird neu eingespielt.
$origBytes = [byte[]]$f.Clone()
$writes.Clear()
foreach ($id in $removed) { Say "[-] $(Get-NameById $id)" 'Yellow' }
$total = $chosen.Count
$width = ([string]$total).Length
$cur = 0
try {
    foreach ($p in $chosen) {
        $cur++
        Say "[+] $(([string]$cur).PadLeft($width))/$total - $(PatchName $p)"
        & $p.Code
    }
    if ($total -gt 0) { Add-Watermark }
} catch {
    Write-Host ''
    Say (T 'PatchFail') 'Red'
    Say $_.Exception.Message 'Red'
    Say (T 'NotWritten') 'Red'
    Exit-Patcher 1
}

# --- 7. Zustand vorbereiten ---
# Erst die Original-Bytes sammeln und pruefen, dass sich das Ergebnis damit
# exakt zum Original zuruecknehmen laesst. Der neue Zustand geht zuerst in
# eine .tmp-Datei und ersetzt den alten erst, wenn die Wow.exe geschrieben ist.
$stateTmp = $stateFile + '.tmp'
if ($total -gt 0) {
    $undo = Get-UndoEntries $origBytes
    if ($null -eq (Restore-Original $f @{ Size = [int64]$origBytes.Length; Undo = $undo })) {
        Write-Host ''
        Say (T 'UndoFail') 'Red'
        Say (T 'NotWritten') 'Red'
        Exit-Patcher 1
    }
    $stateError = Write-State $stateTmp (Get-Sha256 $f) $origBytes.Length $chosenIds $VALUES $undo
    if ($stateError) {
        Write-Host ''
        Say (T 'StateFail') 'Red'
        Say $stateError 'Red'
        Say (T 'NotWritten') 'Red'
        Exit-Patcher 1
    }
}

# --- 8. Datei einmal zurueckschreiben ---
try {
    [System.IO.File]::WriteAllBytes($file, $f)
} catch {
    Write-Host ''
    Say (T 'WriteFail') 'Red'
    Say $_.Exception.Message 'Red'
    try { Remove-Item -LiteralPath $stateTmp -Force -ErrorAction SilentlyContinue } catch { }
    Exit-Patcher 1
}

# --- 9. Zustand uebernehmen (ohne Patches ist die Wow.exe original, dann weg damit) ---
$stateWarn = $null
try {
    if ($total -gt 0) {
        [System.IO.File]::Copy($stateTmp, $stateFile, $true)
        [System.IO.File]::Delete($stateTmp)
    } elseif (Test-Path -LiteralPath $stateFile -PathType Leaf) {
        [System.IO.File]::Delete($stateFile)
    }
} catch {
    $stateWarn = $_.Exception.Message
}

Write-Host ''
Say '============================================' 'Green'
if ($total -eq 0) {
    Say (T 'DoneOrig') 'Green'
} else {
    Say (T 'Done1') 'Green'
    if ($patchedMode) {
        Say (T 'Done3' $added.Count $changed.Count $removed.Count $total) 'Green'
    } else {
        Say (T 'Done2' $total) 'Green'
    }
}
Say '============================================' 'Green'
if ($stateWarn -and $total -gt 0) {
    Write-Host ''
    Say (T 'StateWarn1') 'Yellow'
    Say $stateWarn 'Yellow'
    Say (T 'StateWarn2') 'Yellow'
} elseif ($total -gt 0) {
    Write-Host ''
    Say (T 'StateSaved') 'DarkGray'
}
Exit-Patcher 0
