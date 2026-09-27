# St0nys-AIO-WoW-EXE-Patcher

[🇩🇪 Deutsch](README.md) | 🇬🇧 English

An all-in-one (AIO) patcher for the `Wow.exe` of **World of Warcraft 3.3.5a (build 12340)**.
It applies bug fixes, performance optimizations, extended view distances,
improved sound settings and a few quality-of-life features directly to the
executable – in a single pass, without extra tools or DLL injectors.

On start you choose the **language** (Deutsch / English) and then pick
**which patches** to apply from a menu.

> [!IMPORTANT]
> This repository does **not** contain a `Wow.exe` or any other Blizzard files.
> You need your own unmodified `Wow.exe` 3.3.5a (12340).

---

## Contents

- [Requirements](#requirements)
- [Usage](#usage)
- [Workflow](#workflow)
- [Patch selection](#patch-selection)
- [Parameters for unattended use](#parameters-for-unattended-use)
- [Files](#files)
- [Patch overview](#patch-overview)
- [Patch descriptions](#patch-descriptions)
- [Notes](#notes)
- [License](#license)

---

## Requirements

- Windows with PowerShell (Windows PowerShell 5.1 ships with Windows 10 and later)
- An **original, unmodified** `Wow.exe` 3.3.5a, build 12340 with
  SHA256 `AA63A5750D60EF16746C686B3D5E26876D98953EAB08B1C026CD0FAF78E88CB8`

## Usage

1. Copy `patcher.bat` and `apply_patches.ps1` into your WoW folder
   (next to `Wow.exe`).
2. Close WoW if it is still running.
3. Double-click `patcher.bat`.
4. Choose the language, select patches, confirm – done.

To **restore** the original, delete `Wow.exe` and rename `Wow.exe.BAK` to
`Wow.exe`.

## Workflow

1. The ASCII banner is shown.
2. **Language selection:** `1` = Deutsch, `2` = English.
3. Welcome message, press ENTER to start.
4. Check that a `Wow.exe` exists in the folder.
5. SHA256 integrity check that the `Wow.exe` is original/unmodified.
6. **Patch selection** menu (see below). Your selection from last time is
   already preselected.
7. Summary of the selected patches, notes about missing companion patches and
   a confirmation prompt (Y/N).
8. Automatic backup as `Wow.exe.BAK`.
9. All selected patches are applied in memory (with progress output) and
   `Wow.exe` is written back **once**. If anything fails, `Wow.exe` stays
   untouched.
10. Final message with the number of applied patches.

## Patch selection

The menu lists every patch with a number. `[X]` = will be applied,
`[ ]` = will be skipped. The recommended default selection is preselected
(see the "Default" column in the [patch overview](#patch-overview)). Patches
that need something additional say so in parentheses after their name, with
the link right below.

| Input              | Effect                                     |
|--------------------|--------------------------------------------|
| `5`                | toggle patch 5                             |
| `3 7 12` / `3,7,12`| toggle several patches                     |
| `10-15`            | toggle a range                             |
| `A`                | all patches on                             |
| `N`                | all patches off                            |
| `D` (or `S`)       | back to the default selection              |
| `Q`                | quit, `Wow.exe` stays unmodified           |
| `ENTER`            | accept the selection and continue          |

Some patches only take full effect together with others (e.g. the extended
slider maximums need the CVar unlocks). If such a companion patch is missing
from the selection, the patcher shows a **note** before the confirmation
prompt – nothing is blocked.

### The selection is remembered

As soon as you accept the selection with ENTER, the patcher saves it to
`patcher_selection.ini` next to the script. On the next start exactly this
selection is preselected again – even if you cancelled at the confirmation
prompt.

- The selection is stored per patch (by an internal ID), not by number. If a
  newer version adds patches, your selection stays correct and the new patches
  start with their default setting.
- The file is plain text (`laa=1`, `cache=0`, …) and can also be edited by
  hand.
- **Reset:** press `D` in the menu or delete `patcher_selection.ini` – then
  the default selection applies again.

The default selection is defined in `apply_patches.ps1`: every patch has an
entry `On = $true` (preselected) or `On = $false` (deselected).

## Parameters for unattended use

All parameters are optional and are passed through from `patcher.bat` to
`apply_patches.ps1`.

| Parameter              | Meaning                                                                    |
|------------------------|----------------------------------------------------------------------------|
| `-Language de\|en`     | skip the language prompt                                                   |
| `-Select <selection>`  | skip the selection menu: `saved` (saved selection), `default`, `all` or numbers/ranges like `"1,3,5-8"`. Using `-Select` does not change the saved selection. |
| `-Unattended`          | no confirmation prompts and no pauses                                      |
| `-Path <file>`         | patch a `Wow.exe` other than the one next to the script                    |

Example:

```bat
patcher.bat -Language en -Select saved -Unattended
```

Exit codes: `0` = success, `1` = error, `2` = cancelled by the user.

## Files

| File                | Purpose |
|---------------------|---------|
| `patcher.bat`       | Launcher, calls `apply_patches.ps1` |
| `apply_patches.ps1` | Patch engine: language selection, checks, selection menu, backup; reads the EXE once, patches in memory, writes it back once |
| `README.md`         | German documentation |
| `README.en.md`      | This file |
| `patcher_selection.ini` | Created when you accept a selection, stores your patch selection |
| `LICENSE`           | MIT license |

---

## Patch overview

| No. | Patch | Author | Default |
|----:|-------|-------|:--------:|
| 1  | 4GB patch (Large Address Aware) | Kebabstorm | ✅ |
| 2  | Allow custom GlueXML | Kebabstorm | ✅ |
| 3  | Allow unsigned / incorrectly signed MPQs | 12th Gen exe | ✅ |
| 4  | Disable scan DLL | 12th Gen exe | ✅ |
| 5  | Disable CACHE folder creation | Kebabstorm | – |
| 6  | Refresh item cache immediately | WoWFix335 | ✅ |
| 7  | Remote code execution exploit fix | Robinsch | ✅ |
| 8  | Disable Warden completely (RCE fix) *(may get you kicked if Warden is active)* | Robinsch | – |
| 9  | Disallow client patches from the server | Kebabstorm | – |
| 10 | Disallow hardware surveys from the server | Kebabstorm | – |
| 11 | Disable HTTP requests to Battle.net | Kebabstorm | ✅ |
| 12 | Skip Battle.net login | Kebabstorm | ✅ |
| 13 | Skip Remote Desktop check | Kebabstorm | ✅ |
| 14 | Disable AFK timer idle check *(required for character auto-login, [Discord](https://discord.com/channels/858041817043042364/1515439916878663701))* | St0ny | – |
| 15 | Area trigger timer accuracy (250 ms to 50 ms) | WoWFix335 | ✅ |
| 16 | Allow extended MPQ names |  | ✅ |
| 17 | Load data directly from the Data folder (no MPQ) | 12th Gen exe | – |
| 18 | LUA unlock (allow protected functions) *(may be treated as botting)* | 12th Gen exe | – |
| 19 | Remove melee swing on right-click | Robinsch | ✅ |
| 20 | Suppress NPC attack animation when turning | Robinsch | ✅ |
| 21 | Fix spell animation after cancelled channel | Robinsch | ✅ |
| 22 | Fix "ghost" attack when NPCs evade from combat | Robinsch | ✅ |
| 23 | Level 101+ fix (druid base stats and barber chair) | 12th Gen exe | – |
| 24 | Re-enable the blue moon in the night sky | Robinsch | ✅ |
| 25 | Fix naked character bug | Robinsch | ✅ |
| 26 | Keep force reaction on /reload | WoWFix335 | ✅ |
| 27 | New mail without the 60-second wait | WoWFix335 | – |
| 28 | Allow chat commands while dead | WoWFix335 | – |
| 29 | Unlimited race/class combinations *(server must support it)* | WoWFix335 | – |
| 30 | No character transparency when zooming in | 12th Gen exe | – |
| 31 | Auto-sort quest tracker |  | ✅ |
| 32 | Advanced world map enabled by default |  | ✅ |
| 33 | CVar farclip unlock (max 10000) | 12th Gen exe | ✅ |
| 34 | CVar horizonFarclipScale unlock (max 12) | St0ny | ✅ |
| 35 | CVar environmentDetail unlock (no limit instead of 1.5) | St0ny | ✅ |
| 36 | CVar groundEffectDist unlock (max 3166 instead of 140) |  | ✅ |
| 37 | Graphics options: extend slider maximums | St0ny | ✅ |
| 38 | Windowed mode by default | St0ny | ✅ |
| 39 | Maximized window by default | St0ny | ✅ |
| 40 | No black screen when switching to windowed mode | WoWFix335 | – |
| 41 | Cast bars on all frames | Kebabstorm | ✅ |
| 42 | Max characters per realm raised to 255 | St0ny | – |
| 43 | Retail guild emblems: selection extended from 170 to 196 *(requires [Patch-G](https://discord.com/channels/407664041016688662/1541873346608889936))* | MacWarrior | – |
| 44 | Mouse flicker / camera jump fix | Robinsch | ✅ |
| 45 | GameObject view distance: Cat 0 and Cat 4 scale with environmentDetail | St0ny | ✅ |
| 46 | GameObject view distance: Cat 0 from 30 to 50 yards | St0ny | ✅ |
| 47 | Occluder fix for Stormwind (Open Azeroth) | OpenAzeroth | ✅ |
| 48 | Enable AwesomeWotlkLib.dll support *(requires [awesome_wotlk](https://github.com/noname08662/awesome_wotlk))* | FrostAtom | – |
| 49 | Optimize sound settings | St0ny | ✅ |
| 50 | FlashWindow patch *(requires the [FlashWindow addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash))* | Kebabstorm | – |
| 51 | HD unit frame portraits: 256x256 (live 3D portraits) | Badgermilk0 | ✅ |

> [!NOTE]
> **Authors wanted:** For patches without an entry in the "Author" column, the
> author is not known yet. If you know who made one of these patches, please
> open an [issue](https://github.com/Raz0r1337/St0nys-AIO-WoW-EXE-Patcher/issues) – it will be added.

---

## Patch descriptions

### Memory & system

**4GB patch (Large Address Aware)** *(No. 1, Author: Kebabstorm)*
Lets `Wow.exe` use up to 4 GB of RAM instead of the default 2 GB limit for
32-bit applications.

**Disable CACHE folder creation** *(No. 5, off by default, Author: Kebabstorm)*
Prevents the client from creating a `CACHE` folder automatically.

**Refresh item cache immediately** *(No. 6, Author: WoWFix335)*
Removes the 30-second delay when refreshing the item cache. Item changes
become visible immediately.

### Security

**Allow unsigned / incorrectly signed MPQs** *(No. 3, Author: 12th Gen exe)*
Allows loading MPQ archives without a valid signature. Required for custom
content on private servers.

**Disable scan DLL** *(No. 4, Author: 12th Gen exe)*
Disables the Warden scan DLL mechanism in the client.

**Remote code execution exploit fix** *(No. 7, Author: Robinsch)*
Closes a vulnerability that could allow remote code execution through crafted
packets: the `.zdata` section loses its execute permission and Warden modules
are no longer loaded from the local cache. Warden itself keeps working, so
servers with active Warden are not a problem.

**Disable Warden completely (RCE fix)** *(No. 8, off by default, Author: Robinsch)*
The client drops all Warden packets from the server (`SMSG_WARDEN_DATA`).
Warden modules are code the server has the client execute – with this patch
that is no longer possible at all, including future tricks. Makes the RCE fix
(No. 7) unnecessary; both together do no harm, the patcher just points it
out.

> [!WARNING]
> The client no longer answers Warden. Servers with active Warden (e.g.
> AzerothCore or TrinityCore with default settings) may therefore kick you.

**Disallow client patches from the server** *(No. 9, off by default, Author: Kebabstorm)*
The server can no longer send patch files to the client and have them
installed.

**Disallow hardware surveys from the server** *(No. 10, off by default, Author: Kebabstorm)*
The server can no longer request a hardware survey (information about your PC)
from the client.

### Login & connection

**Skip Battle.net login** *(No. 12, Author: Kebabstorm)*
The client skips the Battle.net login step and goes straight to the classic
login.

**Skip Remote Desktop check** *(No. 13, Author: Kebabstorm)*
The client no longer checks whether it runs over a Remote Desktop connection –
so WoW can be played via RDP, for example.

**Disable HTTP requests to Battle.net** *(No. 11, Author: Kebabstorm)*
The client no longer fetches news, help articles and terms of use from
Blizzard's servers – they no longer exist for 3.3.5 anyway.

### UI & glue screens

**Allow custom GlueXML** *(No. 2, Author: Kebabstorm)*
Allows modifying the login and character selection screens with your own
XML/Lua files (glue screen modding).

**LUA unlock (allow protected functions)** *(No. 18, off by default, Author: 12th Gen exe)*
Addons and macros may call protected functions, e.g. `CastSpellByName`,
`CastSpellByID`, `TargetUnit`, `FocusUnit`, `InteractUnit`, movement functions
or `ReloadUI`. `AttackTarget` still prints an error.

> [!WARNING]
> This enables automation. Servers with anti-cheat may treat it as botting.

### Gameplay fixes

**Disable AFK timer idle check** *(No. 14, off by default, Author: St0ny)*
Disables the idle login check but keeps the automatic AFK disconnect timer
active. Also prevents the CharAutoLogin bug.
**Required for character auto-login** – details on [Discord](https://discord.com/channels/858041817043042364/1515439916878663701).

**Area trigger timer accuracy** *(No. 15, Author: WoWFix335)*
Increases the area trigger check frequency from 250 ms to 50 ms, so zone
transitions and triggers are detected more precisely.

**Remove melee swing on right-click** *(No. 19, Author: Robinsch)*
Prevents the faulty auto-attack swing that was triggered when right-clicking
a target.

**Suppress NPC attack animation when turning** *(No. 20, Author: Robinsch)*
Suppresses the NPC attack animation when turning if no actual attack takes
place.

**Fix spell preparation animation after cancelling channelled spells** *(No. 21, Author: Robinsch)*
Fixes a bug where the preparation animation got stuck after cancelling a
channelled spell.

**Fix "ghost" attack when NPCs evade from combat** *(No. 22, Author: Robinsch)*
Fixes the "ghost" attack NPCs perform when they evade from combat.

**Level 101+ fix for druid base stats and barber chair** *(No. 23, off by default, Author: 12th Gen exe)*
Druids at level 101 and above can view their base stats again, and the
barber chair works for all characters at level 101 and above.
**Requires** the patch "Allow custom GlueXML" (No. 2). In the source it is
called "Disable XML SIG MD5", hence the note "Use XML MD5" there.

**Fix naked character bug** *(No. 25, Author: Robinsch)*
Disables the `SPELL_AURA_X_RAY` effect that could cause characters to be
rendered without their equipment.

**Keep force reaction on /reload** *(No. 26, Author: WoWFix335)*
Prevents force reaction values (e.g. faction standing) from being reset when
reloading the UI. Important for custom servers.

**New mail without the 60-second wait** *(No. 27, off by default, Author: WoWFix335)*
The client checks for new mail immediately – no more 60-second wait and no
relog needed to receive new mail.

**Allow chat commands while dead** *(No. 28, off by default, Author: WoWFix335)*
Slash commands also work while the character is dead.

**Unlimited race/class combinations** *(No. 29, off by default, Author: WoWFix335)*
Character creation allows every race with every class. The server has to
support this as well.

### MPQ extensions

**Allow extended MPQ names** *(No. 16)*
Allows wildcard names for MPQ archives (`patch-*.MPQ` and
`patch-locale-*.MPQ`).

**Load data directly from the Data folder (no MPQ)** *(No. 17, off by default, Author: 12th Gen exe)*
The client reads files directly from the Data folder without packing them into
an MPQ – e.g. `Data\DBFilesClient\ItemDisplayInfo.dbc`. Handy for modders.

### Visual changes

**Re-enable the blue moon in the night sky** *(No. 24, Author: Robinsch)*
Restores a removed legacy feature: the blue moon that used to be visible in
the night sky.

**No character transparency when zooming in** *(No. 30, off by default, Author: 12th Gen exe)*
Your own character no longer becomes transparent when the camera is zoomed in
close.

**Retail guild emblems: selection extended from 170 to 196** *(No. 43, off by default, Author: MacWarrior)*
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

### Default settings (CVars)

**Auto-sort quest tracker** *(No. 31)*
Sets the CVar `trackerSorting` to 1 by default. Quests in the tracker are
sorted automatically.

**Advanced world map enabled by default** *(No. 32)*
Sets the CVar `advancedWorldMap` to 1 by default. The advanced map view is
enabled from the start.

**Farclip unlock to max 10000** *(No. 33, Author: 12th Gen exe)*
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
[Graphics options (UI sliders)](#graphics-options-ui-sliders)).

**CVar horizonFarclipScale unlocked to max 12** *(No. 34, Author: St0ny)*
Unlocks the CVar `horizonFarclipScale` and sets its maximum to 12. Noticeably
increases the horizon view distance.

**Windowed mode by default** *(No. 38, Author: St0ny)*
Sets the CVar `gxWindow` to 1 by default. The game starts in windowed mode
instead of fullscreen.

**Maximized window by default** *(No. 39, Author: St0ny)*
Sets the CVar `gxMaximize` to 1 by default. The window is maximized on start.

**No black screen when switching to windowed mode** *(No. 40, off by default, Author: WoWFix335)*
Switching to windowed mode while in-game no longer results in a black
screen.

**Cast bars on all frames (like Cataclysm)** *(No. 41, Author: Kebabstorm)*
Shows cast bars on all unit frames (party, arena, boss etc.), not just target
and focus, as well as on all default nameplates. Matches the behavior from
Cataclysm onwards.

**Max characters per realm raised to 255** *(No. 42, off by default, Author: St0ny)*
Raises the client-side limit from 10 to 255 characters per realm. The server
has to support this as well. Additional interface changes (GlueXML) are
required for the character selection screen to show more than 10 slots.

### Mouse flicker / camera jumps

**Fix mouse flicker and camera jumps** *(No. 44, Author: Robinsch)*
A larger patch (4 parts) that fixes problems with mice using a high polling
rate. Prevents cursor flicker and uncontrolled camera movement.

### GameObject view distance

**GameObject view distance: Cat 0 and Cat 4 scale with environmentDetail** *(No. 45, Author: St0ny)*
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

With patch No. 46, Cat 0 is at 50 instead of 30 yards (so 50 / 100 / 500 in
the table above). Values above 1.5 require the patch "CVar environmentDetail
unlock" (No. 35).

**GameObject view distance: Cat 0 from 30 to 50 yards** *(No. 46, Author: St0ny)*
If you want to keep view distances entirely at Blizzard's values, deselect
this patch.
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

### Character portraits (HD)

**HD unit frame portraits: 256x256 instead of 64x64** *(No. 51, Author: Badgermilk0)*
Renders the live 3D portraits (player, target, party, bosses etc.) at 256×256
instead of the default 64×64. Framing, tilt and zoom stay the same – only the
render resolution increases, so the portraits become much sharper.
Only the 3D model path is raised; the icon/file path (fixed 64×64 images for
item/spell icons) deliberately stays at 64, because its copy loop would
otherwise read past the source.

> [!NOTE]
> This patch appends a new PE section (`.hdp`) to `Wow.exe` (generated 256px
> alpha mask + code caves + detour of the mask builder). The file grows by
> about 69 KB.

### Window notification

**FlashWindow patch** *(No. 50, off by default, Author: Kebabstorm)*
FlashWindow: makes the WoW window flash in the taskbar when a relevant event
occurs while the game is in the background. The function can be called from
addons.
**Requires** the [FlashWindow addon](https://github.com/noname08662/awesome_wotlk/tree/main/addons/Flash) from awesome_wotlk.

### Occluder

**CVar environmentDetail unlock (no limit instead of 1.5)** *(No. 35, Author: St0ny)*
Removes the upper limit of the CVar `environmentDetail` entirely. Originally
the value is clamped to the range 0.5 to 1.5; the patch disables the upper
clamp so arbitrarily high values are passed through.
Important: this CVar does nothing but multiply the GameObject view distances
(see [GameObject view distance](#gameobject-view-distance)) – in the original
only for categories 1 to 3, with patch No. 45 for all five. That makes it the
most convenient FPS lever for object rendering, since it works in-game without
re-patching.

**CVar groundEffectDist unlock (max 3166 instead of 140)** *(No. 36)*
Raises the maximum view distance for ground effects (grass, flowers, ground
clutter) from 140 to 3166 yards.

**Occluder fix for Stormwind (Open Azeroth)** *(No. 47, Author: OpenAzeroth)*
Raises the occluder threshold for Stormwind so buildings and objects are not
hidden incorrectly. Fixes graphical glitches on custom servers with a rebuilt
Stormwind.

### Graphics options (UI sliders)

**Extend slider maximums in the video menu** *(No. 37, Author: St0ny)*
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
  (No. 33), "CVar environmentDetail unlock" (No. 35) and "CVar
  groundEffectDist unlock" (No. 36) belong with it. If they are missing from
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

### DLL support

**Enable AwesomeWotlkLib.dll support** *(No. 48, off by default, Author: FrostAtom)*
Allows `AwesomeWotlkLib.dll` to be loaded on client start. This DLL extends
the client with additional features and improvements for private servers.
**Requires** `AwesomeWotlkLib.dll` from [awesome_wotlk](https://github.com/noname08662/awesome_wotlk).

### Sound settings

**Optimize sound settings** *(No. 49, Author: St0ny)*
Includes the following changes:

- Sound channel hardware limit raised to 126
- `Sound_OutputQuality` set to maximum (2)
- `Sound_NumChannels` raised from 32 to 64
- `Sound_EnableReverb` enabled (reverb effect)
- `Sound_EnableHardware` enabled (hardware audio acceleration)

---

## Notes

- Before patching, `Wow.exe` is verified by its SHA256 hash. Only an original,
  unmodified `Wow.exe` is accepted – an already patched file is rejected.
- The backup `Wow.exe.BAK` is only created after the integrity check has passed
  and the selection has been confirmed. An existing backup is overwritten (the
  input has just been verified to be the original).
- If there is no `Wow.exe` in the folder, the patcher aborts.
- To restore, simply rename `Wow.exe.BAK` to `Wow.exe`.
- To apply a different selection, restore the original first and run the
  patcher again.
- Use at your own risk. This project is not affiliated with Blizzard
  Entertainment.

## License

This project is licensed under the [MIT License](LICENSE).
Copyright (c) 2026 St0ny (Raz0r1337).

In short: anyone may use, modify and redistribute the patcher – including in
their own projects – as long as the copyright notice and the license text are
kept (attribution).
