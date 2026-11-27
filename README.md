# Balkan Urban Legends

A Godot 4.7 horror game with two levels. Open `baba_roga.tscn` or `Drekavac.tscn` in Godot and press **F6** to play that level. Both instance `player.tscn`. Edit that scene to update the player and flashlight across both levels.

## Working on different levels

Clone the repository once and use that same folder for future updates. Before starting work, save your scenes and run `git pull --ff-only origin main` on your local `main`. Git applies the differences since your last update, including added or deleted assets. Godot imports changed assets when it opens the project.

Commit each level edit together with its dependencies. Include new textures, models, scripts, Godot UID and import settings files, and any changed terrain region files. Baba Roga uses `TerrainData/` and Drekavac uses `DrekavacTerrainData/`. The generated `.godot/` cache stays local.

For example, a Baba Roga update can change `baba_roga.tscn` and a texture it references. Pulling that commit brings in both files. If both players edit separate levels, their scene files can be merged independently. Coordinate edits to shared files such as `player.tscn`. If Git reports overlapping edits or diverging branches, save local work on a branch and merge the changes before pushing.

## Recent game changes

GitHub Actions refreshes the list below after pushes to main. Each entry links to the full diff, including changes to nodes and resource references inside scene files.

## Latest local changes

- **Character model:** Replaced the capsule appearance with an original clothed villager model in an olive jacket, indigo trousers, and brown boots. The capsule remains the movement collider. The camera hides the head from the first-person view.
- **Flashlight arm:** Added a single right arm and hand posed around the flashlight grip. It follows the camera pitch. Removed the extra glove and sleeve meshes from the flashlight asset.
- **Shared player:** The model, flashlight, and aim-following arm live in `player.tscn`, shared by Baba Roga and Drekavac.
- **House interior:** Added a sofa, chair, gothic coffee table, bed, bedside stool, metal shelving, and a storage cart, along with their imported models and textures.
- **House exterior and windows:** Added transparent collidable glass panes and rims to seven round windows, a wood-textured porch canopy with supporting beams, corner timbers, and cornice trim.

<!-- game-changes -->

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
