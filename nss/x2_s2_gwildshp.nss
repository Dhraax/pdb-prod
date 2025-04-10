//::///////////////////////////////////////////////
//:: Greater Wild Shape, Humanoid Shape
//:: x2_s2_gwildshp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the character to shift into one of these
    forms, gaining special abilities

    Credits must be given to mr_bumpkin from the NWN
    community who had the idea of merging item properties
    from weapon and armor to the creatures new forms.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-02
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified Date: January 26th, 2008
//:://////////////////////////////////////////////
/*
    Modified to insure no shapeshifting spells are castable upon
    mounted targets.  This prevents problems that can occur due
    to dismounting after shape shifting, or other issues that can
    occur due to preserved appearances getting out of synch.

    This can additional check can be disabled by setting the variable
    X3_NO_SHAPESHIFT_SPELL_CHECK to 1 on the module object.  If this
    variable is set then this script will function as it did prior to
    this modification.

*/

#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "mti_libreria"
#include "lib_disguise"


void main()
{
    // NO NOS PODEMOS POLIMORFAR CUANDO YA LO ESTAMOS O ESTAMOS MONTADO A CABALLO
    if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(OBJECT_SELF, "<cþ>No puedes polimorfarte cuando estás montado en montura.</c>");
        return;
    }
    if(ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE)
    {
        SendMessageToPC(OBJECT_SELF, "<cþ>Despolimórfate antes de usar esta aptitud.</c>");
        return;
    }

    //--------------------------------------------------------------------------
    // Declare major variables
    //--------------------------------------------------------------------------
    int    nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    int    nShifter = GetLevelByClass(CLASS_TYPE_SHIFTER);
    effect ePoly;
    int    nPoly;
    string sNombre;

    // Feb 13, 2004, Jon: Added scripting to take care of case where it's an NPC
    // using one of the feats. It will randomly pick one of the shapes associated
    // with the feat.
    switch(nSpell)
    {
        // Greater Wildshape I
        case 646: nSpell = Random(5)+658; break;
        // Greater Wildshape II
        case 675: switch(Random(3))
                  {
                    case 0: nSpell = 672; break;
                    case 1: nSpell = 678; break;
                    case 2: nSpell = 680;
                  }
                  break;
        // Greater Wildshape III
        case 676: switch(Random(3))
                  {
                    case 0: nSpell = 670; break;
                    case 1: nSpell = 673; break;
                    case 2: nSpell = 674;
                  }
                  break;
        // Greater Wildshape IV
        case 677: switch(Random(3))
                  {
                    case 0: nSpell = 679; break;
                    case 1: nSpell = 691; break;
                    case 2: nSpell = 694;
                  }
                  break;
        // Humanoid Shape
        case 681:  nSpell = Random(3)+682; break;
        // Undead Shape
        case 685:  nSpell = Random(3)+704; break;
        // Dragon Shape
        case 725:  nSpell = Random(3)+707; break;
        // Outsider Shape
        case 732:  nSpell = Random(3)+733; break;
        // Construct Shape
        case 737:  nSpell = Random(3)+738; break;
    }

    //--------------------------------------------------------------------------
    // Determine which form to use based on spell id, gender and level
    //--------------------------------------------------------------------------
    switch (nSpell)
    {

        //-----------------------------------------------------------------------
        // Greater Wildshape I - Wyrmling Shape
        //-----------------------------------------------------------------------
        case 658:  nPoly = POLYMORPH_TYPE_WYRMLING_RED; sNombre = "Wyrmling Rojo";break;
        case 659:  nPoly = POLYMORPH_TYPE_WYRMLING_BLUE; sNombre = "Wyrmling Azul";break;
        case 660:  nPoly = POLYMORPH_TYPE_WYRMLING_BLACK; sNombre = "Wyrmling Negro";break;
        case 661:  nPoly = POLYMORPH_TYPE_WYRMLING_WHITE; sNombre = "Wyrmling Blanco";break;
        case 662:  nPoly = POLYMORPH_TYPE_WYRMLING_GREEN; sNombre = "Wyrmling Verde";break;

        //-----------------------------------------------------------------------
        // Greater Wildshape II  - Minotaur, Gargoyle, Harpy
        //-----------------------------------------------------------------------
        case 672: if (nShifter < X2_GW2_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_HARPY;
                  else {
                     nPoly = 97; }
                     sNombre = "Arpia";
                  break;

        case 678: if (nShifter < X2_GW2_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_GARGOYLE;
                  else {
                     nPoly = 98; }
                     sNombre = "Gargola";
                  break;

        case 680: if (nShifter < X2_GW2_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_MINOTAUR;
                  else {
                     nPoly = 96; }
                     sNombre = "Minotauro";
                  break;

        //-----------------------------------------------------------------------
        // Greater Wildshape III  - Drider, Basilisk, Manticore
        //-----------------------------------------------------------------------
        case 670: if (nShifter < X2_GW3_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_BASILISK;
                  else {
                     nPoly = 99; }
                     sNombre = "Basilisco";
                  break;

        case 673: if (nShifter < X2_GW3_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_DRIDER;
                  else {
                     nPoly = 100; }
                     sNombre = "Draña";
                  break;

        case 674: if (nShifter < X2_GW3_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_MANTICORE;
                  else {
                     nPoly = 101; }
                     sNombre = "Manticora";
                  break;

       //-----------------------------------------------------------------------
       // Greater Wildshape IV - Dire Tiger, Medusa, MindFlayer
       //-----------------------------------------------------------------------
        case 679: nPoly = POLYMORPH_TYPE_MEDUSA;  sNombre = "Medusa"; break;
        case 691: nPoly = 68; break; sNombre = "Azotamentes"; // Mindflayer
        case 694: nPoly = 69; break; sNombre = "Tigre Terrible";// DireTiger


       //-----------------------------------------------------------------------
       // Humanoid Shape - Kobold Commando, Drow, Lizard Crossbow Specialist
       //-----------------------------------------------------------------------
       case 682:
                 if(nShifter< 17)
                 {
                     if (GetGender(OBJECT_SELF) == GENDER_MALE) //drow
                         nPoly = 59;
                     else
                         nPoly = 70;

                 }
                 else
                 {
                     if (GetGender(OBJECT_SELF) == GENDER_MALE) //drow
                         nPoly = 105;
                     else
                         nPoly = 106;
                 }
                 sNombre = "Drow";
                 break;
       case 683:
                 if(nShifter< 17)
                 {
                    sNombre = "Lagarto";
                    nPoly = 82; break; // Lizard

                 }
                 else
                 {
                    sNombre = "Lagarto";
                    nPoly =104; break; // Epic Lizard
                 }

       case 684: if(nShifter< 17)
                 {
                    sNombre = "Kobold";
                    nPoly = 83; break; // Kobold Commando
                 }
                 else
                 {
                    sNombre = "Kobold";
                    nPoly = 103; break; // Kobold Commando
                 }

       //-----------------------------------------------------------------------
       // Undead Shape - Spectre, Risen Lord, Vampire
       //-----------------------------------------------------------------------
       case 704: nPoly = 75; sNombre = "Aparicion"; break; // Risen lord

       case 705: if (GetGender(OBJECT_SELF) == GENDER_MALE) // vampire
                    {
                     nPoly = 74;
                     sNombre = "Vampiro";
                    }
                  else
                    {
                     nPoly = 77;
                     sNombre = "Vampira";
                    }
                 break;

       case 706: nPoly = 76; sNombre = "Espectro"; break; /// spectre

       //-----------------------------------------------------------------------
       // Dragon Shape - Red Blue and Green Dragons
       //-----------------------------------------------------------------------
       case 707: nPoly = 128; sNombre = "Dragon Rojo Anciano";break; // Ancient Red   Dragon
       case 708: nPoly = 129; sNombre = "Dragon Azul Anciano";break; // Ancient Blue  Dragon
       case 709: nPoly = 130; sNombre = "Dragon Verde Anciano";break; // Ancient Green Dragon


       //-----------------------------------------------------------------------
       // Outsider Shape - Rakshasa, Azer Chieftain, Black Slaad
       //-----------------------------------------------------------------------
       case 733:   if (GetGender(OBJECT_SELF) == GENDER_MALE) //azer
                      nPoly = 85;
                    else { // anything else is female
                      nPoly = 86; }
                      sNombre = "Azer";
                    break;

       case 734:   if (GetGender(OBJECT_SELF) == GENDER_MALE) //rakshasa
                      nPoly = 88;
                    else { // anything else is female
                      nPoly = 89; }
                      sNombre = "Rakshasa";
                    break;

       case 735: nPoly =87; sNombre = "Slaad"; break; // slaad

       //-----------------------------------------------------------------------
       // Construct Shape - Stone Golem, Iron Golem, Demonflesh Golem
       //-----------------------------------------------------------------------
       case 738: nPoly =91; sNombre = "Golem de Piedra"; break; // stone golem
       case 739: nPoly =92; sNombre = "Golem de Carne"; break; // demonflesh golem
       case 740: nPoly =90; sNombre = "Golem de Hierro"; break; // iron golem

    }


    //--------------------------------------------------------------------------
    // Determine which items get their item properties merged onto the shifters
    // new form.
    //--------------------------------------------------------------------------
    int bWeapon = ShifterMergeWeapon(nPoly);
    int bArmor  = ShifterMergeArmor(nPoly);
    int bItems  = ShifterMergeItems(nPoly);

    //--------------------------------------------------------------------------
    // Store the old objects so we can access them after the character has
    // changed into his new form
    //--------------------------------------------------------------------------
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);

    if (GetIsObjectValid(oShield))
    {
        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }


    //--------------------------------------------------------------------------
    // Here the actual polymorphing is done
    //--------------------------------------------------------------------------
    ePoly = EffectPolymorph(nPoly);
    ePoly = ExtraordinaryEffect(ePoly);
    string sNombreReal = GetName(OBJECT_SELF, TRUE);
    string sNombreFalso = PB_Disguise_GetNameOverride(OBJECT_SELF);
    PB_Disguise_SetNameOverride(OBJECT_SELF, sNombre, NWNX_RENAME_PLAYERNAME_OVERRIDE);
    WriteTimestampedLogEntry("Informe: El PJ: " + sNombreReal + " de la cuenta: "  + GetPCPlayerName(OBJECT_SELF) + " se ha transformado en : " + sNombreFalso + ".");
    SetLocalInt(OBJECT_SELF, "POLY_ON", 1);
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //--------------------------------------------------------------------------
    // This code handles the merging of item properties
    //--------------------------------------------------------------------------
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);


    //identify weapon
    SetIdentified(oWeaponNew, TRUE);

    //--------------------------------------------------------------------------
    // ...Weapons
    //--------------------------------------------------------------------------
    if (bWeapon)
    {
        //----------------------------------------------------------------------
        // GZ: 2003-10-20
        // Sorry, but I was forced to take that out, it was confusing people
        // and there were problems with updating the stats sheet.
        //----------------------------------------------------------------------
        /* if (!GetIsObjectValid(oWeaponOld))
        {
            //------------------------------------------------------------------
            // If we had no weapon equipped before, remove the old weapon
            // to allow monks to change into unarmed forms by not equipping any
            // weapon before polymorphing
            //------------------------------------------------------------------
            DestroyObject(oWeaponNew);
        }
        else*/
        {
            //------------------------------------------------------------------
            // Merge item properties...
            //------------------------------------------------------------------

            //GoLoT: Fix para merge de armas en formas que usan garra
            if(oWeaponNew == OBJECT_INVALID) {
                oWeaponNew = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,OBJECT_SELF);
                if(oWeaponNew != OBJECT_INVALID)
                    IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
                oWeaponNew = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,OBJECT_SELF);
                if(oWeaponNew != OBJECT_INVALID)
                    IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
                oWeaponNew = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,OBJECT_SELF);
                if(oWeaponNew != OBJECT_INVALID)
                    IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
            } else
                IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
        }
    }

    //--------------------------------------------------------------------------
    // ...Armor
    //--------------------------------------------------------------------------
    if (bArmor)
    {
        //----------------------------------------------------------------------
        // Merge item properties from armor and helmet...
        //----------------------------------------------------------------------
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
    }

    //--------------------------------------------------------------------------
    // ...Magic Items
    //--------------------------------------------------------------------------
    if (bItems)
    {
        //----------------------------------------------------------------------
        // Merge item properties from from rings, amulets, cloak, boots, belt
        //----------------------------------------------------------------------
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }

    //--------------------------------------------------------------------------
    // Set artificial usage limits for special ability spells to work around
    // the engine limitation of not being able to set a number of uses for
    // spells in the polymorph radial
    //--------------------------------------------------------------------------
    ShifterSetGWildshapeSpellLimits(nSpell);

    /*if(nSpell == 707 && nSpell == 708 && nSpell == 709) {
        //IPRemoveMatchingItemProperties(oArmorNew, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_6, IP_CONST_DAMAGESOAK_40_HP), DURATION_TYPE_PERMANENT);
        RemoveItemProperty(oArmorNew, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_6, IP_CONST_DAMAGESOAK_10_HP));
        IPSafeAddItemProperty(oArmorNew, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_6, IP_CONST_DAMAGESOAK_10_HP), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
    } */

}
