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
#                             "saved" (gespeicherte Auswahl), "default",
#                             "all" oder Nummern/Bereiche wie "1,3,5-8"
#    -Unattended              Keine Rueckfragen und keine Pausen
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
if (-not $Path) { $Path = Join-Path $scriptDir 'Wow.exe' }
$file = $Path
$backup = $file + '.BAK'
$settingsFile = Join-Path $scriptDir 'patcher_selection.ini'

# SHA256 der originalen Wow.exe 3.3.5a (Build 12340)
$EXPECTED_HASH = 'AA63A5750D60EF16746C686B3D5E26876D98953EAB08B1C026CD0FAF78E88CB8'

# Datei-Inhalt, wird einmal gelesen, im Speicher gepatcht und einmal geschrieben
$f = $null

function Patch([int64]$offset, [byte[]]$bytes) {
    [System.Array]::Copy($bytes, 0, $script:f, $offset, $bytes.Length)
}

# ============================================================
#  Texte (Deutsch / English)
# ============================================================
$TEXT = @{
    de = @{
        Welcome1      = 'Willkommen. Dieses Tool patcht deine Wow.exe mit'
        Welcome2      = 'Verbesserungen: Bugfixes, Performance-Optimierungen,'
        Welcome3      = 'erweiterte Sichtweiten und verbesserte Sound-Einstellungen.'
        Welcome4      = 'Ein Backup wird automatisch als Wow.exe.BAK erstellt.'
        PressStart    = 'ENTER druecken um zu starten'
        NotFound      = '[FEHLER] Keine Wow.exe gefunden: {0}'
        Checking      = 'Pruefe Wow.exe Integritaet...'
        HashBad1      = '[FEHLER] Die Wow.exe ist nicht die originale Datei.'
        HashBad2      = '         Sie wurde bereits gepatcht oder ist eine andere Version.'
        Expected      = 'Erwartet:  {0}'
        Found         = 'Gefunden:  {0}'
        HashBad3      = 'Bitte eine unmodifizierte Wow.exe verwenden.'
        HashOk        = '[OK] Wow.exe ist original und unmodifiziert.'
        MenuTitle     = 'PATCH-AUSWAHL  ({0} von {1} ausgewaehlt)'
        MenuHelp1     = 'Nummer(n) eingeben um Patches an-/abzuwaehlen, z.B.:  5   oder  3 7 12   oder  10-15'
        MenuHelp2     = 'A = alle an    N = alle aus    Q = abbrechen'
        MenuHelp3     = 'ENTER = Auswahl uebernehmen, speichern und weiter'
        SavedLoaded   = 'Deine gespeicherte Auswahl vom letzten Mal wurde geladen.'
        Saved         = 'Auswahl fuer den naechsten Start gespeichert.'
        SaveFail      = 'HINWEIS: Auswahl konnte nicht gespeichert werden: {0}'
        Prompt        = 'Eingabe'
        BadInput      = 'Ungueltige Eingabe: {0}'
        NoneSelected  = 'Es ist kein Patch ausgewaehlt.'
        BadSelect     = '[FEHLER] Ungueltiger Wert fuer -Select: {0}'
        Summary       = 'Folgende {0} Patches werden eingespielt:'
        Hint          = 'HINWEIS: "{0}" wirkt nur vollstaendig zusammen mit:'
        Confirm       = 'Patchen jetzt starten? (J/N)'
        Yes           = 'J'
        Aborted       = 'Abgebrochen. Die Wow.exe wurde nicht veraendert.'
        BackupFail    = '[FEHLER] Konnte Wow.exe nicht sichern. Abbruch.'
        BackupOk      = 'Backup der Wow.exe erfolgreich erstellt: {0}'
        Starting      = 'Starte Patch-Vorgang...'
        PatchFail     = '[FEHLER] Beim Patchen ist ein Fehler aufgetreten:'
        NotWritten    = 'Die Wow.exe wurde nicht veraendert.'
        WriteFail     = '[FEHLER] Konnte die Wow.exe nicht schreiben (laeuft WoW noch?):'
        Done1         = '[FERTIG] Wow.exe wurde erfolgreich gepatcht.'
        Done2         = 'Gesamt: {0} Patches eingespielt.'
        PressEnter    = 'ENTER druecken zum Beenden'
    }
    en = @{
        Welcome1      = 'Welcome. This tool patches your Wow.exe with'
        Welcome2      = 'improvements: bug fixes, performance optimizations,'
        Welcome3      = 'extended view distances and improved sound settings.'
        Welcome4      = 'A backup is created automatically as Wow.exe.BAK.'
        PressStart    = 'Press ENTER to start'
        NotFound      = '[ERROR] No Wow.exe found: {0}'
        Checking      = 'Checking Wow.exe integrity...'
        HashBad1      = '[ERROR] This Wow.exe is not the original file.'
        HashBad2      = '        It has already been patched or is a different version.'
        Expected      = 'Expected:  {0}'
        Found         = 'Found:     {0}'
        HashBad3      = 'Please use an unmodified Wow.exe.'
        HashOk        = '[OK] Wow.exe is original and unmodified.'
        MenuTitle     = 'PATCH SELECTION  ({0} of {1} selected)'
        MenuHelp1     = 'Enter number(s) to toggle patches, e.g.:  5   or  3 7 12   or  10-15'
        MenuHelp2     = 'A = all on    N = all off    Q = quit'
        MenuHelp3     = 'ENTER = accept and save selection, continue'
        SavedLoaded   = 'Your saved selection from last time has been loaded.'
        Saved         = 'Selection saved for next time.'
        SaveFail      = 'NOTE: Could not save the selection: {0}'
        Prompt        = 'Input'
        BadInput      = 'Invalid input: {0}'
        NoneSelected  = 'No patch is selected.'
        BadSelect     = '[ERROR] Invalid value for -Select: {0}'
        Summary       = 'The following {0} patches will be applied:'
        Hint          = 'NOTE: "{0}" only takes full effect together with:'
        Confirm       = 'Start patching now? (Y/N)'
        Yes           = 'Y'
        Aborted       = 'Aborted. Wow.exe has not been modified.'
        BackupFail    = '[ERROR] Could not back up Wow.exe. Aborting.'
        BackupOk      = 'Backup of Wow.exe created successfully: {0}'
        Starting      = 'Starting patch process...'
        PatchFail     = '[ERROR] An error occurred while patching:'
        NotWritten    = 'Wow.exe has not been modified.'
        WriteFail     = '[ERROR] Could not write Wow.exe (is WoW still running?):'
        Done1         = '[DONE] Wow.exe has been patched successfully.'
        Done2         = 'Total: {0} patches applied.'
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
    if ($script:lang -eq 'en') { return $p.En } else { return $p.De }
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
#  Anders als alle anderen Patches veraendert dieser die Dateigroesse/PE-Struktur.
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
    [Array]::Copy([BitConverter]::GetBytes([uint16]($nsec + 1)), 0, $script:f, ($e + 6), 2)
    [Array]::Copy([BitConverter]::GetBytes([uint32](AlignUp ($new_rva + $vsize) $SA)), 0, $script:f, ($e + 24 + 56), 4)
    $hoff = $sectBase + 40 * $nsec
    $sh = New-Object byte[] 40
    [Array]::Copy([System.Text.Encoding]::ASCII.GetBytes('.hdp'), 0, $sh, 0, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$vsize), 0, $sh, 8, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$new_rva), 0, $sh, 12, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$raw_size), 0, $sh, 16, 4)
    [Array]::Copy([BitConverter]::GetBytes([uint32]$new_raw), 0, $sh, 20, 4)
    [Array]::Copy([byte[]](0x60, 0x00, 0x00, 0xE0), 0, $sh, 36, 4)                    # chars = 0xE0000060 (RWX | init data)
    [Array]::Copy($sh, 0, $script:f, $hoff, 40)

    # --- In-Place-Edits: Aufruf-Sites auf die Caves umbiegen, Groessen auf SIZE ---
    $toRT = $TRO + ($S_RT - $TVA); $toTEX = $TRO + ($S_TEX - $TVA)
    $toRD = $TRO + ($S_READ - $TVA); $toMK = $TRO + ($S_MASK - $TVA); $toMF = $TRO + ($MASKFN - $TVA)
    [Array]::Copy([BitConverter]::GetBytes([int32]($cA - ($S_RT + 5))), 0, $script:f, ($toRT + 1), 4)
    [Array]::Copy([BitConverter]::GetBytes([int32]($cB - ($S_TEX + 5))), 0, $script:f, ($toTEX + 1), 4)
    [Array]::Copy([BitConverter]::GetBytes([int32]$SIZE), 0, $script:f, ($toRD + 1), 4)
    [Array]::Copy([BitConverter]::GetBytes([int32]$SIZE), 0, $script:f, ($toMK + 1), 4)
    $hook = New-Object byte[] 9
    $hook[0] = 0xE9
    [Array]::Copy([BitConverter]::GetBytes([int32]($det_va - ($MASKFN + 5))), 0, $hook, 1, 4)
    $hook[5] = 0x90; $hook[6] = 0x90; $hook[7] = 0x90; $hook[8] = 0x90
    [Array]::Copy($hook, 0, $script:f, $toMF, 9)
}

# ============================================================
#  PATCH-DEFINITIONEN
#  Jeder Patch ist eine Hashtable:
#    Id    - interner Kurzname (fuer Abhaengigkeiten)
#    De/En - Anzeigename je Sprache
#    On    - im Auswahlmenue vorausgewaehlt ($true) oder nicht ($false)
#    Needs - optional: Ids von Patches, ohne die dieser nicht voll wirkt
#            (erzeugt nur einen Hinweis, keine Sperre)
#    Code  - Scriptblock mit den Patch-Aufrufen
#  Die Reihenfolge hier ist die Reihenfolge im Menue und beim Einspielen.
# ============================================================

$patches = @(

    @{ Id = '4gb'; On = $true
       De = '4GB-Patch (Large Address Aware)'
       En = '4GB patch (Large Address Aware)'
       Code = {
        Patch 0x126 @(0x23)
    }}

    @{ Id = 'glue'; On = $true
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

    @{ Id = 'mpqsig'; On = $true
       De = 'Falsch/Nicht signierte MPQs zulassen'
       En = 'Allow unsigned / incorrectly signed MPQs'
       Code = {
        Patch 0x021350 @(0x55, 0x8B, 0xEC, 0xB9, 0x05, 0x00, 0x00, 0x00, 0x8B, 0x45, 0x0C, 0x89, 0x08, 0xB8, 0x01, 0x00, 0x00, 0x00, 0x5D, 0xC2, 0x18, 0x00)
    }}

    @{ Id = 'scandll'; On = $true
       De = 'Scan DLL deaktivieren'
       En = 'Disable scan DLL'
       Code = {
        Patch 0x5F4D56 @(0xC7, 0xC7)
        Patch 0x5F4D62 @(0xC7, 0xC7)
    }}

    @{ Id = 'cache'; On = $true
       De = 'CACHE Ordner Erstellung deaktivieren'
       En = 'Disable CACHE folder creation'
       Code = {
        Patch 0x61BE58 @(0x7C, 0x7C)
    }}

    @{ Id = 'itemcache'; On = $true
       De = 'Item-Cache sofort aktualisieren'
       En = 'Refresh item cache immediately'
       Code = {
        Patch 0x2689FD @(0x00, 0x00)
    }}

    @{ Id = 'rce'; On = $true
       De = 'Remote Code Execution Exploit Fix'
       En = 'Remote code execution exploit fix'
       Code = {
        Patch 0x2A7 @(0xC0)
        Patch 0x3D9D7C @(0x90, 0x90)
    }}

    @{ Id = 'afk'; On = $true
       De = 'AFK Timer IDLE Check deaktiviert'
       En = 'Disable AFK timer idle check'
       Code = {
        Patch 0x12A3AF @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
        Patch 0x12A64C @(0xE9, 0xB1, 0x06, 0x42, 0x00)
        Patch 0x54AD02 @(0xE8, 0x19, 0xF5, 0xF1, 0xFF, 0x83, 0x3D, 0xA4, 0x99, 0xB4, 0x00, 0x00, 0x75, 0x05, 0xA3, 0xA4, 0x99, 0xB4, 0x00, 0xE9, 0x37, 0xF9, 0xBD, 0xFF)
    }}

    @{ Id = 'areatrigger'; On = $true
       De = 'Area-Trigger-Timer Verbesserung (250ms auf 50ms)'
       En = 'Area trigger timer accuracy (250 ms to 50 ms)'
       Code = {
        Patch 0x2DB241 @(0x32)
    }}

    @{ Id = 'mpqnames'; On = $true
       De = 'Erweiterte MPQ-Namen erlauben'
       En = 'Allow extended MPQ names'
       Code = {
        Patch 0x5E0F09 @(0x2A)
        Patch 0x5E0F16 @(0x2A)
    }}

    @{ Id = 'swing'; On = $true
       De = 'Nahkampf-Schwung bei Rechtsklick entfernt'
       En = 'Remove melee swing on right-click'
       Code = {
        Patch 0x2E1C67 @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'npcanim'; On = $true
       De = 'NPC-Angriffsanimation beim Drehen unterdrueckt'
       En = 'Suppress NPC attack animation when turning'
       Code = {
        Patch 0x33D7C9 @(0xEB)
    }}

    @{ Id = 'spellanim'; On = $true
       De = 'Zauber-Animation nach Abbruch repariert'
       En = 'Fix spell animation after cancelled channel'
       Code = {
        Patch 0x33E0D6 @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'bluemoon'; On = $true
       De = 'Blauer Mond am Nachthimmel reaktiviert'
       En = 'Re-enable the blue moon in the night sky'
       Code = {
        Patch 0x5CFBC0 @(0xC7, 0x05, 0x74, 0x8E, 0xD3, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xC3)
    }}

    @{ Id = 'naked'; On = $true
       De = 'Nackter-Charakter-Bug behoben'
       En = 'Fix naked character bug'
       Code = {
        Patch 0x1DDC5D @(0xEB)
    }}

    @{ Id = 'forcereaction'; On = $true
       De = 'Force-Reaction bei /reload erhalten'
       En = 'Keep force reaction on /reload'
       Code = {
        Patch 0x12811E @(0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'tracker'; On = $true
       De = 'Quest-Tracker automatisch sortieren'
       En = 'Auto-sort quest tracker'
       Code = {
        Patch 0x11D4C5 @(0x64, 0x14, 0x9E, 0x00)
    }}

    @{ Id = 'worldmap'; On = $true
       De = 'Erweiterte Weltkarte standardmaessig aktiv'
       En = 'Advanced world map enabled by default'
       Code = {
        Patch 0x11D462 @(0x64, 0x14, 0x9E, 0x00)
    }}

    @{ Id = 'farclip'; On = $true
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

    @{ Id = 'horizon'; On = $true
       De = 'CVar horizonFarclipScale unlock (max 12)'
       En = 'CVar horizonFarclipScale unlock (max 12)'
       Code = {
        Patch 0x38CBDF @(0x7C, 0x04, 0xA1, 0x00)
    }}

    @{ Id = 'envdetail'; On = $true
       De = 'CVar environmentDetail unlock (kein Limit statt 1.5)'
       En = 'CVar environmentDetail unlock (no limit instead of 1.5)'
       Code = {
        Patch 0x38D08E @(0xD8)
    }}

    @{ Id = 'grounddist'; On = $true
       De = 'CVar groundEffectDist unlock (max 3166 statt 140)'
       En = 'CVar groundEffectDist unlock (max 3166 instead of 140)'
       Code = {
        Patch 0x5E74FC @(0xAB, 0xEA, 0x45, 0x45)
    }}

    @{ Id = 'sliders'; On = $true; Needs = @('farclip', 'envdetail', 'grounddist')
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

    @{ Id = 'window'; On = $true
       De = 'Fenstermodus als Standard setzen'
       En = 'Windowed mode by default'
       Code = {
        Patch 0x369A7D @(0x64, 0x14, 0x9E)
    }}

    @{ Id = 'maximize'; On = $true
       De = 'Fenstermodus maximiert als Standard setzen'
       En = 'Maximized window by default'
       Code = {
        Patch 0x369AB2 @(0x64, 0x14, 0x9E)
    }}

    @{ Id = 'castbars'; On = $true
       De = 'Cast Bars auf allen Frames'
       En = 'Cast bars on all frames'
       Code = {
        Patch 0x123676 @(0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90)
    }}

    @{ Id = 'maxchars'; On = $true
       De = 'Max Characters pro Server auf 255 erhoeht'
       En = 'Max characters per realm raised to 255'
       Code = {
        Patch 0x6404F @(0xFF)
    }}

    @{ Id = 'emblems'; On = $true; Needs = @('mpqnames')
       De = 'Retail-Gildenembleme: Auswahl von 170 auf 196 erweitert'
       En = 'Retail guild emblems: selection extended from 170 to 196'
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
        # "Erweiterte MPQ-Namen erlauben" weiter oben.
        Patch 0x613108 @(0xC4)
    }}

    @{ Id = 'mouse'; On = $true
       De = 'Mausflackern / Kameraspruenge Fix'
       En = 'Mouse flicker / camera jump fix'
       Code = {
        Patch 0x469A2C @(0xE9, 0x71, 0xF0, 0x0B, 0x00, 0xF8, 0x13, 0xD4, 0x00, 0x8B, 0x1D, 0xFC)
        Patch 0x528AA2 @(0x8D, 0x4D, 0xF0, 0x51, 0x57, 0xFF, 0x15, 0xDC, 0xF5, 0x9D, 0x00, 0x8B, 0x45, 0xF0, 0x8B, 0x15, 0xF8, 0x13, 0xD4, 0x00, 0xE9, 0x7A, 0x0F, 0xF4, 0xFF)
        Patch 0x4691B1 @(0x89, 0xE5, 0x8B, 0x05, 0xFC, 0x13, 0xD4, 0x00, 0x8B, 0x0D, 0xF8, 0x13, 0xD4, 0x00, 0xEB, 0xC2, 0x7D, 0x03, 0x83, 0xC1, 0x01, 0x83, 0xC0, 0x32, 0x83, 0xC1, 0x32, 0x3B, 0x0D, 0xEC, 0xBC, 0xCA, 0x00, 0x7E, 0x03, 0x83, 0xE9, 0x01, 0x3B, 0x05, 0xF0, 0xBC, 0xCA, 0x00, 0x7E, 0x03, 0x83, 0xE8, 0x01, 0x83, 0xE9, 0x32, 0x83, 0xE8, 0x32, 0x89, 0x0D, 0xF8, 0x13, 0xD4, 0x00, 0x89, 0x05, 0xFC, 0x13, 0xD4, 0x00, 0x89, 0xEC, 0x5D, 0xE9, 0xB4, 0xF7, 0xFF, 0xFF, 0xEC, 0x5D, 0xC3, 0xC3)
        Patch 0x469183 @(0x83, 0xF8, 0x32, 0x7D, 0x03, 0x83, 0xC0, 0x01, 0x83, 0xF9, 0x32, 0xEB, 0x31)
    }}

    @{ Id = 'goscale'; On = $true; Needs = @('envdetail')
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

    @{ Id = 'cat0'; On = $true
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

    @{ Id = 'occluder'; On = $true
       De = 'Occluder Fix fuer Stormwind (Open Azeroth)'
       En = 'Occluder fix for Stormwind (Open Azeroth)'
       Code = {
        Patch 0x6EE040 @(0x9F, 0x86, 0x01, 0x00)
    }}

    @{ Id = 'awesome'; On = $true
       De = 'AwesomeWotlkLib.dll Unterstuetzung aktivieren'
       En = 'Enable AwesomeWotlkLib.dll support'
       Code = {
        Patch 0xABD0 @(0xE9, 0xDB, 0xA4, 0x0D, 0x00, 0x90, 0x90, 0x90)
        Patch 0xDC0F0 @(0xB8, 0x00, 0x00, 0x00, 0x00, 0xC3)
        Patch 0xE50B0 @(0xB8, 0x01, 0x00, 0x00, 0x00, 0xA3, 0x74, 0xB4, 0xB6, 0x00, 0x68, 0xE0, 0x5C, 0x4E, 0x00, 0xE8, 0x1C, 0x68, 0x38, 0x00, 0x83, 0xC4, 0x04, 0x55, 0x8B, 0xEC, 0xE8, 0xA1, 0x10, 0xF2, 0xFF, 0xE9, 0x04, 0x5B, 0xF2, 0xFF, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0x41, 0x77, 0x65, 0x73, 0x6F, 0x6D, 0x65, 0x57, 0x6F, 0x74, 0x6C, 0x6B, 0x4C, 0x69, 0x62, 0x2E, 0x64, 0x6C, 0x6C, 0x00)
    }}

    @{ Id = 'sound'; On = $true
       De = 'Sound-Einstellungen optimieren'
       En = 'Optimize sound settings'
       Code = {
        Patch 0x0C77C2 @(0xC7, 0x45, 0xF8, 0x7E, 0x00, 0x00, 0x00, 0x90, 0x90, 0x90)
        Patch 0x6B3F80 @(0x36, 0x34, 0x00)
        Patch 0x6B3F84 @(0x32, 0x00)
        Patch 0x0D0604 @(0x68, 0x84, 0x57, 0xAB, 0x00)
        Patch 0x0D0624 @(0x68, 0x80, 0x57, 0xAB, 0x00)
        Patch 0x0D064A @(0x68, 0x64, 0x14, 0x9E, 0x00)
        Patch 0x0D077F @(0x68, 0x64, 0x14, 0x9E, 0x00)
    }}

    @{ Id = 'flash'; On = $true
       De = 'FlashWindow Patch'
       En = 'FlashWindow patch'
       Code = {
        # Datei-Offsets: VA 0x134ED5 -> File 0x1342D5 / VA 0x6086E4 -> File 0x606EE4
        Patch 0x1342D5 @(0x14, 0x68, 0xD8, 0x4C, 0x9E, 0x00, 0xFF, 0x15, 0xB0, 0xF1, 0x9D, 0x00, 0x68, 0xE4, 0x86, 0xA0, 0x00, 0x50, 0xE8, 0xCD, 0x7E, 0xEE, 0xFF, 0x6A, 0x00, 0xB9, 0x20, 0x16, 0xD4, 0x00, 0xFF, 0x31, 0xFF, 0xD0, 0xB8, 0x00, 0x00, 0x00, 0x00, 0xC9, 0xC3, 0xCC)
        Patch 0x606EE4 @(0x46, 0x6C, 0x61, 0x73, 0x68, 0x57, 0x69, 0x6E, 0x64, 0x6F, 0x77, 0x00, 0x00, 0x00)
    }}

    @{ Id = 'hdportraits'; On = $true
       De = 'HD Unit-Frame Portraits: 256x256 (live 3D-Portraits)'
       En = 'HD unit frame portraits: 256x256 (live 3D portraits)'
       Code = {
        # Haengt die .hdp-Sektion an und biegt den Model-Render-Pfad auf 256px um.
        Add-HdPortraits 256
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

# Auswahl in patcher_selection.ini schreiben. Liefert $null oder die Fehlermeldung.
function Save-Selection($sel) {
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# St0nys-AIO-WoW-EXE-Patcher - gespeicherte Patch-Auswahl / saved patch selection")
    $lines.Add('# 1 = an / on, 0 = aus / off')
    $lines.Add('# Datei loeschen setzt die Auswahl zurueck / delete this file to reset the selection')
    for ($i = 0; $i -lt $patches.Count; $i++) {
        $v = 0; if ($sel[$i]) { $v = 1 }
        $lines.Add("$($patches[$i].Id)=$v")
    }
    try {
        [System.IO.File]::WriteAllLines($settingsFile, $lines.ToArray())
        return $null
    } catch {
        return $_.Exception.Message
    }
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
    for ($i = 0; $i -lt $total; $i++) {
        $nr = ([string]($i + 1)).PadLeft($width)
        if ($sel[$i]) {
            Write-Host "   $nr  [X]  $(PatchName $patches[$i])" -ForegroundColor Green
        } else {
            Write-Host "   $nr  [ ]  $(PatchName $patches[$i])" -ForegroundColor DarkGray
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

# Interaktive Auswahl. Liefert das bool-Array oder $null bei Abbruch.
function Select-Patches {
    $sel = Get-SavedSelection
    $message = ''
    if ($null -eq $sel) { $sel = Get-DefaultSelection } else { $message = T 'SavedLoaded' }
    while ($true) {
        Show-Menu $sel $message
        $message = ''
        $in = (Read-Host "  $(T 'Prompt')").Trim()
        switch -regex ($in) {
            '^$' {
                if ((Get-SelectedCount $sel) -eq 0) { $message = T 'NoneSelected'; break }
                return , $sel
            }
            '^[aA]$'   { for ($i = 0; $i -lt $sel.Length; $i++) { $sel[$i] = $true };  break }
            '^[nN]$'   { for ($i = 0; $i -lt $sel.Length; $i++) { $sel[$i] = $false }; break }
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
    if ($v -eq 'default' -or $v -eq 'standard') { return , (Get-DefaultSelection) }
    if ($v -eq 'saved' -or $v -eq 'gespeichert') {
        $sel = Get-SavedSelection
        if ($null -eq $sel) { $sel = Get-DefaultSelection }
        return , $sel
    }
    $sel = New-Object bool[] $patches.Count
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
$lang = $Language
while (-not $lang) {
    Say 'Sprache waehlen / Choose language:'
    Say '  1 = Deutsch'
    Say '  2 = English'
    $in = (Read-Host '  [1/2]').Trim().ToLowerInvariant()
    switch ($in) {
        { $_ -eq '1' -or $_ -eq 'd' -or $_ -eq 'de' } { $lang = 'de' }
        { $_ -eq '2' -or $_ -eq 'e' -or $_ -eq 'en' } { $lang = 'en' }
    }
    Write-Host ''
}

Say (T 'Welcome1')
Say (T 'Welcome2')
Say (T 'Welcome3')
Write-Host ''
Say (T 'Welcome4')
Write-Host ''
if (-not $Unattended) {
    [void](Read-Host "  $(T 'PressStart')")
    Write-Host ''
}

# --- 2. Wow.exe vorhanden und original? ---
if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
    Say (T 'NotFound' $file) 'Red'
    Exit-Patcher 1
}

Say (T 'Checking')
$f = [System.IO.File]::ReadAllBytes($file)
$sha = [System.Security.Cryptography.SHA256]::Create()
$hash = ([BitConverter]::ToString($sha.ComputeHash($f))).Replace('-', '')
if ($hash -ne $EXPECTED_HASH) {
    Write-Host ''
    Say (T 'HashBad1') 'Red'
    Say (T 'HashBad2') 'Red'
    Write-Host ''
    Say (T 'Expected' $EXPECTED_HASH)
    Say (T 'Found' $hash)
    Write-Host ''
    Say (T 'HashBad3')
    Exit-Patcher 1
}
Say (T 'HashOk') 'Green'
Write-Host ''

# --- 3. Patches auswaehlen ---
if ($Select) {
    $selection = Get-SelectionFromParam $Select
    if ($null -eq $selection) {
        Say (T 'BadSelect' $Select) 'Red'
        Exit-Patcher 1
    }
} else {
    $selection = Select-Patches
    if ($null -eq $selection) {
        Write-Host ''
        Say (T 'Aborted') 'Yellow'
        Exit-Patcher 2
    }
    Clear-Host
    Write-Host ''
    $saveError = Save-Selection $selection
    if ($saveError) { Say (T 'SaveFail' $saveError) 'Yellow' } else { Say (T 'Saved') 'DarkGray' }
}

$chosen = @()
$chosenIds = @()
for ($i = 0; $i -lt $patches.Count; $i++) {
    if ($selection[$i]) { $chosen += , $patches[$i]; $chosenIds += $patches[$i].Id }
}

# --- 4. Zusammenfassung, Hinweise, Bestaetigung ---
Write-Host ''
Say (T 'Summary' $chosen.Count) 'Cyan'
foreach ($p in $chosen) { Say "  - $(PatchName $p)" }

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
        Say (T 'Hint' (PatchName $p)) 'Yellow'
        foreach ($m in $missing) { Say "  - $m" 'Yellow' }
    }
}
Write-Host ''

if (-not $Unattended) {
    $answer = (Read-Host "  $(T 'Confirm')").Trim().ToUpperInvariant()
    if ($answer -ne (T 'Yes') -and $answer -ne 'Y' -and $answer -ne 'J') {
        Write-Host ''
        Say (T 'Aborted') 'Yellow'
        Exit-Patcher 2
    }
    Write-Host ''
}

# --- 5. Backup ---
try {
    Copy-Item -LiteralPath $file -Destination $backup -Force
} catch {
    Say (T 'BackupFail') 'Red'
    Say $_.Exception.Message 'Red'
    Exit-Patcher 1
}
Say (T 'BackupOk' $backup)
Write-Host ''
Say (T 'Starting')
Write-Host ''

# --- 6. Patchen (im Speicher) ---
$total = $chosen.Count
$width = ([string]$total).Length
$cur = 0
try {
    foreach ($p in $chosen) {
        $cur++
        Say "[+] $(([string]$cur).PadLeft($width))/$total - $(PatchName $p)"
        & $p.Code
    }
} catch {
    Write-Host ''
    Say (T 'PatchFail') 'Red'
    Say $_.Exception.Message 'Red'
    Say (T 'NotWritten') 'Red'
    Exit-Patcher 1
}

# --- 7. Datei einmal zurueckschreiben ---
try {
    [System.IO.File]::WriteAllBytes($file, $f)
} catch {
    Write-Host ''
    Say (T 'WriteFail') 'Red'
    Say $_.Exception.Message 'Red'
    Exit-Patcher 1
}

Write-Host ''
Say '============================================' 'Green'
Say (T 'Done1') 'Green'
Say (T 'Done2' $total) 'Green'
Say '============================================' 'Green'
Exit-Patcher 0
