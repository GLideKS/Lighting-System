# Lighting System for Sonic Robo Blast 2

Lighting System is an addon for Sonic Robo Blast 2 heavily inspired from an ancient but beloved feature of SRB2 Final Demo 1.09.x, **the Coronas.**
Intended to be loaded in a dedicated server or locally loaded with an SRB2 custom build.

Lights are object based and defined per MT_ Object to spawn with. Light objects are made to be lightweight as possible to not cause any major performance impact.

This addon is an experiment of how this lighting system could be made in Lua on Sonic Robo Blast 2 with the modding stuff we have nowadays, without sacrificing too much the game's performance.

> [!CAUTION]
> **Do not load this addon on a server that is not a dedicated server!** will make players get kicked out on join if you do so.

> [!IMPORTANT]
> **As for SRB2 v2.2.15**, lights might look off in OpenGL on front of translucent platforms (FOFs). Also specifically floorlights does not interpolate on higher FPS than 35. Both of these issues are both SRB2 rendering problems and can't be solved on the addon's side.

## Commands
- `corona_toggle` : toggles lights on or off.
- `corona_floorlight` : toggles lights appearing on the floor on or off. improves performance slightly if turned off. depends of the map.
- `corona_size` : changes the size of the lights.
- `corona_litemode` : if your device is weak, you can toggle this command on. disables lights for most common objects in the maps like rings and flame throwers.

## Recommended settings
- Models: **Off**, as these are just sprite objects, lights on models will not look good.

## Documentation
*Comming soon.*

## Previews
![Amy on Haunted Heights](/previews/srb20480.png)
![CTF Red Rings](/previews/srb20482.png)
![CTF Map showing other lights](/previews/srb20483.png)
![CEZ2 Lights](/previews/srb20486.png)
![Amy fighting Brak Eggman](/previews/srb20498.png)
![Amy fighting Brak Eggman](/previews/srb20494.png)
