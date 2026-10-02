# St0nys-AIO-WoW-EXE-Patcher

[🇩🇪 Deutsch](README.md) | 🇬🇧 English

An all-in-one (AIO) patcher for the `Wow.exe` of **World of Warcraft 3.3.5a (build 12340)**.
It applies bug fixes, performance optimizations, extended view distances,
improved sound settings and a few quality-of-life features directly to the
executable – in a single pass, without extra tools or DLL injectors.

On start you choose the **language** (Deutsch / English) and then pick
**which patches** to apply from a menu. Applied patches can be **deselected or
extended** at any time later – all the way back to the original `Wow.exe`.

> [!IMPORTANT]
> This repository does **not** contain a `Wow.exe` or any other Blizzard files.
> You need your own unmodified `Wow.exe` 3.3.5a (12340).

> [!WARNING]
> **Use at your own risk.** Some patches in this patcher can get you **banned**
> on some public servers. We do our best to mark all affected patches
> accordingly, but servers change their detection from time to time. When in
> doubt, check the rules of your server.

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
  (on the first start; after that a `Wow.exe` patched with this patcher)

## Usage

1. Copy `patcher.bat` and `apply_patches.ps1` into your WoW folder
   (next to `Wow.exe`).
2. Close WoW if it is still running.
3. Double-click `patcher.bat`.
4. Choose the language (first start only), select patches, confirm – done.

To **change or remove** patches just run `patcher.bat` again, see
[Changing or removing patches](#changing-or-removing-patches).

## Workflow

1. The ASCII banner is shown.
2. **Language selection:** `1` = Deutsch, `2` = English. First start only – after
   that the language is remembered and can be switched with `L` in the menu.
3. Welcome message, press ENTER to start.
4. Check that a `Wow.exe` exists in the folder.
5. Checking `Wow.exe`: on the first start it must be original and unmodified
   (SHA256). After that the patcher recognizes a `Wow.exe` patched by itself by
   the watermark and determines which patches are in it. Anything else aborts.
6. **Patch selection** menu (see below). Your selection from last time is
   preselected, or for a patched `Wow.exe` the patches currently in it.
7. Summary of the selected patches (for a patched `Wow.exe`: what is added and
   what is removed), notes about missing or redundant companion patches and a
   confirmation prompt (Y/N).
8. Backup: on the first patch run the original is saved as `Wow.exe.ORI`, on
   every later run the previous `Wow.exe` is saved as `Wow.exe.BAK`.
9. All selected patches are applied in memory (with progress output) and
   `Wow.exe` is written back **once**. If anything fails, `Wow.exe` stays
   untouched.
10. The patcher remembers the hash of the new `Wow.exe` together with the
    original bytes in `patcher_state.ini` (for a faster next start) and shows a
    final message.

## Patch selection

The menu lists every patch with a number. `[X]` = will be applied,
`[ ]` = will be skipped. The menu is grouped into the same categories as the
[patch overview](#patch-overview). On the first start the
**preset "Billy's_Wow.exe"** is preselected (see the "Default" column in the
overview), after that the saved selection or the patches currently in
`Wow.exe`. `S` loads the second preset **"Billy's_Wow.exe (edited by St0ny)"**
(column "St0ny"). Patches that need something additional say so in parentheses after
their name, with the link right below.

| Input              | Effect                                     |
|--------------------|--------------------------------------------|
| `5`                | toggle patch 5                             |
| `3 7 12` / `3,7,12`| toggle several patches                     |
| `10-15`            | toggle a range                             |
| `A`                | all patches on                             |
| `N`                | all patches off (patched `Wow.exe` + ENTER: restore the original) |
| `L`                | switch language (Deutsch ↔ English)        |
| `B`                | load preset "Billy's_Wow.exe" (= default)  |
| `S`                | load preset "Billy's_Wow.exe (edited by St0ny)" – **not tested yet** |
| `Q`                | quit, `Wow.exe` stays unmodified           |
| `ENTER`            | accept the selection and continue          |

Before the confirmation prompt the patcher shows **notes**, nothing is blocked:
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
  hand. It also holds the entered values of the client info patches
  (`value.clientversion=3.3.6` etc.).
- The language is remembered there as well (`language=de` or `en`).
- **Reset:** press `B` in the menu or delete `patcher_selection.ini` – then
  the preset "Billy's_Wow.exe" applies again.

The preset "Billy's_Wow.exe" is Billy Hoyle's patch set and also the default
selection. It is defined in `apply_patches.ps1`: every patch has an entry
`On = $true` (in the preset) or `On = $false` (not in the preset).

The second preset "Billy's_Wow.exe (edited by St0ny)" (key `S`) is Billy's
patch set plus the RCE fix, the security and login patches, MPQ signature
check off, the `/follow` fix, level 101, object scale, tracker, world map and
windowed mode. The list is in `apply_patches.ps1` under `$PRESET_STONY`; in
the overview it is the "St0ny" column. **Warning: this preset has not been
tested yet.** The patcher shows this as a yellow note when you load it with `S`.

## Changing or removing patches

Applied patches are not final. Just run `patcher.bat` again: the menu then has
exactly the patches checked that are currently in `Wow.exe`. Newly checked
patches are marked **(new)**, deselected ones **(will be removed)**. This way
you can add patches, deselect them or change values (jump height, double
jump, client info) as you like. `N` and ENTER removes every patch – afterwards
`Wow.exe` is **byte-for-byte the original** again.

How it works:

- **First start:** `Wow.exe` must be original (SHA256 check), otherwise the
  patcher aborts. Patching saves the original as `Wow.exe.ORI`, and every
  patched `Wow.exe` gets a [watermark](#notes).
- **Every later start:** the patcher recognizes a `Wow.exe` patched by itself
  by the watermark. If it is missing (and the file is not original), it aborts
  – e.g. for an exe patched with another tool.
- **Determining the patch state:** if the hash in `patcher_state.ini` matches
  (the patcher stores hash, patches, values and original bytes there after
  every run), it uses that file – the fast way. Otherwise, e.g. if the file is
  missing or the `Wow.exe` comes from another computer, the patcher checks all
  patch locations in the exe itself: which patches are in it, and with which
  values (jump height, build date etc.)? For this the script contains a small
  table with the original bytes at all patch locations.
- **Restoring the original:** from the patched exe the patcher rebuilds the
  original in memory, verifies it against the original's SHA256 and applies the
  new selection on top. If that does not work exactly – e.g. because the exe
  was changed in some other way after patching – it aborts.
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
| `-Language de\|en`     | set the language for this run (does not change the remembered language)   |
| `-Select <selection>`  | skip the selection menu: `saved` (saved selection), `billy` (preset "Billy's_Wow.exe", also `default`), `stony` (preset "Billy's_Wow.exe (edited by St0ny)"), `all`, `none` (remove all patches, restore the original) or numbers/ranges like `"1,3,5-8"`. The selection completely replaces the patches in `Wow.exe`. Using `-Select` does not change the saved selection. |
| `-Unattended`          | no prompts and no pauses. Without `-Language` the remembered language or German is used, without `-Select` the saved selection or the preset "Billy's_Wow.exe". |
| `-Path <file>`         | patch a `Wow.exe` other than the one next to the script                    |

Example:

```bat
patcher.bat -Language en -Select saved -Unattended
```

Exit codes: `0` = success (or nothing to do), `1` = error, `2` = cancelled (by the user or because no more input is possible).

## Files

| File                | Purpose |
|---------------------|---------|
| `patcher.bat`       | Launcher, calls `apply_patches.ps1` |
| `apply_patches.ps1` | Patch engine: language selection, checks, selection menu, backup; reads the EXE once, patches in memory, writes it back once |
| `README.md`         | German documentation |
| `README.en.md`      | This file |
| `patcher_selection.ini` | Created when you accept a selection, stores your patch selection |
| `patcher_state.ini` | Created when patching: hash of the patched `Wow.exe`, applied patches, values and original bytes – speeds up the next start, but is not strictly required |
| `Wow.exe.ORI`       | Backup of the original `Wow.exe`, created on the first patch run |
| `Wow.exe.BAK`       | Backup of the previous `Wow.exe` from before the last run |
| `LICENSE`           | MIT license |

---

## Patch overview

| No. | Patch | Author | Default | St0ny |
|----:|-------|-------|:--------:|:-----:|
|    | **System & performance** |  |  |  |
| 1  | 4GB patch (Large Address Aware) | Alastor StrixEfuartus / Kebabstorm / Robinsch | ✅ | ✅ |
| 2  | Disable CACHE folder creation | Alastor StrixEfuartus / Kebabstorm | – | – |
| 3  | Refresh item cache immediately | Robinsch | ✅ | ✅ |
| 4  | WorldFrame crash fix (invalid triangle indices) *(shares code cave with the slider patch; together the exe grows – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | – |
|    | **Security & privacy** |  |  |  |
| 5  | Remote code execution exploit fix *(enable only one of the two RCE patches)* | Robinsch | – | ✅ |
| 6  | Disable Warden completely, RCE fix *(may get you kicked if Warden is active; enable only one of the two RCE patches)* | Robinsch | – | – |
| 7  | Disable Scan.dll | Alastor StrixEfuartus | – | ✅ |
| 8  | Disallow client patches from the server | Kebabstorm | – | ✅ |
| 9  | Disallow hardware surveys from the server | Kebabstorm | – | ✅ |
|    | **Login & connection** |  |  |  |
| 10 | Skip Battle.net login | Kebabstorm | – | ✅ |
| 11 | Skip Remote Desktop check | Kebabstorm | – | ✅ |
| 12 | Disable HTTP requests to Battle.net | Kebabstorm | – | ✅ |
| 13 | Disable AFK timer idle check *(required for character auto-login, [Discord](https://discord.com/channels/858041817043042364/1515439916878663701))* | St0ny | – | – |
|    | **Modding: interface, MPQs & addons** |  |  |  |
| 14 | Allow custom GlueXML | Alastor StrixEfuartus / Kebabstorm | ✅ | ✅ |
| 15 | Allow unsigned / incorrectly signed MPQs | Alastor StrixEfuartus | – | ✅ |
| 16 | Allow extended MPQ names |  | ✅ | ✅ |
| 17 | Load data directly from the Data folder (no MPQ) | Alastor StrixEfuartus | ✅ | ✅ |
| 18 | LUA unlock (allow protected functions) *(may be treated as botting – ban risk)* | Alastor StrixEfuartus | – | – |
| 19 | Enable AwesomeWotlkLib.dll support *(requires [awesome_wotlk](https://github.com/noname08662/awesome_wotlk))* | FrostAtom | ✅ | ✅ |
| 20 | Load voice.dll at startup (mod-voicechat) [ALPHA] *(module untested and unfinished, [mod-voicechat](https://github.com/Raz0r1337/mod-voicechat))* | St0ny | – | – |
| 21 | Pass all keyboard events on to addons (OnKeyDown) | Alyst3r (0x539wowmod) | – | – |
|    | **Gameplay fixes** |  |  |  |
| 22 | More precise area trigger timer (50 ms instead of 250 ms) | Robinsch | ✅ | ✅ |
| 23 | Remove melee swing on right-click | Robinsch | ✅ | ✅ |
| 24 | Suppress NPC attack animation when turning | Robinsch | ✅ | ✅ |
| 25 | Fix spell animation after cancelled channel | Robinsch | ✅ | ✅ |
| 26 | Fix "ghost" attack when NPCs evade from combat | Robinsch | ✅ | ✅ |
| 27 | Fix naked character bug | Robinsch | ✅ | ✅ |
| 28 | Keep force reaction on /reload | Robinsch | ✅ | ✅ |
| 29 | New mail without the 60-second wait | Robinsch | ✅ | ✅ |
| 30 | Allow chat commands while dead | Robinsch | ✅ | ✅ |
| 31 | Allow /follow on NPCs | Alastor StrixEfuartus / St0ny | – | ✅ |
| 32 | Level 101+ fix (druid base stats and barber chair) | Alastor StrixEfuartus | – | ✅ |
| 33 | Unlimited race/class combinations *(server must support it)* | Alastor StrixEfuartus / Robinsch | – | – |
| 34 | Disable the name check in character creation (e.g. digits in names) *(server must allow the names as well)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 35 | Max characters per realm raised to 255 | St0ny | ✅ | ✅ |
| 36 | Remove the climb angle limit (walk up any slope) *(may be detected as cheating by the server – ban risk)* | Alastor StrixEfuartus | – | – |
| 37 | Change jump height (original -7.9555473) *(asks for the value, may be detected as cheating by the server – ban risk)* | Alastor StrixEfuartus | – | – |
| 38 | Steer forward/backward while jumping *(may be detected as cheating by the server – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 39 | Steer sideways while jumping *(may be detected as cheating by the server – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 40 | Turning while jumping changes the flight direction *(may be detected as cheating by the server – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 41 | Double jump (more jumps in the air) *(asks for the value, may be detected as cheating by the server, exe grows – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | – |
|    | **Graphics & view distance** |  |  |  |
| 42 | CVar farclip unlock (max 10000) | Alastor StrixEfuartus | ✅ | ✅ |
| 43 | CVar horizonFarclipScale unlock (max 12) | St0ny | ✅ | ✅ |
| 44 | CVar environmentDetail unlock (no limit instead of 1.5) | St0ny | ✅ | ✅ |
| 45 | CVar groundEffectDist unlock (max 3166 instead of 140) |  | ✅ | ✅ |
| 46 | Graphics options: extend slider maximums | St0ny | – | – |
| 47 | GameObject view distance: Cat 0 and Cat 4 scale with environmentDetail | St0ny | – | ✅ |
| 48 | GameObject view distance: Cat 0 from 30 to 50 yards *(costs performance, more small objects visible)* | St0ny | – | – |
| 49 | Occluder fix for Stormwind (Open Azeroth) | Robinsch | – | – |
| 50 | Re-enable the blue moon in the night sky | Robinsch | ✅ | ✅ |
| 51 | No character transparency when zooming in | Alastor StrixEfuartus | ✅ | ✅ |
| 52 | No fade-out for NPCs with flag DO_NOT_FADE_IN *(server must set the flag, shares code cave with the slider patch; together the exe grows – ban risk)* | Alyst3r (0x539wowmod) / St0ny | – | – |
| 53 | HD unit frame portraits: 256x256 (live 3D portraits) *(exe grows – ban risk)* | Badgermilk0 | – | – |
|    | **Interface & comfort** |  |  |  |
| 54 | Auto-sort quest tracker |  | – | ✅ |
| 55 | Advanced world map enabled by default |  | – | ✅ |
| 56 | Cast bars on all frames | Kebabstorm | ✅ | ✅ |
| 57 | Retail guild emblems: selection extended from 170 to 196 *(requires [Patch-G](https://discord.com/channels/407664041016688662/1541873346608889936))* | MacWarrior | – | – |
| 58 | FlashWindow patch *(requires the [FlashWindow addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash))* | Kebabstorm | ✅ | ✅ |
| 59 | Character creation: do not randomize the appearance automatically | Alyst3r (0x539wowmod) | – | – |
|    | **Window, mouse & camera** |  |  |  |
| 60 | Windowed mode by default | St0ny | – | ✅ |
| 61 | Maximized window by default | St0ny | – | ✅ |
| 62 | No black screen when switching to windowed mode | Robinsch | ✅ | ✅ |
| 63 | Mouse flicker / camera jump fix | Robinsch | ✅ | ✅ |
| 64 | CameraReforged [BETA]: camera height, shoulder offset, zoom limits *(not 100% finished yet; exe grows – ban risk)* | Stormhand / St0ny | – | – |
|    | **Sound** |  |  |  |
| 65 | Optimize sound settings *(requires [OpenAL](https://github.com/kcat/openal-soft))* | St0ny | – | – |
|    | **Client info: version, build, title, date** |  |  |  |
| 66 | Change client version (original 3.3.5) *(asks for the value)* | MacWarrior | – | – |
| 67 | Change build number (original 12340) *(asks for the value)* | MacWarrior | – | – |
| 68 | Change program title in the file properties *(asks for the value)* | MacWarrior | – | – |
| 69 | Change build date (original Jun 24 2010) *(asks for the value)* | MacWarrior | – | – |

> [!NOTE]
> **Authors wanted:** For patches without an entry in the "Author" column, the
> author is not known yet. If you know who made one of these patches, please
> open an [issue](https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher/issues) – it will be added.

---

## Patch descriptions

### System & performance

**4GB patch (Large Address Aware)** *(No. 1, Author: Alastor StrixEfuartus / Kebabstorm / Robinsch)*
Lets `Wow.exe` use up to 4 GB of RAM instead of the default 2 GB limit for
32-bit applications.

**Disable CACHE folder creation** *(No. 2, off by default, Author: Alastor StrixEfuartus / Kebabstorm)*
Prevents the client from creating a `CACHE` folder automatically.

**Refresh item cache immediately** *(No. 3, Author: Robinsch)*
Removes the 30-second delay when refreshing the item cache. Item changes
become visible immediately.

**WorldFrame crash fix (invalid triangle indices)** *(No. 4, off by default, Author: Alyst3r (0x539wowmod) / St0ny)*
Prevents a crash in a world rendering function (VA `0x81D510`). It walks over
triangles made of three vertex indices each and turns "index minus base" into a
memory address. If an index is smaller than the base, the address points before
the buffer and the client crashes. The patch checks the three indices of the
first triangle beforehand and skips the function in that case. Compared to the
original, the three jump distances have been corrected and the code is shorter.

> [!IMPORTANT]
> **Shares the code cave with the slider patch (No. 46).** The code lives in the
> free gap at the end of `.text`, which No. 52 uses as well. No. 4 and 52 fit in
> there together, but not next to the slider patch: if No. 46 is selected, the
> patch automatically moves to a small section `.wfcfix` of its own at the end
> of the file, and the patcher points this out before the confirmation prompt.
> This makes `Wow.exe` slightly larger (a 512-byte section plus padding of the
> end of the file, about 1.4 KB for No. 4 and 52 together; removing the patches
> takes this away again). **Many servers do not tolerate a changed file size of
> `Wow.exe` – this can lead to a ban.**

> [!NOTE]
> A heuristic fix, as the author calls it too: only the first triangle of each
> call is checked. It does no harm when everything is fine, but does not catch
> every conceivable case.

### Security & privacy

**Remote code execution exploit fix** *(No. 5, off by default, Author: Robinsch)*
Closes a vulnerability that could allow remote code execution through crafted
packets: the `.zdata` section loses its execute permission and Warden modules
are no longer loaded from the local cache. Warden itself keeps working, so
servers with active Warden are not a problem.

> [!NOTE]
> Enable only one of the two RCE patches: either this one (Warden keeps running)
> or "Disable Warden completely" (No. 6), which closes the hole as well. Both
> together add nothing.

**Disable Warden completely, RCE fix** *(No. 6, off by default, Author: Robinsch)*
The client drops all Warden packets from the server (`SMSG_WARDEN_DATA`).
Warden modules are code the server has the client execute – with this patch
that is no longer possible at all, including future tricks. Makes the RCE fix
(No. 5) unnecessary, so it only makes sense to enable one of the two. Both
together do no harm, the patcher just points it out.

> [!WARNING]
> The client no longer answers Warden. Servers with active Warden (e.g.
> AzerothCore or TrinityCore with default settings) may therefore kick you.

**Disable Scan.dll** *(No. 7, off by default, Author: Alastor StrixEfuartus)*
Disables the Warden scan DLL mechanism in the client.

**Disallow client patches from the server** *(No. 8, off by default, Author: Kebabstorm)*
The server can no longer send patch files to the client and have them
installed.

**Disallow hardware surveys from the server** *(No. 9, off by default, Author: Kebabstorm)*
The server can no longer request a hardware survey (information about your PC)
from the client.

### Login & connection

**Skip Battle.net login** *(No. 10, off by default, Author: Kebabstorm)*
The client skips the Battle.net login step and goes straight to the classic
login.

**Skip Remote Desktop check** *(No. 11, off by default, Author: Kebabstorm)*
The client no longer checks whether it runs over a Remote Desktop connection –
so WoW can be played via RDP, for example.

**Disable HTTP requests to Battle.net** *(No. 12, off by default, Author: Kebabstorm)*
The client no longer fetches news, help articles and terms of use from
Blizzard's servers – they no longer exist for 3.3.5 anyway.

**Disable AFK timer idle check** *(No. 13, off by default, Author: St0ny)*
Disables the idle login check but keeps the automatic AFK disconnect timer
active. Also prevents the CharAutoLogin bug.
**Required for character auto-login** – details on [Discord](https://discord.com/channels/858041817043042364/1515439916878663701).

### Modding: interface, MPQs & addons

**Allow custom GlueXML** *(No. 14, Author: Alastor StrixEfuartus / Kebabstorm)*
Allows modifying the login and character selection screens with your own
XML/Lua files (glue screen modding).

**Allow unsigned / incorrectly signed MPQs** *(No. 15, off by default, Author: Alastor StrixEfuartus)*
Allows loading MPQ archives without a valid signature. Required for custom
content on private servers.

**Allow extended MPQ names** *(No. 16)*
Allows wildcard names for MPQ archives (`patch-*.MPQ` and
`patch-locale-*.MPQ`).

**Load data directly from the Data folder (no MPQ)** *(No. 17, Author: Alastor StrixEfuartus)*
The client reads files directly from the Data folder without packing them into
an MPQ – e.g. `Data\DBFilesClient\ItemDisplayInfo.dbc`. Handy for modders.

**LUA unlock (allow protected functions)** *(No. 18, off by default, Author: Alastor StrixEfuartus)*
Addons and macros may call protected functions, e.g. `CastSpellByName`,
`CastSpellByID`, `TargetUnit`, `FocusUnit`, `InteractUnit`, movement functions
or `ReloadUI`. `AttackTarget` still prints an error.

> [!WARNING]
> This enables automation. Servers with anti-cheat may treat it as botting –
> this can lead to a ban.

**Enable AwesomeWotlkLib.dll support** *(No. 19, Author: FrostAtom)*
Allows `AwesomeWotlkLib.dll` to be loaded on client start. This DLL extends
the client with additional features and improvements for private servers.
**Requires** `AwesomeWotlkLib.dll` from [awesome_wotlk](https://github.com/noname08662/awesome_wotlk).

> [!NOTE]
> The patch itself is harmless, it only loads a DLL that is not included here.
> Only the loaded `AwesomeWotlkLib.dll` may be noticed by servers with
> anti-cheat – so use it only where awesome_wotlk is allowed. The patcher shows
> a yellow note for this.

**Load voice.dll at startup (mod-voicechat) [ALPHA]** *(No. 20, off by default, Author: St0ny)*
Loads `voice.dll` from the WoW folder at startup – the client part of
[mod-voicechat](https://github.com/Raz0r1337/mod-voicechat), a voice chat module for AzerothCore. If the DLL is
missing, WoW starts normally.

> [!CAUTION]
> **ALPHA** – the mod-voicechat module is still completely untested and not
> finished. It is not released for playing. That is why this patch is
> deselected by default.

File size and PE header stay unchanged: the jump at the entry point (VA
`0x401005`) is redirected into a free 27-byte gap between two functions (VA
`0x944B45`), which holds `push "voice.dll"` → `call [LoadLibraryA]` → jump to the
original target. Before writing, the patcher checks the entry point, the gap and
the `LoadLibraryA` import.

**Pass all keyboard events on to addons (OnKeyDown)** *(No. 21, off by default, Author: Alyst3r (0x539wowmod))*
If a frame has an OnKeyDown script, the client reports the key as handled
afterwards – it no longer reaches the key bindings. With the patch every key
continues to the key bindings after the OnKeyDown script. This lets addons see
all key presses without blocking the normal controls.

> [!NOTE]
> Addons that rely on OnKeyDown "swallowing" a key will additionally trigger the
> bound action.

### Gameplay fixes

**More precise area trigger timer (50 ms instead of 250 ms)** *(No. 22, Author: Robinsch)*
Increases the area trigger check frequency from 250 ms to 50 ms, so zone
transitions and triggers are detected more precisely.

**Remove melee swing on right-click** *(No. 23, Author: Robinsch)*
Prevents the faulty auto-attack swing that was triggered when right-clicking
a target.

**Suppress NPC attack animation when turning** *(No. 24, Author: Robinsch)*
Suppresses the NPC attack animation when turning if no actual attack takes
place.

**Fix spell animation after cancelled channel** *(No. 25, Author: Robinsch)*
Fixes a bug where the preparation animation got stuck after cancelling a
channelled spell.

**Fix "ghost" attack when NPCs evade from combat** *(No. 26, Author: Robinsch)*
Fixes the "ghost" attack NPCs perform when they evade from combat.

**Fix naked character bug** *(No. 27, Author: Robinsch)*
Disables the `SPELL_AURA_X_RAY` effect that could cause characters to be
rendered without their equipment.

**Keep force reaction on /reload** *(No. 28, Author: Robinsch)*
Prevents force reaction values (e.g. faction standing) from being reset when
reloading the UI. Important for custom servers.

**New mail without the 60-second wait** *(No. 29, Author: Robinsch)*
The client checks for new mail immediately – no more 60-second wait and no
relog needed to receive new mail.

**Allow chat commands while dead** *(No. 30, Author: Robinsch)*
Slash commands also work while the character is dead.

**Allow /follow on NPCs** *(No. 31, off by default, Author: Alastor StrixEfuartus / St0ny)*
`/follow` also works on NPCs, not just players. Based on the /follow patch
from Alastor StrixEfuartus' 12th Generation EXE, ported and adjusted by St0ny:
the original redirects the check into a code cave that ignores its result.
That cave, however, sits exactly where the slider
patch (No. 46) puts its code. Here the conditional jump after the check
is made unconditional instead – a single byte, same effect, and both patches
work together.

**Level 101+ fix (druid base stats and barber chair)** *(No. 32, off by default, Author: Alastor StrixEfuartus)*
Druids at level 101 and above can view their base stats again, and the
barber chair works for all characters at level 101 and above.
**Requires** the patch "Allow custom GlueXML" (No. 14). In the source it is
called "Disable XML SIG MD5", hence the note "Use XML MD5" there.

**Unlimited race/class combinations** *(No. 33, off by default, Author: Alastor StrixEfuartus / Robinsch)*
Character creation allows every race with every class. The server has to
support this as well.

**Disable the name check in character creation (e.g. digits in names)** *(No. 34, off by default, Author: Alyst3r (0x539wowmod) / St0ny)*
Disables the complete client-side name check in character creation: the check
function (VA `0x6B0F90`) always reports "name valid". This allows e.g. digits in
names – but all other client rules (length, allowed characters etc.) are gone as
well. The original (0x539wowmod) uses a detour with the wrong calling
convention, here it is done directly in the function (`mov eax, 57h` / `ret`).

> [!WARNING]
> The server still checks names itself and has to allow them as well, otherwise
> it rejects the character.

**Max characters per realm raised to 255** *(No. 35, Author: St0ny)*
Raises the client-side limit from 10 to 255 characters per realm. The server
has to support this as well. Additional interface changes (GlueXML) are
required for the character selection screen to show more than 10 slots.

**Remove the climb angle limit (walk up any slope)** *(No. 36, off by default, Author: Alastor StrixEfuartus)*
The character can walk up any slope, no matter how steep. The original stops at
50°: the client compares the slope with the cosine of that angle (`0.6427876`
at VA `0xA37F0C`). The patch sets it to `0.0` = cos 90°.

> [!WARNING]
> Servers with anti-cheat may detect this as a climb hack – this can lead to a
> ban.

**Change jump height (original -7.9555473)** *(No. 37, off by default, Author: Alastor StrixEfuartus)*
Changes the initial velocity of a jump (VA `0xAA33DC`, original `-7.9555473`).
The patcher asks for the value after the selection: a negative number from
`-100` to just below `0`, with comma or dot as decimal separator. The lower the
value, the higher the jump; the height grows with the square, i.e. `-11.25`
gives about double and `-15.91` about four times the jump height. The value is
remembered like those of the client info patches.

> [!WARNING]
> Servers with anti-cheat may detect this as a jump hack – this can lead to a
> ban.

**Steer forward/backward while jumping** *(No. 38, off by default, Author: Alyst3r (0x539wowmod) / St0ny)*
Normally the client ignores forward and backward input while the character is
jumping or falling. With the patch the direction can be changed in the air as
well, even to the opposite direction. 0x539wowmod replaces the client's forward
input with a DLL for this; that version differs from the original only in two
jumps (do not stop in the air, recalculate the speed), which are changed directly
in the EXE here – without DLL and without a code cave. On top comes the byte
patch from 0x539wowmod that updates the movement in the air.

> [!WARNING]
> Servers with anti-cheat may detect changed movement in the air – this can
> lead to a ban.

**Steer sideways while jumping** *(No. 39, off by default, Author: Alyst3r (0x539wowmod) / St0ny)*
Like the previous patch, but for sideways movement (strafing): two jumps in the
client's sideways input plus the byte patch from 0x539wowmod that no longer stops
the movement early while the falling flag is set.

> [!WARNING]
> Servers with anti-cheat may detect changed movement in the air – this can
> lead to a ban.

**Turning while jumping changes the flight direction** *(No. 40, off by default, Author: Alyst3r (0x539wowmod) / St0ny)*
If you turn while jumping (mouse or keys), the character keeps its flight
direction in the original. With the patch the client sets the movement direction
in the air as well, like the 0x539wowmod DLL does. Works best together with the
two previous patches.

> [!WARNING]
> Servers with anti-cheat may detect changed movement in the air – this can
> lead to a ban.

**Double jump (more jumps in the air)** *(No. 41, off by default, Author: Alyst3r (0x539wowmod) / St0ny)*
Allows more jumps while the character is in the air. After the selection the
patcher asks how many extra jumps there should be (1 to 9, `1` = double jump);
the value is remembered like those of the client info patches.

The client's jump function (VA `0x9883F0`) rejects every jump while the character
is falling. 0x539wowmod replaces it with a DLL and counts jump charges. Here the
same happens in a small code cave: a jump from the ground sets a counter to the
selected number, and in the air a jump is allowed as long as the counter is not
0. Rooted or flying still blocks jumping. Every air jump uses the same jump
height as a normal jump (so also the value from "Change jump height"). The
separate second jump height of 0x539wowmod's double jump is not included.

The counter is a byte the client has to write. That is why the patch gets a small
section `.djump` of its own at the end of the file (the gap in `.text` is not
writable); this makes `Wow.exe` slightly larger.

> [!WARNING]
> Servers with anti-cheat may detect jumps in the air – this can lead to a ban.
>
> This patch appends a section of its own, which makes `Wow.exe` larger.
> **Many servers do not tolerate a changed file size of `Wow.exe` – this can lead
> to a ban.**

### Graphics & view distance

**CVar farclip unlock (max 10000)** *(No. 42, Author: Alastor StrixEfuartus)*
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
patch No. 46 "Graphics options: extend slider maximums").

**CVar horizonFarclipScale unlock (max 12)** *(No. 43, Author: St0ny)*
Unlocks the CVar `horizonFarclipScale` and sets its maximum to 12. Noticeably
increases the horizon view distance.

**CVar environmentDetail unlock (no limit instead of 1.5)** *(No. 44, Author: St0ny)*
Removes the upper limit of the CVar `environmentDetail` entirely. Originally
the value is clamped to the range 0.5 to 1.5; the patch disables the upper
clamp so arbitrarily high values are passed through.
Important: this CVar does nothing but multiply the GameObject view distances
(see patch No. 47) – in the original only for categories 1 to 3, with patch
No. 47 for all five. That makes it the
most convenient FPS lever for object rendering, since it works in-game without
re-patching.

**CVar groundEffectDist unlock (max 3166 instead of 140)** *(No. 45)*
Raises the maximum view distance for ground effects (grass, flowers, ground
clutter) from 140 to 3166 yards.

**Graphics options: extend slider maximums** *(No. 46, off by default, Author: St0ny)*
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
<summary><b>Background: why the sliders didn't grow along before</b></summary>

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
routine that walks a table of {CVar name, maximum}. If a CVar is listed, the
interface gets that value; if not, everything works as before. The routine
lives in the padding at the end of the code section, the table in the padding
of the data section – the file does not grow.

Important: `GetCVarMax` exists twice in the EXE – once for the login/character
screens and once for the running game. Both call the same lookup routine. If
only one of them is patched, the sliders in-game stay at 1277 / 1.5 / 140 / 64
without any visible sign.

</details>

**Two limitations**

- The slider only sets the CVar. Without the unlock patches the client clamps
  the value back to its original immediately – so the patches "Farclip unlock"
  (No. 42), "CVar environmentDetail unlock" (No. 44) and "CVar
  groundEffectDist unlock" (No. 45) belong with it. If they are missing from
  the selection, the patcher points this out.
- For `groundEffectDensity` nothing changes above 64: the vertex buffer for
  ground clutter is hard-clamped in the client to density × 64 ≤ 4096. The
  slider goes up to 256, but visually nothing changes above 64.

**The Ultra preset stays at Blizzard's values**

The master "Graphics quality" slider still sets 1277 / 1.5 / 64 / 140 on
Ultra, not the new maximums. This cannot be changed from the EXE: the preset
values are plain Lua constants in
`Interface\FrameXML\GraphicsQualityLevels.lua` and are written directly into
the sliders from there. The only link from the EXE into this path is
`VideoOptionsEffectsPanel_FixupQualityLevels`, and that function can only
clamp – values above the maximum down, values below the minimum up. Both apply
per CVar to all six quality levels at once; a single level cannot be
addressed.

> [!CAUTION]
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

> [!WARNING]
> No. 4 and No. 52 use the code cave at the end of `.text` as well. Together with
> this patch they automatically move to small sections of their own at the end
> of the file – this makes `Wow.exe` slightly larger. **Many servers do not
> tolerate a changed file size of `Wow.exe` – this can lead to a ban.**

**GameObject view distance: Cat 0 and Cat 4 scale with environmentDetail** *(No. 47, off by default, Author: St0ny)*
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

With patch No. 48, Cat 0 is at 50 instead of 30 yards (so 50 / 100 / 500 in
the table above). Values above 1.5 require the patch "CVar environmentDetail
unlock" (No. 44).

**GameObject view distance: Cat 0 from 30 to 50 yards** *(No. 48, off by default, Author: St0ny)*
If you want to keep view distances entirely at Blizzard's values, deselect
this patch. It costs performance: noticeably more small clutter is visible at
the same time, and the number of drawn objects is the performance lever.
The patch only raises the smallest object category: candles, books, sacks,
tools. In the original, Cat 0 is so tight at 30 yards that small clutter
disappears much earlier than everything else; 50 improves the ratio to Cat 1
from 1:3.3 to 1:2, and the `environmentDetail` slider scales it
proportionally. Cat 1 to 4 are not touched – the view distance is controlled
via the CVar (see the previous patch), which, together with the code patch,
stretches all five categories evenly.

Five related values are changed:

| Value                   | Blizzard | Patch |
|-------------------------|---------:|------:|
| View distance           | 30       | 50    |
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
Without the code patch this only applies to Cat 1–3, and the categories drift
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

**Occluder fix for Stormwind (Open Azeroth)** *(No. 49, off by default, Author: Robinsch)*
Raises the occluder threshold for Stormwind so buildings and objects are not
hidden incorrectly. Fixes graphical glitches on custom servers with a rebuilt
Stormwind.

**Re-enable the blue moon in the night sky** *(No. 50, Author: Robinsch)*
Restores a removed legacy feature: the blue moon that used to be visible in
the night sky.

**No character transparency when zooming in** *(No. 51, Author: Alastor StrixEfuartus)*
Your own character no longer becomes transparent when the camera is zoomed in
close.

**No fade-out for NPCs with flag DO_NOT_FADE_IN** *(No. 52, off by default, Author: Alyst3r (0x539wowmod) / St0ny)*
When an NPC is removed (e.g. despawn), the client normally fades the model out
slowly. With the patch, NPCs for which the server sets the flag
`UNIT_FLAG2_DO_NOT_FADE_IN` (`0x20`) in `UNIT_FIELD_FLAGS_2` disappear instantly –
matching the missing fade-in. Players and NPCs without the flag behave as
before.

> [!IMPORTANT]
> Only takes effect if the server sets the flag. Without server support nothing
> changes.
>
> **Shares the code cave with the slider patch (No. 46).** As with No. 4: together
> with the slider patch, the patch automatically moves to a small section
> `.nofade` of its own at the end of the file, which makes `Wow.exe` slightly
> larger. **Many servers do not tolerate a changed file size of `Wow.exe` – this
> can lead to a ban.**

**HD unit frame portraits: 256x256 (live 3D portraits)** *(No. 53, off by default, Author: Badgermilk0)*
Renders the live 3D portraits (player, target, party, bosses etc.) at 256×256
instead of the default 64×64. Framing, tilt and zoom stay the same – only the
render resolution increases, so the portraits become much sharper.
Only the 3D model path is raised; the icon/file path (fixed 64×64 images for
item/spell icons) deliberately stays at 64, because its copy loop would
otherwise read past the source.

> [!WARNING]
> This patch appends a new PE section `.hdp` to `Wow.exe` (generated 256px alpha
> mask + code caves + detour of the mask builder), the file grows by about
> 69 KB. **Many servers do not tolerate a changed file size of `Wow.exe` – this
> can lead to a ban.**

### Interface & comfort

**Auto-sort quest tracker** *(No. 54, off by default)*
Sets the CVar `trackerSorting` to 1 by default. Quests in the tracker are
sorted automatically.

**Advanced world map enabled by default** *(No. 55, off by default)*
Sets the CVar `advancedWorldMap` to 1 by default. The advanced map view is
enabled from the start.

**Cast bars on all frames** *(No. 56, Author: Kebabstorm)*
Shows cast bars on all unit frames (party, arena, boss etc.), not just target
and focus, as well as on all default nameplates. Matches the behavior from
Cataclysm onwards.

**Retail guild emblems: selection extended from 170 to 196** *(No. 57, off by default, Author: MacWarrior)*
The client keeps the number of selectable tabard variants in a small table
(VA `0xA14908`, file offset `0x613108`): 170 emblems, 17 emblem colors,
6 borders, 17 border colors, 51 background colors. The tabard designer cycles
with "index modulo count", the random tabard picks "rand() times count" – both
read the value at runtime, and there is no second hard-coded 170 anywhere. The
patch raises the emblem count to retail's 196, which removes the limit
completely.

> [!WARNING]
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

**FlashWindow patch** *(No. 58, Author: Kebabstorm)*
FlashWindow: makes the WoW window flash in the taskbar when a relevant event
occurs while the game is in the background. The function can be called from
addons.
**Requires** the [FlashWindow addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash) from awesome_wotlk.

**Character creation: do not randomize the appearance automatically** *(No. 59, off by default, Author: Alyst3r (0x539wowmod))*
When opening character creation (clicking "Create New Character") and when
changing race or gender, the client no longer randomizes face, skin, hair style
etc. automatically; you start with the default appearance. The randomize button
keeps working – it uses a separate path in the client.

### Window, mouse & camera

**Windowed mode by default** *(No. 60, off by default, Author: St0ny)*
Sets the CVar `gxWindow` to 1 by default. The game starts in windowed mode
instead of fullscreen.

**Maximized window by default** *(No. 61, off by default, Author: St0ny)*
Sets the CVar `gxMaximize` to 1 by default. The window is maximized on start.

**No black screen when switching to windowed mode** *(No. 62, Author: Robinsch)*
Switching to windowed mode while in-game no longer results in a black
screen.

**Mouse flicker / camera jump fix** *(No. 63, Author: Robinsch)*
A larger patch (4 parts) that fixes problems with mice using a high polling
rate. Prevents cursor flicker and uncontrolled camera movement.

**CameraReforged [BETA]: camera height, shoulder offset, zoom limits** *(No. 64, off by default, Author: Stormhand / St0ny)*
Port of [CameraReforged](https://github.com/Zendevve/CameraReforged) by **Stormhand** into this patcher, so everything
runs in one pass – included with his explicit permission ("Of course! Take
whatever you need. I appreciate your work."). The port and its adjustments were
made by St0ny. The client gets two brand-new CVars and new default values for
two existing ones.

> [!WARNING]
> **BETA** – this patch does not work 100% yet, more work is going into it.
> That is why it is deselected by default.

| CVar                      | Blizzard  | here  | Range         |
|---------------------------|-----------|-------|---------------|
| `test_cameraHeight`       | (missing) | 0.50  | 0.0 to 3.0    |
| `test_cameraOverShoulder` | (missing) | 0.00  | -2.0 to 2.0   |
| `cameraDistanceMaxFactor` | 1.0       | 2.60  | 1.0 to 5.0    |
| `cameraDistanceMoveSpeed` | 8.33      | 20.00 | 1.0 to 100.0  |

- `test_cameraHeight` raises the point the camera aims at. The client puts it
  at chest height; 0.5 yards brings it to head height.
- `test_cameraOverShoulder` shifts the camera sideways, negative values to the
  left. 0 keeps it centered, anything else gives an over-the-shoulder view.
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
focus path (where the height is added), two redirected default-value pointers
and four redirected read sites for the shoulder offset.

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

> [!WARNING]
> Like the HD portraits, this patch appends a section of its own (about +1 KB),
> which makes `Wow.exe` larger. **Many servers do not tolerate a changed file
> size of `Wow.exe` – this can lead to a ban.**

### Sound

**Optimize sound settings** *(No. 65, off by default, Author: St0ny)*
Includes the following changes:

- Sound channel hardware limit raised to 126
- `Sound_OutputQuality` set to maximum (2)
- `Sound_NumChannels` raised from 32 to 64
- `Sound_EnableReverb` enabled (reverb effect)
- `Sound_EnableHardware` enabled (hardware audio acceleration)

> [!IMPORTANT]
> **OpenAL** is required for these settings to take effect at all, e.g.
> [OpenAL Soft](https://github.com/kcat/openal-soft).

### Client info: version, build, title, date

These four patches by MacWarrior (ported from his Python scripts
`edit_version.py`, `edit_revision.py`, `edit_title.py` and `edit_date.py`)
change how the client identifies itself. When selected, **the patcher asks for
the desired values after the selection**. A suggestion is shown in square
brackets, ENTER accepts it. Invalid input is asked again with a message, and all
values are checked before anything is written. The patcher remembers the values
in `patcher_selection.ini` (`value.<Id>=…`); with `-Unattended` the remembered
values or the original values are used. If a patch is already in `Wow.exe`,
its current value is the suggestion. When asking, it is also shown after the
patch name (`-> suggestion: …`, or `-> current: …` for an already applied patch).

> [!NOTE]
> Servers may check the client version or build number, so a changed value has
> to match the server.

**Change client version (original 3.3.5)** *(No. 66, off by default, Author: MacWarrior)*
Sets a new version in the format `x.y.z` (e.g. `3.3.6` or `3.3.123`, at most 7
characters). Changes the version the client shows in-game, the FileVersion and
ProductVersion (`Version x.y`) of the version resource and `VS_FIXEDFILEINFO`.
The build number is kept. Major and minor version together must fit into the
ProductVersion field (e.g. `3.3`).

**Change build number (original 12340)** *(No. 67, off by default, Author: MacWarrior)*
Sets a new build number (6142 to 65535, original `12340`): the internal build
number, the visible build number and the fourth part of the FileVersion. The
patcher does not allow builds up to 6141: servers like AzerothCore or
TrinityCore then treat the client as a Classic client (pre-BC) and use a
different login protocol – a 3.3.5 client can no longer get onto the server.

> [!TIP]
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

**Change program title in the file properties** *(No. 68, off by default, Author: MacWarrior)*
Sets FileDescription, InternalName and ProductName of the version resource,
i.e. what Windows shows in the file properties and the Task Manager. At most 17
characters, ASCII only.

**Change build date (original Jun 24 2010)** *(No. 69, off by default, Author: MacWarrior)*
Sets the build date (original `Jun 24 2010`) at all three places in the EXE and
the year in the copyright notice. Input as `YYYY-MM-DD`, optionally followed by
`FR` for French month names (e.g. `2026-09-28 FR` → `Sep 28 2026`). The
suggestion in brackets is **today's date** (with `FR` if you chose it last
time); with `-Unattended` the remembered value is used. If the patch is already
applied, the current date of `Wow.exe` is suggested.

---

## Notes

- **Ban risk:** two groups of patches can lead to a ban on many servers. First,
  patches that servers with anti-cheat may treat as cheating or botting: LUA
  unlock (No. 18), climb angle (36), jump height (37), the air steering (38–40)
  and the double jump (41). Second, patches that append a section to `Wow.exe`
  and thus make the file larger: No. 41, 53 and 64 always, No. 4 and 52
  together with No. 46 – many servers do not tolerate a changed file size.
  Both groups are marked "ban risk" in the overview, and the patcher shows a
  red warning before the confirmation prompt. All other patches do not change
  the file size.
- **Watermark:** every patched `Wow.exe` contains the text
  `Patched with St0nys AIO WoW.exe Patcher by St0ny (Raz0r1337) - https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher`.
  This is how the patcher identifies a `Wow.exe` unambiguously as its own: it
  never mixes its patches with those of other patchers, and it can read its
  patch state from the exe even if `patcher_state.ini` was deleted. The text
  sits in the unused padding behind the `.tls` section (file offset
  `0x72DE20`), is never loaded into memory and does not change the file size.
  Removing all patches removes it again. As a side effect you can always
  check whether a `Wow.exe` was made with this patcher – e.g. with a hex editor
  or in the command prompt with `findstr /m "St0nys AIO" Wow.exe` (prints the
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

A very special thank you goes to **Billy Hoyle** – for all his help and tips
over the past months and for helping to collect the patches. His patch set is
included as the preset "Billy's_Wow.exe" and is the default selection.

**MacWarrior** also helped collecting the patches and contributed some of his
own – thank you as well!

Thanks also to **Stormhand** for the permission to include his CameraReforged
patch.

And of course thanks to all patch authors named in the
[patch overview](#patch-overview).

## License

This project is licensed under the [MIT License](LICENSE).
Copyright (c) 2026 St0ny (Raz0r1337).

In short: anyone may use, modify and redistribute the patcher – including in
their own projects – as long as the copyright notice and the license text are
kept (attribution).
