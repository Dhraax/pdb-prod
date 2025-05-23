#include "nw_i0_spells"

void main()
{
    object oPercibido=GetLastPerceived();
    string sVar =  GetLocalString (OBJECT_SELF, "sVoz");
    if (GetTag(OBJECT_SELF)=="sute_bicho_alarma"){

       if(GetIsPC(oPercibido) && !GetIsDM(oPercibido) && !GetIsDMPossessed(oPercibido))
       {
          object oPC= GetLocalObject(OBJECT_SELF, "PCCREADOR");
          if (GetName(oPC)!=GetName(oPercibido)){
             SendMessageToPC(oPC, "<cxxþ>¡Intruso detectado! "+ GetName(oPercibido)+ " ha cruzado la zona de alarma.</c>");
             ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1001, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), OBJECT_SELF);
             DestroyObject(OBJECT_SELF,GetRandomDelay());
          }
       }
    }

    ExecuteScript("nw_c2_default2", OBJECT_SELF);
    if (GetIsPC(oPercibido)==TRUE)
    {
         if (sVar!=GetName(oPercibido))
         {
            SendMessageToPC(oPercibido, "<cþ<<>¡Os prevengo! La senda que pretendéis iniciar sólo os llevará hasta el lugar de vuestro destino, mas la vuelta dependar de vuestra propia fortuna ¿Realmente deseáis abandonar la protección de estos muros?</c><cxxþ> *Dice una voz gutural que ignoras de donde proviene*.</c>");
            SetLocalString(OBJECT_SELF,"sVoz",GetName(oPercibido));
         }
    }


}
