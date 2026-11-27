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

<details><summary>Build Drekavac mountain valley and dense fir forest</summary>

[View commit](https://github.com/Ognen11/Balkan-urban-legends/commit/1093c35cf3054892b17a5ec8b2a04215ff4c9940)

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
