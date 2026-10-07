# St0nys-AIO-WoW-EXE-Patcher

[🇩🇪 Deutsch](README.de.md) | 🇬🇧 English

An all-in-one (AIO) patcher for the `Wow.exe` of **World of Warcraft 3.3.5a
(build 12340)**. It applies bug fixes, performance optimizations, extended view
distances, improved sound settings and a few quality-of-life features directly
to the executable – in a single pass, without extra tools or DLL injectors.

On start you choose the **language** (Deutsch / English) and then pick
**which patches** to apply from a menu. Applied patches can be **deselected or
extended** at any time later – all the way back to the original `Wow.exe`.

> [!IMPORTANT]
> This repository does **not** contain a `Wow.exe` or any other Blizzard files.
> You need your own unmodified `Wow.exe` 3.3.5a (12340).

> [!WARNING]
> **Use at your own risk.** Patches without a warning have been tested in game
> and should be harmless on public servers as well – but there is no 100 %
> guarantee: what a server detects and tolerates is up to the server and
> changes from time to time. All other patches carry a uniform warning in the
> overview and in the patcher (see [Notes](#notes)). If in doubt, check the
> rules of your server before using a patched `Wow.exe` there. The patcher
> also shows this note on every start.

---

## Contents

- [Requirements](#requirements)
- [Usage](#usage)
- [Workflow](#workflow)
- [Patch selection](#patch-selection)
- [Changing or removing patches](#changing-or-removing-patches)
- [Parameters for unattended use](#parameters-for-unattended-use)
- [Files](#files)
- [Patch overview](#patch-overview)
- [Patch descriptions](#patch-descriptions)
- [Notes](#notes)
- [Acknowledgements](#acknowledgements)
- [License](#license)

---

## Requirements

- Windows with PowerShell (Windows PowerShell 5.1 ships with Windows 10 and later)
- An **original, unmodified** `Wow.exe` 3.3.5a, build 12340 with
  SHA256 `AA63A5750D60EF16746C686B3D5E26876D98953EAB08B1C026CD0FAF78E88CB8`
  (only on the first start; after that a `Wow.exe` patched with this patcher is
  enough)

## Usage

1. Copy `patcher.bat` and `apply_patches.ps1` into your WoW folder
   (next to `Wow.exe`).
2. Close WoW if it is still running.
3. Double-click `patcher.bat`.
4. Choose the language (first start only), select patches, confirm – done.

To **change or remove** patches just run `patcher.bat` again, see
[Changing or removing patches](#changing-or-removing-patches).

> [!NOTE]
> Windows will probably warn about an unsigned, potentially harmful app when
> you start the patched `Wow.exe`. This happens with every modified `Wow.exe`:
> any change invalidates Blizzard's digital signature, and a new signature that
> Windows accepts cannot be created for a modified Blizzard file. It still
> starts, e.g. via "More info" → "Run anyway". More on this under
> [Notes](#notes).

## Workflow

1. The ASCII banner is shown.
2. **Language selection:** `1` = Deutsch, `2` = English. First start only – after
   that the language is remembered and can be switched with `L` in the menu.
3. Welcome message, press ENTER to start.
4. Check that a `Wow.exe` exists in the folder.
5. Checking `Wow.exe`: on the first start it must be original and unmodified
   (SHA256). After that the patcher recognizes a `Wow.exe` it patched itself
   by the watermark and determines which patches are in it. Anything else
   aborts.
6. **Patch selection** menu (see below). Your selection from last time is
   preselected, or for a patched `Wow.exe` the patches currently in it.
7. For patches with their own value (jump height, double jump, client info) the
   patcher asks for the values; then it saves the selection.
8. Summary of the selected patches (for a patched `Wow.exe`: what is added and
   what is removed), notes (missing or redundant companion patches, warnings)
   and a confirmation prompt (Y/N).
9. Backup: on the first patch run the original is saved as `Wow.exe.ORI`, on
   every later run the previous `Wow.exe` is saved as `Wow.exe.BAK`.
10. All selected patches are applied in memory (with progress output) and
    `Wow.exe` is written back **once**. If anything fails, `Wow.exe` stays
    untouched.
11. The patcher remembers the hash of the new `Wow.exe` together with the
    original bytes in `patcher_state.ini` (for a faster next start) and shows a
    final message.

## Patch selection

The menu lists every patch with a number. `[X]` = will be applied,
`[ ]` = will be skipped. The menu is grouped into the same categories as the
[patch overview](#patch-overview). On the first start the
**preset "Project Reforged"** is preselected (see the "Reforged" column in the
overview), after that the saved selection or the patches currently in
`Wow.exe`. `B` loads the preset **"Billy's_Wow.exe"** (column "Billy"), `S` the
preset **"St0nys_Wow.exe"** (column "St0ny").
Patches that need something additional say so in parentheses
after their name, with the link right below.

| Input              | Effect                                     |
|--------------------|--------------------------------------------|
| `5`                | toggle patch 5                             |
| `3 7 12` / `3,7,12` | toggle several patches                    |
| `10-15`            | toggle a range                             |
| `A`                | all patches on                             |
| `N`                | all patches off (patched `Wow.exe` + ENTER: restore the original) |
| `L`                | switch language (Deutsch ↔ English)        |
| `R`                | load preset "Project Reforged" (= default) (**Safe** – official preset of [Project Reforged](https://projectreforged.github.io/wotlk/)) |
| `B`                | load preset "Billy's_Wow.exe" (**Safe** – based on Billy's proven exe) |
| `S`                | load preset "St0nys_Wow.exe" (**Not safe**, use only on your own servers) |
| `Q`                | quit, `Wow.exe` stays unmodified           |
| `ENTER`            | accept the selection and continue          |

Before the confirmation prompt the patcher shows **notes** – nothing is blocked:
when a companion patch is missing (e.g. the extended slider maximums need the
CVar unlocks), when one patch makes another unnecessary (disabling Warden
completely replaces the RCE fix) and when selected patches carry a warning –
red for ban risk and a larger `Wow.exe`, yellow for patches that are still
untested on public servers or in game (see [Notes](#notes)).

### The selection is remembered

As soon as you accept the selection with ENTER, the patcher saves it to
`patcher_selection.ini` next to the script. On the next start exactly this
selection is preselected again – even if you cancelled at the confirmation
prompt.

- The selection is stored per patch (by an internal ID), not by number. If a
  newer version adds patches, your selection stays correct and the new patches
  start with their default setting.
- The file is plain text (`laa=1`, `cache=0`, …) and can also be edited by
  hand. It also holds the entered values of the value patches – client info,
  jump height, double jump (`value.clientversion=3.3.6` etc.).
- The language is remembered there as well (`language=de` or `en`).
- **Reset:** press `R` in the menu or delete `patcher_selection.ini` – then
  the preset "Project Reforged" applies again (deleting the file also forgets the
  language and the remembered values, they are asked for again).

The preset "Project Reforged" (key `R`) is the official preset of the
[Project Reforged](https://projectreforged.github.io/wotlk/) project, put
together by Stormhand, and the default selection. It contains only patches
without a warning that do not make `Wow.exe` larger – **the preset is safe** and
can be used on public servers as well. The "Reforged" column in the
[patch overview](#patch-overview) shows which patches belong to it; in the
script the list is `$PRESET_REFORGED`.

The preset "Billy's_Wow.exe" (key `B`) is Billy Hoyle's patch set. It is
defined in `apply_patches.ps1`: every patch has an entry
`On = $true` (in the preset) or `On = $false` (not in the preset).

It is based on Billy's `Wow.exe`, which was in use on public servers for a long
time. Some of its patches have since been fixed because they could crash the
client or break animations. In the overview you can recognize them by the
addition "fixed by St0ny" to the author. The fixed patches have been tested in
game and work – **the preset is safe**.

If you still run into problems, please let me know via an
[issue](https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher/issues).

The second preset "St0nys_Wow.exe" (key `S`) is St0ny's own selection for
private servers. It also contains patches with a ban risk and patches that make
`Wow.exe` larger – **use it only on your own servers**. The "St0ny" column in
the [patch overview](#patch-overview) shows which patches belong to it; in the
script the list is `$PRESET_STONY`. **Warning: this preset should never be used on
public servers under any circumstances – it will most likely get you banned!**
The patcher shows this as a yellow note when you load it with `S`.

## Changing or removing patches

Applied patches are not final. Just run `patcher.bat` again: the menu then has
exactly the patches checked that are currently in `Wow.exe`. Newly checked
patches are marked **(new)**, deselected ones **(will be removed)**. This way
you can add patches, deselect them or change values (jump height, double
jump, client info) as you like. `N` plus ENTER removes every patch – afterwards
`Wow.exe` is **byte-for-byte the original** again.

How it works:

- **First start:** `Wow.exe` must be original (SHA256 check), otherwise the
  patcher aborts. Patching saves the original as `Wow.exe.ORI`, and every
  patched `Wow.exe` gets a [watermark](#notes).
- **Every later start:** the patcher recognizes a `Wow.exe` it patched itself
  by the watermark. If it is missing (and the file is not original), it aborts
  – e.g. for an exe patched with another tool.
- **Determining the patch state:** if the hash in `patcher_state.ini` matches
  (the patcher stores hash, patches, values and original bytes there after
  every run), it uses that file – the fast way. Otherwise, e.g. if the file is
  missing or the `Wow.exe` comes from another computer, the patcher checks all
  patch locations in the exe itself: which patches are in it, and with which
  values (jump height, build date etc.)? For this the script contains a small
  table with the original bytes at all patch locations. If there is nothing to
  do afterwards, the patcher still recreates `patcher_state.ini` so that the
  next start takes the fast way again.
- **Restoring the original:** from the patched exe the patcher rebuilds the
  original in memory, verifies it by SHA256 and applies the new selection on
  top. If that does not work exactly – e.g. because the exe was changed in
  some other way after patching – it aborts.
- Before writing, the patcher also checks that the new result can be reverted
  cleanly to the original.
- `Wow.exe.ORI` is not touched on later runs and is always the original. If
  it is missing, the patcher recreates it from the reconstructed original. In
  addition, every later run saves the previous `Wow.exe` as `Wow.exe.BAK`, so
  one step back is always possible.

> [!NOTE]
> A patch with a value exactly matching the original (e.g. the jump height
> `-7.9555473`) changes no bytes and is therefore not detected as applied when
> the exe is checked – it has no effect then anyway.

## Parameters for unattended use

All parameters are optional and are passed through from `patcher.bat` to
`apply_patches.ps1`.

| Parameter              | Meaning                                                                    |
|------------------------|----------------------------------------------------------------------------|
| `-Language de\|en`     | set the language for this run. Together with `-Select` the remembered language stays unchanged; if you accept a selection in the menu with ENTER, it is saved along with it. |
| `-Select <selection>`  | skip the selection menu: `saved` (saved selection), `reforged` (preset "Project Reforged", also `default`), `billy` (preset "Billy's_Wow.exe"), `stony` (preset "St0nys_Wow.exe"), `all`, `none` (remove all patches, restore the original) or numbers/ranges like `"1,3,5-8"`. The selection completely replaces the patches in `Wow.exe`. Using `-Select` does not change the saved selection. |
| `-Unattended`          | no prompts and no pauses. Without `-Language` the remembered language or German is used, without `-Select` the saved selection or the preset "Project Reforged". |
| `-Path <file>`         | patch a `Wow.exe` other than the one next to the script                    |

Example:

```bat
patcher.bat -Language en -Select saved -Unattended
```

Exit codes: `0` = success (or nothing to do), `1` = error, `2` = cancelled (by
the user or because no more input is possible).

## Files

| File                | Purpose |
|---------------------|---------|
| `patcher.bat`       | Launcher, calls `apply_patches.ps1` |
| `apply_patches.ps1` | Patch engine: language selection, checks, selection menu, backup; reads the EXE once, patches in memory, writes it back once |
| `README.md`         | This file |
| `README.de.md`      | German documentation |
| `PATCHES.md`        | Detailed patch descriptions in German |
| `PATCHES.en.md`     | Detailed descriptions of all patches |
| `patcher_selection.ini` | Created on the first start (remembered language), stores the accepted selection and the entered values |
| `patcher_state.ini` | Created when patching: hash of the patched `Wow.exe`, applied patches, values and original bytes – speeds up the next start, but is not strictly required |
| `Wow.exe.ORI`       | Backup of the original `Wow.exe`, created on the first patch run |
| `Wow.exe.BAK`       | Backup of the previous `Wow.exe` from before the last run |
| `LICENSE`           | MIT license |

---

## Patch overview

> [!IMPORTANT]
> **What the warnings mean** – they are shown after the name of a patch, in
> the patcher in square brackets:
>
> - **no warning** – **safe**: tested in game, no warning and no note.
> - 🔴 **[ban risk]** – **confirmed ban risk**: the patch can lead to a ban on
>   many servers. Only use it on servers that allow it. The patcher shows a
>   red warning before patching.
> - 🟡 **[untested on public servers]** – **not tested on public servers,
>   possible ban risk**: careful, it may get you kicked or banned. The patcher
>   shows a yellow note before patching.
> - 🟡 **[untested in game]** – **function untested in game**: the patch has
>   not been checked in game yet and may be buggy. The patcher shows a yellow
>   note before patching.
> - **[exe grows]** – the patch appends a section to `Wow.exe`. Many servers do
>   not tolerate a changed file size – this can lead to a ban. The patcher
>   shows a red warning before patching.
>
> A patch can carry several warnings, e.g. 🟡 **[untested on public servers
> and in game]**.

Click the number of a patch to jump to its description.

<details>
<summary><b>Show all patches with author and preset assignment</b></summary>

#### System & performance

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [1](PATCHES.en.md#patch-laa) | 4GB patch (Large Address Aware) | Alastor StrixEfuartus / Kebabstorm / Robinsch | ✅ | ✅ | ✅ |
| [2](PATCHES.en.md#patch-cache) | Disable CACHE folder creation | Alastor StrixEfuartus / Kebabstorm | – | – | – |
| [3](PATCHES.en.md#patch-itemcache) | Refresh item cache immediately | Robinsch | ✅ | ✅ | ✅ |
| [4](PATCHES.en.md#patch-worldcrash) | WorldFrame crash fix (invalid triangle indices) 🟡 **[untested on public servers and in game]** | Alyst3r (0x539wowmod) (fixed by St0ny) | – | – | ✅ |
| [5](PATCHES.en.md#patch-timer) | Always use the precise timer (fixes turning stutter) | St0ny | – | – | ✅ |
| [6](PATCHES.en.md#patch-nothrottle) | Do not throttle item and player name queries | Hour of Twilight (ported by St0ny) | – | – | – |
| [7](PATCHES.en.md#patch-mirrorfix) | Mirror Image crash fix (memory leak with mirror images) 🟡 **[untested on public servers and in game]** | Hour of Twilight (ported by St0ny) | – | – | – |
| [8](PATCHES.en.md#patch-wmocube) | Missing WMO file: error cube instead of ERROR #134 🟡 **[untested on public servers and in game]** | Alyst3r (ported by St0ny) | – | – | – |
| [9](PATCHES.en.md#patch-glyphfix) | Font glyph fix (wrong or garbled characters in text) 🟡 **[untested on public servers and in game, exe grows]** | Hour of Twilight (ported by St0ny) | – | – | – |

#### Security & privacy

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [10](PATCHES.en.md#patch-rce) | Remote code execution exploit fix 🔴 **[ban risk]** | Robinsch | – | – | ✅ |
| [11](PATCHES.en.md#patch-wardenoff) | Disable Warden completely, RCE fix 🔴 **[ban risk]** | Robinsch | – | – | – |
| [12](PATCHES.en.md#patch-scandll) | Disable Scan.dll | Alastor StrixEfuartus | – | – | ✅ |
| [13](PATCHES.en.md#patch-noserverpatch) | Disallow client patches from the server | Kebabstorm | – | – | ✅ |
| [14](PATCHES.en.md#patch-nosurvey) | Disallow hardware surveys from the server | Kebabstorm | – | – | ✅ |

#### Login & connection

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [15](PATCHES.en.md#patch-skipbnet) | Skip Battle.net login | Kebabstorm | – | – | ✅ |
| [16](PATCHES.en.md#patch-skiprdp) | Skip Remote Desktop check | Kebabstorm | – | – | ✅ |
| [17](PATCHES.en.md#patch-nohttp) | Disable HTTP requests to Battle.net | Kebabstorm | – | – | ✅ |
| [18](PATCHES.en.md#patch-afk) | Prevent the idle kick after character auto-login *(required for character auto-login; AFK and idle timers stay active, [Discord](https://discord.com/channels/858041817043042364/1515439916878663701))* | St0ny | – | – | ✅ |

#### Modding: interface, MPQs & addons

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [19](PATCHES.en.md#patch-glue) | Allow custom GlueXML | Alastor StrixEfuartus / Kebabstorm (fixed by St0ny) | – | ✅ | ✅ |
| [20](PATCHES.en.md#patch-mpqsig) | Allow unsigned / incorrectly signed MPQs | Alastor StrixEfuartus | – | – | ✅ |
| [21](PATCHES.en.md#patch-mpqnames) | Allow extended MPQ names |  | – | ✅ | ✅ |
| [22](PATCHES.en.md#patch-localdata) | Load data directly from the Data folder (no MPQ) | Alastor StrixEfuartus | – | ✅ | ✅ |
| [23](PATCHES.en.md#patch-luaunlock) | LUA unlock (spells, movement, macros) 🔴 **[ban risk]** | Alastor StrixEfuartus | – | – | – |
| [24](PATCHES.en.md#patch-luaunlockfull) | LUA unlock (complete): allow all protected functions 🔴 **[ban risk]** | St0ny | – | – | – |
| [25](PATCHES.en.md#patch-keyprop) | Pass all keyboard events on to addons (OnKeyDown) 🔴 **[ban risk, untested in game]** | Alyst3r (0x539wowmod) | – | – | – |
| [26](PATCHES.en.md#patch-globalsv) | Merge addon data of all accounts (SavedVariables) *(shared folder `WTF\Account\global`)* 🟡 **[untested on public servers and in game]** | St0ny (original by boredatom) | – | – | – |

#### DLL loaders

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [27](PATCHES.en.md#patch-awesome) | Enable AwesomeWotlkLib.dll support *(requires [awesome_wotlk](https://github.com/noname08662/awesome_wotlk))* | FrostAtom | – | ✅ | ✅ |
| [28](PATCHES.en.md#patch-wotlkext) | Enable WotLKExtensions.dll support *(requires [WotLK-Extensions](https://github.com/Alyst3r/WotLK-Extensions))* | St0ny (original by Alyst3r) | – | – | – |
| [29](PATCHES.en.md#patch-voicedll) | Load voice.dll at startup (mod-voicechat) [ALPHA] *(module not finished yet, [mod-voicechat](https://github.com/Raz0r1337/mod-voicechat))* 🟡 **[untested on public servers and in game]** | St0ny | – | – | – |

#### Gameplay fixes

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [30](PATCHES.en.md#patch-areatrigger) | More precise area trigger timer (50 ms instead of 100 ms) | Robinsch | – | ✅ | ✅ |
| [31](PATCHES.en.md#patch-swing) | Remove melee swing on right-click | Robinsch | – | ✅ | ✅ |
| [32](PATCHES.en.md#patch-npcanim) | Suppress NPC attack animation when turning | Robinsch (fixed by St0ny) | – | ✅ | ✅ |
| [33](PATCHES.en.md#patch-spellanim) | Fix spell animation after cancelled channel | Robinsch | – | ✅ | ✅ |
| [34](PATCHES.en.md#patch-ghostattack) | Fix "ghost" attack when NPCs evade from combat | Robinsch (fixed by St0ny) | – | ✅ | ✅ |
| [35](PATCHES.en.md#patch-naked) | Fix naked character bug | Robinsch (fixed by St0ny) | – | ✅ | ✅ |
| [36](PATCHES.en.md#patch-forcereaction) | Keep force reaction on /reload | Robinsch | – | ✅ | ✅ |
| [37](PATCHES.en.md#patch-mail) | New mail without the 60-second wait | Robinsch | – | ✅ | ✅ |
| [38](PATCHES.en.md#patch-deadchat) | Allow chat commands while dead | Robinsch | – | ✅ | ✅ |
| [39](PATCHES.en.md#patch-follow) | Allow /follow on NPCs | St0ny (original by Alastor StrixEfuartus) | – | – | ✅ |
| [40](PATCHES.en.md#patch-level101) | Level 101+ fix (game tables, barber chair, base stats) | Alastor StrixEfuartus (fixed by St0ny) | – | – | ✅ |
| [41](PATCHES.en.md#patch-raceclass) | Character creation: more than 10 classes (random class) *(for custom classes; server must support it)* 🔴 **[ban risk]** | Alastor StrixEfuartus / Robinsch | – | – | – |
| [42](PATCHES.en.md#patch-namecheck) | Disable the name check in character creation (e.g. digits in names) *(server must allow the names as well)* 🔴 **[ban risk]** | Alyst3r (0x539wowmod) (fixed by St0ny) | – | – | – |
| [43](PATCHES.en.md#patch-maxchars) | Max characters per realm raised to 255 | St0ny | – | ✅ | ✅ |
| [44](PATCHES.en.md#patch-customitem) | Custom Item Fix (BETA) v2 *(custom items without DBC changes: model, icon and item type from the server data)* 🟡 **[untested on public servers and in game]** | Kebabstorm (fixed by St0ny) | – | – | ✅ |
| [45](PATCHES.en.md#patch-climb) | Remove the climb angle limit (walk up any slope) 🔴 **[ban risk]** | Alastor StrixEfuartus | – | – | – |
| [46](PATCHES.en.md#patch-jump) | Change jump height (original -7.9555473) *(asks for the value)* 🔴 **[ban risk]** | Alastor StrixEfuartus | – | – | – |
| [47](PATCHES.en.md#patch-airforward) | Steer forward/backward while jumping 🔴 **[ban risk]** | Alyst3r (0x539wowmod) (ported by St0ny) | – | – | ✅ |
| [48](PATCHES.en.md#patch-airlateral) | Steer sideways while jumping 🔴 **[ban risk]** | Alyst3r (0x539wowmod) (ported by St0ny) | – | – | ✅ |
| [49](PATCHES.en.md#patch-airturn) | Turning while jumping changes the flight direction 🔴 **[ban risk]** | Alyst3r (0x539wowmod) (ported by St0ny) | – | – | ✅ |
| [50](PATCHES.en.md#patch-doublejump) | Double jump (more jumps in the air) *(asks for the value)* 🔴 **[ban risk, exe grows]** | Alyst3r (0x539wowmod) (ported by St0ny) | – | – | ✅ |
| [51](PATCHES.en.md#patch-noammo) | Ranged attacks without ammo *(the server has to support it, otherwise it still reports "no ammo")* 🟡 **[untested on public servers and in game]** | Alyst3r (ported by St0ny) | – | – | – |

#### Graphics & view distance

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [52](PATCHES.en.md#patch-farclip) | CVar farclip unlock (max 10000) | Alastor StrixEfuartus | – | ✅ | ✅ |
| [53](PATCHES.en.md#patch-horizon) | CVar horizonFarclipScale unlock (max 12) | St0ny | – | ✅ | ✅ |
| [54](PATCHES.en.md#patch-envdetail) | CVar environmentDetail unlock (no limit instead of 1.5) | St0ny | – | ✅ | ✅ |
| [55](PATCHES.en.md#patch-grounddist) | CVar groundEffectDist unlock (max 3166 instead of 140) |  | – | ✅ | ✅ |
| [56](PATCHES.en.md#patch-sliders) | Graphics options: extend slider maximums | St0ny | – | – | ✅ |
| [57](PATCHES.en.md#patch-goscale) | GameObject view distance: Cat 0 and Cat 4 scale with environmentDetail | St0ny | – | – | ✅ |
| [58](PATCHES.en.md#patch-cat0) | GameObject view distance: Cat 0 from 30 to 50 yards *(costs performance, more small objects visible)* | St0ny | – | – | ✅ |
| [59](PATCHES.en.md#patch-occluder) | Occluder fix for Stormwind (Open Azeroth) | Robinsch | – | – | ✅ |
| [60](PATCHES.en.md#patch-bluemoon) | Re-enable the blue moon in the night sky | Robinsch | – | ✅ | ✅ |
| [61](PATCHES.en.md#patch-notransparency) | No character transparency when zooming in | Alastor StrixEfuartus | – | ✅ | ✅ |
| [62](PATCHES.en.md#patch-nofade) | No fade-out for NPCs with flag DO_NOT_FADE_IN *(server must set the flag)* 🟡 **[untested on public servers and in game]** | Alyst3r (0x539wowmod) (ported by St0ny) | – | – | – |
| [63](PATCHES.en.md#patch-hdportraits) | HD unit frame portraits: render resolution 256 instead of 64 pixels 🟡 **[untested on public servers and in game, exe grows]** | St0ny (original by Badgermilk0) | – | – | ✅ |
| [64](PATCHES.en.md#patch-iconsnap) | Pixel-exact icons in text (sharp instead of blurry) 🟡 **[untested on public servers and in game, exe grows]** | Hour of Twilight (ported by St0ny) | – | – | – |

#### Interface & comfort

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [65](PATCHES.en.md#patch-tracker) | Auto-sort quest tracker |  | – | – | ✅ |
| [66](PATCHES.en.md#patch-worldmap) | Advanced world map enabled by default |  | – | – | ✅ |
| [67](PATCHES.en.md#patch-castbars) | Cast bars on all frames | Kebabstorm | – | ✅ | ✅ |
| [68](PATCHES.en.md#patch-emblems) | Retail guild emblems: selection extended from 170 to 196 *(requires [Patch-G](https://discord.com/channels/407664041016688662/1541873346608889936))* 🟡 **[untested on public servers and in game]** | MacWarrior | – | – | ✅ |
| [69](PATCHES.en.md#patch-flash) | FlashWindow patch *(requires the [FlashWindow addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash))* | Kebabstorm | – | ✅ | ✅ |
| [70](PATCHES.en.md#patch-charrandom) | Character creation: do not randomize the appearance automatically 🟡 **[untested on public servers and in game]** | Alyst3r (0x539wowmod) | – | – | – |
| [71](PATCHES.en.md#patch-lootopen) | Loot window stays open while moving 🟡 **[untested on public servers]** | Hour of Twilight (ported by St0ny) | – | – | – |
| [72](PATCHES.en.md#patch-showlevel) | Real level instead of "??" for enemies 10+ levels above you *(bosses still show "??" – see No. 73)* 🟡 **[untested on public servers]** | Hour of Twilight (ported by St0ny) | – | – | – |
| [73](PATCHES.en.md#patch-showlevelboss) | Real level for bosses too instead of "??" (extension to No. 72) 🟡 **[untested on public servers]** | St0ny | – | – | – |
| [74](PATCHES.en.md#patch-holdrepeat) | Hold action buttons to repeat 🔴 **[ban risk, exe grows]** | Hour of Twilight (ported by St0ny) | – | – | – |

#### Window, mouse & camera

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [75](PATCHES.en.md#patch-window) | Windowed mode by default *(starts as a small window in the middle of the desktop – maximized only together with No. 76)* | St0ny | – | – | ✅ |
| [76](PATCHES.en.md#patch-maximize) | Maximized window by default *(only works together with No. 75)* | St0ny | – | – | ✅ |
| [77](PATCHES.en.md#patch-windowfix) | No black screen when switching to windowed mode | Robinsch | ✅ | ✅ | ✅ |
| [78](PATCHES.en.md#patch-mouse) | Mouse flicker / camera jump fix | Robinsch | ✅ | ✅ | ✅ |
| [79](PATCHES.en.md#patch-camera) | CameraReforged [BETA]: camera height and zoom limits *(shoulder offset has no effect yet)* 🟡 **[untested on public servers, exe grows]** | Stormhand (fixed by St0ny) | – | – | – |

#### Sound

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [80](PATCHES.en.md#patch-sound) | Optimize sound settings *(requires [OpenAL](https://github.com/kcat/openal-soft), otherwise the settings have no effect)* | St0ny | – | – | ✅ |

#### Client info: version, build, title, date, icon

| No. | Patch | Author | Reforged | Billy | St0ny |
|----:|-------|-------|:--------:|:-----:|:-----:|
| [81](PATCHES.en.md#patch-clientversion) | Change client version (original 3.3.5) *(asks for the value)* 🔴 **[ban risk]** | MacWarrior | – | – | – |
| [82](PATCHES.en.md#patch-clientbuild) | Change build number (original 12340) *(asks for the value)* 🔴 **[ban risk]** | MacWarrior | – | – | – |
| [83](PATCHES.en.md#patch-clienttitle) | Change program title (file properties and window title) *(asks for the value)* 🔴 **[ban risk]** | MacWarrior (fixed by St0ny) | – | – | – |
| [84](PATCHES.en.md#patch-clientdate) | Change build date (original Jun 24 2010) *(asks for the value)* 🔴 **[ban risk]** | St0ny (original by MacWarrior) | – | – | – |
| [85](PATCHES.en.md#patch-clienticon) | Change program icon (icon of Wow.exe) *(asks for the value)* 🔴 **[ban risk]** | St0ny (original by MacWarrior) | – | – | – |

</details>

> [!NOTE]
> **Authors wanted:** For patches without an entry in the "Author" column, the
> author is not known yet. If you know who made one of these patches, please
> open an [issue](https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher/issues) – it will be added.

---

## Patch descriptions

The detailed descriptions of all patches are in a separate file:
**[PATCHES.en.md](PATCHES.en.md)**. In the [patch overview](#patch-overview),
clicking the number of a patch takes you straight to its description.

---

## Notes

- **Warnings:** every patch has a uniform rating. In the
  [patch overview](#patch-overview) it is shown after the name, in the patcher
  in square brackets, and before the confirmation prompt the patcher lists the
  selected patches with a warning once more:
  - **no warning** – safe, tested in game.
  - 🔴 **ban risk** – can lead to a ban on many servers: No. 10, 11, 23–25,
    41, 42, 45–50, 74 and 81–85 (red warning).
  - 🟡 **untested on public servers** – possible ban risk, careful, may get
    you kicked or banned: No. 4, 7–9, 26, 29, 44, 51, 62–64, 68, 70–73 and
    79 (yellow note).
  - 🟡 **untested in game** – the function has not been checked in game yet,
    possibly buggy: No. 4, 7–9, 25, 26, 29, 44, 51, 62–64, 68 and 70 (yellow
    note).
  - **exe grows** – these patches append a section to `Wow.exe`: No. 9, 50,
    63, 64, 74 and 79. Many servers do not tolerate a changed file size – this
    can lead to a ban (red warning). All other patches do not change the file
    size.
- **Signature:** the original `Wow.exe` is digitally signed by Blizzard. Every
  patch invalidates this signature. Windows will therefore probably warn about
  an unsigned, potentially harmful app when it starts; with "More info" → "Run
  anyway" WoW starts normally. A new signature that Windows trusts is only
  issued by certificate authorities with identity verification – you cannot
  get one for a modified Blizzard file. The patches that append a section
  (No. 9, 50, 63, 64, 74 and 79) also remove the reference to the
  signature from the header: the new section lies behind the signature, and
  some tools would otherwise report the file as damaged. The signature bytes
  themselves stay untouched, and removing the patches restores the original
  including its signature. On Windows the patcher removes a download mark
  ("This file came from another computer") from `Wow.exe` after writing it,
  like the "Unblock" checkbox in the file properties.
- **Watermark:** every patched `Wow.exe` contains the text
  `Patched with St0nys AIO WoW.exe Patcher by St0ny (Raz0r1337) - https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher`.
  This is how the patcher identifies a `Wow.exe` unambiguously as its own: it
  never mixes its patches with those of other patchers, and it can read its
  patch state from the exe even if `patcher_state.ini` was deleted. The text
  sits in the unused padding behind the `.tls` section (file offset
  `0x72DE20`), is never loaded into memory and does not change the file size.
  Removing all patches removes it again. As a side effect you can always
  check whether a `Wow.exe` was made with this patcher – e.g. with a hex editor
  or in the command prompt with `findstr /m /c:"St0nys AIO" Wow.exe` (prints the
  file name if it is there).
- **Restoring the original:** run the patcher, press `N` and ENTER – with or
  without `patcher_state.ini`. Alternatively delete the patched `Wow.exe` and
  rename `Wow.exe.ORI` to `Wow.exe`. `Wow.exe.BAK`, on the other hand, is the
  `Wow.exe` from before the last run.
- **For developers:** the original bytes table in the script is regenerated
  with `apply_patches.ps1 -BuildTable -Path <original Wow.exe>`. This is needed
  after every change to a patch; if it no longer matches, the patcher points it
  out after patching.
- Use at your own risk. This project is not affiliated with Blizzard
  Entertainment.

## Acknowledgements

- A very special thank you goes to **Billy Hoyle** – for all his help and tips
  over the past months and for helping to collect the patches. His patch set is
  included as the preset "Billy's_Wow.exe".
- **MacWarrior** also helped collect the patches and contributed some of his
  own – thank you as well!
- Thanks also to **Stormhand** for the permission to include his
  CameraReforged patch, and for the preset "Project Reforged", the official
  preset of his [Project Reforged](https://projectreforged.github.io/wotlk/)
  project.
- Thanks to **Moroes**, who tracked down patch
  [#26](PATCHES.en.md#patch-globalsv) and passed it on to me.
- And of course thanks to all patch authors named in the
  [patch overview](#patch-overview).

## License

This project is licensed under the [MIT License](LICENSE).
Copyright (c) 2026 St0ny (Raz0r1337).

In short: anyone may use, modify and redistribute the patcher – including in
their own projects – as long as the copyright notice and the license text are
kept (attribution).
