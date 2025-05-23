#include "f_vampire_spls_h"
void main()
{
    object oPC = GetLastUsedBy();
    object oDestino = GetWaypointByTag("asy_casavampira");
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    int iRestriccion1 = GetLocalInt (OBJECT_SELF, "SIGHUL");
    effect eEfecto = EffectBeam(VFX_BEAM_EVIL,OBJECT_SELF,BODY_NODE_CHEST,FALSE);

    if ((GetIsVampire(oPC)==TRUE)||((GetItemPossessedBy(oPC, "asy_emblemavamp") != OBJECT_INVALID))||((sSubraza == "necropolita")||(sSubraza == "deathknight")||(sSubraza == "ghul") ||(sSubraza == "liche") && (iRestriccion1 != 0)))
    {
      SendMessageToPC(oPC, "<c  ó>*El pulido cristal se vuelve poco a poco líquido, atrayendote hacia él*</c>");
      ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEfecto,oPC,7.0));
      DelayCommand(9.0, AssignCommand(oPC, JumpToObject(oDestino)));
      DelayCommand(9.0, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
    }
    else
    {
        SendMessageToPC(oPC, "<c  ó>*El espejo devuelve tu reflejo.*</c>");
    }
}
