/*
Tile magic - Tile placeables!

Add this script to a placeable in the creator and toss it down to give the tile a nice grassy, lava,
ice or whatever effect. Effects automatically center in the tile, where a tile is that big red square
you see under your areas in the creator.

Spread these around any way you see fit, but it would be nice if you could leave my name in
somewhere. Or drop me a mail at otster@hotmail.com if you made nice use of these tiles, I'd love to
see it.

For the script kiddies, if you're planning on using these functions elsewhere you should note that
I consider the topmost tile 1,1. What this function does exactly:
- The placed object has a heartbeat in which it self-destructs and replaces itself with another helper
- This helper is centered in the middle of the tile
- The tile magic effect is place on this helper


Enjoy!

- 0tting


*/

#include "x2_inc_toollib"
/* Otting: All I include from this lib is:
const int X2_TL_GROUNDTILE_ICE = 426;
const int X2_TL_GROUNDTILE_WATER = 401;
const int X2_TL_GROUNDTILE_GRASS = 402;
const int X2_TL_GROUNDTILE_LAVA_FOUNTAIN = 349; // ugly
const int X2_TL_GROUNDTILE_LAVA = 350;
const int X2_TL_GROUNDTILE_CAVEFLOOR = 406;
const int X2_TL_GROUNDTILE_SEWER_WATER = 461;
*/

// 0tting: Checks this tile and returns TRUE if it is valid
int GetIsTileValid(int nX, int nY, object oArea = OBJECT_SELF)
{
    // 0tting: Read the GetTileMainLight1Color comment and understand how this works (fools..)
    int nColor = GetTileMainLight1Color(Location(oArea, Vector(IntToFloat(nX),IntToFloat(nY), 0.0), 0.0));
    return nColor != 517;
}

// 0tting: Returns the own horizontal tile number this object is in
int GetOwnHorizontalTile(object oObject)
{
    vector vPos = GetPosition(oObject);
    return FloatToInt((vPos.x / 10)) + 1;
}

// 0tting: Returns the own vertical tile number this object is in
int GetOwnVerticalTile(object oObject)
{
    vector vPos = GetPosition(oObject);
    return FloatToInt((vPos.y / 10)) + 1;
}

// Otting: Given tile numbers, this function returns a location in the middle of this tile. The z is optional so you don't have to add it later
location GetLocationFromTile(int nX, int nY, object oArea = OBJECT_SELF, float fZaxis = 0.0)
{
    return Location(oArea, Vector((IntToFloat(nX * 10) - 5.0) , (IntToFloat(nY * 10) - 5), fZaxis), 0.0);;
}

// Otting: Place the tile at the given location.
// nMagicType = any of the constants from x2_inc_toollib (see top, you can do without the include)
// oPlacer = A helper object placed to pin the location
// fZaxis = Height, added to the current height of the helper
// nX = Your horizontal tile
// nY = Your vertical tile
void DoTileMagic(int nMagicType, object oPlacer, float fZaxis, int nX = 0, int nY = 0)
{
        //Mark: Gotta pull the location apart to put the tile a little higher then ground level
        vector vPosition = GetPosition(oPlacer);
        location lTile = GetLocationFromTile(GetOwnHorizontalTile(oPlacer) + nX, GetOwnVerticalTile(oPlacer) + nY, GetArea(oPlacer), vPosition.z + fZaxis);
        object oTile = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lTile,FALSE, "ott_tmp_tile");
        SetPlotFlag(oTile,TRUE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(nMagicType), oTile);
}

// Otting: See DoTileMagic, applies the effect in a 3x3 square around the helper
void DoTileMagicLarge(int nMagicType, object oPlacer, float fZaxis)
{
    int nX;
    int nY;
    for(nX = - 1; nX < 2; nX++)
    {
        for(nY = -1; nY < 2; nY++)
        {
            DoTileMagic(nMagicType, oPlacer, fZaxis, nX, nY);
        }
    }
}

void main()
{
    string sSelfTag = GetTag(OBJECT_SELF);
    if(sSelfTag == "ott_spell_grass")
    {
        DoTileMagic(X2_TL_GROUNDTILE_GRASS, OBJECT_SELF, 0.02);
    }
    else if(sSelfTag == "ott_spell_grass_large")
    {
        DoTileMagicLarge(X2_TL_GROUNDTILE_GRASS, OBJECT_SELF, 0.02);
    }
    else if(sSelfTag == "ott_spell_water_low")
    {
        DoTileMagic(X2_TL_GROUNDTILE_WATER, OBJECT_SELF, 1.02);
    }
    else if(sSelfTag == "ott_spell_water_high")
    {
        DoTileMagic(X2_TL_GROUNDTILE_WATER, OBJECT_SELF, 1.6);
    }
    else if(sSelfTag == "ott_spell_water_high_large")
    {
        DoTileMagicLarge(X2_TL_GROUNDTILE_WATER, OBJECT_SELF, 1.6);
    }
    else if(sSelfTag == "ott_spell_ice")
    {
        DoTileMagic(X2_TL_GROUNDTILE_ICE, OBJECT_SELF, 0.02);
    }
    else if(sSelfTag == "ott_spell_lava")
    {
        DoTileMagic(X2_TL_GROUNDTILE_LAVA, OBJECT_SELF, 1.02);
    }
    else if(sSelfTag == "ott_spell_cueva")
    {
        DoTileMagic(X2_TL_GROUNDTILE_CAVEFLOOR, OBJECT_SELF, 0.02);
    }
    DestroyObject(OBJECT_SELF);
}
