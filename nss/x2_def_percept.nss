//::///////////////////////////////////////////////
//:: Name x2_def_percept
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default On Perception script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

#include "nw_i0_spells"

void main()
{
    if (GetTag(OBJECT_SELF)=="sute_bicho_alarma"){
       object oPercibido=GetLastPerceived();
       if(GetIsPC(oPercibido) && !GetIsDM(oPercibido) && !GetIsDMPossessed(oPercibido) && (ObtenerIntPersistente(oPercibido,"INDETECTABLE") == 0))
       {
          object oPC= GetLocalObject(OBJECT_SELF, "PCCREADOR");
          if (GetName(oPC)!=GetName(oPercibido)){
             SendMessageToPC(oPC, "<cxxþ>¡Intruso detectado! Alguien ha cruzado la zona de alarma.</c>");
             ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1001, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), OBJECT_SELF);
             DestroyObject(OBJECT_SELF,GetRandomDelay());
          }
       }
    }
    ExecuteScript("nw_c2_default2", OBJECT_SELF);
}
