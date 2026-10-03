# St0nys-AIO-WoW-EXE-Patcher

[🇩🇪 Deutsch](README.md) | 🇬🇧 English

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

> [!CAUTION]
> **Developer tool – use at your own risk.** This patcher is meant for your
> own servers, modding and testing. On public servers **any** patch can violate
> the server rules and get you **banned** – including the patches that are
> **not** marked as a ban risk here. The markings only name the known cases;
> what a server detects and tolerates is up to the server and changes from
> time to time. Check the rules of your server **before** using a patched
> `Wow.exe` there. The patcher also shows this warning on every start.

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
- [Removed patches](#removed-patches)
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
   what is removed), notes (missing or redundant companion patches, ban risk)
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
**preset "Billy's_Wow.exe"** is preselected (see the "Default" column in the
overview), after that the saved selection or the patches currently in
`Wow.exe`. `S` loads the second preset **"St0nys_Wow.exe"** (column "St0ny").
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
| `B`                | load preset "Billy's_Wow.exe" (= default) (**Safe** on public servers) |
| `S`                | load preset "St0nys_Wow.exe" (**Not safe**, use only on your own servers) |
| `Q`                | quit, `Wow.exe` stays unmodified           |
| `ENTER`            | accept the selection and continue          |

Before the confirmation prompt the patcher shows **notes** – nothing is blocked:
when a companion patch is missing (e.g. the extended slider maximums need the
CVar unlocks), when one patch makes another unnecessary (disabling Warden
completely replaces the RCE fix) and – as a red line – when selected patches
can lead to a ban (anti-cheat or changed file size, see [Notes](#notes)).

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
- **Reset:** press `B` in the menu or delete `patcher_selection.ini` – then
  the preset "Billy's_Wow.exe" applies again (deleting the file also forgets the
  language and the remembered values, they are asked for again).

The preset "Billy's_Wow.exe" is Billy Hoyle's patch set and also the default
selection. It is defined in `apply_patches.ps1`: every patch has an entry
`On = $true` (in the preset) or `On = $false` (not in the preset).

This lets you rebuild the proven `Wow.exe` from Billy's package at any time:
whoever experiments can always return with `B` to a state that has been
running on public servers for years.

The second preset "St0nys_Wow.exe" (key `S`) is St0ny's own selection for
private servers. It also contains patches with a ban risk and patches that make
`Wow.exe` larger – **use it only on your own servers**. The "St0ny" column in
the [patch overview](#patch-overview) shows which patches belong to it; in the
script the list is `$PRESET_STONY`. **Warning: this preset has not been tested
yet.** The patcher shows this as a yellow note when you load it with `S`.

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
| `-Select <selection>`  | skip the selection menu: `saved` (saved selection), `billy` (preset "Billy's_Wow.exe", also `default`), `stony` (preset "St0nys_Wow.exe"), `all`, `none` (remove all patches, restore the original) or numbers/ranges like `"1,3,5-8"`. The selection completely replaces the patches in `Wow.exe`. Using `-Select` does not change the saved selection. |
| `-Unattended`          | no prompts and no pauses. Without `-Language` the remembered language or German is used, without `-Select` the saved selection or the preset "Billy's_Wow.exe". |
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
| `README.md`         | German documentation |
| `README.en.md`      | This file |
| `patcher_selection.ini` | Created on the first start (remembered language), stores the accepted selection and the entered values |
| `patcher_state.ini` | Created when patching: hash of the patched `Wow.exe`, applied patches, values and original bytes – speeds up the next start, but is not strictly required |
| `Wow.exe.ORI`       | Backup of the original `Wow.exe`, created on the first patch run |
| `Wow.exe.BAK`       | Backup of the previous `Wow.exe` from before the last run |
| `LICENSE`           | MIT license |

---

## Patch overview

Click a patch name to jump to its description.

<details>
<summary><b>Show all patches with author and preset assignment</b></summary>

| No. | Patch | Author | Default | St0ny |
|----:|-------|-------|:--------:|:-----:|
|    | **System & performance** |  |  |  |
| 1  | [4GB patch (Large Address Aware)](#patch-laa) | Alastor StrixEfuartus / Kebabstorm / Robinsch | ✅ | ✅ |
| 2  | [Disable CACHE folder creation](#patch-cache) | Alastor StrixEfuartus / Kebabstorm | – | – |
| 3  | [Refresh item cache immediately](#patch-itemcache) | Robinsch | ✅ | ✅ |
| 4  | [WorldFrame crash fix (invalid triangle indices)](#patch-worldcrash) | Alyst3r (0x539wowmod) / St0ny | – | ✅ |
|    | **Security & privacy** |  |  |  |
| 5  | [Remote code execution exploit fix](#patch-rce) | Robinsch | – | ✅ |
| 6  | [Disable Warden completely, RCE fix](#patch-wardenoff) *(may get you kicked if Warden is active)* | Robinsch | – | – |
| 7  | [Disable Scan.dll](#patch-scandll) | Alastor StrixEfuartus | – | ✅ |
| 8  | [Disallow client patches from the server](#patch-noserverpatch) | Kebabstorm | – | ✅ |
| 9  | [Disallow hardware surveys from the server](#patch-nosurvey) | Kebabstorm | – | ✅ |
|    | **Login & connection** |  |  |  |
| 10 | [Skip Battle.net login](#patch-skipbnet) | Kebabstorm | – | ✅ |
| 11 | [Skip Remote Desktop check](#patch-skiprdp) | Kebabstorm | – | ✅ |
| 12 | [Disable HTTP requests to Battle.net](#patch-nohttp) | Kebabstorm | – | ✅ |
| 13 | [Prevent the idle kick after character auto-login](#patch-afk) *(required for character auto-login; AFK and idle timers stay active, [Discord](https://discord.com/channels/858041817043042364/1515439916878663701))* | St0ny | – | ✅ |
|    | **Modding: interface, MPQs & addons** |  |  |  |
| 14 | [Allow custom GlueXML](#patch-glue) | Alastor StrixEfuartus / Kebabstorm / St0ny | ✅ | ✅ |
| 15 | [Allow unsigned / incorrectly signed MPQs](#patch-mpqsig) | Alastor StrixEfuartus | – | ✅ |
| 16 | [Allow extended MPQ names](#patch-mpqnames) |  | ✅ | ✅ |
| 17 | [Load data directly from the Data folder (no MPQ)](#patch-localdata) | Alastor StrixEfuartus | ✅ | ✅ |
| 18 | [LUA unlock (spells, movement, macros)](#patch-luaunlock) *(may be treated as botting – ban risk)* | Alastor StrixEfuartus | – | – |
| 19 | [LUA unlock (complete): allow all protected functions](#patch-luaunlockfull) *(may be treated as botting – ban risk)* | St0ny | – | – |
| 20 | [Pass all keyboard events on to addons (OnKeyDown)](#patch-keyprop) | Alyst3r (0x539wowmod) | – | – |
| 21 | [Merge addon data of all accounts (SavedVariables)](#patch-globalsv) *(shared folder `WTF\Account\global`)* | boredatom / St0ny | – | – |
|    | **DLL loaders** |  |  |  |
| 22 | [Enable AwesomeWotlkLib.dll support](#patch-awesome) *(requires [awesome_wotlk](https://github.com/noname08662/awesome_wotlk))* | FrostAtom | ✅ | ✅ |
| 23 | [Load voice.dll at startup (mod-voicechat) \[ALPHA\]](#patch-voicedll) *(module not finished yet, [mod-voicechat](https://github.com/Raz0r1337/mod-voicechat))* | St0ny | – | – |
|    | **Gameplay fixes** |  |  |  |
| 24 | [More precise area trigger timer (50 ms instead of 100 ms)](#patch-areatrigger) | Robinsch | ✅ | ✅ |
| 25 | [Remove melee swing on right-click](#patch-swing) | Robinsch | ✅ | ✅ |
| 26 | [Suppress NPC attack animation when turning](#patch-npcanim) | Robinsch | ✅ | ✅ |
| 27 | [Fix spell animation after cancelled channel](#patch-spellanim) | Robinsch | ✅ | ✅ |
| 28 | [Keep force reaction on /reload](#patch-forcereaction) | Robinsch | ✅ | ✅ |
| 29 | [New mail without the 60-second wait](#patch-mail) | Robinsch | ✅ | ✅ |
| 30 | [Allow chat commands while dead](#patch-deadchat) | Robinsch | ✅ | ✅ |
| 31 | [Allow /follow on NPCs](#patch-follow) | Alastor StrixEfuartus / St0ny | – | ✅ |
| 32 | [Level 101+ fix (game tables, barber chair, base stats)](#patch-level101) | Alastor StrixEfuartus / St0ny | – | ✅ |
| 33 | [Character creation: more than 10 classes (random class)](#patch-raceclass) *(for custom classes; server must support it)* | Alastor StrixEfuartus / Robinsch | – | – |
| 34 | [Disable the name check in character creation (e.g. digits in names)](#patch-namecheck) *(server must allow the names as well)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 35 | [Max characters per realm raised to 255](#patch-maxchars) | St0ny | ✅ | – |
| 36 | [Custom Item Fix (BETA) v2](#patch-customitem) *(custom items without DBC changes: model, icon and item type from the server data)* | Kebabstorm / St0ny | – | ✅ |
| 37 | [Remove the climb angle limit (walk up any slope)](#patch-climb) *(may be detected as cheating by the server – ban risk)* | Alastor StrixEfuartus | – | – |
| 38 | [Change jump height (original -7.9555473)](#patch-jump) *(asks for the value, may be detected as cheating by the server – ban risk)* | Alastor StrixEfuartus | – | – |
| 39 | [Steer forward/backward while jumping](#patch-airforward) *(may be detected as cheating by the server – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | ✅ |
| 40 | [Steer sideways while jumping](#patch-airlateral) *(may be detected as cheating by the server – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | ✅ |
| 41 | [Turning while jumping changes the flight direction](#patch-airturn) *(may be detected as cheating by the server – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | ✅ |
| 42 | [Double jump (more jumps in the air)](#patch-doublejump) *(asks for the value, may be detected as cheating by the server, exe grows – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | ✅ |
|    | **Graphics & view distance** |  |  |  |
| 43 | [CVar farclip unlock (max 10000)](#patch-farclip) | Alastor StrixEfuartus | ✅ | ✅ |
| 44 | [CVar horizonFarclipScale unlock (max 12)](#patch-horizon) | St0ny | ✅ | ✅ |
| 45 | [CVar environmentDetail unlock (no limit instead of 1.5)](#patch-envdetail) | St0ny | ✅ | ✅ |
| 46 | [CVar groundEffectDist unlock (max 3166 instead of 140)](#patch-grounddist) |  | ✅ | ✅ |
| 47 | [Graphics options: extend slider maximums](#patch-sliders) | St0ny | – | ✅ |
| 48 | [GameObject view distance: Cat 0 and Cat 4 scale with environmentDetail](#patch-goscale) | St0ny | – | ✅ |
| 49 | [GameObject view distance: Cat 0 from 30 to 50 yards](#patch-cat0) *(costs performance, more small objects visible)* | St0ny | – | ✅ |
| 50 | [Occluder fix for Stormwind (Open Azeroth)](#patch-occluder) | Robinsch | – | ✅ |
| 51 | [Re-enable the blue moon in the night sky](#patch-bluemoon) | Robinsch | ✅ | ✅ |
| 52 | [No character transparency when zooming in](#patch-notransparency) | Alastor StrixEfuartus | ✅ | ✅ |
| 53 | [No fade-out for NPCs with flag DO_NOT_FADE_IN](#patch-nofade) *(server must set the flag)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 54 | [HD unit frame portraits: render resolution 256 instead of 64 pixels](#patch-hdportraits) *(exe grows – ban risk)* | Badgermilk0 / St0ny | – | ✅ |
|    | **Interface & comfort** |  |  |  |
| 55 | [Auto-sort quest tracker](#patch-tracker) |  | – | ✅ |
| 56 | [Advanced world map enabled by default](#patch-worldmap) |  | – | ✅ |
| 57 | [Cast bars on all frames](#patch-castbars) | Kebabstorm | ✅ | ✅ |
| 58 | [Retail guild emblems: selection extended from 170 to 196](#patch-emblems) *(requires [Patch-G](https://discord.com/channels/407664041016688662/1541873346608889936))* | MacWarrior | – | ✅ |
| 59 | [FlashWindow patch](#patch-flash) *(requires the [FlashWindow addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash))* | Kebabstorm | ✅ | ✅ |
| 60 | [Character creation: do not randomize the appearance automatically](#patch-charrandom) | Alyst3r (0x539wowmod) | – | – |
|    | **Window, mouse & camera** |  |  |  |
| 61 | [Windowed mode by default](#patch-window) | St0ny | – | ✅ |
| 62 | [Maximized window by default](#patch-maximize) | St0ny | – | ✅ |
| 63 | [No black screen when switching to windowed mode](#patch-windowfix) | Robinsch | ✅ | ✅ |
| 64 | [Mouse flicker / camera jump fix](#patch-mouse) | Robinsch | ✅ | ✅ |
| 65 | [CameraReforged \[BETA\]: camera height and zoom limits](#patch-camera) *(shoulder offset has no effect yet; exe grows – ban risk)* | Stormhand / St0ny | – | – |
|    | **Sound** |  |  |  |
| 66 | [Optimize sound settings](#patch-sound) *(requires [OpenAL](https://github.com/kcat/openal-soft), otherwise the settings have no effect)* | St0ny | – | ✅ |
|    | **Client info: version, build, title, date, icon** |  |  |  |
| 67 | [Change client version (original 3.3.5)](#patch-clientversion) *(asks for the value)* | MacWarrior | – | – |
| 68 | [Change build number (original 12340)](#patch-clientbuild) *(asks for the value)* | MacWarrior | – | – |
| 69 | [Change program title in the file properties](#patch-clienttitle) *(asks for the value)* | MacWarrior / St0ny | – | – |
| 70 | [Change build date (original Jun 24 2010)](#patch-clientdate) *(asks for the value)* | MacWarrior | – | – |
| 71 | [Change program icon (icon of Wow.exe)](#patch-clienticon) *(asks for the value)* | MacWarrior / St0ny | – | – |

</details>

> [!NOTE]
> **Authors wanted:** For patches without an entry in the "Author" column, the
> author is not known yet. If you know who made one of these patches, please
> open an [issue](https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher/issues) – it will be added.

---

## Patch descriptions

Each description is collapsed – click the patch name to expand it.

### System & performance

<a id="patch-laa"></a>
<details>
<summary><b>4GB patch (Large Address Aware)</b> <i>(No. 1, Author: Alastor StrixEfuartus / Kebabstorm / Robinsch)</i></summary>

Lets `Wow.exe` use up to 4 GB of RAM instead of the default 2 GB limit for
32-bit applications.

</details>

<a id="patch-cache"></a>
<details>
<summary><b>Disable CACHE folder creation</b> <i>(No. 2, off by default, Author: Alastor StrixEfuartus / Kebabstorm)</i></summary>

Prevents the client from creating a `CACHE` folder automatically.

</details>

<a id="patch-itemcache"></a>
<details>
<summary><b>Refresh item cache immediately</b> <i>(No. 3, Author: Robinsch)</i></summary>

Removes the 30-second delay when refreshing the item cache. Item changes
become visible immediately.

</details>

<a id="patch-worldcrash"></a>
<details>
<summary><b>WorldFrame crash fix (invalid triangle indices)</b> <i>(No. 4, off by default, Author: Alyst3r (0x539wowmod) / St0ny)</i></summary>

Prevents a crash in a world rendering function (VA `0x81D510`). It walks over
triangles made of three vertex indices each and turns "index minus base" into a
memory address. If an index is smaller than the base, the address points before
the buffer and the client crashes. The patch checks the three indices of the
first triangle beforehand and skips the function in that case. Compared to the
original, the three jump distances have been corrected and the code is shorter.

> ℹ️ **Note:**
> The code lives in the free gap at the end of `.text`, which No. 53 uses as
> well. Both fit in there together, the file size does not change.

> ℹ️ **Note:**
> A heuristic fix, as the author himself calls it: only the first triangle of
> each call is checked. It does no harm when everything is fine, but does not
> catch every conceivable case.

</details>

### Security & privacy

<a id="patch-rce"></a>
<details>
<summary><b>Remote code execution exploit fix</b> <i>(No. 5, off by default, Author: Robinsch)</i></summary>

Closes a vulnerability that could allow remote code execution through crafted
packets: the `.zdata` section loses its execute permission and Warden modules
are no longer loaded from the local cache. Warden itself keeps working, so
servers with active Warden are not a problem.

> ℹ️ **Note:**
> "Disable Warden completely" (No. 6) closes the hole as well and makes this
> patch unnecessary. If you select both, the patcher points it out; together
> they do no harm.

</details>

<a id="patch-wardenoff"></a>
<details>
<summary><b>Disable Warden completely, RCE fix</b> <i>(No. 6, off by default, Author: Robinsch)</i></summary>

The client drops all Warden packets from the server (`SMSG_WARDEN_DATA`).
Warden modules are code the server has the client execute – with this patch
that is no longer possible at all, including future tricks. Makes the RCE fix
(No. 5) unnecessary; both together do no harm, the patcher just points it out.

> ⚠️ **Warning:**
> The client no longer answers Warden. Servers with active Warden (e.g.
> AzerothCore or TrinityCore with default settings) may therefore kick you.

</details>

<a id="patch-scandll"></a>
<details>
<summary><b>Disable Scan.dll</b> <i>(No. 7, off by default, Author: Alastor StrixEfuartus)</i></summary>

Prevents loading of `Scan.dll`, which the login server can push with its
"Scan" command (a check module of the login server, independent of Warden):
`.\Scan.dll` and `.\Scan.dll.new` become `.\||an.dll` – `|` is not allowed in
file names, so loading is guaranteed to fail.

</details>

<a id="patch-noserverpatch"></a>
<details>
<summary><b>Disallow client patches from the server</b> <i>(No. 8, off by default, Author: Kebabstorm)</i></summary>

The server can no longer send patch files to the client and have them
installed.

</details>

<a id="patch-nosurvey"></a>
<details>
<summary><b>Disallow hardware surveys from the server</b> <i>(No. 9, off by default, Author: Kebabstorm)</i></summary>

The server can no longer request a hardware survey (information about your PC)
from the client.

</details>

### Login & connection

<a id="patch-skipbnet"></a>
<details>
<summary><b>Skip Battle.net login</b> <i>(No. 10, off by default, Author: Kebabstorm)</i></summary>

The client skips the Battle.net login step and goes straight to the classic
login.

</details>

<a id="patch-skiprdp"></a>
<details>
<summary><b>Skip Remote Desktop check</b> <i>(No. 11, off by default, Author: Kebabstorm)</i></summary>

The client no longer checks whether it runs over a Remote Desktop connection –
so WoW can be played via RDP, for example.

</details>

<a id="patch-nohttp"></a>
<details>
<summary><b>Disable HTTP requests to Battle.net</b> <i>(No. 12, off by default, Author: Kebabstorm)</i></summary>

The client no longer fetches news, help articles and terms of use from
Blizzard's servers – they no longer exist for 3.3.5 anyway.

</details>

<a id="patch-afk"></a>
<details>
<summary><b>Prevent the idle kick after character auto-login</b> <i>(No. 13, off by default, Author: St0ny)</i></summary>

After an auto-login without any keyboard or mouse input the timestamp of the
last input is still 0 – the client immediately considers the player idle and
kicks them (CharAutoLogin bug). The patch sets the timestamp to "now" on the
first pass if it is still empty and removes a fatal-error check that can
trigger there. The actual timers stay unchanged: AFK status after 5 minutes,
logout after 30 minutes without input.
**Required for character auto-login** – details on [Discord](https://discord.com/channels/858041817043042364/1515439916878663701).

</details>

### Modding: interface, MPQs & addons

<a id="patch-glue"></a>
<details>
<summary><b>Allow custom GlueXML</b> <i>(No. 14, Author: Alastor StrixEfuartus / Kebabstorm / St0ny)</i></summary>

Allows modifying the login and character selection screens with your own
XML/Lua files (glue screen modding): the signature check of the interface files
always reports "valid", and local `Interface\GlueXML` and `Interface\FrameXML`
folders are no longer renamed to `*.old`.

> ℹ️ **Note:**
> Side effect that every version of this patch has: addons without a signature
> file are treated as "secure" (like Blizzard code) as well and may call
> protected functions – similar in effect to the LUA unlock (No. 18). Servers
> with anti-cheat may judge it the same way.

The widespread version (Alastor/Kebabstorm) continues with uninitialised
variables when the signature file is missing and frees a dangling pointer on
the way (undefined behaviour). Here the error exit returns "valid" directly
instead – same effect, without the wild memory access.

</details>

<a id="patch-mpqsig"></a>
<details>
<summary><b>Allow unsigned / incorrectly signed MPQs</b> <i>(No. 15, off by default, Author: Alastor StrixEfuartus)</i></summary>

The signature check for MPQ archives always reports "valid". The client only
checks archives sent by the server with it: `wow-patch.mpq` (client patch from
the server) and `Cache\Survey.mpq` (hardware survey). The regular `Data\*.MPQ`
are loaded without any signature check anyway – so this patch is not needed for
your own patch MPQs. Together with No. 8 and No. 9 it has no effect any more,
because neither path runs then.

</details>

<a id="patch-mpqnames"></a>
<details>
<summary><b>Allow extended MPQ names</b> <i>(No. 16)</i></summary>

Allows wildcard names for MPQ archives (`patch-*.MPQ` and
`patch-locale-*.MPQ`).

</details>

<a id="patch-localdata"></a>
<details>
<summary><b>Load data directly from the Data folder (no MPQ)</b> <i>(No. 17, Author: Alastor StrixEfuartus)</i></summary>

The client reads files directly from the Data folder without packing them into
an MPQ – e.g. `Data\DBFilesClient\ItemDisplayInfo.dbc`. Handy for modders.

</details>

<a id="patch-luaunlock"></a>
<details>
<summary><b>LUA unlock (spells, movement, macros)</b> <i>(No. 18, off by default, Author: Alastor StrixEfuartus)</i></summary>

Addons and macros may call protected functions: movement functions
(`MoveForwardStart`, `TurnLeftStart`, …), `CastSpellByName`, `CastSpell`,
`UseAction`, `PetAttack`, `RunMacro`/`RunMacroText` and the GM ticket
functions. Not unlocked, because they have their own checks in the code:
`TargetUnit`, `FocusUnit`, `InteractUnit`, `ReloadUI`; `AttackTarget` still
prints an error. No. 19 unlocks these and all others.

> ⚠️ **Warning:**
> This enables automation. Servers with anti-cheat may treat it as botting –
> this can lead to a ban.

</details>

<a id="patch-luaunlockfull"></a>
<details>
<summary><b>LUA unlock (complete): allow all protected functions</b> <i>(No. 19, off by default, Author: St0ny)</i></summary>

Extends No. 18 to all protected functions. The client's central protection
check knows 24 protection types in three classes (always forbidden, allowed only
after a hardware event, allowed only while attribute changes are permitted) –
with this patch it reports "allowed" for all of them. In addition, the own
checks of the functions that do not go through this central check are bypassed:
`TargetUnit`, `AssistUnit`, `TargetLastTarget`, `TargetNearest…`,
`TargetDirection…`, `AttackTarget`, `StartAttack`, `FocusUnit`, `ClearFocus`,
`InteractUnit`, `ReloadUI`, `UninviteUnit`, `CancelLogout`, the pet commands
(`PetAttack`, `PetFollow`, …) as well as `UseAction`, trading, the auction
house, the calendar, LFG, raid subgroups and creating or editing macros. The
block list for spells cast from insecure code is no longer checked either.

Left untouched are the frame protection check (`SetAttribute`, `Show`, `Hide`
on protected frames) and `RegisterForSave` – they do not concern game actions.
Makes No. 18 unnecessary; both together do no harm, the patcher only points it
out.

> ⚠️ **Warning:**
> This enables automation to the full extent. Servers with anti-cheat may treat
> it as botting – this can lead to a ban.

</details>

<a id="patch-keyprop"></a>
<details>
<summary><b>Pass all keyboard events on to addons (OnKeyDown)</b> <i>(No. 20, off by default, Author: Alyst3r (0x539wowmod))</i></summary>

If a frame has an OnKeyDown script, the client reports the key as handled
afterwards – it no longer reaches the key bindings. With the patch every key
continues to the key bindings after the OnKeyDown script. This lets addons see
all key presses without blocking the normal controls.

> ℹ️ **Note:**
> Addons that rely on OnKeyDown "swallowing" a key will additionally trigger the
> bound action.

</details>

<a id="patch-globalsv"></a>
<details>
<summary><b>Merge addon data of all accounts (SavedVariables)</b> <i>(No. 21, off by default, Author: boredatom / St0ny)</i></summary>

WoW normally stores addon data per account under `WTF\Account\<ACCOUNT>\`. With
this patch all accounts use the shared folder `WTF\Account\global\` instead – if
you play several accounts, you only have to set up your addons once. The
following are merged:

- the account-wide addon data (`SavedVariables\*.lua`),
- the per-character addon data (`<Realm>\<Character>\SavedVariables\*.lua`),
- the list of enabled addons (`AddOns.txt`, account-wide and per character).

Macros, key bindings as well as chat and game settings stay separate per
account as before.

> ℹ️ **Note:**
> The patch does not move existing addon data. To keep it, copy the contents of
> `WTF\Account\<ACCOUNT>\` to `WTF\Account\global\` before the first start. If
> the patch is reverted, WoW uses the folders of the individual accounts again;
> `global` is simply left as it is.

Technically the patch changes 9 bytes in the function that stores the account
name for the addon paths after login (VA `0x5F9080`): instead of the
name it copies the text `global`, which is already in `Wow.exe`. The original by
boredatom (`patch_globalvariables.exe`) moves the rest of the function by 4 bytes
for this; here everything stays in place. The advertising that the original
additionally writes into `Wow.exe` (a Telegram notice on the login screen) is
not included.

</details>

### DLL loaders

<a id="patch-awesome"></a>
<details>
<summary><b>Enable AwesomeWotlkLib.dll support</b> <i>(No. 22, Author: FrostAtom)</i></summary>

Allows `AwesomeWotlkLib.dll` to be loaded on client start. This DLL extends
the client with additional features and improvements for private servers.
**Requires** `AwesomeWotlkLib.dll` from [awesome_wotlk](https://github.com/noname08662/awesome_wotlk).
Belongs together with the 4GB patch (No. 1): if that one is not selected, the
patcher points it out.

The loader sits at the start of the client's main fiber (right before
`WinMain`) and overwrites the beginning of the Scan.dll start function for
that; the Lua function `ScanDLLStart` becomes a no-op and the Scan.dll flag is
set to "passed". As a side effect the patch disables the Scan.dll mechanism
(like No. 7). If the DLL is missing, WoW simply starts normally.

> ℹ️ **Note:**
> The patch itself is harmless, it only loads a DLL that is not included here.
> Only the loaded `AwesomeWotlkLib.dll` may be noticed by servers with
> anti-cheat – so use it only where awesome_wotlk is allowed. The patcher shows
> a yellow note for this.

</details>

<a id="patch-voicedll"></a>
<details>
<summary><b>Load voice.dll at startup (mod-voicechat) [ALPHA]</b> <i>(No. 23, off by default, Author: St0ny)</i></summary>

Loads `voice.dll` from the WoW folder at startup – the client part of
[mod-voicechat](https://github.com/Raz0r1337/mod-voicechat), a voice chat
module for AzerothCore. If the DLL is missing, WoW starts normally.

> 🛑 **Caution:**
> **ALPHA** – the mod-voicechat module is not finished yet. That is why this
> patch is deselected by default. The patch itself has been tested in game.

File size and PE header stay unchanged: the jump at the entry point (VA
`0x401005`) is redirected into a free 27-byte gap between two functions (VA
`0x944B45`), which holds `push "voice.dll"` → `call [LoadLibraryA]` → jump to the
original target. Before writing, the patcher checks the entry point, the gap and
the `LoadLibraryA` import.

</details>

### Gameplay fixes

<a id="patch-areatrigger"></a>
<details>
<summary><b>More precise area trigger timer (50 ms instead of 100 ms)</b> <i>(No. 24, Author: Robinsch)</i></summary>

Increases the area trigger check frequency from 100 ms to 50 ms, so zone
transitions and triggers are detected more precisely.

</details>

<a id="patch-swing"></a>
<details>
<summary><b>Remove melee swing on right-click</b> <i>(No. 25, Author: Robinsch)</i></summary>

Prevents the faulty auto-attack swing that was triggered when right-clicking
a target.

</details>

<a id="patch-npcanim"></a>
<details>
<summary><b>Suppress NPC attack animation when turning</b> <i>(No. 26, Author: Robinsch)</i></summary>

Suppresses the NPC attack animation when turning if no actual attack takes
place.

</details>

<a id="patch-spellanim"></a>
<details>
<summary><b>Fix spell animation after cancelled channel</b> <i>(No. 27, Author: Robinsch)</i></summary>

Fixes a bug where the preparation animation got stuck after cancelling a
channelled spell.

</details>

<a id="patch-forcereaction"></a>
<details>
<summary><b>Keep force reaction on /reload</b> <i>(No. 28, Author: Robinsch)</i></summary>

Prevents force reaction values (e.g. faction standing) from being reset when
reloading the UI. Important for custom servers.

</details>

<a id="patch-mail"></a>
<details>
<summary><b>New mail without the 60-second wait</b> <i>(No. 29, Author: Robinsch)</i></summary>

The client checks for new mail immediately – no more 60-second wait and no
relog needed to receive new mail.

</details>

<a id="patch-deadchat"></a>
<details>
<summary><b>Allow chat commands while dead</b> <i>(No. 30, Author: Robinsch)</i></summary>

Slash commands also work while the character is dead.

</details>

<a id="patch-follow"></a>
<details>
<summary><b>Allow /follow on NPCs</b> <i>(No. 31, off by default, Author: Alastor StrixEfuartus / St0ny)</i></summary>

`/follow` also works on NPCs, not just players. Based on the `/follow` patch
from Alastor StrixEfuartus' 12th Generation EXE, ported and adjusted by St0ny:
the original redirects the check into a code cave that ignores its result.
That cave, however, would sit exactly in the gap at the end of `.text` that
No. 4 and No. 53 use. Here the conditional jump after the check is made
unconditional instead – a single byte, same effect, and the patches work
together.

</details>

<a id="patch-level101"></a>
<details>
<summary><b>Level 101+ fix (game tables, barber chair, base stats)</b> <i>(No. 32, off by default, Author: Alastor StrixEfuartus / St0ny)</i></summary>

The client's game tables (`gtCombatRatings`, `gtBarberShopCostBase`,
`gtOCTRegenHP`/`MP`, `gtChanceToMeleeCrit` … – eleven tables) have 100 rows per
column, one per level. From level 101 on the client reads outside the column –
druids no longer see their base stats, the barber chair does not work, in the
worst case the client crashes. The patch clamps the row to the last one of the
column: level 101+ gets the values for level 100, everything below stays
unchanged.

> ℹ️ **Note:**
> The widespread version from the 12th Generation EXE removes the level from
> the calculation entirely instead – so *all* characters show the values for
> level 1 (ratings, critical strike chance, regeneration …). Here the two
> accessor functions (VA `0x7F69B0` and `0x7F69E0`) are rewritten for this.

**Requires** the patch "Allow custom GlueXML" (No. 14) according to the
source. There it is called "Disable XML SIG MD5", hence the note "Use XML MD5".

</details>

<a id="patch-raceclass"></a>
<details>
<summary><b>Character creation: more than 10 classes (random class)</b> <i>(No. 33, off by default, Author: Alastor StrixEfuartus / Robinsch)</i></summary>

The random class selection in character creation collects the allowed classes
in an array with 10 slots. With custom classes (`ChrClasses.dbc` with more than
10 entries) it would overflow; the patch enlarges it to 30 slots. Which race may
pick which class is still checked by the server – this patch does nothing more.

</details>

<a id="patch-namecheck"></a>
<details>
<summary><b>Disable the name check in character creation (e.g. digits in names)</b> <i>(No. 34, off by default, Author: Alyst3r (0x539wowmod) / St0ny)</i></summary>

Disables the complete client-side name check in character creation: the check
function (VA `0x6B0F90`) always reports "name valid". This allows e.g. digits in
names – but all other client rules (length, allowed characters etc.) are gone as
well. The original (0x539wowmod) uses a detour with the wrong calling
convention, here it is done directly in the function (`mov eax, 57h` / `ret`).

> ⚠️ **Warning:**
> The server still checks names itself and has to allow them as well, otherwise
> it rejects the character.

</details>

<a id="patch-maxchars"></a>
<details>
<summary><b>Max characters per realm raised to 255</b> <i>(No. 35, Author: St0ny)</i></summary>

Raises the client-side limit from 10 to 255 characters per realm. The server
has to support this as well. Additional interface changes (GlueXML) are
required for the character selection screen to show more than 10 slots.

</details>

<a id="patch-customitem"></a>
<details>
<summary><b>Custom Item Fix (BETA) v2</b> <i>(No. 36, off by default, Author: Kebabstorm / St0ny)</i></summary>

Makes custom items possible without changing the client's `Item.dbc`. Many
places in the client read the display ID, inventory type, class, subclass and
sheath of an item only from `Item.dbc`. Items that only exist in the server's
database are missing there – the client then shows e.g. no model on the
character and no icon. But `Wow.exe` already has helper functions that look
these values up in the item cache first (the data the server sends for every
item) and only then in `Item.dbc`. The patch redirects the plain DBC lookups to
these helper functions. If an item is in both, the server's values apply. On
the server, an entry in `item_template` is then all a custom item needs; with
TrinityCore, `DBC.EnforceItemAttributes = 0` must be set in `worldserver.conf`.
Only the material (the sound when moving the item in the inventory) still comes
from `Item.dbc` alone.

The basis is the "Custom Item Fix (BETA) v1" from Kebabstorm's
[WoW 3.3.5 Patcher (Custom Item Fix)](https://www.wowmodding.net/files/file/283-wow-335-patcher-custom-item-fix/).

**Recommended** together with "Disable CACHE folder creation" (No. 2): then WoW
does not store the item cache on disk and fetches changed custom items fresh
from the server at every start. If No. 2 is not selected, the patcher points
this out.

> ℹ️ **Note:**
> v2 has been tested in game. The v1 patch list this patch was taken from
> contained two errors that would have crashed the client: one line was missing
> a byte (turning the function for the item class into garbage), another was a
> copy of the line before it (a call landed in the middle of an unrelated
> function). v2 fixes both. All rebuilt places were checked by emulation with
> test items: only in the cache, only in `Item.dbc`, in both and in neither.

Not taken over from v1: the PE checksum (Windows does not check it for
programs) and the change `Cache` → `||che` – that is exactly patch No. 2.

</details>

<a id="patch-climb"></a>
<details>
<summary><b>Remove the climb angle limit (walk up any slope)</b> <i>(No. 37, off by default, Author: Alastor StrixEfuartus)</i></summary>

The character can walk up any slope, no matter how steep. The original stops at
50°: the client compares the slope with the cosine of that angle (`0.6427876`
at VA `0xA37F0C`). The patch sets it to `0.0` = cos 90°.

> ⚠️ **Warning:**
> Servers with anti-cheat may detect this as a climb hack – this can lead to a
> ban.

</details>

<a id="patch-jump"></a>
<details>
<summary><b>Change jump height (original -7.9555473)</b> <i>(No. 38, off by default, Author: Alastor StrixEfuartus)</i></summary>

Changes the initial velocity of a jump (VA `0xAA33DC`, original `-7.9555473`).
The patcher asks for the value after the selection: a negative number from
`-100` to just below `0`, with comma or dot as decimal separator. The lower the
value, the higher the jump; the height grows with the square, i.e. `-11.25`
gives about double and `-15.91` about four times the jump height. The value is
remembered like those of the client info patches.

> ⚠️ **Warning:**
> Servers with anti-cheat may detect this as a jump hack – this can lead to a
> ban.

</details>

<a id="patch-airforward"></a>
<details>
<summary><b>Steer forward/backward while jumping</b> <i>(No. 39, off by default, Author: Alyst3r (0x539wowmod) / St0ny)</i></summary>

Normally the client ignores forward and backward input while the character is
jumping or falling. With the patch the direction can be changed in the air as
well, even to the opposite direction. 0x539wowmod replaces the client's forward
input with a DLL for this; that version differs from the original only in two
jumps (do not stop in the air, recalculate the speed), which are changed directly
in the EXE here – without DLL and without a code cave. Added to this is the
byte patch from 0x539wowmod that updates the movement in the air.

> ⚠️ **Warning:**
> Servers with anti-cheat may detect changed movement in the air – this can
> lead to a ban.

</details>

<a id="patch-airlateral"></a>
<details>
<summary><b>Steer sideways while jumping</b> <i>(No. 40, off by default, Author: Alyst3r (0x539wowmod) / St0ny)</i></summary>

Like the previous patch, but for sideways movement (strafing): two jumps in the
client's sideways input plus the byte patch from 0x539wowmod that no longer stops
the movement early while the falling flag is set.

> ⚠️ **Warning:**
> Servers with anti-cheat may detect changed movement in the air – this can
> lead to a ban.

</details>

<a id="patch-airturn"></a>
<details>
<summary><b>Turning while jumping changes the flight direction</b> <i>(No. 41, off by default, Author: Alyst3r (0x539wowmod) / St0ny)</i></summary>

If you turn while jumping (mouse or keys), the character keeps its flight
direction in the original. With the patch the client sets the movement direction
in the air as well, like the 0x539wowmod DLL does. Works best together with the
two previous patches.

> ⚠️ **Warning:**
> Servers with anti-cheat may detect changed movement in the air – this can
> lead to a ban.

</details>

<a id="patch-doublejump"></a>
<details>
<summary><b>Double jump (more jumps in the air)</b> <i>(No. 42, off by default, Author: Alyst3r (0x539wowmod) / St0ny)</i></summary>

Allows more jumps while the character is in the air. After the selection the
patcher asks how many extra jumps there should be (1 to 9, `1` = double jump);
the value is remembered like those of the client info patches.

The client's jump function (VA `0x9883F0`) rejects every jump while the
character is falling. 0x539wowmod replaces it with a DLL and counts jump
charges. Here the same happens in a small code cave: a jump from the ground
sets a counter to the selected number, and in the air a jump is allowed as long
as the counter is not 0. Rooted or flying still blocks jumping. Every air jump
uses the same jump height as a normal jump (so also the value from "Change jump
height", No. 38). The separate second jump height of 0x539wowmod's double jump
is not included. The counter is only reset by the next jump from the ground,
not on landing: if you land after a jump and then walk off a ledge, you have the
chosen number of jumps in the air again.

The counter is a byte the client has to write. That is why the patch gets a small
section `.djump` of its own at the end of the file (the gap in `.text` is not
writable); this makes `Wow.exe` slightly larger.

> ⚠️ **Warning:**
> Servers with anti-cheat may detect jumps in the air – this can lead to a ban.
>
> This patch appends a section of its own, which makes `Wow.exe` larger.
> **Many servers do not tolerate a changed file size of `Wow.exe` – this can lead
> to a ban.**

</details>

### Graphics & view distance

<a id="patch-farclip"></a>
<details>
<summary><b>CVar farclip unlock (max 10000)</b> <i>(No. 43, Author: Alastor StrixEfuartus)</i></summary>

Unlocks the maximum view distance (farclip) to 10000 yards. The client clamps
the value when it is set, in a single function (VA `0x780770`), and has two
upper limits for it: 1583 yards normally and 791 yards as a fallback. The 791
applies in the old vanilla zones and on machines with at most 1 GB of RAM –
the client really does query the RAM size there. The patch raises both limits
to 10000, otherwise the view distance drops back to 791 depending on the zone.
The lower limit of 183 yards stays untouched, and there is no separate input
limit for the CVar – this clamp is the limit.
Not to be confused with the 1277 from the video menu: that is the maximum of
the view distance slider and a completely different location in the EXE (see
patch No. 47 "Graphics options: extend slider maximums").

</details>

<a id="patch-horizon"></a>
<details>
<summary><b>CVar horizonFarclipScale unlock (max 12)</b> <i>(No. 44, Author: St0ny)</i></summary>

Unlocks the CVar `horizonFarclipScale` and sets its maximum to 12. Noticeably
increases the horizon view distance.

</details>

<a id="patch-envdetail"></a>
<details>
<summary><b>CVar environmentDetail unlock (no limit instead of 1.5)</b> <i>(No. 45, Author: St0ny)</i></summary>

Removes the upper limit of the CVar `environmentDetail` entirely. Originally
the value is clamped to the range 0.5 to 1.5; the patch replaces the clamped
value with the raw value at the shared exit of the check – so the lower limit
0.5 goes away as well, any value is passed through (sensible values start at
0.5).
Important: this CVar does nothing but multiply the GameObject view distances
(see patch No. 48) – in the original only for categories 1 to 3, with patch
No. 48 for all five. That makes it the most convenient FPS lever for object
rendering, since it works in-game without re-patching.

</details>

<a id="patch-grounddist"></a>
<details>
<summary><b>CVar groundEffectDist unlock (max 3166 instead of 140)</b> <i>(No. 46)</i></summary>

Raises the maximum view distance for ground effects (grass, flowers, ground
clutter) from 140 to 3166 yards.

</details>

<a id="patch-sliders"></a>
<details>
<summary><b>Graphics options: extend slider maximums</b> <i>(No. 47, off by default, Author: St0ny)</i></summary>

Raises the maximums of four sliders in the video menu, "Effects" tab. The
CVars themselves have long been unlocked by the unlock patches – but the
sliders stayed at Blizzard's values because they don't take their maximum
from the CVar limit.

| CVar                  | Slider before | Slider after |
|-----------------------|--------------:|-------------:|
| `farclip`             | 1277          | 2477         |
| `environmentDetail`   | 1.5           | 2.5          |
| `groundEffectDist`    | 140           | 250          |
| `groundEffectDensity` | 64            | 256          |

The minimums stay unchanged (177 / 0.5 / 70 / 16), as do the step sizes from
the interface. They divide evenly: 8 steps for `environmentDetail`, 18 for
`groundEffectDist`, 30 for `groundEffectDensity`. For the view distance slider
the interface calculates the step size itself as (max−min)/10, so 230 yards
per notch here.

<details>
<summary><b>Background: why the sliders didn't grow with the unlocks before</b></summary>

The interface builds every slider using this pattern:

```lua
minValue = GetCVarMin(cvar)  -- or fallback value from the Lua
maxValue = GetCVarMax(cvar)  -- or fallback value from the Lua
```

So it asks the EXE first and only uses the fallback from
`VideoOptionsPanels.lua` if the EXE returns nothing. In the original,
`GetCVarMax` only knows two CVars: `extShadowQuality` and `farclip`. For
everything else it returns nothing, and then the hard-coded Lua values
1.5 / 140 / 64 apply. For `farclip` it returned a fixed 1277 – likewise
regardless of how far the CVar is unlocked.

The patch replaces the fixed farclip comparison with a call to a small lookup
routine that walks a list of CVar names. If a CVar is listed, the interface
gets the matching maximum; if not, everything works as before. The routine
(18 bytes) lives in a free gap between two functions of the code section, the
list with the maximums in the unused rest of `.rdata` – the file does not grow.

Important: `GetCVarMax` exists twice in the EXE – once for the login/character
screens and once for the running game. Both call the same lookup routine. If
only one of them is patched, the sliders in-game stay at 1277 / 1.5 / 140 / 64
without any visible sign.

</details>

**Two limitations**

- The slider only sets the CVar. Without the unlock patches the client clamps
  the value back to its original immediately – so the patches "CVar farclip
  unlock" (No. 43), "CVar environmentDetail unlock" (No. 45) and "CVar
  groundEffectDist unlock" (No. 46) belong with it. If they are missing from
  the selection, the patcher points this out.
- For `groundEffectDensity` nothing changes above 64: the vertex buffer for
  ground clutter is hard-clamped in the client to density × 64 ≤ 4096. The
  slider goes up to 256, but visually nothing changes above 64.

**The Ultra preset stays at Blizzard's values**

The master "Graphics quality" slider still sets 1277 / 1.5 / 140 / 64 on
Ultra, not the new maximums. This cannot be changed from the EXE: the preset
values are plain Lua constants in
`Interface\FrameXML\GraphicsQualityLevels.lua` and are written directly into
the sliders from there. The only link from the EXE into this path is
`VideoOptionsEffectsPanel_FixupQualityLevels`, and that function can only
clamp – values above the maximum down, values below the minimum up. Both apply
per CVar to all six quality levels at once; a single level cannot be
addressed.

> 🛑 **Caution:**
> Tempting dead end: you could pull Ultra up via the minimum
> (`GetCVarMin("farclip")` is the double at `0x9F5798`, originally 177.0), but
> then ALL six levels are pulled to that value – Low just like Ultra – and the
> slider ends up with minimum above maximum, sticks to the end stop and gets a
> negative step size. Exactly that happened in an earlier attempt and caused
> startup crashes via `Config.wtf`. Leave the minimum double alone.

If you really want Ultra at the new maximums, you need the interface side, i.e.
an MPQ with a modified `GraphicsQualityLevels.lua` – then the values are fixed
in the client instead of being set afterwards by an addon. This is
deliberately not part of this patcher: it remains a pure EXE patcher that
touches nothing but `Wow.exe`.

**No slider for horizonFarclipScale**

There is no slider for this CVar in the video menu at all – it doesn't appear
anywhere in the interface. An EXE patch cannot raise anything here because
there is nothing to raise. The value can still only be set via `Config.wtf`,
`/console horizonFarclipScale 12` or a CVar addon (it is unlocked up to 12,
see above).

> ℹ️ **Note:**
> The file size does not change: the small search routine lives in a free gap
> between two functions, the table with the maximums in the unused rest of
> `.rdata`. There is no overlap with No. 4 and No. 53.

</details>

<a id="patch-goscale"></a>
<details>
<summary><b>GameObject view distance: Cat 0 and Cat 4 scale with environmentDetail</b> <i>(No. 48, off by default, Author: St0ny)</i></summary>

Fixes an omission in the client: the function that calculates the runtime view
distances from the base values only multiplies Cat 1 to 3 by the CVar
`environmentDetail`. Cat 0 (small clutter) and Cat 4 (huge buildings) take
their base value unchanged – the slider simply doesn't affect them.
The patch adds the missing multiplication in both blocks. The space for it
comes from dropping a redundant copy of the size thresholds (both tables are
identical and never modified). Afterwards `environmentDetail` scales all five
categories evenly – the slider becomes a true master slider. The base view
distances stay at Blizzard's values; everything is controlled via the CVar:

| environmentDetail | Cat 0 | Cat 1 | Cat 2 | Cat 3 | Cat 4 |
|------------------:|------:|------:|------:|------:|------:|
| 1.0               | 30    | 100   | 200   | 750   | 1250  |
| 2.0               | 60    | 200   | 400   | 1500  | 2500  |
| 10                | 300   | 1000  | 2000  | 7500  | 12500 |

With patch No. 49, Cat 0 is at 50 instead of 30 yards (so 50 / 100 / 500 in
the table above). Values above 1.5 require the patch "CVar environmentDetail
unlock" (No. 45).

</details>

<a id="patch-cat0"></a>
<details>
<summary><b>GameObject view distance: Cat 0 from 30 to 50 yards</b> <i>(No. 49, off by default, Author: St0ny)</i></summary>

The patch costs performance: noticeably more small clutter is visible at the
same time, and the number of drawn objects is the performance lever. If you
want to keep view distances entirely at Blizzard's values, leave it out. It
only raises the smallest object category: candles, books, sacks,
tools. In the original, Cat 0 is so tight at 30 yards that small clutter
disappears much earlier than everything else; 50 improves the ratio to Cat 1
from 1:3.3 to 1:2, and the `environmentDetail` slider scales it
proportionally. Cat 1 to 4 are not touched – the view distance is controlled
via the CVar, which, together with the code patch No. 48, stretches all five
categories evenly.

Five related values are changed:

| Value                   | Blizzard | Patch |
|-------------------------|---------:|------:|
| Base view distance      | 30       | 50    |
| Runtime view distance   | 30       | 50    |
| View distance squared   | 900      | 2500  |
| Fade start              | 25       | 45    |
| Fade start squared      | 625      | 2025  |

The runtime value must match the base value, the squares are the squares of
those, and the fade start is view distance minus fade band. The fade band stays
at Blizzard's 5 yards.

<details>
<summary><b>Background: how the categories are determined</b></summary>

The client takes an object's bounding box, determines the **longest edge**
(not the radius, not the volume) and looks for the first threshold that is
greater than or equal to that edge:

| Category | Longest edge      | Examples                                  |
|----------|-------------------|-------------------------------------------|
| Cat 0    | up to 1 yard      | candles, books, sacks, tools              |
| Cat 1    | 1 to 4 yards      | crates, barrels, cabinets, fire bowls     |
| Cat 2    | 4 to 15 yards     | large tables, banners, cannons            |
| Cat 3    | 15 to 100 yards   | gates, cages, thrones, raid doors         |
| Cat 4    | 100 yards and up  | zeppelins, floating platforms             |

The thresholds are a separate table in the EXE and are NOT touched by this
patch. The examples come from the client's `GameObjectDisplayInfo.dbc`.
Note: the fully transformed box is classified, so an upscaled object can end
up one category higher than its model suggests.

**Interaction with the CVar environmentDetail**

The values in this patch are base values. The client recalculates them every
time `environmentDetail` is set:

```
view distance = base value * environmentDetail
```

In the original this ONLY applies to Cat 1, 2 and 3 – for Cat 0 and Cat 4 the
multiplication is missing from the code. The patch "Cat 0 and Cat 4 scale with
environmentDetail" adds it, so all five categories grow evenly.

Important when doing the math: the two factors **multiply**. Base value ×2 at
CVar 1.5 results in ×3, not ×2. To reach a target factor Z at CVar value E,
enter Z/E as the base value.
Without patch No. 48 this only applies to Cat 1–3, and the categories drift
apart at high CVar values: Cat 3 would eventually overtake Cat 4, so
medium-sized objects would be visible further away than huge ones.

Note: if a category distance is above the CVar `farclip`, the general view
distance cuts off first and the category has no visible effect anymore. At
farclip 1100, Cat 4 is effectively capped at 1100 – higher values only take
effect once farclip grows accordingly.

**Derived tables**

View distance and fade band are one table each in the EXE, plus four more that
the client calculates from them – every time `environmentDetail` is set:

```
runtime view distance = base value * environmentDetail
fade start            = runtime view distance - fade band
squared tables        = the square of each
                        (the engine culls using the squares, saving the sqrt)
```

So the only real inputs are the base view distances and the fade bands.
Anyone writing the four derived tables anyway has to keep them consistent,
otherwise the values jump on the first recalculation.

**Fade bands**

The fade band widths are at Blizzard's original values (5/10/15/20/50) and are
not scaled. The band is the distance over which an object fades out before
the cull limit – narrow bands keep objects opaque until shortly before,
instead of letting them fade out semi-transparently over many yards.
The fade start is always view distance minus band and moves with
`environmentDetail`: at 1.0 it is 25/90/185/730/1200, at 2.0 it is
55/190/385/1480/2450. Because the band stays the same, the fade start grows
slightly faster than the view distance itself.

Note: the view distance determines how many objects are drawn at the same
time and is therefore the performance lever. The fade bands cost practically
no FPS – if you find pop-in more annoying than losing a few frames per second,
you can widen them independently of the distances.

</details>

</details>

<a id="patch-occluder"></a>
<details>
<summary><b>Occluder fix for Stormwind (Open Azeroth)</b> <i>(No. 50, off by default, Author: Robinsch)</i></summary>

Disables the occluders (view blockers) for Stormwind that are hard-coded in the
client: the map key of the table entry for the Eastern Kingdoms is set to
99999, so it no longer matches any map. This way no buildings and objects are
hidden incorrectly on custom servers with a rebuilt Stormwind.

</details>

<a id="patch-bluemoon"></a>
<details>
<summary><b>Re-enable the blue moon in the night sky</b> <i>(No. 51, Author: Robinsch)</i></summary>

Restores a removed legacy feature: the blue moon that used to be visible in
the night sky.

</details>

<a id="patch-notransparency"></a>
<details>
<summary><b>No character transparency when zooming in</b> <i>(No. 52, Author: Alastor StrixEfuartus)</i></summary>

Your own character no longer becomes transparent when the camera is zoomed in
close. The patch removes the transparency assignment for the normal case; if
the character sits in a vehicle or is attached to another object, it can still
become transparent when zooming in (same as in the original patch).

</details>

<a id="patch-nofade"></a>
<details>
<summary><b>No fade-out for NPCs with flag DO_NOT_FADE_IN</b> <i>(No. 53, off by default, Author: Alyst3r (0x539wowmod) / St0ny)</i></summary>

When an NPC is removed (e.g. despawn), the client normally fades the model out
slowly. With the patch, NPCs for which the server sets the flag
`UNIT_FLAG2_DO_NOT_FADE_IN` (`0x20`) in `UNIT_FIELD_FLAGS_2` disappear instantly –
matching the missing fade-in. Players and NPCs without the flag behave as
before.

> ❗ **Important:**
> Only takes effect if the server sets the flag. Without server support nothing
> changes.
>
> As with No. 4, the code lives in the free gap at the end of `.text`. Both fit
> in there together, the file size does not change.

</details>

<a id="patch-hdportraits"></a>
<details>
<summary><b>HD unit frame portraits: render resolution 256 instead of 64 pixels</b> <i>(No. 54, off by default, Author: Badgermilk0 / St0ny)</i></summary>

The unit frames (player, target, party, bosses etc.) already show the 3D model
of the respective character in the unmodified client. So the patch creates
**no new portraits, no images and no animations** – it changes a single
number: the client renders this model into a texture for the frame, and that
texture is 64×64 pixels in the original. The patch raises exactly this render
resolution to 256×256 pixels, hard-wired via the call `Add-HdPortraits 256` in
`apply_patches.ps1`. Badgermilk0's original allows up to 4096×4096; 256 was
chosen here deliberately, because more only costs memory without looking
visibly better. Framing, tilt and zoom stay the same, the portraits just
become much sharper.
Only the 3D model path is raised; the icon/file path (fixed 64×64 images for
item/spell icons) deliberately stays at 64, because its copy loop would
otherwise read past the source.

> ⚠️ **Warning:**
> This patch appends a new PE section `.hdp` to `Wow.exe` (generated 256px alpha
> mask + code caves + detour of the mask builder), the file grows by about
> 69 KB. **Many servers do not tolerate a changed file size of `Wow.exe` – this
> can lead to a ban.**

</details>

### Interface & comfort

<a id="patch-tracker"></a>
<details>
<summary><b>Auto-sort quest tracker</b> <i>(No. 55, off by default)</i></summary>

Sets the CVar `trackerSorting` to 1 by default. Quests in the tracker are
sorted automatically.

</details>

<a id="patch-worldmap"></a>
<details>
<summary><b>Advanced world map enabled by default</b> <i>(No. 56, off by default)</i></summary>

Sets the CVar `advancedWorldMap` to 1 by default. The advanced map view is
enabled from the start.

</details>

<a id="patch-castbars"></a>
<details>
<summary><b>Cast bars on all frames</b> <i>(No. 57, Author: Kebabstorm)</i></summary>

Shows cast bars on all unit frames (party, arena, boss etc.), not just target
and focus, as well as on all default nameplates. Matches the behavior from
Cataclysm onwards.

</details>

<a id="patch-emblems"></a>
<details>
<summary><b>Retail guild emblems: selection extended from 170 to 196</b> <i>(No. 58, off by default, Author: MacWarrior)</i></summary>

The client keeps the number of selectable tabard variants in a small table
(VA `0xA14908`, file offset `0x613108`): 170 emblems, 17 emblem colors,
6 borders, 17 border colors, 51 background colors. The tabard designer cycles
with "index modulo count", the random tabard picks "rand() times count" – both
read the value at runtime, and there is no second hard-coded 170 anywhere. The
patch raises the emblem count to retail's 196, which removes the limit
completely.

> ⚠️ **Warning:**
> **Additional MPQ patch archive required.** This patch only raises the counter
> in the EXE, it does not ship any graphics. The 26 new emblems (index 170 to
> 195) have to be provided as a separate MPQ archive in the `Data` folder.
> Without it, the new slots in the tabard designer can be selected but stay
> empty.
>
> The matching archive is **Patch-G**: [Discord](https://discord.com/channels/407664041016688662/1541873346608889936)

The client builds the file names from the emblem index and color index, in
this order:

```
Textures\GuildEmblems\Emblem_<Index>_<Color>_TU_U   (upper half)
Textures\GuildEmblems\Emblem_<Index>_<Color>_TL_U   (lower half)
```

The texture loader appends the `.blp` extension. That is 17 colors × 2 halves
= 34 files per emblem, 884 files for all 26 new emblems. The archive name is
up to you (`patch-*.MPQ`), thanks to the patch "Allow extended MPQ names"
(No. 16).

</details>

<a id="patch-flash"></a>
<details>
<summary><b>FlashWindow patch</b> <i>(No. 59, Author: Kebabstorm)</i></summary>

Makes the WoW window flash in the taskbar when a relevant event occurs while
the game is in the background. For this the Lua function `BNRemoveFriend`,
which has no function in 3.3.5a, is replaced by `FlashWindow()`, which addons
can call (Windows API `FlashWindow(hwnd, FALSE)`, exactly like the version in
`AwesomeWotlkLib.dll`).
**Requires** an addon that calls `FlashWindow()`, e.g. the
[Flash addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash) from awesome_wotlk –
which additionally needs `IsWindowFocused()` from `AwesomeWotlkLib.dll`
(No. 22).

</details>

<a id="patch-charrandom"></a>
<details>
<summary><b>Character creation: do not randomize the appearance automatically</b> <i>(No. 60, off by default, Author: Alyst3r (0x539wowmod))</i></summary>

When opening character creation (clicking "Create New Character") and when
changing race or gender, the client no longer randomizes face, skin, hair style
etc. automatically; you start with the default appearance. The randomize button
keeps working – it uses a separate path in the client.

</details>

### Window, mouse & camera

<a id="patch-window"></a>
<details>
<summary><b>Windowed mode by default</b> <i>(No. 61, off by default, Author: St0ny)</i></summary>

Sets the CVar `gxWindow` to 1 by default. The game starts in windowed mode
instead of fullscreen.

</details>

<a id="patch-maximize"></a>
<details>
<summary><b>Maximized window by default</b> <i>(No. 62, off by default, Author: St0ny)</i></summary>

Sets the CVar `gxMaximize` to 1 by default. The window is maximized on start.

</details>

<a id="patch-windowfix"></a>
<details>
<summary><b>No black screen when switching to windowed mode</b> <i>(No. 63, Author: Robinsch)</i></summary>

Switching to windowed mode while in-game no longer results in a black
screen. Technically the callback of the CVar `DesktopGamma` always takes the
game-gamma path; the desktop-gamma path and with it the CVar `DesktopGamma`
have no effect.

</details>

<a id="patch-mouse"></a>
<details>
<summary><b>Mouse flicker / camera jump fix</b> <i>(No. 64, Author: Robinsch)</i></summary>

A larger patch (4 parts) that fixes problems with mice using a high polling
rate. Prevents cursor flicker and uncontrolled camera movement.

</details>

<a id="patch-camera"></a>
<details>
<summary><b>CameraReforged [BETA]: camera height and zoom limits</b> <i>(No. 65, off by default, Author: Stormhand / St0ny)</i></summary>

Port of [CameraReforged](https://github.com/Zendevve/CameraReforged) by
**Stormhand** into this patcher, so everything
runs in one pass – included with his explicit permission ("Of course! Take
whatever you need. I appreciate your work."). The port and its adjustments were
made by St0ny. The client gets two brand-new CVars and new default values for
two existing ones.

> ⚠️ **Warning:**
> **BETA** – this patch does not work 100% yet, more work is going into it.
> That is why it is deselected by default. The shoulder offset
> (`test_cameraOverShoulder`) currently has no effect: the four read sites the
> original redirects for it do not belong to the camera but to the chat frame
> (display time of messages). They are left untouched here.

| CVar                      | Blizzard  | here  | Range         |
|---------------------------|-----------|-------|---------------|
| `test_cameraHeight`       | (missing) | 0.50  | 0.0 to 3.0    |
| `test_cameraOverShoulder` | (missing) | 0.00  | -2.0 to 2.0 (no effect) |
| `cameraDistanceMaxFactor` | 1.0       | 2.60  | 1.0 to 5.0    |
| `cameraDistanceMoveSpeed` | 8.33      | 20.00 | 1.0 to 100.0  |

- `test_cameraHeight` raises the point the camera aims at. The client puts it
  at chest height; 0.5 yards brings it to head height.
- `test_cameraOverShoulder` is meant to shift the camera sideways, negative
  values to the left – currently without effect (see above).
- `cameraDistanceMaxFactor` is the factor by which you can zoom out beyond the
  normal limit, `cameraDistanceMoveSpeed` the zoom speed.

In 3.3.5a both new CVars were previously only available through
`ConsoleXP.dll` plus an injector – the patch registers them directly in the
EXE. All four are reachable via the console in-game and take effect
immediately, so they also work from macros and addons such as DynamicCam, e.g.
`/console test_cameraHeight 0.8`. They are registered with flag `0x10` and
saved to `Config.wtf`, so changes survive a restart. The default values can be
changed in the call
`Add-CameraReforged -Height 0.5 -Shoulder 0.0 -MaxFactor 2.6 -ZoomSpeed 20.0`
in `apply_patches.ps1`; values outside the ranges are rejected.

<details>
<summary><b>Background: how the patch is wired in</b></summary>

The patch appends its own section `.camr` to the EXE (about +1 KB,
read/write/execute) with code and data. It is wired up via a detour on
`CVars_Initialize` (where the new CVars are registered), a detour on the camera
focus path (where the height is added) and two redirected default-value
pointers.

Two deviations from the original tool, both necessary:

1. *Own section instead of `.rdata` padding.* The original puts code and data
   into the `.rdata` padding and makes that section executable – exactly that
   makes this client abort on start with runtime error R6002.
2. *Pointer instead of callback.* The original's callback is a validation
   callback that runs before the new value is stored, so the value lags behind
   every change. Here the init hook stores the pointer to the CVar object and
   the camera hook reads the value fresh every frame.

Do not run `CameraReforged.exe` in addition: it brings back the R6002 crash and
overwrites the table of the slider patch.

</details>

> ⚠️ **Warning:**
> Like the HD portraits, this patch appends a section of its own (about +1 KB),
> which makes `Wow.exe` larger. **Many servers do not tolerate a changed file
> size of `Wow.exe` – this can lead to a ban.**

</details>

### Sound

<a id="patch-sound"></a>
<details>
<summary><b>Optimize sound settings</b> <i>(No. 66, off by default, Author: St0ny)</i></summary>

Includes the following changes:

- Sound channel hardware limit raised to 126
- `Sound_OutputQuality` set to maximum (2)
- `Sound_NumChannels` raised from 32 to 64
- `Sound_EnableReverb` enabled (reverb effect)
- `Sound_EnableHardware` enabled (hardware audio acceleration)

The channel limit of 126 is hard-coded in the initialisation code; the default
of 64 for `Sound_NumChannels` only applies at the second place where the client
reads the CVar.

> ❗ **Important:**
> **OpenAL** is required for these settings to take effect at all, e.g.
> [OpenAL Soft](https://github.com/kcat/openal-soft).

</details>

### Client info: version, build, title, date, icon

These five patches by MacWarrior (ported from his Python scripts
`edit_version.py`, `edit_revision.py`, `edit_title.py`, `edit_date.py` and
`edit_icon.py`) change how the client identifies itself. When selected, **the
patcher asks for the desired values after the selection**. A suggestion is
shown in square brackets, ENTER accepts it. Invalid input is rejected with a
message and asked for again, and all values are checked before anything is
written. The patcher remembers the values in `patcher_selection.ini`
(`value.<Id>=…`); with `-Unattended` the remembered values are used, otherwise
the original values – exceptions: build date (today's date) and icon (the
patcher aborts), see No. 70 and 71. If a patch is already in `Wow.exe`, its
current value is the suggestion. When asking, it is also shown after the patch
name (`-> suggestion: …`, or `-> current: …` for an already applied patch).

> [!NOTE]
> Servers may check the client version or build number, so a changed value has
> to match the server.

<a id="patch-clientversion"></a>
<details>
<summary><b>Change client version (original 3.3.5)</b> <i>(No. 67, off by default, Author: MacWarrior)</i></summary>

Sets a new version in the format `x.y.z` (e.g. `3.3.6` or `3.3.123`, at most 7
characters). Changes the version the client shows in-game, the FileVersion and
ProductVersion (`Version x.y`) of the version resource and `VS_FIXEDFILEINFO`.
The build number in `VS_FIXEDFILEINFO` is kept; the FileVersion text
(`3, 3, 5, 12340`) becomes the plain version (`3.3.6`). Major and minor version
together must fit into the ProductVersion field (e.g. `3.3`).

</details>

<a id="patch-clientbuild"></a>
<details>
<summary><b>Change build number (original 12340)</b> <i>(No. 68, off by default, Author: MacWarrior)</i></summary>

Sets a new build number (6142 to 65535, original `12340`): the internal build
number, the visible build number and the fourth part of the FileVersion in
`VS_FIXEDFILEINFO`. The texts `3, 3, 5, 12340` (FileVersion text) and
`WoW [Release] Build 12340 (…)` stay unchanged. The
patcher does not allow builds up to 6141: servers like AzerothCore or
TrinityCore then treat the client as a Classic client (pre-BC) and use a
different login protocol – a 3.3.5 client can no longer get onto the server.

> 💡 **Tip:**
> **AzerothCore:** the authserver only accepts builds listed in the `build_info`
> table of the auth database. For a build of your own, e.g. `12341`:
>
> ```sql
> INSERT INTO build_info (majorVersion, minorVersion, bugfixVersion, hotfixVersion, build, winChecksumSeed, macChecksumSeed)
> VALUES (3, 3, 5, 'a', 12341, NULL, NULL);
> UPDATE realmlist SET gamebuild = 12341 WHERE id = 1;
> ```
>
> Leave `winChecksumSeed` empty (it is only checked with `StrictVersionCheck = 1`
> in `authserver.conf` and would not match a patched exe anyway).
> Major/minor/bugfix are only displayed in the realm list. Restart the
> authserver afterwards – it reads `build_info` only at startup. A realm only
> accepts the build in `realmlist.gamebuild`; players with an older client see
> it as offline.

</details>

<a id="patch-clienttitle"></a>
<details>
<summary><b>Change program title in the file properties</b> <i>(No. 69, off by default, Author: MacWarrior / St0ny)</i></summary>

Sets FileDescription, InternalName and ProductName of the version resource,
i.e. what Windows shows in the file properties and the Task Manager. At most 17
characters, ASCII only.

</details>

<a id="patch-clientdate"></a>
<details>
<summary><b>Change build date (original Jun 24 2010)</b> <i>(No. 70, off by default, Author: MacWarrior)</i></summary>

Sets the build date (original `Jun 24 2010`) at all three places in the EXE and
the year in the copyright notice. Input as `YYYY-MM-DD`, optionally followed by
`FR` for French month names (e.g. `2026-09-28 FR` → `Sep 28 2026`). The
suggestion in brackets is **today's date** (with `FR` if you chose it last
time); with `-Unattended` the remembered value is used, or today's date if
nothing is remembered. If the patch is already applied, the current date of
`Wow.exe` is suggested.

</details>

<a id="patch-clienticon"></a>
<details>
<summary><b>Change program icon (icon of Wow.exe)</b> <i>(No. 71, off by default, Author: MacWarrior / St0ny)</i></summary>

Replaces the icon Windows shows for `Wow.exe` (Explorer, taskbar, shortcuts).
The patcher asks for the path of an `.ico` or `.png` file, absolute or
relative to the WoW folder. From that file it builds the four sizes stored in
`Wow.exe` (48, 32, 24 and 16 pixels, each 32-bit with alpha channel): if a size
is present in the ICO it is used as is, otherwise the next larger image is
downscaled by area averaging (or, as a last resort, the largest one is
upscaled). A PNG provides all four sizes by scaling. Transparency is kept.

MacWarrior's `edit_icon.py` swaps the resources via the Windows API, which
rewrites the `.rsrc` section. Here only the image data of the eight existing
icon bitmaps (four sizes in two language variants) is overwritten in place –
same size, same bit depth, same space. Resource directory, offsets and file
size stay unchanged, and the patch can be removed like any other. The other
patches are not shifted by it, not even those that append a section: they land
after the end of the file, while the icon images lie before it. Before writing,
the patcher checks in the resource directory that each of the eight places
really holds an icon image of exactly this size. If not, it aborts without
writing anything. The patcher reads ICO images in BMP form (1, 4, 8, 16, 24
or 32 bit) and PNG (not
interlaced) by itself, without extra modules. The path is remembered in
`patcher_selection.ini`; with `-Unattended` it has to be there, otherwise the
patcher aborts with a message.

> ℹ️ **Note:**
> If Explorer still shows the old icon afterwards, that is the Windows icon
> cache: rename `Wow.exe` briefly or copy it to another folder, recreate
> shortcuts or restart Explorer. The icon in the game itself (window title)
> comes from these resources as well.

</details>

---

## Notes

- **Ban risk:** two groups of patches can lead to a ban on many servers. First,
  patches that servers with anti-cheat may treat as cheating or botting: LUA
  unlock (No. 18 and 19), climb angle (37), jump height (38), the air steering
  (39–41) and the double jump (42). Second, patches that append a section to `Wow.exe`
  and thus make the file larger: No. 42, 54 and 65 – many servers do not
  tolerate a changed file size. Both groups are marked "ban risk" in the
  overview, and the patcher shows a red warning before the confirmation prompt.
  All other patches do not change the file size.
- **Signature:** the original `Wow.exe` is digitally signed by Blizzard. Every
  patch invalidates this signature. Windows will therefore probably warn about
  an unsigned, potentially harmful app when it starts; with "More info" → "Run
  anyway" WoW starts normally. A new signature that Windows trusts is only
  issued by certificate authorities with identity verification – you cannot
  get one for a modified Blizzard file. The patches that append a section
  (No. 42, 54 and 65) also remove the reference to the
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

## Removed patches

Two patches from Robinsch's collection that earlier versions of this patcher
contained were removed after the code review – their offsets do not match this
`Wow.exe`:

- **Fix "ghost" attack when NPCs evade from combat** (`0x355BF`: `E8` → `EB`).
  The byte turns a `call` in a string helper function (VA `0x4361BF`) into a
  jump back by 5 bytes – an endless loop that pushes 4 bytes onto the stack per
  iteration until the client crashes. The function is rarely called, which is
  why this went unnoticed in game.
- **Fix naked character bug** (`0x1DDC5D`: `00` → `EB`). The byte is the
  argument of a `push 0` in the Lua function `GetTradeSkillTools`
  (VA `0x5DE85C`) and turns it into `push -21` – it only corrupts a parameter of
  the profession tool check and has nothing to do with `SPELL_AURA_X_RAY`.

A `Wow.exe` that was still created with these two patches is no longer
recognized by the patcher without `patcher_state.ini`: copy `Wow.exe.ORI` back
and patch again.

## Acknowledgements

A very special thank you goes to **Billy Hoyle** – for all his help and tips
over the past months and for helping to collect the patches. His patch set is
included as the preset "Billy's_Wow.exe" and is the default selection.

**MacWarrior** also helped collect the patches and contributed some of his
own – thank you as well!

Thanks also to **Stormhand** for the permission to include his CameraReforged
patch.

Thanks to **Moroes**, who tracked down patch [#21](#patch-globalsv) and passed it
on to me.

And of course thanks to all patch authors named in the
[patch overview](#patch-overview).

## License

This project is licensed under the [MIT License](LICENSE).
Copyright (c) 2026 St0ny (Raz0r1337).

In short: anyone may use, modify and redistribute the patcher – including in
their own projects – as long as the copyright notice and the license text are
kept (attribution).
