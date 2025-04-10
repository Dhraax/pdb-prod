#include "f_vampire_h"
#include "f_vampirepenta_h"

location GetRandomCloseLocation(location lTarget, int iMetersAway = 5)
{ //perhaps make it determine a proper facing to look at the target location in the future.
object oArea = GetAreaFromLocation(lTarget);
vector V = GetPositionFromLocation(lTarget);
int xChange = (Random(3) * iMetersAway) - iMetersAway;
int yChange = (Random(3) * iMetersAway) - iMetersAway;
float fFacing = IntToFloat(Random(360));
while(xChange == 0 && yChange == 0 && iMetersAway != 0)
    {
    xChange = (Random(3) * iMetersAway) - iMetersAway;
    yChange = (Random(3) * iMetersAway) - iMetersAway;
    }
V.x += IntToFloat(xChange);
V.y += IntToFloat(yChange);
return Location(oArea, V, fFacing);
}

void RemoveAnyAOE()
{
effect eE = GetFirstEffect(OBJECT_SELF);
while(GetIsEffectValid(eE))
    {
    if(GetEffectType(eE) == EFFECT_TYPE_AREA_OF_EFFECT)
         RemoveEffect(OBJECT_SELF, eE);
    eE = GetNextEffect(OBJECT_SELF);
    }
}

void MakeComeBat(location lLoc)
{
  location lRand = GetRandomCloseLocation(lLoc, 5);
  effect eDisappear = EffectDisappear();
  effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
  object oBat = CreateObject(OBJECT_TYPE_CREATURE, "brainlessbat", lRand, TRUE);
  DelayCommand(2.0, AssignCommand(oBat, ActionForceMoveToLocation(lLoc, TRUE, 3.0)));
  DelayCommand(4.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF));
  DelayCommand(4.5, DestroyObject(oBat));
}

void LlegadaMurci(object oJugador)
{
  location lSelf = GetLocation(oJugador);
  effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
  MakeComeBat(lSelf);
  MakeComeBat(lSelf);
  MakeComeBat(lSelf);
  MakeComeBat(lSelf);
  DelayCommand(3.5, pentagram(GetLocation(oJugador), VFX_BEAM_EVIL, 2.5));
  DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oJugador));
  DelayCommand(6.5, Vampire_Apply_Stats(oJugador));
  DelayCommand(7.5, SetImmortal(oJugador, FALSE));
  DelayCommand(8.0, SetCommandable(TRUE, oJugador));
  DelayCommand(8.0, DeleteLocalInt(oJugador, "VUELO_VAMPIRO"));
}
void MurciSaltan(object oJugador, location lDestino)
{

  effect eInvis = SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
  SetCommandable(TRUE, OBJECT_SELF);
  ClearAllActions(TRUE);
  ActionJumpToLocation(lDestino);
  ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oJugador));
  ActionDoCommand(FadeFromBlack(oJugador, FADE_SPEED_FASTEST));
//ActionWait(1.0);
  ActionDoCommand(LlegadaMurci(oJugador));
  SetCommandable(FALSE, oJugador);
}

void MakeGoBat(location lLoc, location lTarget)
{
location lRand = GetRandomCloseLocation(lLoc, 1);
location lDest = GetRandomCloseLocation(lTarget, 5);
effect eVis = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
effect eGone = EffectDisappear();
object oBat = CreateObject(OBJECT_TYPE_CREATURE, "brainlessbat", lRand);

ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oBat);
AssignCommand(oBat, ActionMoveToLocation(lDest, FALSE));
DelayCommand(1.0, AssignCommand(oBat, ClearAllActions(TRUE)));
DelayCommand(1.0, AssignCommand(oBat, ActionMoveToLocation(lDest, FALSE)));
DelayCommand(2.0, AssignCommand(oBat, ClearAllActions(TRUE)));
DelayCommand(2.0, AssignCommand(oBat, ActionMoveToLocation(lDest, FALSE)));
DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGone, oBat));
}


void main()
{
  object oPC = GetPCSpeaker();
  location lSelf = GetLocation(oPC);
  location lDest = GetLocation(GetWaypointByTag("asy_bosqueimpio"));
  location lRand = GetRandomCloseLocation(lSelf, 20);
  SetLocalInt(oPC, "VUELO_VAMPIRO", TRUE);
  ClearAllActions(TRUE);
  DelayCommand(0.5, pentagram(GetLocation(oPC), VFX_BEAM_EVIL, 3.0));
  SetCommandable(FALSE, oPC);
  effect eInvis = SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
  effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
  if(GetAreaFromLocation(lSelf) == GetAreaFromLocation(lDest))
  {
    lRand = lDest;
  }
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
  RemoveAnyAOE();
  MakeGoBat(lSelf, lRand);
  MakeGoBat(lSelf, lRand);
  MakeGoBat(lSelf, lRand);
  MakeGoBat(lSelf, lRand);
  DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oPC));
  DelayCommand(6.0, FadeToBlack(oPC, FADE_SPEED_FASTEST));
  DelayCommand(6.5, MurciSaltan(oPC, lDest));
}



