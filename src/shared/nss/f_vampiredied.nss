#include "f_vampire_h"

location GetRandomCloseLocation(location lTarget, int iMetersAway = 5)
{ //perhaps make it determine a proper facing to look at the target location in the future.
object oArea = GetAreaFromLocation(lTarget);
vector V = GetPositionFromLocation(lTarget);
int xChange = (Random(3) * iMetersAway) - iMetersAway;
int yChange = (Random(3) * iMetersAway) - iMetersAway;
while(xChange == 0 && yChange == 0 && iMetersAway != 0)
    {
    xChange = (Random(3) * iMetersAway) - iMetersAway;
    yChange = (Random(3) * iMetersAway) - iMetersAway;
    }
V.x += IntToFloat(xChange);
V.y += IntToFloat(yChange);
return Location(oArea, V, GetFacingFromLocation(lTarget));
}

void SwitchToSleep()
{
SetPlotFlag(OBJECT_SELF, FALSE);
SetCommandable(TRUE, OBJECT_SELF);
ExecuteScript("f_vampirecoffin2", OBJECT_SELF);
}

void DeadJump(object oCoffin, int iBlackout)
{
location lSelf = GetLocation(OBJECT_SELF);
location lClose = GetRandomCloseLocation(lSelf, 5);
location lTarget = GetLocation(oCoffin);
SetCommandable(TRUE, OBJECT_SELF);
ActionForceMoveToLocation(lClose, TRUE, 5.0);
if(iBlackout)
    {
    ActionDoCommand(FadeToBlack(OBJECT_SELF, FADE_SPEED_FASTEST));
    ActionWait(0.5);
    }
ActionJumpToLocation(lTarget);
if(iBlackout)
    {
    ActionDoCommand(FadeFromBlack(OBJECT_SELF, FADE_SPEED_FASTEST));
    }
ActionWait(0.5);
ActionDoCommand(SwitchToSleep());
SetCommandable(FALSE, OBJECT_SELF);
}

void main()
{ //if you don't have a coffin somewhere or were killed as a mist then
  //your really dead  =(
object oCoffin = GetLocalObject(OBJECT_SELF, "FALLEN_VAMPIRE_COFFIN");
if(GetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_STAKED"))
    {
    DelayCommand(2.5, PopUpDeathGUIPanel(OBJECT_SELF, FALSE, TRUE, 0, "Has sido estacado y has muerto. Puedes cargar partida o esperar a un clérigo para revivirte."));
    return;
    }
if(GetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_MIST"))
    {
    DelayCommand(2.5, PopUpDeathGUIPanel(OBJECT_SELF, FALSE, TRUE, 0, "Has muerto y no tienes ningún ataúd en el cual restablecerte. Puedes cargar partida o o esperar a un clérigo para revivirte."));
    return;
    }
if(!GetIsObjectValid(oCoffin))
    {
    DelayCommand(2.5, PopUpDeathGUIPanel(OBJECT_SELF, FALSE, TRUE, 0, "Has muerto y no tiene ningún ataúd en el cual restablecerte. Puedes cargar partida o o esperar a un clérigo para revivirte."));
    return;
    }
if(GetIsDay())
    {
    object oCheck = GetFirstPC();
    oCheck = GetNextPC();
    if(GetIsObjectValid(oCheck))
        {
        DelayCommand(2.5, PopUpDeathGUIPanel(OBJECT_SELF, FALSE, TRUE, 0, "Has muerto. Ya que es de día en un ambiente multijugador tu cuerpo no puede convertirse en forma gaseosa y volver a tu ataúd ahora. Puede esperar hasta anochecer o esperar que un clérigo le restablezca."));
        return;
        }
    SendMessageToPC(OBJECT_SELF, "Tu cadáver mortal debe esperar hasta anochecer antes de regenerar.");
    SetTime(20, 0, 0, 0);
    }
SetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_MIST", TRUE);
SetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_DEAD", TRUE);
int myHD = GetHitDice(OBJECT_SELF);
int iBlackout = (GetArea(OBJECT_SELF) == GetArea(oCoffin));
effect eVis = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
effect eInvis = SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
effect eMist = SupernaturalEffect(EffectAreaOfEffect(MistAOEType, "f_vampiremist2", "f_vampiremist3", "****"));
Vampire_Remove_Stats(OBJECT_SELF);
SetCommandable(FALSE, OBJECT_SELF);
SetPlotFlag(OBJECT_SELF, TRUE);
DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(), OBJECT_SELF));
DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMist, OBJECT_SELF));
DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, OBJECT_SELF));
DelayCommand(4.0, DeadJump(oCoffin, iBlackout));
}
