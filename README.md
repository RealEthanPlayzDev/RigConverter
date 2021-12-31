# RigConverter
Roblox module for converting between R6 and R15 rigs,

# Implementation notes:
- The character is converted by using a template with all player accesories and things put over it (R6) / ``Players:CreateHumanoidModelFromUserId()`` (R15). Then it clears everything on the original player character model (``Player.Character``) and fills it with the converted version + some scripts to bring back functionality like jumping, health regen.
- Luckily since we use  ``Players:CreateHumanoidModelFromUserId()`` for the R15 conversion, player animations will also be restored as what they have equipped aswell!
- Unfortunately, if you make changes/hook events/add instances/any interaction with the player character, they will all be removed each time conversion happens.

# Documentation
**function RigConverter.R6(plr: number | string | Player): boolean**

Converts the target player's (``plr``) character rig into R6. Returns true on success.

**function RigConverter.R15(plr: number | string | Player): boolean**

Converts the target player's (``plr``) character rig into R15. Returns true on success.