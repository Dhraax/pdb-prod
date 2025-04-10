////////////////////////////////////////////////////////////////////////////////
// LIBRERIA DE FUNCIONES REFERENTES A LAS ARMAS, INCLUYE LAS DEL CEP
////////////////////////////////////////////////////////////////////////////////

/******************************************************************************/
//: CEP USERS

//Baseitem: New Weapon Types
//const int BASE_ITEM_TRIDENT = 300;
const int BASE_ITEM_HEAVYPICK = 301;
const int BASE_ITEM_LIGHTPICK = 302;
const int BASE_ITEM_SAI = 303;
const int BASE_ITEM_NUNCHAKU = 304;
const int BASE_ITEM_FALCHION1 = 305;
const int BASE_ITEM_SAP = 308;
const int BASE_ITEM_DAGGERASSASSIN = 309;
const int BASE_ITEM_KATAR = 310;
const int BASE_ITEM_LIGHTMACE2 = 312;
const int BASE_ITEM_KUKRI2 = 313;
const int BASE_ITEM_FALCHION2 = 316;
const int BASE_ITEM_HEAVYMACE = 317;
const int BASE_ITEM_MAUL = 318;
const int BASE_ITEM_MERCURIALLONGSWORD = 319;
const int BASE_ITEM_MERCURIALGREATSWORD = 320;
const int BASE_ITEM_DOUBLESCIMITAR = 321;
const int BASE_ITEM_GOAD = 322;
const int BASE_ITEM_WINDFIREWHEEL = 323;

//: CEP USERS
/******************************************************************************/

/******************************************************************************/
//: NON CEP USERS
/*
//Baseitem: New Weapon Types
const int BASE_ITEM_BUTTERFLYSWORD = 265;
const int BASE_ITEM_CHAN = 266;
const int BASE_ITEM_DAO = 267;
const int BASE_ITEM_DOUBLESCIMITAR = 221;
const int BASE_ITEM_FALCHION = 216;
const int BASE_ITEM_FARMTOOLS = 272;
const int BASE_ITEM_FISHINGROD = 273;
const int BASE_ITEM_GOAD = 268;
const int BASE_ITEM_HANBO = 270;
const int BASE_ITEM_HEAVYMACE = 217;
const int BASE_ITEM_HEAVYPICK = 257;
const int BASE_ITEM_JIAN = 269;
const int BASE_ITEM_JUTTE = 271;
const int BASE_ITEM_LIGHTPICK = 258;
const int BASE_ITEM_MAUL = 218;
const int BASE_ITEM_MERCURIALGREATSWORD = 220;
const int BASE_ITEM_MERCURIALLONGSWORD = 219;
const int BASE_ITEM_NAGAMAKI = 259;
const int BASE_ITEM_NINJTO = 279;
const int BASE_ITEM_NODACHI = 260;
const int BASE_ITEM_WAKAZASHI = 256;

//: NON CEP USERS
/******************************************************************************/

int IsMeleeWeapon(object oWeapon)
{
    int nType = GetBaseItemType(oWeapon);
    switch (nType)
    {
      case BASE_ITEM_BASTARDSWORD:
      case BASE_ITEM_BATTLEAXE:
      case BASE_ITEM_DAGGER:
      case BASE_ITEM_DIREMACE:
      case BASE_ITEM_DOUBLEAXE:
      case BASE_ITEM_DWARVENWARAXE:
      case BASE_ITEM_GLOVES:
      case BASE_ITEM_GREATAXE:
      case BASE_ITEM_GREATSWORD:
      case BASE_ITEM_HALBERD:
      case BASE_ITEM_HANDAXE:
      case BASE_ITEM_HEAVYFLAIL:
      case BASE_ITEM_KAMA:
      case BASE_ITEM_KATANA:
      case BASE_ITEM_KUKRI:
      case BASE_ITEM_LIGHTFLAIL:
      case BASE_ITEM_LIGHTHAMMER:
      case BASE_ITEM_LIGHTMACE:
      case BASE_ITEM_LONGSWORD:
      case BASE_ITEM_MORNINGSTAR:
      case BASE_ITEM_RAPIER:
      case BASE_ITEM_SCIMITAR:
      case BASE_ITEM_SCYTHE:
      case BASE_ITEM_SHORTSPEAR:
      case BASE_ITEM_SHORTSWORD:
      case BASE_ITEM_SICKLE:
      case BASE_ITEM_TWOBLADEDSWORD:
      case BASE_ITEM_WARHAMMER:
      case BASE_ITEM_CLUB:
      case BASE_ITEM_MAGICSTAFF:
      case BASE_ITEM_QUARTERSTAFF:
      case BASE_ITEM_WHIP:

      //CEP
      /*********************************/

      case BASE_ITEM_TRIDENT:
      case BASE_ITEM_HEAVYPICK:
      case BASE_ITEM_LIGHTPICK:
      case BASE_ITEM_SAI:
      case BASE_ITEM_NUNCHAKU:
      case BASE_ITEM_FALCHION1:
      case BASE_ITEM_SAP:
      case BASE_ITEM_DAGGERASSASSIN:
      case BASE_ITEM_KATAR:
      case BASE_ITEM_LIGHTMACE2:
      case BASE_ITEM_KUKRI2:
      case BASE_ITEM_FALCHION2:
      case BASE_ITEM_HEAVYMACE:
      case BASE_ITEM_MAUL:
      case BASE_ITEM_MERCURIALLONGSWORD:
      case BASE_ITEM_MERCURIALGREATSWORD:
      case BASE_ITEM_DOUBLESCIMITAR:
      case BASE_ITEM_GOAD:
      case BASE_ITEM_WINDFIREWHEEL:
      /*********************************/

      //NO CEP
      /*********************************/
      /*
      case BASE_ITEM_BUTTERFLYSWORD:
      case BASE_ITEM_CHAN:
      case BASE_ITEM_DAO:
      case BASE_ITEM_DOUBLESCIMITAR:
      case BASE_ITEM_FALCHION:
      case BASE_ITEM_FARMTOOLS:
      case BASE_ITEM_FISHINGROD:
      case BASE_ITEM_GOAD:
      case BASE_ITEM_HANBO:
      case BASE_ITEM_HEAVYMACE:
      case BASE_ITEM_HEAVYPICK:
      case BASE_ITEM_JIAN:
      case BASE_ITEM_JUTTE:
      case BASE_ITEM_LIGHTPICK:
      case BASE_ITEM_MAUL:
      case BASE_ITEM_MERCURIALGREATSWORD:
      case BASE_ITEM_MERCURIALLONGSWORD:
      case BASE_ITEM_NAGAMAKI:
      case BASE_ITEM_NINJTO:
      case BASE_ITEM_NODACHI:
      case BASE_ITEM_WAKAZASHI:
      /*********************************/

      return TRUE;
    }
    return FALSE;
}

int IsRangedWeapon(object oWeapon)
{
    int nType = GetBaseItemType(oWeapon);
    switch (nType)
    {
      case BASE_ITEM_THROWINGAXE:
      case BASE_ITEM_HEAVYCROSSBOW:
      case BASE_ITEM_LIGHTCROSSBOW:
      case BASE_ITEM_LONGBOW:
      case BASE_ITEM_SHORTBOW:
      case BASE_ITEM_SLING:
      case BASE_ITEM_DART:
      return TRUE;
    }
    return FALSE;
}

int IsLightMeleeWeapon(object oWeapon)
{
    int nType = GetBaseItemType(oWeapon);
    switch (nType)
    {
      case BASE_ITEM_DAGGER:
      case BASE_ITEM_GLOVES:
      case BASE_ITEM_HANDAXE:
      case BASE_ITEM_KAMA:
      case BASE_ITEM_KUKRI:
      case BASE_ITEM_LIGHTFLAIL:
      case BASE_ITEM_LIGHTHAMMER:
      case BASE_ITEM_LIGHTMACE:
      case BASE_ITEM_QUARTERSTAFF:
      case BASE_ITEM_RAPIER:
      case BASE_ITEM_SCIMITAR:
      case BASE_ITEM_SHORTBOW:
      case BASE_ITEM_SHORTSPEAR:
      case BASE_ITEM_SHORTSWORD:
      case BASE_ITEM_SICKLE:
      case BASE_ITEM_SLING:
      case BASE_ITEM_THROWINGAXE:
      case BASE_ITEM_WHIP:

      //CEP
      /*********************************/

      case BASE_ITEM_LIGHTPICK:
      case BASE_ITEM_SAI:
      case BASE_ITEM_NUNCHAKU:
      case BASE_ITEM_SAP:
      case BASE_ITEM_DAGGERASSASSIN:
      case BASE_ITEM_KATAR:
      case BASE_ITEM_LIGHTMACE2:
      case BASE_ITEM_KUKRI2:
      /*********************************/

      //NO CEP
      /*********************************/
      /*
      case BASE_ITEM_BUTTERFLYSWORD:
      case BASE_ITEM_HANBO:
      case BASE_ITEM_JIAN:
      case BASE_ITEM_JUTTE:
      case BASE_ITEM_LIGHTPICK:
      case BASE_ITEM_WAKAZASHI:
      /*********************************/

      return TRUE;
    }
    return FALSE;
}

int IsMediumMeleeWeapon(object oWeapon)
{
    int nType = GetBaseItemType(oWeapon);
    switch (nType)
    {
      case BASE_ITEM_BASTARDSWORD:
      case BASE_ITEM_BATTLEAXE:
      case BASE_ITEM_DWARVENWARAXE:
      case BASE_ITEM_KATANA:
      case BASE_ITEM_LIGHTCROSSBOW:
      case BASE_ITEM_LONGBOW:
      case BASE_ITEM_LONGSWORD:
      case BASE_ITEM_MORNINGSTAR:
      case BASE_ITEM_WARHAMMER:

      //CEP
      /*********************************/

      case BASE_ITEM_FALCHION1:
      case BASE_ITEM_FALCHION2:
      case BASE_ITEM_GOAD:
      case BASE_ITEM_HEAVYMACE:
      case BASE_ITEM_HEAVYPICK:
      case BASE_ITEM_MERCURIALLONGSWORD:
      case BASE_ITEM_WINDFIREWHEEL:
      /*********************************/

      //NO CEP
      /*********************************/
      /*
      case BASE_ITEM_DAO:
      case BASE_ITEM_GOAD:
      case BASE_ITEM_HEAVYMACE:
      case BASE_ITEM_HEAVYPICK:
      case BASE_ITEM_JIAN:
      case BASE_ITEM_MERCURIALLONGSWORD:
      case BASE_ITEM_NINJTO:
      /*********************************/

      return TRUE;
    }
    return FALSE;
}

int IsHeavyMeleeWeapon(object oWeapon)
{
    int nType = GetBaseItemType(oWeapon);
    switch (nType)
    {
      case BASE_ITEM_GREATSWORD:
      case BASE_ITEM_GREATAXE:
      case BASE_ITEM_DIREMACE:
      case BASE_ITEM_DOUBLEAXE:
      case BASE_ITEM_HALBERD:
      case BASE_ITEM_HEAVYCROSSBOW:
      case BASE_ITEM_HEAVYFLAIL:
      case BASE_ITEM_SCYTHE:
      case BASE_ITEM_TWOBLADEDSWORD:

      //CEP
      /*********************************/

      case BASE_ITEM_DOUBLESCIMITAR:
      case BASE_ITEM_MAUL:
      case BASE_ITEM_MERCURIALGREATSWORD:
      case BASE_ITEM_TRIDENT:
      /*********************************/

      //NO CEP
      /*********************************/
      /*
      case BASE_ITEM_CHAN:
      case BASE_ITEM_DOUBLESCIMITAR:
      case BASE_ITEM_FALCHION:
      case BASE_ITEM_MAUL:
      case BASE_ITEM_MERCURIALGREATSWORD:
      case BASE_ITEM_NAGAMAKI:
      case BASE_ITEM_NODACHI:
      /*********************************/

      return TRUE;
    }
    return FALSE;
}

//void main(){}
