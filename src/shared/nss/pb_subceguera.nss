//::///////////////////////////////////////////////
//:: EFECTOS DE CEGUERA ANTIPODA OSCURA
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Regula los efectos de la ceguera de las subrazas de la Antipoda OScura
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 27/03/2012
//:://////////////////////////////////////////////

#include "mti_libreria"

void main()
{
  object oPC = OBJECT_SELF;
  object oArea = GetArea(oPC);

  if(oArea == OBJECT_INVALID) return;

  int iHora = GetTimeHour();
  int iDrowSuperficie = ObtenerIntPersistente(oPC, "DROWSUPERFICIE");
  int iSemidrowSuperficie = ObtenerIntPersistente(oPC, "SEMIDROWSUPERFICIE");
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  effect eCeguera = ExtraordinaryEffect(EffectBlindness());
  effect eMenosUnoAtaque = SupernaturalEffect(EffectAttackDecrease(1));
  effect eMenosUnoHabilidades = SupernaturalEffect(EffectSkillDecrease(SKILL_ALL_SKILLS,1));
  effect eMenosUnoSalvaciones = SupernaturalEffect(EffectSavingThrowDecrease(SAVING_THROW_ALL,1));
  int iVariableCeguera = GetLocalInt(oPC, "CEGUERA_AO");

  if((sSubraza == "drow" && iDrowSuperficie == 0) ||
     (sSubraza == "semidrow" && iSemidrowSuperficie == 0) ||
      sSubraza == "duergar" || sSubraza == "svirfneblin" || sSubraza == "orog")
   {
       if(GetIsAreaInterior(oArea) != TRUE) // Si es una area de exterior
       {
           if(iHora >= 6 && iHora <= 18 && iVariableCeguera == 0) // Ceguera
           {
               SetLocalInt(oPC, "CEGUERA_AO", 1);
               DelayCommand(2.0, FloatingTextStringOnCreature("<cþ<<>* ¡La luz solar te ha cegado! *</c>", oPC, FALSE));
               ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMenosUnoAtaque, oPC);
               ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMenosUnoHabilidades, oPC);
               ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMenosUnoSalvaciones, oPC);
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCeguera, oPC, 30.0);
           }
           else if((iHora <= 5 || iHora >= 19) && iVariableCeguera == 1) // Se cura la ceguera si la tenemos
           {
               DeleteLocalInt(oPC, "CEGUERA_AO");
               ReaplicarEfectosPB(oPC,TRUE);
           }
       }
       else if(GetLocalInt(oPC, "CEGUERA_AO")) // Si estamos en un area de interior se cura la ceguera si la tenemos
       {
           DeleteLocalInt(oPC, "CEGUERA_AO");
           ReaplicarEfectosPB(oPC,TRUE);
       }
   }
}
