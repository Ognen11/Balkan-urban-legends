# Balkan Urban Legends

A Godot 4.7 horror game with two levels. Open `baba_roga.tscn` or `Drekavac.tscn` in Godot and press **F6** to play that level. Both instance `player.tscn`. Edit that scene to update the player and flashlight across both levels.

## Working on different levels

Clone the repository once and use that same folder for future updates. Before starting work, save your scenes and run `git pull --ff-only origin main` on your local `main`. Git applies the differences since your last update, including added or deleted assets. Godot imports changed assets when it opens the project.

Commit each level edit together with its dependencies. Include new textures, models, scripts, Godot UID and import settings files, and any changed terrain region files. Baba Roga uses `TerrainData/` and Drekavac uses `DrekavacTerrainData/`. The generated `.godot/` cache stays local.

For example, a Baba Roga update can change `baba_roga.tscn` and a texture it references. Pulling that commit brings in both files. If both players edit separate levels, their scene files can be merged independently. Coordinate edits to shared files such as `player.tscn`. If Git reports overlapping edits or diverging branches, save local work on a branch and merge the changes before pushing.

## Recent game changes

GitHub Actions refreshes the list below after pushes to main. Each entry links to the full diff, including changes to nodes and resource references inside scene files.

## Current controls

| Key | Action |
| --- | --- |
| W / A / S / D | Move |
| Shift | Sprint while moving forward |
| Space | Jump |
| Mouse | Look |
| E | Pick up the aimed item or open/close the aimed door |
| 1–5 | Use the item in that inventory slot |
| F | Cycle the flashlight through close range, far range, and off |
| F1 | Thumbs-up gesture, restores 0.1 mental health on completion |
| F2 | Middle-finger gesture, removes 0.1 mental health on completion |
| Escape | Release/capture the mouse |

Using the flashlight's inventory slot also cycles its modes. Using a cigarette slot starts the smoking animation and consumes one cigarette immediately. Using a battery slot consumes the battery and fully recharges the flashlight when its charge is below 100%.

## Gameplay update — 2026-11-27

- Rebuilt the shared player with the caretaker model, a connected rigged left hand, and reference-guided thumbs-up, middle-finger, and two-hand cigarette-lighting animations. Added a separate flashlight model with an arm that raises and lowers as its mode changes.
- Added a white health bar starting at 100, a mental-health bar starting at 50/100, a dot crosshair, and five inventory slots with item icons, number-key labels, and remaining counts.
- Looking directly at Baba Roga with an unobstructed crosshair drains 2 mental health per second. Finishing a cigarette restores 20 mental health, capped at 100.
- Added a red-and-white cigarette pack to the first-floor coffee table. Aiming within 2.5 metres shows white “press E” text. Picking up the box removes it from the table and adds 20 cigarettes to inventory. Starting a smoke uses one cigarette. Emptying the box removes its inventory entry and restores a fresh box at the same table position.
- The flashlight starts in slot 1 with 100% battery. Close range drains 0.3 percentage points per second, far range drains 5, and an empty flashlight switches off. Added three consumable spare batteries on the second-floor shelving unit, with accessible shelf collisions.
- Added the detailed Baba Roga model, rig, face/hair/teeth/clothing textures, and staff attacks. Her current detection radius is 10 metres with a clear line of sight. A direct flashlight hit interrupts her attack and makes her flee for 5 seconds after the last hit, followed by searching and a 1-second detection delay.
- Baba Roga roams independently, descends to the first floor, opens nearby unlocked doors, and leaves the house to choose random reachable destinations in the woods. Added woodland navigation, connected it to the house through the front-door link, corrected stair waypoint stalling and overlapping navigation edges, and added recovery when stuck. Full terrain collision supports roaming away from the player. Woodland navigation covers the area from approximately −128 to +128 metres on both horizontal axes.
- Chase speeds increase as mental health falls. The five bands are 80–100 at 3 m/s, 60–under 80 at 4 m/s, 40–under 60 at 5 m/s, over 20–under 40 at 6 m/s, and 0–20 at 8 m/s. Staff hits deal 50 health damage at 50 or more mental health and kill the player below 50 mental health.
- Added chase, damage-taken, door-opening, and door-closing sound effects. Doors show “press E to open” or “press E to close” when aimed at within interaction range.
- Added the death screen with “Game Over!”, “you died...”, and a retry button.
- Marked house window glass as transparent to flashlight detection.
- Included the new scenes, scripts, models, textures, icons, sound files, navigation resources, and Godot import/UID files needed by these features.

Validation included Godot scene imports, inventory pickups and consumption, flashlight drain and recharge, door interaction, enemy state transitions and damage thresholds, plus several three-minute autonomous roaming simulations through the house and woods.

<!-- game-changes -->

<details><summary>Merge remote-tracking branch 'origin/main'</summary>

[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/cc86a106d62b9f671afc69f848d47ac44bac7e26)

<pre>Modified  Drekavac.tscn
Added  DrekavacTerrainData/drekavac_river.res
Added  DrekavacTerrainData/fir_forest.scn
Added  DrekavacTerrainData/river_water.gdshader
Added  DrekavacTerrainData/river_water.gdshader.uid
Added  DrekavacTerrainData/riverbed_rocks.tscn
Modified  DrekavacTerrainData/terrain3d-01-01.res
Added  DrekavacTerrainData/terrain3d-01-02.res
Added  DrekavacTerrainData/terrain3d-01-03.res
Modified  DrekavacTerrainData/terrain3d-01_00.res
Added  DrekavacTerrainData/terrain3d-02-01.res
Added  DrekavacTerrainData/terrain3d-02-02.res
Added  DrekavacTerrainData/terrain3d-02-03.res
Added  DrekavacTerrainData/terrain3d-02_00.res
Modified  DrekavacTerrainData/terrain3d_00-01.res
Added  DrekavacTerrainData/terrain3d_00-02.res
Added  DrekavacTerrainData/terrain3d_00-03.res
Modified  DrekavacTerrainData/terrain3d_00_00.res
Added  DrekavacTerrainData/terrain3d_01-01.res
Added  DrekavacTerrainData/terrain3d_01-02.res
Added  DrekavacTerrainData/terrain3d_01-03.res
Added  DrekavacTerrainData/terrain3d_01_00.res
Added  DrekavacTerrainData/terrain_assets.tres
Added  Models/Vegetation/FirTree01/BlenderSource/.gdignore
Added  Models/Vegetation/FirTree01/BlenderSource/fir_tree_01_1k.blend
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_bark_diff_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_bark_disp_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_bark_nor_gl_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_bark_rough_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_a_diff_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_a_nor_gl_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_a_rough_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_b_diff_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_b_nor_gl_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_b_rough_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_c_diff_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_c_nor_gl_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_trunk_c_rough_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_twig_alpha_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_twig_diff_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_twig_mask_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_twig_nor_gl_1k.png
Added  Models/Vegetation/FirTree01/BlenderSource/textures/fir_tree_01_twig_rough_1k.png
Added  Models/Vegetation/FirTree01/fir_a_distant.png
Added  Models/Vegetation/FirTree01/fir_a_distant.png.import
Added  Models/Vegetation/FirTree01/fir_a_wide.res
Added  Models/Vegetation/FirTree01/fir_b_distant.png
Added  Models/Vegetation/FirTree01/fir_b_distant.png.import
Added  Models/Vegetation/FirTree01/fir_b_wide.res
Added  Models/Vegetation/FirTree01/fir_c_distant.png
Added  Models/Vegetation/FirTree01/fir_c_distant.png.import
Added  Models/Vegetation/FirTree01/fir_c_wide.res
Added  Models/Vegetation/FirTree01/fir_trees.glb
Added  Models/Vegetation/FirTree01/fir_trees.glb.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_bark_diff.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_bark_diff.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_bark_nor_gl.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_bark_nor_gl.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_a_diff.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_a_diff.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_a_nor_gl.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_a_nor_gl.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_b_diff.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_b_diff.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_b_nor_gl.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_b_nor_gl.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_c_diff.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_c_diff.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_c_nor_gl.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_trunk_c_nor_gl.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_twig_diff-fir_tree_01_twig_alpha.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_twig_diff-fir_tree_01_twig_alpha.png.import
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_twig_nor_gl.png
Added  Models/Vegetation/FirTree01/fir_trees_fir_tree_01_twig_nor_gl.png.import
Added  Textures/leaf_scattered_gravel_diff_1k.jpg
Added  Textures/leaf_scattered_gravel_diff_1k.jpg.import
Added  addons/terrain_3d/csharp/.gdignore
Modified  addons/terrain_3d/src/double_slider.gd
Added  demo/csharp/.gdignore
Modified  project.godot</pre>
</details>

<details><summary>Add inventory, mental health, battery-powered flashlight and roaming Baba Roga</summary>

[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/09253b4425a49c7b485df2093f28f1e78e2227dc)

<pre>Added  Items/battery.tscn
Added  Items/battery_icon.png
Added  Items/battery_icon.png.import
Added  Items/cigarette_box.tscn
Added  Items/cigarette_box_icon.png
Added  Items/cigarette_box_icon.png.import
Added  Items/flashlight_icon.png
Added  Items/flashlight_icon.png.import
Added  Items/pickup.gd
Added  Items/pickup.gd.uid
Added  Models/BabaRoga/BabaRoga.glb
Added  Models/BabaRoga/BabaRoga.glb.import
Added  Models/BabaRoga/BabaRoga.tscn
Added  Models/BabaRoga/BabaRoga_AmberIris.png
Added  Models/BabaRoga/BabaRoga_AmberIris.png.import
Added  Models/BabaRoga/BabaRoga_AshHair.png
Added  Models/BabaRoga/BabaRoga_AshHair.png.import
Added  Models/BabaRoga/BabaRoga_Blackthorn.png
Added  Models/BabaRoga/BabaRoga_Blackthorn.png.import
Added  Models/BabaRoga/BabaRoga_CloudedEye.png
Added  Models/BabaRoga/BabaRoga_CloudedEye.png.import
Added  Models/BabaRoga/BabaRoga_CreasesAndLips.png
Added  Models/BabaRoga/BabaRoga_CreasesAndLips.png.import
Added  Models/BabaRoga/BabaRoga_DeepShadow.png
Added  Models/BabaRoga/BabaRoga_DeepShadow.png.import
Added  Models/BabaRoga/BabaRoga_DriedLinen.png
Added  Models/BabaRoga/BabaRoga_DriedLinen.png.import
Added  Models/BabaRoga/BabaRoga_HairUnderlayer.png
Added  Models/BabaRoga/BabaRoga_HairUnderlayer.png.import
Added  Models/BabaRoga/BabaRoga_PeatWool.png
Added  Models/BabaRoga/BabaRoga_PeatWool.png.import
Added  Models/BabaRoga/BabaRoga_StainedIvory.png
Added  Models/BabaRoga/BabaRoga_StainedIvory.png.import
Added  Models/BabaRoga/BabaRoga_WeatheredSkin.png
Added  Models/BabaRoga/BabaRoga_WeatheredSkin.png.import
Added  Models/BabaRoga/baba_roga.gd
Added  Models/BabaRoga/baba_roga.gd.uid
Added  Models/BabaRoga/house_navigation.tres
Added  Models/BabaRoga/woods_navigation.res
Modified  Models/Flashlight/flashlight.gd
Added  Models/Flashlight/torch.tscn
Modified  Models/House/window_glass.tscn
Added  Models/Player/Emotes/cigarette_pack.glb
Added  Models/Player/Emotes/cigarette_pack.glb.import
Added  Models/Player/Emotes/cigarette_pack_cigarette_pack_diff.png
Added  Models/Player/Emotes/cigarette_pack_cigarette_pack_diff.png.import
Added  Models/Player/Emotes/cigarette_pack_cigarette_pack_metal-cigarette_pack_rough.png
Added  Models/Player/Emotes/cigarette_pack_cigarette_pack_metal-cigarette_pack_rough.png.import
Added  Models/Player/Emotes/cigarette_pack_cigarette_pack_nor_gl.png
Added  Models/Player/Emotes/cigarette_pack_cigarette_pack_nor_gl.png.import
Added  Models/Player/Emotes/exhale_smoke.tscn
Added  Models/Player/Emotes/first_person_hand.tscn
Added  Models/Player/Emotes/left_hand.glb
Added  Models/Player/Emotes/left_hand.glb.import
Added  Models/Player/Emotes/player_emotes.gd
Added  Models/Player/Emotes/player_emotes.gd.uid
Added  Models/Player/Emotes/smoke_puff.png
Added  Models/Player/Emotes/smoke_puff.png.import
Added  Models/Player/caretaker.tscn
Added  SFX/BabaRogaSFX/damage_taken.mp3
Added  SFX/BabaRogaSFX/damage_taken.mp3.import
Added  SFX/BabaRogaSFX/door_close.wav
Added  SFX/BabaRogaSFX/door_close.wav.import
Added  SFX/BabaRogaSFX/door_open.wav
Added  SFX/BabaRogaSFX/door_open.wav.import
Added  SFX/BabaRogaSFX/dooropening.mp3
Added  SFX/BabaRogaSFX/dooropening.mp3.import
Added  SFX/BabaRogaSFX/universfield-eerie-sudden-shock-454675.mp3
Added  SFX/BabaRogaSFX/universfield-eerie-sudden-shock-454675.mp3.import
Modified  baba_roga.tscn
Modified  character_body_3d.gd
Modified  door.gd
Modified  player.tscn
Modified  project.godot</pre>
</details>

<details><summary>Improve shared player flashlight and decorate Baba Roga house</summary>

[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/200e6f6bb780972e333c08529f2bca2d61db38cb)

<pre>Modified  Models/Flashlight/hand_flashlight.glb
Added  Models/House/GothicBed_01.glb
Added  Models/House/GothicBed_01.glb.import
Added  Models/House/GothicBed_01_GothicBed_01_diff_4k.png
Added  Models/House/GothicBed_01_GothicBed_01_diff_4k.png.import
Added  Models/House/GothicBed_01_GothicBed_01_metallic-GothicBed_01_roughness.png
Added  Models/House/GothicBed_01_GothicBed_01_metallic-GothicBed_01_roughness.png.import
Added  Models/House/GothicBed_01_GothicBed_01_nor_gl_4k.png
Added  Models/House/GothicBed_01_GothicBed_01_nor_gl_4k.png.import
Added  Models/House/gallinera_chair.glb
Added  Models/House/gallinera_chair.glb.import
Added  Models/House/gallinera_chair_gallinera_chair_diff_4k.png
Added  Models/House/gallinera_chair_gallinera_chair_diff_4k.png.import
Added  Models/House/gallinera_chair_gallinera_chair_nor_gl_4k.png
Added  Models/House/gallinera_chair_gallinera_chair_nor_gl_4k.png.import
Added  Models/House/gallinera_chair_gallinera_chair_rough_4k.png
Added  Models/House/gallinera_chair_gallinera_chair_rough_4k.png.import
Added  Models/House/gothic_coffee_table.glb
Added  Models/House/gothic_coffee_table.glb.import
Added  Models/House/gothic_coffee_table_gothic_coffee_table_diff_4k.png
Added  Models/House/gothic_coffee_table_gothic_coffee_table_diff_4k.png.import
Added  Models/House/gothic_coffee_table_gothic_coffee_table_nor_gl_4k.png
Added  Models/House/gothic_coffee_table_gothic_coffee_table_nor_gl_4k.png.import
Added  Models/House/gothic_coffee_table_gothic_coffee_table_rough_4k.png
Added  Models/House/gothic_coffee_table_gothic_coffee_table_rough_4k.png.import
Added  Models/House/industrial_storage_cart.glb
Added  Models/House/industrial_storage_cart.glb.import
Added  Models/House/industrial_storage_cart_industrial_storage_cart_diff_4k.png
Added  Models/House/industrial_storage_cart_industrial_storage_cart_diff_4k.png.import
Added  Models/House/industrial_storage_cart_industrial_storage_cart_metal-industrial_storage_cart_rough.png
Added  Models/House/industrial_storage_cart_industrial_storage_cart_metal-industrial_storage_cart_rough.png.import
Added  Models/House/industrial_storage_cart_industrial_storage_cart_nor_gl_4k.png
Added  Models/House/industrial_storage_cart_industrial_storage_cart_nor_gl_4k.png.import
Added  Models/House/sofa_03.glb
Added  Models/House/sofa_03.glb.import
Added  Models/House/sofa_03_sofa_03_diff.png.png
Added  Models/House/sofa_03_sofa_03_diff.png.png.import
Added  Models/House/sofa_03_sofa_03_diff_4k.png
Added  Models/House/sofa_03_sofa_03_diff_4k.png.import
Added  Models/House/sofa_03_sofa_03_nor_gl_4k.png
Added  Models/House/sofa_03_sofa_03_nor_gl_4k.png.import
Added  Models/House/sofa_03_sofa_03_rough_4k.png
Added  Models/House/sofa_03_sofa_03_rough_4k.png.import
Added  Models/House/steel_frame_shelves_03.glb
Added  Models/House/steel_frame_shelves_03.glb.import
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_diff_4k.png
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_diff_4k.png.import
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_drawers_diff_4k.png
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_drawers_diff_4k.png.import
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_drawers_nor_gl_4k.png
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_drawers_nor_gl_4k.png.import
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_drawers_rough_4k.png
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_drawers_rough_4k.png.import
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_metal-steel_frame_shelves_03_rough.png
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_metal-steel_frame_shelves_03_rough.png.import
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_nor_gl_4k.png
Added  Models/House/steel_frame_shelves_03_steel_frame_shelves_03_nor_gl_4k.png.import
Added  Models/House/window_glass.tscn
Added  Models/House/wooden_stool_02.glb
Added  Models/House/wooden_stool_02.glb.import
Added  Models/House/wooden_stool_02_wooden_stool_02_diff_4k.png
Added  Models/House/wooden_stool_02_wooden_stool_02_diff_4k.png.import
Added  Models/House/wooden_stool_02_wooden_stool_02_nor_gl_4k.png
Added  Models/House/wooden_stool_02_wooden_stool_02_nor_gl_4k.png.import
Added  Models/House/wooden_stool_02_wooden_stool_02_rough_4k.png
Added  Models/House/wooden_stool_02_wooden_stool_02_rough_4k.png.import
Added  Models/Player/holding_arm.glb
Added  Models/Player/holding_arm.glb.import
Added  Models/Player/player_appearance.gd
Added  Models/Player/player_appearance.gd.uid
Added  Models/Player/villager.glb
Added  Models/Player/villager.glb.import
Modified  baba_roga.tscn
Modified  player.tscn</pre>
</details>

<details><summary>Update Baba Roga and share the player and flashlight across both levels</summary>

[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/708acca094cfb329694e8ae9c92d8db336a252bb)

<pre>Added  Drekavac.tscn
Added  DrekavacTerrainData/terrain3d-01-01.res
Added  DrekavacTerrainData/terrain3d-01_00.res
Added  DrekavacTerrainData/terrain3d_00-01.res
Added  DrekavacTerrainData/terrain3d_00_00.res
Added  Models/Flashlight/flashlight.gd
Added  Models/Flashlight/flashlight.gd.uid
Added  Models/Flashlight/hand_flashlight.glb
Added  Models/Flashlight/hand_flashlight.glb.import
Added  Textures/Ground037_1K-JPG_Color.jpg
Added  Textures/Ground037_1K-JPG_Color.jpg.import
Modified  baba_roga.tscn
Added  player.tscn</pre>
</details>

<details><summary>Update Baba Roga cloud positions</summary>

[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/581987512547f1f1fac42bd5a042bb2b4c7c1aa7)

<pre>Modified  baba_roga.tscn</pre>
</details>

<details><summary>Update Baba Roga level and stair movement</summary>

[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/22f8b9d9fe92abdfbda711617c6d91ba6edb7ed1)

<pre>Modified  TerrainData/terrain3d-01-01.res
Modified  Textures/Street_lamp_7_BaseColor.png.import
Added  Textures/hinoki_planks_diff_1k.jpg
Added  Textures/hinoki_planks_diff_1k.jpg.import
Modified  baba_roga.tscn
Modified  character_body_3d.gd</pre>
</details>

<details><summary>Update Baba Roga house and lighting</summary>

[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/3007644e2c961d349bf8fb9a075e32aff6458975)

<pre>Removed  addons/terrain_3d/bin/~libterrain.windows.debug.x86_64.dll
Modified  baba_roga.tscn</pre>
</details>
