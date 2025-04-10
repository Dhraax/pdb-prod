//::///////////////////////////////////////////////
//:: DOTE COMBATE CON DOS ARMAS MAYOR
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Combate con dos armas Mayor.
*/
//:://////////////////////////////////////////////
//:: Created By: Jose-G-C
//:: Created On: 15 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
   object oPC = OBJECT_SELF;

  // Desactivacion del modo
  if(GetHasSpellEffect(982))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Combate con dos armas mayor desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 982);
      return;
  }

   effect atAdicional = EffectModifyAttacks(1);
   atAdicional = ExtraordinaryEffect(atAdicional);

    //Revisa primero si se lleva un arma doble de las siguientes:
    int nApply = FALSE;
    int nArma = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
    if(nArma == BASE_ITEM_TWOBLADEDSWORD ||     //Espada de doble hoja
    nArma == BASE_ITEM_DIREMACE ||              //Maza doble
    nArma == BASE_ITEM_DOUBLEAXE ||             //Hacha doble
    nArma == 321 &&                             //Cimitarra doble
    nArma != BASE_ITEM_QUARTERSTAFF             //Bastón
    ){
        nApply = TRUE;
    }
    //Revisa que lleve un arma equipada en la mano torpe:
    if(IPGetIsMeleeWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))){
        nApply = TRUE;
    }

    //Si se cumple cualquiera de las dos condiciones se aplica la dote.
    if(nApply){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, atAdicional, oPC);
        FloatingTextStringOnCreature("<c´þd>* Combate con dos armas mayor activado *</c>", OBJECT_SELF, FALSE);
    } else {
        FloatingTextStringOnCreature("<cþ<<>* Debes tener dos armas cuerpo a cuerpo equipadas *</c>", OBJECT_SELF, FALSE);
    }
}
