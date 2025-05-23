////////////////////////////////////////////////////////////////////////////////
//  EQUIPARSE ARMADURAS: penalizacion de movimiento y espera                  //
////////////////////////////////////////////////////////////////////////////////

#include "NW_I0_GENERIC"
#include "mti_libreria"
#include "x2_inc_itemprop"
#include "pb_constantes"
#include "lib_race"

void main()
{
  object oPC = GetPCItemLastEquippedBy();
  object oArmadura = GetPCItemLastEquipped();
  int iEntrenamiento1 = ObtenerIntPersistente(oPC, "ENTRENAMIENTOGU1");
  int iEntrenamiento2 = ObtenerIntPersistente(oPC, "ENTRENAMIENTOGU2");
  int iTipoArmadura = GetArmorType(oArmadura);
  int iAsaltos, iPorcentageReduccion, iBardos;
  GuardarIntPersistente(oPC, "bReduccion_Vel",1);
  string sArmadura;

  // Sin Armadura
  if(iTipoArmadura == 0)
  {
      if(InvisibleTrue(oPC) == FALSE)
      {
          AssignCommand(oPC, ActionSpeakString("<c!}þ>*Equipando ropas*</c>"));
      }

      return;
  }

  // Armadura ligera
  else if(iTipoArmadura <= 3)
  {
      iAsaltos = 1;
      iPorcentageReduccion = 5;
      sArmadura = "ligera";

      if(iTipoArmadura == 1)      iBardos = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;
      else if(iTipoArmadura == 2) iBardos = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;
      else if(iTipoArmadura == 3) iBardos = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
  }

  // Armadura intermedia
  else if(iTipoArmadura <= 5)
  {
      iAsaltos = 2 - iEntrenamiento1;
      iPorcentageReduccion = 10 - iEntrenamiento2;
      sArmadura = "intermedia";

     iBardos = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
  }

  // Armadura pesada
  else // if(iTipoArmadura <= 8)
  {
      // Licantropos en forma animal no se equipan pesadas
      if(ObtenerIntPersistente(oPC, "ESTADOLICANTROPIA") == 2) return;

      iAsaltos = 3 - iEntrenamiento1;
      iPorcentageReduccion = 20 - iEntrenamiento2;
      sArmadura = "pesada";
      iBardos = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
  }

  //Apartado del Ingeniero
  if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) > 0)
  {
     if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 2){iBardos = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;}
     if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 1){iBardos = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;}
  }

  // BARDOS  BRUJOS Y MDL NO TIENEN FALLO DE CONJURO ARCANO EN ARMADURAS LIGERAS
  if(GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 || GetLevelByClass(57, oPC) > 0 || GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) > 0)
  {
      GuardarIntPersistente(oPC, "bReduccion_Vel",0);
      //if(iTipoArmadura >= 1 && iTipoArmadura <= 3)
      IPSafeAddItemProperty(oArmadura, ItemPropertyArcaneSpellFailure(iBardos), 9999999.9, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE);
  }

  // Efectos
  ReaplicarEfectosPB(oPC,TRUE);
  AssignCommand(oPC, ActionSpeakString("<c!}þ>*Equipando armadura*</c>"));

  if(GetRacialType(oPC) == RACIAL_TYPE_DUERGAR || PB_Race_GetIsDwarf(oPC)) iPorcentageReduccion = 0;

  float fAsaltos = RoundsToSeconds(iAsaltos);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, fAsaltos);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PARALYZED), oPC, fAsaltos);
  AssignCommand(oPC, DelayCommand(2.0, ActionDoCommand(ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, fAsaltos-2.0))));
  SendMessageToPC(oPC,"<cÍþ>Equipar esta armadura te llevará " + IntToString(iAsaltos) + " asaltos</c>");
  DelayCommand(fAsaltos, SendMessageToPC(oPC,"<c´þd>Equipada armadura " + sArmadura + ".</c>"));
  DelayCommand(fAsaltos, SendMessageToPC(oPC,"<cþ>Tu velocidad de movimiento ha disminuido en un: <cþ>" + IntToString(iPorcentageReduccion) + "%</c></c>"));

}
