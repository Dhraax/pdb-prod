//::///////////////////////////////////////////////
//:: MAGNIFICA MANSION DE MORDENKAINEN
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Magnifica mansion de Mordenkainen.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "pb_nivellanzador"

void Sebedestrukce()
{
  object oSelf = OBJECT_SELF;
  object oArea = GetObjectByTag("sl_mmm"+IntToString(GetLocalInt(oSelf, "MMM"))+"_area");
  object oPC = GetFirstPC();
  while(GetIsObjectValid(oPC))
  {
      if(GetArea(oPC) == oArea)
      {
          location lMMM = GetLocalLocation(oPC, "MMM");
          DeleteLocalLocation(oPC, "MMM");
          AssignCommand(oPC, ClearAllActions());
          AssignCommand(oPC, DelayCommand(0.1, JumpToLocation(lMMM)));
      }

      oPC = GetNextPC();
  }

  DeleteLocalInt(GetLocalObject(oSelf, "CASTER"), "MMM");
  DeleteLocalInt(oArea, "OBSAZENO");
  DestroyObject(oSelf, 0.1);
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  object oCaster = OBJECT_SELF;
  if(GetLocalInt(GetArea(oCaster), "DISABLE_MMM") ||
     GetLocalInt(GetArea(oCaster), "NOTELEPORT"))
  {
      FloatingTextStringOnCreature("<cþ<<>Una gran fuerza te impide usar este conjuro aquí.</c>", oCaster);
      return;
  }

  //Modificación 29/09/2024: Ahora la mansión no permite su uso en interiores (áreas seteadas en su propiedades como interior).
  if(GetIsAreaInterior(GetArea(oCaster)))
  {
      FloatingTextStringOnCreature("<cþ<<>No puedes lanzar este conjuro en interiores.</c>", oCaster);
      return;
  }
  int iNivelLanzador = GetTotalCasterLevel(oCaster);
  int nDuration = iNivelLanzador; // * Duracion 1 hora / nivel
  int nZnicitCislo = GetLocalInt(oCaster, "MMM");
  if(nZnicitCislo)
  {
      object oZnicitArea = GetObjectByTag("sl_mmm"+IntToString(nZnicitCislo)+"_area");
      object oPC = GetFirstPC();
      while(GetIsObjectValid(oPC))
      {
          if(GetArea(oPC) == oZnicitArea)
          {
              location lMMM = GetLocalLocation(oPC, "MMM");
              DeleteLocalLocation(oPC, "MMM");
              AssignCommand(oPC, ClearAllActions());
              AssignCommand(oPC, DelayCommand(0.1, JumpToLocation(lMMM)));
          }

          oPC = GetNextPC();
      }

      DeleteLocalInt(oCaster, "MMM");
      DeleteLocalInt(oZnicitArea, "OBSAZENO");
      DestroyObject(GetObjectByTag("sl_mmm"+IntToString(nZnicitCislo)));
  }

  int nCislo = -1;
  if(!GetLocalInt(GetObjectByTag("sl_mmm1_area"), "OBSAZENO")){nCislo = 1;}
  else if(!GetLocalInt(GetObjectByTag("sl_mmm2_area"), "OBSAZENO")){nCislo = 2;}
  else if(!GetLocalInt(GetObjectByTag("sl_mmm3_area"), "OBSAZENO")){nCislo = 3;}
  else if(!GetLocalInt(GetObjectByTag("sl_mmm4_area"), "OBSAZENO")){nCislo = 4;}
  else if(!GetLocalInt(GetObjectByTag("sl_mmm5_area"), "OBSAZENO")){nCislo = 5;}
  else
  {
      FloatingTextStringOnCreature("<cþ<<>Lo sentimos pero las 5 mansiones que tiene habilitado el servidor están ocupadas. Inténtalo más tarde.</c>", oCaster);
      return;
  }

  string sCislo = IntToString(nCislo);
  object oArea = GetObjectByTag("sl_mmm"+sCislo+"_area");
  SetLocalInt(oArea, "OBSAZENO", 1);

  location lTarget = GetSpellTargetLocation();
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lTarget);
  lTarget = Location(GetArea(oCaster), GetPositionFromLocation(lTarget) + Vector(0.0, 0.0, -0.5), GetFacingFromLocation(lTarget));

  object oMMM = CreateObject(OBJECT_TYPE_PLACEABLE, "sl_mmm", lTarget, TRUE, "sl_mmm"+sCislo);
  SetLocalObject(oMMM, "CASTER", oCaster);
  AssignCommand(oMMM, DelayCommand(HoursToSeconds(nDuration), Sebedestrukce()));
  SetLocalInt(oMMM, "MMM", nCislo);
  SetLocalInt(oCaster, "MMM", nCislo);

  AssignCommand(GetModule(), ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE), oMMM));
  AssignCommand(GetModule(), ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_PURPLE_20), oMMM));
  SignalEvent(GetArea(oCaster), EventSpellCastAt(oCaster, GetSpellId(), FALSE));
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
