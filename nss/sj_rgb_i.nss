// -----------------------------------------------------------------------------
//  sj_rgb_i
// -----------------------------------------------------------------------------
/*
    Common library of RGB Color related constants, structures and functions.

    Provides symbolic constants for 140 standard colors, introduces a new color
    user-defined type (struct) and provides functions which enable scripters to:

        - create a color using individual red, green and blue values
        - convert a color type to and from a 24-bit int color value
        - manipulate a color directly or through its brightness
        - get, set and delete a color as a local variable


    COLOR
    =====

    The color functions allow creation of a color user-defined type either using
    individual R, G, and B channel values or a 24-bit int color value. A 24-bit
    int color values can be as expressed as decimal or hexidecimal numbers, for
    example, 0x0000FF or 255 for bright blue.

    The SJ_RGB_COLOR_* constants represent the 140 (if you ignore duplicates for
    Grey and Gray) named colors defined by the W3C in their CSS3 Color Module
    Candidate Recommendation. These constants complement BioWare's FOG_COLOR_*
    constants.

    To view the colors visit http://www.w3.org/TR/css3-color/#svg-color.


    BRIGHTNESS
    ==========

    The brightness functions calculate and control a color's brightness level
    allowing you to produce a lighter or darker color of the same hue as the
    reference color.

    A pure hue has a brightness level of 50%, black has a brighness level of 0%
    and white has a brightness level of 100%. Brighness is therefore identical
    to lightness (luminoisty) in the HSL color space as defined by the W3C in
    their CSS3 Color Module Candidate Recommendation.

    To view the definition visit http://www.w3.org/TR/css3-color/#hsl-color.


    TODO @ 1.01
    ===========
    - add *LocalColorChannel functions
    - add *AdjustColor functions

*/
// -----------------------------------------------------------------------------
/*
    Version 1.01 - 14 May 2006 - Sunjammer
    - added SJ_RGB_ColorToHexString
    - added SJ_RGB_AdjustBrightness
    - added SJ_RGB_GetBrightness

    Version 1.00 - 01 Mar 2006 - Sunjammer
    - created

    Credits
    - pspeed: for being bitwise
*/
// -----------------------------------------------------------------------------
#include "sj_rgb_x"


// -----------------------------------------------------------------------------
//  CONSTANTS
// -----------------------------------------------------------------------------

// Channel constants
const int SJ_RGB_CHANNEL_R  = 0x10;
const int SJ_RGB_CHANNEL_G  = 0x08;
const int SJ_RGB_CHANNEL_B  = 0x00;

// Color contants
const int SJ_RGB_COLOR_ALICE_BLUE               = 0xF0F8FF;
const int SJ_RGB_COLOR_ANTIQUE_WHITE            = 0xFAEBD7;
const int SJ_RGB_COLOR_AQUA                     = 0x00FFFF;
const int SJ_RGB_COLOR_AQUAMARINE               = 0x7FFFD4;
const int SJ_RGB_COLOR_AZURE                    = 0xF0FFFF;
const int SJ_RGB_COLOR_BEIGE                    = 0xF5F5DC;
const int SJ_RGB_COLOR_BISQUE                   = 0xFFE4C4;
const int SJ_RGB_COLOR_BLACK                    = 0x000000;
const int SJ_RGB_COLOR_BLANCHED_ALMOND          = 0xFFEBCD;
const int SJ_RGB_COLOR_BLUE                     = 0x0000FF;
const int SJ_RGB_COLOR_BLUE_VIOLET              = 0x8A2BE2;
const int SJ_RGB_COLOR_BROWN                    = 0xA52A2A;
const int SJ_RGB_COLOR_BURLY_WOOD               = 0xDEB887;
const int SJ_RGB_COLOR_CADET_BLUE               = 0x5F9EA0;
const int SJ_RGB_COLOR_CHARTREUSE               = 0x7FFF00;
const int SJ_RGB_COLOR_CHOCOLATE                = 0xD2691E;
const int SJ_RGB_COLOR_CORAL                    = 0xFF7F50;
const int SJ_RGB_COLOR_CORNFLOWER_BLUE          = 0x6495ED;
const int SJ_RGB_COLOR_CORNSILK                 = 0xFFF8DC;
const int SJ_RGB_COLOR_CRIMSON                  = 0xDC143C;
const int SJ_RGB_COLOR_CYAN                     = 0x00FFFF;
const int SJ_RGB_COLOR_DARK_BLUE                = 0x00008B;
const int SJ_RGB_COLOR_DARK_CYAN                = 0x008B8B;
const int SJ_RGB_COLOR_DARK_GOLDENROD           = 0xB8860B;
const int SJ_RGB_COLOR_DARK_GREY                = 0xA9A9A9;
const int SJ_RGB_COLOR_DARK_GREEN               = 0x006400;
const int SJ_RGB_COLOR_DARK_KHAKI               = 0xBDB76B;
const int SJ_RGB_COLOR_DARK_MAGENTA             = 0x8B008B;
const int SJ_RGB_COLOR_DARK_OLIVE_GREEN         = 0x556B2F;
const int SJ_RGB_COLOR_DARK_ORANGE              = 0xFF8C00;
const int SJ_RGB_COLOR_DARK_ORCHID              = 0x9932CC;
const int SJ_RGB_COLOR_DARK_RED                 = 0x8B0000;
const int SJ_RGB_COLOR_DARK_SALMON              = 0xE9967A;
const int SJ_RGB_COLOR_DARK_SEA_GREEN           = 0x8FBC8F;
const int SJ_RGB_COLOR_DARK_SLATE_BLUE          = 0x483D8B;
const int SJ_RGB_COLOR_DARK_SLATE_GREY          = 0x2F4F4F;
const int SJ_RGB_COLOR_DARK_TURQUOISE           = 0x00CED1;
const int SJ_RGB_COLOR_DARK_VIOLET              = 0x9400D3;
const int SJ_RGB_COLOR_DEEP_PINK                = 0xFF1493;
const int SJ_RGB_COLOR_DEEP_SKY_BLUE            = 0x00BFFF;
const int SJ_RGB_COLOR_DIM_GREY                 = 0x696969;
const int SJ_RGB_COLOR_DODGER_BLUE              = 0x1E90FF;
const int SJ_RGB_COLOR_FIRE_BRICK               = 0xB22222;
const int SJ_RGB_COLOR_FLORAL_WHITE             = 0xFFFAF0;
const int SJ_RGB_COLOR_FOREST_GREEN             = 0x228B22;
const int SJ_RGB_COLOR_FUCHSIA                  = 0xFF00FF;
const int SJ_RGB_COLOR_GAINSBORO                = 0xDCDCDC;
const int SJ_RGB_COLOR_GHOST_WHITE              = 0xF8F8FF;
const int SJ_RGB_COLOR_GOLD                     = 0xFFD700;
const int SJ_RGB_COLOR_GOLDENROD                = 0xDAA520;
const int SJ_RGB_COLOR_GREY                     = 0x808080;
const int SJ_RGB_COLOR_GREEN                    = 0x008000;
const int SJ_RGB_COLOR_GREEN_YELLOW             = 0xADFF2F;
const int SJ_RGB_COLOR_HONEYDEW                 = 0xF0FFF0;
const int SJ_RGB_COLOR_HOT_PINK                 = 0xFF69B4;
const int SJ_RGB_COLOR_INDIAN_RED               = 0xCD5C5C;
const int SJ_RGB_COLOR_INDIGO                   = 0x4B0082;
const int SJ_RGB_COLOR_IVORY                    = 0xFFFFF0;
const int SJ_RGB_COLOR_KHAKI                    = 0xF0E68C;
const int SJ_RGB_COLOR_LAVENDER                 = 0xE6E6FA;
const int SJ_RGB_COLOR_LAVENDER_BLUSH           = 0xFFF0F5;
const int SJ_RGB_COLOR_LAWN_GREEN               = 0x7CFC00;
const int SJ_RGB_COLOR_LEMON_CHIFFON            = 0xFFFACD;
const int SJ_RGB_COLOR_LIGHT_BLUE               = 0xADD8E6;
const int SJ_RGB_COLOR_LIGHT_CORAL              = 0xF08080;
const int SJ_RGB_COLOR_LIGHT_CYAN               = 0xE0FFFF;
const int SJ_RGB_COLOR_LIGHT_GOLDENROD_YELLOW   = 0xFAFAD2;
const int SJ_RGB_COLOR_LIGHT_GREEN              = 0x90EE90;
const int SJ_RGB_COLOR_LIGHT_GREY               = 0xD3D3D3;
const int SJ_RGB_COLOR_LIGHT_PINK               = 0xFFB6C1;
const int SJ_RGB_COLOR_LIGHT_SALMON             = 0xFFA07A;
const int SJ_RGB_COLOR_LIGHT_SEA_GREEN          = 0x20B2AA;
const int SJ_RGB_COLOR_LIGHT_SKY_BLUE           = 0x87CEFA;
const int SJ_RGB_COLOR_LIGHT_SLATE_GREY         = 0x778899;
const int SJ_RGB_COLOR_LIGHT_STEEL_BLUE         = 0xB0C4DE;
const int SJ_RGB_COLOR_LIGHT_YELLOW             = 0xFFFFE0;
const int SJ_RGB_COLOR_LIME                     = 0x00FF00;
const int SJ_RGB_COLOR_LIME_GREEN               = 0x32CD32;
const int SJ_RGB_COLOR_LINEN                    = 0xFAF0E6;
const int SJ_RGB_COLOR_MAGENTA                  = 0xFF00FF;
const int SJ_RGB_COLOR_MAROON                   = 0x800000;
const int SJ_RGB_COLOR_MEDIUM_AQUAMARINE        = 0x66CDAA;
const int SJ_RGB_COLOR_MEDIUM_BLUE              = 0x0000CD;
const int SJ_RGB_COLOR_MEDIUM_ORCHID            = 0xBA55D3;
const int SJ_RGB_COLOR_MEDIUM_PURPLE            = 0x9370DB;
const int SJ_RGB_COLOR_MEDIUM_SEA_GREEN         = 0x3CB371;
const int SJ_RGB_COLOR_MEDIUM_SLATE_BLUE        = 0x7B68EE;
const int SJ_RGB_COLOR_MEDIUM_SPRING_GREEN      = 0x00FA9A;
const int SJ_RGB_COLOR_MEDIUM_TURQUOISE         = 0x48D1CC;
const int SJ_RGB_COLOR_MEDIUM_VIOLET_RED        = 0xC71585;
const int SJ_RGB_COLOR_MIDNIGHT_BLUE            = 0x191970;
const int SJ_RGB_COLOR_MINT_CREAM               = 0xF5FFFA;
const int SJ_RGB_COLOR_MISTY_ROSE               = 0xFFE4E1;
const int SJ_RGB_COLOR_MOCCASIN                 = 0xFFE4B5;
const int SJ_RGB_COLOR_NAVAJO_WHITE             = 0xFFDEAD;
const int SJ_RGB_COLOR_NAVY                     = 0x000080;
const int SJ_RGB_COLOR_OLD_LACE                 = 0xFDF5E6;
const int SJ_RGB_COLOR_OLIVE                    = 0x808000;
const int SJ_RGB_COLOR_OLIVE_DRAB               = 0x6B8E23;
const int SJ_RGB_COLOR_ORANGE                   = 0xFFA500;
const int SJ_RGB_COLOR_ORANGE_RED               = 0xFF4500;
const int SJ_RGB_COLOR_ORCHID                   = 0xDA70D6;
const int SJ_RGB_COLOR_PALE_GOLDENROD           = 0xEEE8AA;
const int SJ_RGB_COLOR_PALE_GREEN               = 0x98FB98;
const int SJ_RGB_COLOR_PALE_TURQUOISE           = 0xAFEEEE;
const int SJ_RGB_COLOR_PALE_VIOLET_RED          = 0xDB7093;
const int SJ_RGB_COLOR_PAPAYA_WHIP              = 0xFFEFD5;
const int SJ_RGB_COLOR_PEACH_PUFF               = 0xFFDAB9;
const int SJ_RGB_COLOR_PERU                     = 0xCD853F;
const int SJ_RGB_COLOR_PINK                     = 0xFFC0CB;
const int SJ_RGB_COLOR_PLUM                     = 0xDDA0DD;
const int SJ_RGB_COLOR_POWDER_BLUE              = 0xB0E0E6;
const int SJ_RGB_COLOR_PURPLE                   = 0x800080;
const int SJ_RGB_COLOR_RED                      = 0xFF0000;
const int SJ_RGB_COLOR_ROSY_BROWN               = 0xBC8F8F;
const int SJ_RGB_COLOR_ROYAL_BLUE               = 0x4169E1;
const int SJ_RGB_COLOR_SADDLE_BROWN             = 0x8B4513;
const int SJ_RGB_COLOR_SALMON                   = 0xFA8072;
const int SJ_RGB_COLOR_SANDY_BROWN              = 0xF4A460;
const int SJ_RGB_COLOR_SEA_GREEN                = 0x2E8B57;
const int SJ_RGB_COLOR_SEASHELL                 = 0xFFF5EE;
const int SJ_RGB_COLOR_SIENNA                   = 0xA0522D;
const int SJ_RGB_COLOR_SILVER                   = 0xC0C0C0;
const int SJ_RGB_COLOR_SKY_BLUE                 = 0x87CEEB;
const int SJ_RGB_COLOR_SLATE_BLUE               = 0x6A5ACD;
const int SJ_RGB_COLOR_SLATE_GREY               = 0x708090;
const int SJ_RGB_COLOR_SNOW                     = 0xFFFAFA;
const int SJ_RGB_COLOR_SPRING_GREEN             = 0x00FF7F;
const int SJ_RGB_COLOR_STEEL_BLUE               = 0x4682B4;
const int SJ_RGB_COLOR_TAN                      = 0xD2B48C;
const int SJ_RGB_COLOR_TEAL                     = 0x008080;
const int SJ_RGB_COLOR_THISTLE                  = 0xD8BFD8;
const int SJ_RGB_COLOR_TOMATO                   = 0xFF6347;
const int SJ_RGB_COLOR_TURQUOISE                = 0x40E0D0;
const int SJ_RGB_COLOR_VIOLET                   = 0xEE82EE;
const int SJ_RGB_COLOR_WHEAT                    = 0xF5DEB3;
const int SJ_RGB_COLOR_WHITE                    = 0xFFFFFF;
const int SJ_RGB_COLOR_WHITE_SMOKE              = 0xF5F5F5;
const int SJ_RGB_COLOR_YELLOW                   = 0xFFFF00;
const int SJ_RGB_COLOR_YELLOW_GREEN             = 0x9ACD32;


// -----------------------------------------------------------------------------
//  STRUCTURES
// -----------------------------------------------------------------------------

struct color
{
    int r;
    int g;
    int b;
};


// -----------------------------------------------------------------------------
//  PROTOTYPES
// -----------------------------------------------------------------------------

// Creates a color with specified values for r, g and b. The integer values can
// be passed in decimal or hexidecimal format i.e. 255 or 0xFF.
//  - nR:               an 8-bit integer for red channel
//  - nG:               an 8-bit integer for green channel
//  - nB:               an 8-bit integer for blue channel
//  * Returns:          a color
struct color Color(int nR, int nG, int nB);

// Returns a color of the same hue with the specified brightness level, i.e. a
// lighter or darker version of the specified color.
// NOTE: black has a brighness level of 0%, a pure hue (e.g. 0x0000FF) has a
// brightness level of 50% and white has a brightness level of 100%.
//  - nColor:           a 24-bit integer
//  - nBrightness:      new brightness level (0-100)
//  * Returns:          a 24-bit integer
int SJ_RGB_AdjustBrightness(int nColor, int nBrightness);

// Converts a color into hex and returns the hex value as a string.
//  - uColor:           a color
string SJ_RGB_ColorToHexString(struct color uColor);

// Converts a color into a 24-bit integer equivalent.
//  - uColor:           a color
//  * Returns:          a 24-bit integer
int SJ_RGB_ColorToInt(struct color uColor);

// Deletes the color stored with sVarName on oObject.
void SJ_RGB_DeleteLocalColor(object oObject, string sVarName);

// Returns a color's brightness level.
// NOTE: black has a brighness level of 0%, a pure hue (e.g. 0x0000FF) has a
// brightness level of 50% and white has a brightness level of 100%.
//  - nColor:           a 24-bit integer
//  * Returns:          0-100
int SJ_RGB_GetBrightness(int nColor);

// Returns the color stored with sVarName on oObject.
// NOTE: the color is stored as a 24-bit int value and can also be returned or
// adjusted using Get/SetLocalInt whenever that format is more appropriate.
struct color SJ_RGB_GetLocalColor(object oObject, string sVarName);

// Converts a 24-bit integer equivalent into a color. The integer value can be
// passed in decimal or hexidecimal format i.e. 255 or 0x0000FF.
//  - nColor:           a 24-bit integer
//  * Returns:          a color
struct color SJ_RGB_IntToColor(int nColor);

// Sets the color stored with sVarName on oObject.
// NOTE: the color is stored as a 24-bit int value and can also be returned or
// adjusted using Get/SetLocalInt whenever that format is more appropriate.
void SJ_RGB_SetLocalColor(object oObject, string sVarName, struct color uColor);


// -----------------------------------------------------------------------------
//  FUNCTIONS
// -----------------------------------------------------------------------------

struct color Color(int nR, int nG, int nB)
{
    struct color uColor;

    uColor.r = nR & 0xFF;
    uColor.g = nG & 0xFF;
    uColor.b = nB & 0xFF;

    return uColor;
}


int SJ_RGB_AdjustBrightness(int nColor, int nBrightness)
{
    // sanity checks: silently correct params
    nColor = RestrictIntToRange(nColor, 0, 0xFFFFFF);
    nBrightness = RestrictIntToRange(nBrightness, 0, 100);

    int nCurBrightness = SJ_RGB_GetBrightness(nColor);

    // shift each channel towards white or black depending on whether the new
    // brightness level is lighter or darker than the current level
    if(nBrightness > nCurBrightness)
    {
        // actual shift = target shift / max shift
        float fShift = IntToFloat(nBrightness - nCurBrightness) / IntToFloat(100 - nCurBrightness);


        // shift each channel to white proportional to its current offset
        struct color uColor = SJ_RGB_IntToColor(nColor);
        uColor.r = uColor.r + FloatToInt((0xFF - uColor.r) * fShift);
        uColor.g = uColor.g + FloatToInt((0xFF - uColor.g) * fShift);
        uColor.b = uColor.b + FloatToInt((0xFF - uColor.b) * fShift);

        return SJ_RGB_ColorToInt(uColor);
    }
    else if(nBrightness < nCurBrightness)
    {
        // actual shift = target shift / max shift
        float fShift = IntToFloat(nBrightness - nCurBrightness) / IntToFloat(nCurBrightness);

        // shift each channel to black proportional to its current offset
        struct color uColor = SJ_RGB_IntToColor(nColor);
        uColor.r = uColor.r + FloatToInt(uColor.r * fShift);
        uColor.g = uColor.g + FloatToInt(uColor.g * fShift);
        uColor.b = uColor.b + FloatToInt(uColor.b * fShift);

        return SJ_RGB_ColorToInt(uColor);
    }

    // the brightness levels are the same: the color is unchanged
    return nColor;
}


string SJ_RGB_ColorToHexString(struct color uColor)
{
    return IntToHexString(SJ_RGB_ColorToInt(uColor));
}


int SJ_RGB_ColorToInt(struct color uColor)
{
    int nR = uColor.r << SJ_RGB_CHANNEL_R;
    int nG = uColor.g << SJ_RGB_CHANNEL_G;

    return nR | nG | uColor.b;
}


void SJ_RGB_DeleteLocalColor(object oObject, string sVarName)
{
    DeleteLocalInt(oObject, sVarName);
}


int SJ_RGB_GetBrightness(int nColor)
{
    struct color uColor = SJ_RGB_IntToColor(nColor);

    // get the least intense color
    int nMin = uColor.r;
    if(uColor.g < nMin) nMin = uColor.g;
    if(uColor.b < nMin) nMin = uColor.b;

    // get the most intense color
    int nMax = uColor.r;
    if(uColor.g > nMax) nMax = uColor.g;
    if(uColor.b > nMax) nMax = uColor.b;

    // calculate actual brightness: the average of the min and max intensities
    float fBrightness = IntToFloat(nMin + nMax) / 2;

    // return brightness as a percentage
    return FloatToInt(fBrightness / 0xFF * 100);
}


struct color SJ_RGB_GetLocalColor(object oObject, string sVarName)
{
    int nColor = GetLocalInt(oObject, sVarName);
    return SJ_RGB_IntToColor(nColor);
}


struct color SJ_RGB_IntToColor(int nColor)
{
    struct color uColor;

    uColor.r = (nColor >> SJ_RGB_CHANNEL_R) & 0xFF;
    uColor.g = (nColor >> SJ_RGB_CHANNEL_G) & 0xFF;
    uColor.b = nColor & 0xFF;

    return uColor;
}


void SJ_RGB_SetLocalColor(object oObject, string sVarName, struct color uColor)
{
    int nColor = SJ_RGB_ColorToInt(uColor);
    SetLocalInt(oObject, sVarName, nColor);
}


