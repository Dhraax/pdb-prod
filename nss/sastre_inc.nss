//::///////////////////////////////////////////////
//:: MIL_TAILOR Include
//::  restricted items list(s)
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: Created By: bloodsong from milambus' tailor stuff
//:://////////////////////////////////////////////
/*
  Restriction Lists add-on

  you can create a list of part numbers you do not wish
people to access on the tailoring models.  this is set
up for the neck, torso, belt, and hip.
  remember to remove the // before any lines you are using.

  To Restrict Individual Numbers:

place a list of case statements above the return TRUE; line.
 ie:
        case 1:
        case 53:
        case 42:
          return TRUE;

  To Restrict Number Ranges:

replace the [low#] and [high#] with your starting and ending numbers
(inclusive), in the if statement.  copy the base if statment for more
ranges.
ie, to exclude 1, 2, 3, 4, and 5:

       if( n >= 1 && n <= 5)  return TRUE;


  To Find the Numbers to Restrict:

edit a piece of clothing/armor and cycle through the body part lists.
note down any numbers you want people not to use. also note which gender
they are on.  put female parts in the first segment of each section.
*/

//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int NeckIsInvalid(int n, int g)
{

  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List
  switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}

//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int TorsoIsInvalid(int n, int g)
{
  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List
  switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}


//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int BeltIsInvalid(int n, int g)
{
  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List
  switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}


//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int HipIsInvalid(int n, int g)
{
  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List

    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}


//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int RobeIsInvalid(int n, int g)
{
  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List
  switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}





//-- MILAMBUS' COLOUR CODES: do not touch anything below this line--------------------------------

// Returns the name of a color given is index.
string ClothColor(int iColor)
{
    switch (iColor)
    {
        case 00: return "Marrón/Curtido muy claro";
        case 01: return "Marrón/Curtido claro";
        case 02: return "Marrón/Curtido oscuro";
        case 03: return "Marrón/Curtido muy oscuro";

        case 04: return "Rojo/Curtido muy claro";
        case 05: return "Rojo/Curtido claro";
        case 06: return "Rojo/Curtido oscuro";
        case 07: return "Rojo/Curtido muy oscuro";

        case 08: return "Amarillo/Curtido muy claro";
        case 09: return "Amarillo/Curtido claro";
        case 10: return "Amarillo/Curtido oscuro";
        case 11: return "Amarillo/Curtido muy oscuro";

        case 12: return "Gris/Curtido muy claro";
        case 13: return "Gris/Curtido claro";
        case 14: return "Gris/Curtido oscuro";
        case 15: return "Gris/Curtido muy oscuro";

        case 16: return "Oliva muy claro";
        case 17: return "Oliva claro";
        case 18: return "Oliva oscuro";
        case 19: return "Oliva muy oscuro";

        case 20: return "Blanco";
        case 21: return "Gris claro";
        case 22: return "Gris oscuro";
        case 23: return "Negro";

        case 24: return "Azul claro";
        case 25: return "Azul oscuro";

        case 26: return "Azul agua claro";
        case 27: return "Azul agua oscuro";

        case 28: return "Azul turquesa claro";
        case 29: return "Azul turquesa oscuro";

        case 30: return "Verde claro";
        case 31: return "Verde oscuro";

        case 32: return "Amarillo claro";
        case 33: return "Amarillo oscuro";

        case 34: return "Naranja claro";
        case 35: return "Naranja oscuro";

        case 36: return "Rojo claro";
        case 37: return "Rojo oscuro";

        case 38: return "Rosa claro";
        case 39: return "Rosa oscuro";

        case 40: return "Morado claro";
        case 41: return "Morado oscuro";

        case 42: return "Violeta claro";
        case 43: return "Violeta oscuro";

        case 44: return "Blanco brillante";
        case 45: return "Negro brillante";

        case 46: return "Azul brillante";
        case 47: return "Azul agua brillante";

        case 48: return "Azul turquesa brillante";
        case 49: return "Verde brillante";

        case 50: return "Amarillo brillante";
        case 51: return "Naranja brillante";

        case 52: return "Rojo brillante";
        case 53: return "Rosa brillante";

        case 54: return "Morado brillante";
        case 55: return "Violeta brillante";

        case 56: return "Oculto: Metal";
        case 57: return "Oculto: Obsidiana";
        case 58: return "Oculto: Oro";
        case 59: return "Oculto: Cobre";
        case 60: return "Oculto: Gris";
        case 61: return "Oculto: Espejo";
        case 62: return "Oculto: Blanco puro";
        case 63: return "Oculto: Negro puro";

        case 64: return "Smoky Rosa";
        case 65: return "Smoky Marrón tierra";
        case 66: return "Smoky Oro";
        case 67: return "Smoky Verde hoja";
        case 68: return "Smoky Verde";
        case 69: return "Smoky Verde oscuro";
        case 70: return "Smoky Púrpura";
        case 71: return "Smoky Ahumado";
        case 72: return "Smoky Ciruela";
        case 73: return "Smoky Ciruela opaco";
        case 74: return "Smoky Marrón";
        case 75: return "Smoky Gris";
        case 76: return "Smoky Verde marino";
        case 77: return "Smoky Verde opaco";
        case 78: return "Smoky Azul";
        case 79: return "Smoky Azul opaco";
        case 80: return "Smoky Verde salvaje";
        case 81: return "Smoky Verde opaco";
        case 82: return "Smoky Azul hielo";
        case 83: return "Smoky Azul cobalto";
        case 84: return "Smoky Verde saltamontes";
        case 85: return "Smoky Piedra";
        case 86: return "Smoky Verde champiñón";
        case 87: return "Smoky Verde musgo";
        case 88: return "Smoky Rojo muy claro";
        case 89: return "Smoky Rojo claro";
        case 90: return "Smoky Rojo";
        case 91: return "Smoky Rojo oscuro";
        case 92: return "Smoky Latón muy claro";
        case 93: return "Smoky Latón claro";
        case 94: return "Smoky Latón";
        case 95: return "Smoky Latón oscuro";
        case 96: return "Cereza negra muy claro";
        case 97: return "Cereza negra claro";
        case 98: return "Cereza negra";
        case 99: return "Cereza negra oscuro";
        case 100: return "Canela muy claro";
        case 101: return "Canela claro";
        case 102: return "Canela";
        case 103: return "Canela oscuro";
        case 104: return "Verde cazador muy claro";
        case 105: return "Verde cazador claro";
        case 106: return "Verde cazador";
        case 107: return "Verde cazador oscuro";
        case 108: return "Verde druida muy claro";
        case 109: return "Verde druida claro";
        case 110: return "Verde druida";
        case 111: return "Verde druida oscuro";
        case 112: return "Niebla muy claro";
        case 113: return "Niebla claro";
        case 114: return "Niebla";
        case 115: return "Niebla oscuro";
        case 116: return "Castaño muy claro";
        case 117: return "Castaño claro";
        case 118: return "Castaño";
        case 119: return "Castaño oscuro";
        case 120: return "Arcilla muy claro";
        case 121: return "Arcilla claro";
        case 122: return "Arcilla";
        case 123: return "Arcilla oscuro";
        case 124: return "Ceniza muy claro";
        case 125: return "Ceniza claro";
        case 126: return "Ceniza";
        case 127: return "Ceniza oscuro";
        case 128: return "Marrón caracol muy claro";
        case 129: return "Marrón caracol claro";
        case 130: return "Marrón caracol";
        case 131: return "Marrón caracol oscuro";
        case 132: return "Azul cobalto muy claro";
        case 133: return "Azul cobalto claro";
        case 134: return "Azul cobalto";
        case 135: return "Azul cobalto oscuro";
        case 136: return "Azul medianoche muy claro";
        case 137: return "Azul medianoche claro";
        case 138: return "Azul medianoche";
        case 139: return "Azul medianoche oscuro";
        case 140: return "Verde real muy claro";
        case 141: return "Verde real claro";
        case 142: return "Verde real";
        case 143: return "Verde real oscuro";
        case 144: return "Púrpura real muy claro";
        case 145: return "Púrpura real claro";
        case 146: return "Púrpura real";
        case 147: return "Púrpura real oscuro";
        case 148: return "Azul montaña claro";
        case 149: return "Azul montaña oscuro";
        case 150: return "Verde fondo marino claro";
        case 151: return "Verde fondo marino oscuro";
        case 152: return "Verde primavera claro";
        case 153: return "Verde primavera oscuro";
        case 154: return "Oromiel claro";
        case 155: return "Oromiel oscuro";
        case 156: return "Cobre claro";
        case 157: return "Cobre oscuro";
        case 158: return "Bayahelada claro";
        case 159: return "Bayahelada oscuro";
        case 160: return "Ciruela dulce claro";
        case 161: return "Ciruela dulce oscuro";
        case 162: return "Bayahelada";
        case 163: return "Ciruela";
        case 164: return "Azul hielo";
        case 165: return "Azul opaco";
        case 166: return "Blanco hielo";
        case 167: return "Roca oscura";
        case 168: return "Apio";
        case 169: return "Verde místico";
        case 170: return "Morado místico";
        case 171: return "Azul místico";
        case 172: return "Verde dorado";
        case 173: return "Chocolate";
        case 174: return "Marrón cuero";
        case 175: return "Oro moteado";

    }

    return "";
}

// Returns the name of a color given is index.
string MetalColor(int iColor)
{
    switch (iColor)
    {
        case 00: return "Metal brillante claro";
        case 01: return "Metal brillante oscuro";
        case 02: return "Obsidiana brillante clara";
        case 03: return "Obsidiana brillante oscura";

        case 04: return "Plata opaco claro";
        case 05: return "Plata opaco oscuro";
        case 06: return "Obsidiana opaca clara";
        case 07: return "Obsidiana opaca oscura";

        case 08: return "Oro muy claro";
        case 09: return "Oro claro";
        case 10: return "Oro oscuro";
        case 11: return "Oro muy oscuro";

        case 12: return "Oro celestial muy claro";
        case 13: return "Oro celestial claro";
        case 14: return "Oro celestial oscuro";
        case 15: return "Oro celestial muy oscuro";

        case 16: return "Cobre muy claro";
        case 17: return "Cobre claro";
        case 18: return "Cobre oscuro";
        case 19: return "Cobre muy oscuro";

        case 20: return "Latón muy claro";
        case 21: return "Latón claro";
        case 22: return "Latón oscuro";
        case 23: return "Latón muy oscuro";

        case 24: return "Rojo claro";
        case 25: return "Rojo oscuro";
        case 26: return "Rojo opaco claro";
        case 27: return "Rojo opaco oscuro";

        case 28: return "Morado claro";
        case 29: return "Morado oscuro";
        case 30: return "Morado opaco claro";
        case 31: return "Morado opaco oscuro";

        case 32: return "Azul claro";
        case 33: return "Azul oscuro";
        case 34: return "Azul opaco claro";
        case 35: return "Azul opaco oscuro";

        case 36: return "Turquesa claro";
        case 37: return "Turquesa oscuro";
        case 38: return "Turquesa opaco claro";
        case 39: return "Turquesa opaco oscuro";

        case 40: return "Verde claro";
        case 41: return "Verde oscuro";
        case 42: return "Verde opaco claro";
        case 43: return "Verde opaco oscuro";

        case 44: return "Oliva claro";
        case 45: return "Oliva oscuro";
        case 46: return "Oliva opaco claro";
        case 47: return "Oliva opaco oscuro";

        case 48: return "Prismático claro";
        case 49: return "Prismático oscuro";

        case 50: return "Óxido muy claro";
        case 51: return "Óxido claro";
        case 52: return "Óxido oscuro";
        case 53: return "Óxido muy oscuro";

        case 54: return "Metal envejecido claro";
        case 55: return "Metal envejecido oscuro";

        case 56: return "Oculto: Metal";
        case 57: return "Oculto: Obsidiana";
        case 58: return "Oculto: Oro";
        case 59: return "Oculto: Cobre";
        case 60: return "Oculto: Gris";
        case 61: return "Oculto: Espejo";
        case 62: return "Oculto: Blanco puro";
        case 63: return "Oculto: Negro puro";

        case 64: return "Smoky Rosa";
        case 65: return "Smoky Marrón tierra";
        case 66: return "Smoky Oro";
        case 67: return "Smoky Verde hoja";
        case 68: return "Smoky Verde";
        case 69: return "Smoky Verde oscuro";
        case 70: return "Smoky Púrpura";
        case 71: return "Smoky Ahumado";
        case 72: return "Smoky Ciruela";
        case 73: return "Smoky Ciruela opaco";
        case 74: return "Smoky Marrón";
        case 75: return "Smoky Gris";
        case 76: return "Smoky Verde marino";
        case 77: return "Smoky Verde opaco";
        case 78: return "Smoky Azul";
        case 79: return "Smoky Azul opaco";
        case 80: return "Smoky Verde salvaje";
        case 81: return "Smoky Verde opaco";
        case 82: return "Smoky Azul hielo";
        case 83: return "Smoky Azul cobalto";
        case 84: return "Smoky Verde saltamontes";
        case 85: return "Smoky Piedra";
        case 86: return "Smoky Verde champiñón";
        case 87: return "Smoky Verde musgo";
        case 88: return "Smoky Rojo muy claro";
        case 89: return "Smoky Rojo claro";
        case 90: return "Smoky Rojo";
        case 91: return "Smoky Rojo oscuro";
        case 92: return "Smoky Latón muy claro";
        case 93: return "Smoky Latón claro";
        case 94: return "Smoky Latón";
        case 95: return "Smoky Latón oscuro";
        case 96: return "Cereza negra muy claro";
        case 97: return "Cereza negra claro";
        case 98: return "Cereza negra";
        case 99: return "Cereza negra oscuro";
        case 100: return "Canela muy claro";
        case 101: return "Canela claro";
        case 102: return "Canela";
        case 103: return "Canela oscuro";
        case 104: return "Verde cazador muy claro";
        case 105: return "Verde cazador claro";
        case 106: return "Verde cazador";
        case 107: return "Verde cazador oscuro";
        case 108: return "Verde druida muy claro";
        case 109: return "Verde druida claro";
        case 110: return "Verde druida";
        case 111: return "Verde druida oscuro";
        case 112: return "Niebla muy claro";
        case 113: return "Niebla claro";
        case 114: return "Niebla";
        case 115: return "Niebla oscuro";
        case 116: return "Castaño muy claro";
        case 117: return "Castaño claro";
        case 118: return "Castaño";
        case 119: return "Castaño oscuro";
        case 120: return "Arcilla muy claro";
        case 121: return "Arcilla claro";
        case 122: return "Arcilla";
        case 123: return "Arcilla oscuro";
        case 124: return "Ceniza muy claro";
        case 125: return "Ceniza claro";
        case 126: return "Ceniza";
        case 127: return "Ceniza oscuro";
        case 128: return "Marrón caracol muy claro";
        case 129: return "Marrón caracol claro";
        case 130: return "Marrón caracol";
        case 131: return "Marrón caracol oscuro";
        case 132: return "Azul cobalto muy claro";
        case 133: return "Azul cobalto claro";
        case 134: return "Azul cobalto";
        case 135: return "Azul cobalto oscuro";
        case 136: return "Azul medianoche muy claro";
        case 137: return "Azul medianoche claro";
        case 138: return "Azul medianoche";
        case 139: return "Azul medianoche oscuro";
        case 140: return "Verde real muy claro";
        case 141: return "Verde real claro";
        case 142: return "Verde real";
        case 143: return "Verde real oscuro";
        case 144: return "Púrpura real muy claro";
        case 145: return "Púrpura real claro";
        case 146: return "Púrpura real";
        case 147: return "Púrpura real oscuro";
        case 148: return "Azul montaña claro";
        case 149: return "Azul montaña oscuro";
        case 150: return "Verde fondo marino claro";
        case 151: return "Verde fondo marino oscuro";
        case 152: return "Verde primavera claro";
        case 153: return "Verde primavera oscuro";
        case 154: return "Oromiel claro";
        case 155: return "Oromiel oscuro";
        case 156: return "Cobre claro";
        case 157: return "Cobre oscuro";
        case 158: return "Bayahelada claro";
        case 159: return "Bayahelada oscuro";
        case 160: return "Ciruela dulce claro";
        case 161: return "Ciruela dulce oscuro";
        case 162: return "Bayahelada";
        case 163: return "Ciruela";
        case 164: return "Azul hielo";
        case 165: return "Azul opaco";
        case 166: return "Blanco hielo";
        case 167: return "Roca oscura";
        case 168: return "Apio";
        case 169: return "Verde místico";
        case 170: return "Morado místico";
        case 171: return "Azul místico";
        case 172: return "Verde dorado";
        case 173: return "Chocolate";
        case 174: return "Marrón cuero";
        case 175: return "Oro moteado";
    }

    return "";
}



//::///////////////////////////////////////////////
//:: Tailoring - Items Include File
//:: tlr_items_inc.nss
//::
//:://////////////////////////////////////////////
/*
    Includes functions for scrolling through and
    recoloring equipped items
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: Created On: January 28, 2006
//:: Edited by 420 for CEP where indicated
//:://////////////////////////////////////////////

const int    PART_NEXT  = 0;
const int    PART_PREV  = 1;
const int    COLOR_NEXT = 3;
const int    COLOR_PREV = 4;
const int    HELMET = 8888;
const int    SHIELD = 8889;

int GetIsShieldInvalid(int nCurrApp, int nBaseType);
int GetIsWeaponInvalid(int nCurrApp, int nBaseType, int nPart);

//Cloak crafting added for CEP
void RemakeCloak(object oNPC, object oItem, int nMode)
{
    int nCurrApp, nSlot;
    object oNew;

        nCurrApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
        int nMin = 1;
        int nMax = 255;

        do
        {
            if (nMode == PART_NEXT)
            {
                if (++nCurrApp>nMax) nCurrApp = nMin;
            }
            else
            {
                if (--nCurrApp<nMin) nCurrApp = nMax;
            }

         }
         while (Get2DAString("cloakmodel", "LABEL", nCurrApp) == "");

    oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nCurrApp, TRUE);
            nSlot = INVENTORY_SLOT_CLOAK;


    if (GetIsObjectValid(oNew))
    {
        DestroyObject(oItem);
        AssignCommand(oNPC, ClearAllActions(TRUE));
        AssignCommand(oNPC, ActionEquipItem(oNew, nSlot));
    }
        object oPC = GetPCSpeaker();
        SendMessageToPC(oPC, "<c þ >Nueva apariencia: " + IntToString(nCurrApp) +" "+ Get2DAString("cloakmodel", "LABEL", nCurrApp) + "</c>");
}

void RemakeShield(object oNPC, object oItem, int nMode)
{
///////////////////////////////////////////////////////////////////
/*
   Change the following values to the highest shield model
   numbers used in your module.  The default NWN values (no haks)
   are already listed.
*/
///////////////////////////////////////////////////////////////////

    int MaxSmallShield = 216;
    int MaxLargeShield = 255;
    int MaxTowerShield = 249; //CEP 2.4 + PB 1.5 Tower Shield Max

///////////////////////////////////////////////////////////////////

    int nSlot;
    object oNew;

    int nCurrApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    int nBaseType = GetBaseItemType(oItem);
    int nMin = 11;
    int nMax;
    if(nBaseType == BASE_ITEM_SMALLSHIELD) {nMax = MaxSmallShield;}
    if(nBaseType == BASE_ITEM_LARGESHIELD) {nMax = MaxLargeShield;}
    if(nBaseType == BASE_ITEM_TOWERSHIELD) {nMax = MaxTowerShield;}
    do
    {
        if (nMode == PART_NEXT)
        {
            if (++nCurrApp > nMax)
                nCurrApp = nMin;
        }
        else
        {
            if (--nCurrApp < nMin)
                nCurrApp = nMax;
        }
        while(GetIsShieldInvalid(nCurrApp, nBaseType))
        {
            if (nMode == PART_NEXT)
                nCurrApp++;
            else
                nCurrApp--;
        }
        oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nCurrApp, TRUE);
    }
    while (!GetIsObjectValid(oNew));
        nSlot = INVENTORY_SLOT_LEFTHAND;

    if (GetIsObjectValid(oNew))
    {
        DestroyObject(oItem);
        AssignCommand(oNPC, ClearAllActions(TRUE));
        AssignCommand(oNPC, ActionEquipItem(oNew, nSlot));
    }
        object oPC = GetPCSpeaker();
        SendMessageToPC(oPC, "<c þ >Nueva apariencia " + IntToString(nCurrApp)+"<c þ >");
}

void RemakeHelm(object oModel, object oItem, int nMode)
{
    int nCurrApp, nSlot;
    object oNew;

        nCurrApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0);
        int nMin = 1;
        int nMax = StringToInt(Get2DAString("baseitems", "MaxRange", BASE_ITEM_HELMET));

        do
        {
            if (nMode == PART_NEXT)
            {
                if (++nCurrApp>nMax) nCurrApp = nMin;
            }
            else
            {
                if (--nCurrApp<nMin) nCurrApp = nMax;
            }

            oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0, nCurrApp, TRUE);
         }
         while (!GetIsObjectValid(oNew));
            nSlot = INVENTORY_SLOT_HEAD;


    if (GetIsObjectValid(oNew))
    {
        DestroyObject(oItem);
        AssignCommand(oModel, ClearAllActions(TRUE));
        AssignCommand(oModel, ActionEquipItem(oNew, nSlot));
    }
        object oPC = GetPCSpeaker();
        SendMessageToPC(oPC, "<c þ >Nueva apariencia "  + IntToString(nCurrApp)+"</c>");
}

void RemakeWeapon(object oNPC, object oItem, int nPart, int nMode)
{
    object oColor1, oItemFinal;
    int nCurrApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, nPart);
    int nBaseType = GetBaseItemType(oItem);
    int nSlot;
    int nMin = StringToInt(Get2DAString("baseitems", "MinRange", nBaseType)) /10;
    int nMax = StringToInt(Get2DAString("baseitems", "MaxRange", nBaseType)) /10;
    oColor1 = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, nPart, 1, TRUE);
    DestroyObject(oItem);
    do
    {
        if (nMode == PART_NEXT)
        {
            nCurrApp = nCurrApp + 1;
            if (nCurrApp>nMax)
                nCurrApp = nMin;
        }
        else
        {
            nCurrApp = nCurrApp - 1;
            if (nCurrApp<nMin)
                nCurrApp = nMax;
        }
        /*while(GetIsWeaponInvalid(nCurrApp, nBaseType, nPart))
        {
            if (nMode == PART_NEXT)
                nCurrApp = nCurrApp + 1;
            else
                nCurrApp = nCurrApp - 1;
        }*/
        oItemFinal = CopyItemAndModify(oColor1, ITEM_APPR_TYPE_WEAPON_MODEL, nPart, nCurrApp, TRUE);
        nSlot = INVENTORY_SLOT_RIGHTHAND;
     }
     while (!GetIsObjectValid(oItemFinal));
    if (GetIsObjectValid(oItemFinal))
    {
        DestroyObject(oColor1);
        oItem = oItemFinal;
        AssignCommand(oNPC, ClearAllActions(TRUE));
        AssignCommand(oNPC, ActionEquipItem(oItem, nSlot));
        object oPC = GetPCSpeaker();
        SendMessageToPC(oPC, "<c þ >Nueva apariencia "  + IntToString(nCurrApp)+"</c>");
    }

}

void ColorItem(object oNPC, object oItem, int nPart, int nMode)
{
    int nCurrApp, nSlot;
    object oNew;

    nCurrApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, nPart);
    int nMin = 1;
    int nMax = 9;

    do
    {
        if (nMode == COLOR_NEXT)
        {
            if (++nCurrApp>nMax) nCurrApp = nMin;
        }
        else
        {
            if (--nCurrApp<nMin) nCurrApp = nMax;
        }

        oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, nPart, nCurrApp, TRUE);
        nSlot = INVENTORY_SLOT_RIGHTHAND;
    } while (!GetIsObjectValid(oNew));
    if (GetIsObjectValid(oNew))
    {
        DestroyObject(oItem);
        oItem = oNew;
        AssignCommand(oNPC, ClearAllActions(TRUE));
        AssignCommand(oNPC, ActionEquipItem(oItem, nSlot));
        object oPC = GetPCSpeaker();
        SendMessageToPC(oPC, "<c þ >Nuevo color "  + IntToString(nCurrApp)+"</c>");
    }
}

/*
///////////////////////////////////////////////////////
   Invalid Model Numbers and Restriction List
///////////////////////////////////////////////////////

   To Restrict Individual Numbers:
   Place a list of case statements above the return TRUE; line.
   ie:
        case 1:
        case 53:
        case 42:
            return TRUE;

  To Restrict Number Ranges:
  Replace the [low#] and [high#] with your starting and ending numbers
  (inclusive), in the if statement.  Copy the base if statment for more
  ranges.
  ie, to exclude 1, 2, 3, 4, and 5:

       if( nBaseType >= 1 && nBaseType <= 5)
           return TRUE;

  To Find the Numbers to Restrict:

      Shields:
      Edit a small, large, and tower shield in the toolset and mark
      which shield model numbers are missing for each shield type.  Also note
      down any shield model number you do not want players to be able
      to use, and put the unwanted numbers into the above format in the
      GetIsShieldInvalid function.

      Weapons:
      Follow the above method for weapons to determine which model numbers
      you don't want to allow.

*/
int GetIsShieldInvalid(int nCurrApp, int nBaseType)
{
// shield code modified 22/AUG/2006 by SJGL
// Edited by 420 for CEP 2.x to use cepshieldmodel.2da
////////////////////////////////////////////////////////////////
//                       Small Shields
////////////////////////////////////////////////////////////////
    if(nBaseType == BASE_ITEM_SMALLSHIELD)
    {
/*      Place restricted numbers here and uncomment as neccessary
        switch(nCurrApp)
        {
            case 1:
            case 53:
            case 42:
                return TRUE;
        }

        if( nCurrApp >= 1 && nCurrApp <= 5)
            return TRUE;
*/
        if(Get2DAString("cepshieldmodel", "BASE_ITEM_SMALLSHIELD", nCurrApp) == "")
            return TRUE;
        return FALSE;
    }

////////////////////////////////////////////////////////////////
//                       Large Shields
////////////////////////////////////////////////////////////////
    if(nBaseType == BASE_ITEM_LARGESHIELD)
    {
/*      Place restricted numbers here and uncomment as neccessary
        switch(nCurrApp)
        {
            case 1:
            case 53:
            case 42:
                return TRUE;
        }

        if( nCurrApp >= 1 && nCurrApp <= 5)
            return TRUE;
*/
        if(Get2DAString("cepshieldmodel", "BASE_ITEM_LARGESHIELD", nCurrApp) == "")
            return TRUE;
        return FALSE;
   }

////////////////////////////////////////////////////////////////
//                       Tower Shields
////////////////////////////////////////////////////////////////
    if(nBaseType == BASE_ITEM_TOWERSHIELD)
    {
/*      Place restricted numbers here and uncomment as neccessary

        //To restrict individual numbers, replace #
        //with the number to restrict
        switch(nCurrApp)
        {
            case #:
            case #:
            case #:
                return TRUE;
        }

        //To restrict individual numbers, replace #
        //with the lowest and highest number to restrict (inclusive)
        if(nCurrApp >= # && nCurrApp <= #)
            return TRUE;
*/
        if(Get2DAString("cepshieldmodel", "BASE_ITEM_TOWERSHIELD", nCurrApp) == "")
            return TRUE;
        return FALSE;
    }
return FALSE;
}

int GetIsWeaponInvalid(int nCurrApp, int nBaseType, int nPart)
{
/*
//    Uncomment and fill out as neccessary.  Change **** to the base item
//    type you are wanting to disallow models from.  You can type
//    "BASE_ITEM_" in the filter to the right, and click the Constants button
//    to see a list.  For example: BASE_ITEM_DAGGER, BASE_ITEM_CLUB, etc.
//    Copy and paste the below template if you are wanting to restrict models
//    from more than one item type.

      //Weapon Top Restrictions
      if(nPart == ITEM_APPR_WEAPON_MODEL_TOP)
      {
          if(nBaseType == BASE_ITEM_****)
          {
              //To restrict individual numbers, replace #
              //with the number to restrict
              switch(nCurrApp)
              {
                  case #:
                  case #:
                  case #:
                      return TRUE;
              }
              //To restrict individual numbers, replace #
              //with the lowest and highest number to restrict (inclusive)
              if(nCurrApp >= # && nCurrApp <= #)
                  return TRUE;
          }
      }

      //Weapon Middle Restrictions
      if(nPart == ITEM_APPR_WEAPON_MODEL_MIDDLE)
      {
          if(nBaseType == BASE_ITEM_****)
          {
              //To restrict individual numbers, replace #
              //with the number to restrict
              switch(nCurrApp)
              {
                  case #:
                  case #:
                  case #:
                      return TRUE;
              }
              //To restrict individual numbers, replace #
              //with the lowest and highest number to restrict (inclusive)
              if(nCurrApp >= # && nCurrApp <= #)
                  return TRUE;
          }
      }

      //Weapon Bottom Restrictions
      if(nPart == ITEM_APPR_WEAPON_MODEL_BOTTOM)
      {
          if(nBaseType == BASE_ITEM_****)
          {
              //To restrict individual numbers, replace #
              //with the number to restrict
              switch(nCurrApp)
              {
                  case #:
                  case #:
                  case #:
                      return TRUE;
              }
              //To restrict individual numbers, replace #
              //with the lowest and highest number to restrict (inclusive)
              if(nCurrApp >= # && nCurrApp <= #)
                  return TRUE;
          }
      }
*/
      return FALSE;
}

//void main() {}
