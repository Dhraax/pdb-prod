//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////

#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "x0_i0_henchman"
#include "henchman_inv"

void main()
{
    object oKiller = GetLastKiller();
    object oMaster = GetMaster(OBJECT_SELF);
    object oLastMaster = GetLastMaster(OBJECT_SELF);
    effect eHeal = EffectResurrection();

    SetLootable(OBJECT_SELF, FALSE);

    // SISTEMA DE SEGURIDAD, POR SI LA CRIATURA SE MATA A SI MISMA
    if(oKiller == OBJECT_SELF) return;

    //Reanimar a los muertos
   if(GetResRef(OBJECT_SELF) == "animarmuerto" || GetResRef(OBJECT_SELF) == "animarmuerto2" || GetResRef(OBJECT_SELF) == "animarmuerto3" )
    {
      int nDG = GetLocalInt(oMaster, "UNDEADDG");
      int nNiveles = GetLocalInt(OBJECT_SELF, "NOMUERTO");

      //Restamos el valor del bicho muerto al control de Undeads.
      if(oMaster != OBJECT_INVALID)SetLocalInt(oMaster, "UNDEADDG", nDG - nNiveles);
      else SetLocalInt(GetLastMaster(OBJECT_SELF), "UNDEADDG", nDG - nNiveles);
    }

   //Si estamos en la area
    if(GetLocalInt(oMaster, "ARENA") > 0)
     {
      if(GetResRef(OBJECT_SELF) == "ow_sum_fght" ) { ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarOrcFght(oMaster); IncrementRemainingFeatUses(oMaster, 1380); }
      else if(GetResRef(OBJECT_SELF) == "ow_sum_barb" ){ ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarOrcBarb(oMaster); IncrementRemainingFeatUses(oMaster, 1381); }
      else if(GetResRef(OBJECT_SELF) == "ow_sum_sham" ){ ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarOrcSham(oMaster); IncrementRemainingFeatUses(oMaster, 1436); }
      else if(GetResRef(OBJECT_SELF) == "ow_sum_axe" ) { ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarOrcAxe(oMaster); IncrementRemainingFeatUses(oMaster, 1379); }
      else if(GetResRef(OBJECT_SELF) == "conj_ladsombras" ){ ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarLadron1(oMaster); IncrementRemainingFeatUses(oMaster, 1284); }
      else if(GetResRef(OBJECT_SELF) == "conj_ladsombras2" ){ ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarLadron2(oMaster); IncrementRemainingFeatUses(oMaster, 1289); }
      else if(GetResRef(OBJECT_SELF) == "conj_ladsombras3" ){ ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarLadron3(oMaster); IncrementRemainingFeatUses(oMaster, 1290); }
      else if(GetResRef(OBJECT_SELF) == "conj_lider" ){ ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarLiderazgo(oMaster); IncrementRemainingFeatUses(oMaster, 1550); }
      else if(GetResRef(OBJECT_SELF) == "conj_mdl" ){ ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarMDL(oMaster); IncrementRemainingFeatUses(oMaster, 1555); }

      //No drop items por seguridad
     object oItem = GetFirstItemInInventory(OBJECT_SELF);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(OBJECT_SELF);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)
     {
        oItem = GetItemInSlot(i, OBJECT_SELF);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
      DelayCommand(1.0, RemoveHenchman(oMaster, OBJECT_SELF));
      DelayCommand(1.0, SetIsDestroyable(TRUE,FALSE,FALSE));
      DelayCommand(2.0, DestroyObject(OBJECT_SELF));
      return;
     }


    //Guardamos la variable de muerte
   if(GetResRef(OBJECT_SELF) == "ow_sum_fght" ) { GuardarIntPersistente(oMaster, "FGHTMUERTO", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarOrcFght(oMaster); }
   else if(GetResRef(OBJECT_SELF) == "ow_sum_barb" ){ GuardarIntPersistente(oMaster, "BARBMUERTO", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarOrcBarb(oMaster); }
   else if(GetResRef(OBJECT_SELF) == "ow_sum_sham" ){ GuardarIntPersistente(oMaster, "SHAMMUERTO", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarOrcSham(oMaster); }
   else if(GetResRef(OBJECT_SELF) == "ow_sum_axe" ) { GuardarIntPersistente(oMaster, "AXEMUERTO", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarOrcAxe(oMaster); }
   else if(GetResRef(OBJECT_SELF) == "conj_ladsombras" ){ GuardarIntPersistente(oMaster, "LADMUERTO1", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarLadron1(oMaster); }
   else if(GetResRef(OBJECT_SELF) == "conj_ladsombras2" ){ GuardarIntPersistente(oMaster, "LADMUERTO2", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarLadron2(oMaster); }
   else if(GetResRef(OBJECT_SELF) == "conj_ladsombras3" ){ GuardarIntPersistente(oMaster, "LADMUERTO3", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarLadron3(oMaster); }
   else if(GetResRef(OBJECT_SELF) == "conj_lider" ){ GuardarIntPersistente(oMaster, "ALIADOMUERTO", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarLiderazgo(oMaster); }
   else if(GetResRef(OBJECT_SELF) == "conj_mdl" ){ GuardarIntPersistente(oMaster, "ALIADOMDL", 1); ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , OBJECT_SELF); GuardarMDL(oMaster); }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);


     //No drop items por seguridad
     object oItem = GetFirstItemInInventory(OBJECT_SELF);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(OBJECT_SELF);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)
     {
        oItem = GetItemInSlot(i, OBJECT_SELF);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }

    //Lo destruimos
    DelayCommand(0.5,ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_DEFENDER));
    DelayCommand(1.0, RemoveHenchman(oMaster, OBJECT_SELF));
    DelayCommand(1.0, SetIsDestroyable(TRUE,FALSE,FALSE));
    DelayCommand(3.0, DestroyObject(OBJECT_SELF));
}

