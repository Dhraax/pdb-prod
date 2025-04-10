#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "mti_libreria"
#include "x0_i0_spells"
#include "lib_disguise"

void main()
{
  object oPC = OBJECT_SELF;

  // No en el mar
  string sNombreArea = GetName(GetArea(OBJECT_SELF));
  if(sNombreArea == "Mar de las Espadas"|| sNombreArea == "Mar Impenetrable")
  {
      FloatingTextStringOnCreature("<cþ<<>¡No puedes transformar tu barco!</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No polimorfado
  if(GetHasEffect(EFFECT_TYPE_POLYMORPH) || ObtenerIntPersistente(oPC,"POLYMORPHED"))
  {
      FloatingTextStringOnCreature("<cþ<<>* Esta aptitud no se puede activar polimorfado *</c>", OBJECT_SELF, FALSE);
      return;
  }
  if(ObtenerIntPersistente(oPC, "APA_CAMBIADA") == TRUE)
  {
      SendMessageToPC(oPC, "<cþ>Despolimórfate antes de usar esta habilidad / conjuro.</c>");
      return;
  }

  // No funciona montado en montura
  if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
  {
      FloatingTextStringOnCreature("<cþ<<>* Esta aptitud no se puede activar montado en montura *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Declaraciones
  int iPoly;
  string sNombre;
  int iForma = GetLocalInt(oPC, "FORMAESCOGIDA");
  DeleteLocalInt(oPC, "FORMAESCOGIDA");

  // Elegir polimorfacion
  // Forma Salvaje Mayor I
  if(iForma >= 1 && iForma <= 15)
  {
      if(GetHasFeat(FEAT_GREATER_WILDSHAPE_1) == TRUE)
      {
          DecrementRemainingFeatUses(oPC,FEAT_GREATER_WILDSHAPE_1);
      }
      else
      {
          SendMessageToPC(oPC, "<cþ>¡Debes tener usos de Forma Salvaje Mayor I para polimorfarte!</c>");
          return;
      }

      // Formas nivel 1
      if(iForma == 1) { iPoly = POLYMORPH_TYPE_GIANT_SPIDER;  sNombre = "Araña Gigante"; }        //Forma de Araña Gigante
      else if(iForma == 2) {iPoly = POLYMORPH_TYPE_CHICKEN; sNombre = "Pollo"; }          //Forma de Pollo
      else if(iForma == 3) {iPoly = POLYMORPH_TYPE_COW;    sNombre = "Vaca"; }           //Forma de Vaca
      else if(iForma == 4) {iPoly = POLYMORPH_TYPE_PENGUIN; sNombre = "Pinguino"; }          //Forma de Pinguino
      else if(iForma == 5){ iPoly = 80;  sNombre = "Chico"; }                             //Forma de Chico
      else if(iForma == 6){ iPoly = 81;  sNombre = "Chica"; }                            //Forma de Chica
      // Formas nivel 2
      else if(iForma == 7){ iPoly = POLYMORPH_TYPE_IMP;   sNombre = "Diablillo"; }            //Forma de Diablillo
      else if(iForma == 8) {iPoly = POLYMORPH_TYPE_WERECAT; sNombre = "Hombre-Gato"; }          //Forma de Hombre-gato
      else if(iForma == 9) {iPoly = POLYMORPH_TYPE_WEREWOLF;  sNombre = "Hombre-Lobo"; }        //Forma de Hombre-lobo
      else if(iForma == 10){ iPoly = POLYMORPH_TYPE_WERERAT;  sNombre = "Hombre-Rata"; }        //Forma de Hombre-rata
      else if(iForma == 11){ iPoly = POLYMORPH_TYPE_PIXIE; sNombre = "Pixi"; }           //Forma de Pixi
      else if(iForma == 12){ iPoly = POLYMORPH_TYPE_QUASIT;  sNombre = "Quasit"; }         //Forma de Quasit
      else if(iForma == 13) {iPoly = POLYMORPH_TYPE_ZOMBIE; sNombre = "Zombi"; }         //Forma de Zombi
      else if(iForma == 14) {iPoly = 102; sNombre = "Lobo Invernal"; }                            //Forma de Lobo invernal
      else if(iForma == 15) {iPoly = 84;    sNombre = "Fuego Fauto"; }                          //Forma de Fuego fatuo
  }

  // Forma Salvaje Mayor II
  else if(iForma >= 16 && iForma <= 24)
  {
      if(GetHasFeat(FEAT_GREATER_WILDSHAPE_2) == TRUE)
      {
          DecrementRemainingFeatUses(oPC,FEAT_GREATER_WILDSHAPE_2);
      }
      else
      {
          SendMessageToPC(oPC, "<cþ>¡Debes tener usos de Forma Salvaje Mayor II para polimorfarte!</c>");
          return;
      }

      // Formas nivel 4
      if(iForma == 16){ iPoly = POLYMORPH_TYPE_DIRE_BOAR;  sNombre = "Jabali Terrible"; }      //Forma de Jabali Terrible
      else if(iForma == 17) {iPoly = POLYMORPH_TYPE_DIRE_WOLF;  sNombre = "Lobo Terrible"; }      //Forma de Lobo Terrible
      else if(iForma == 18) {iPoly = POLYMORPH_TYPE_UMBER_HULK;  sNombre = "Mole Sombria"; }     //Forma de Mole Sombría
      else if(iForma == 19) {iPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;sNombre = "Oso Pardo Terrible"; }  //Forma de Oso Pardo Terrible
      else if(iForma == 20) {iPoly = POLYMORPH_TYPE_DIRE_PANTHER;sNombre = "Pantera Terrible"; }     //Forma de Pantera Terrible
      else if(iForma == 21){ iPoly = POLYMORPH_TYPE_DIRE_BADGER; sNombre = "Tejon Terrible"; }     //Forma de Tejon Terrible
      else if(iForma == 22){ iPoly = POLYMORPH_TYPE_TROLL;  sNombre = "Troll"; }          //Forma de Troll
      else if(iForma == 23){ iPoly = 79;  sNombre = "Mimico"; }                            //Forma de Mimico
      else if(iForma == 24) {iPoly = 51;  sNombre = "Draconido"; }                            //Forma de Draconido
  }

  // Forma Salvaje Mayor III
  else if(iForma >= 25 && iForma <= 34)
  {
      if(GetHasFeat(FEAT_GREATER_WILDSHAPE_3) == TRUE)
      {
          DecrementRemainingFeatUses(oPC,FEAT_GREATER_WILDSHAPE_3);
      }
      else
      {
          SendMessageToPC(oPC, "<cþ>¡Debes tener usos de Forma Salvaje Mayor III para polimorfarte!</c>");
          return;
      }

      // Formas nivel 6
      if(iForma == 25) {iPoly = POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL;  sNombre = "Elemental de Agua Mayor"; } //Forma de Elemental de Agua Mayor
      else if(iForma == 26) {iPoly = POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL;  sNombre = "Elemental de Aire Mayor"; }   //Forma de Elemental de Aire Mayor
      else if(iForma == 27) {iPoly = POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL;  sNombre = "Elemental de Fuego Mayor"; }  //Forma de Elemental de Fuego Mayor
      else if(iForma == 28) {iPoly = POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL; sNombre = "Elemental de Tierra Mayor"; }  //Forma de Elemental de Tierra Mayor
      else if(iForma == 29) {iPoly = POLYMORPH_TYPE_BEHOLDER;   sNombre = "Contemplador"; }      //Forma de Contemplador
      else if(iForma == 30) {iPoly = POLYMORPH_TYPE_SUCCUBUS;  sNombre = "Sucubo"; }       //Forma de sucubo
      else if(iForma == 31) {iPoly = POLYMORPH_TYPE_YUANTI;   sNombre = "Yuanti"; }        //Forma de Yuanti
      else if(iForma == 32){ iPoly = POLYMORPH_TYPE_FIRE_GIANT;  sNombre = "Gigante de Fuego"; }     //Forma de Gigante de Fuego
      else if(iForma == 33) {iPoly = POLYMORPH_TYPE_FROST_GIANT_MALE; sNombre = "Gigante de Hielo"; }//Forma de Gigante de Hielo
      else if(iForma == 34){ iPoly = POLYMORPH_TYPE_VROCK;   sNombre = "Vrock"; }         //Forma de Vrock
  }

  // Forma Humanoide
  else if(iForma >= 35 && iForma <= 43)
  {
      if(GetHasFeat(FEAT_HUMANOID_SHAPE) == TRUE)
      {
          DecrementRemainingFeatUses(oPC,FEAT_HUMANOID_SHAPE);
      }
      else
      {
          SendMessageToPC(oPC, "<cþ>¡Debes tener usos de Forma Humanoide para polimorfarte!</c>");
          return;
      }

      // Formas nivel 8
      if(iForma == 35) {iPoly = POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL;  sNombre = "Elemental de Agua Anciano"; }//Forma de Elemental de Agua Anciano
      else if(iForma == 36) {iPoly = POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL;   sNombre = "Elemental de Aire Anciano"; } //Forma de Elemental de Aire Anciano
      else if(iForma == 37) {iPoly = POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL;  sNombre = "Elemental de Fuego Anciano"; } //Forma de Elemental de Fuego Anciano
      else if(iForma == 38) {iPoly = POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL; sNombre = "Elemental de Tierra Anciano"; } //Forma de Elemental de Tierra Anciano
      else if(iForma == 39) {iPoly = POLYMORPH_TYPE_DOOM_KNIGHT;   sNombre = "Caballero Condenado"; }    //Forma de Caballero Condenado
      else if(iForma == 40) {iPoly = POLYMORPH_TYPE_CELESTIAL_AVENGER; sNombre = "Vengador Celestial"; }//Forma de Vengador Celestial
      else if(iForma == 41) {iPoly = 91;   sNombre = "Golem de piedra"; }                            //Forma de Golem de piedra
      else if(iForma == 42) {iPoly = 90;  sNombre = "Golem de hierro"; }                             //Forma de Golem de hierro
      else if(iForma == 43){ iPoly = 92;    sNombre = "Golem de carne"; }                           //Forma de Golem de carne
  }

  // Forma Salvaje Mayor IV
  else if(iForma >= 44 && iForma <= 53)
  {
      if(GetHasFeat(FEAT_GREATER_WILDSHAPE_4) == TRUE)
      {
          DecrementRemainingFeatUses(oPC,FEAT_GREATER_WILDSHAPE_4);
      }
      else
      {
          SendMessageToPC(oPC, "<cþ>¡Debes tener usos de Forma Salvaje Mayor IV para polimorfarte!</c>");
          return;
      }

      // Formas nivel 10
      if(iForma == 44){ iPoly = 128;    sNombre = "Dragon Rojo"; }                           //Forma de Dragon Rojo anciano  72
      else if(iForma == 45) {iPoly = 129;   sNombre = "Dragon Azul"; }                            //Forma de Dragon Azul anciano 71
      else if(iForma == 46) {iPoly = 130;    sNombre = "Dragon Verde"; }                           //Forma de Dragon Verde anciano 73
      else if(iForma == 47){ iPoly = POLYMORPH_TYPE_BALOR;     sNombre = "Balor"; }        //Forma de Balor
      else if(iForma == 48){ iPoly = 76;   sNombre = "Espectro"; }                           //Forma de Espectro
      else if(iForma == 49){ iPoly = 74;   sNombre = "Vampiro"; }                           //Forma de Vampiro
      else if(iForma == 50) {iPoly = 75;  sNombre = "Caballero resucitado"; }                            //Forma de Caballero resucitado
      else if(iForma == 51) {iPoly = 87;  sNombre = "Slaad negro"; }                            //Forma de Slaad negro
      else if(iForma == 52) {iPoly = 88;   sNombre = "Rakshasa"; }                           //Forma de Rakshasa
      else if(iForma == 53){ iPoly = 85;   sNombre = "Cacique Azer"; }                           //Forma de CaciqueAzer
  }

    //--------------------------------------------------------------------------
    // Determine which items get their item properties merged onto the shifters
    // new form.
    //--------------------------------------------------------------------------
    int bWeapon = ShifterMergeWeapon(iPoly);
    int bArmor  = ShifterMergeArmor(iPoly);
    int bItems  = ShifterMergeItems(iPoly);

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
    string sNombreReal = GetName(OBJECT_SELF, TRUE);
    string sNombreFalso = PB_Disguise_GetNameOverride(OBJECT_SELF);
       effect ePoly;
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    ePoly = EffectPolymorph(iPoly);
    ePoly = ExtraordinaryEffect(ePoly);
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF);
    PB_Disguise_SetNameOverride(OBJECT_SELF, sNombre, NWNX_RENAME_PLAYERNAME_OVERRIDE);
       WriteTimestampedLogEntry("Informe: El PJ: " + sNombreReal + " de la cuenta: "  + GetPCPlayerName(oPC) + " se ha transformado en : " + sNombreFalso + ".");
       SetLocalInt(OBJECT_SELF, "POLY_ON", 1);

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
}
