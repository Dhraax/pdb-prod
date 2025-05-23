//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons in the Area are frozen in time
    except the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "mti_libreria"
#include "pb_constantes"

const int iHench = FALSE; // Some people prefer to not affect henchmen.
const float fSize = -1.0f; // Some people don't want to effect whole area.
const int iClassic = FALSE; // Should the caster be able to damage timefrozen targets.

void ApplyTimestop(object oChar, float fTime)
{
    location lTarget = GetLocation(oChar);
    object oArea = GetArea(oChar);
    object oTarget;

    effect eParalyze = EffectCutsceneParalyze();
    effect eFreeze = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    eParalyze = EffectLinkEffects(eFreeze, eParalyze);

    if(fSize > 0.0)
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, lTarget);
    else
        oTarget = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oTarget) == TRUE)
    {
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
           GetHasSpellEffect(GetSpellId(), oTarget) == FALSE &&
           GetIsDM(oTarget) == FALSE)
        {
            if(oTarget != oChar ||
               (iHench == TRUE && oTarget != GetMaster(oChar)))
            {
                if(GetIsPC(oTarget) == TRUE)
                {
                    //FloatingTextStringOnCreature("*Tiempo detenido*", oTarget, FALSE);
                }
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, oTarget, fTime);
                if(iClassic == FALSE && GetPlotFlag(oTarget) == FALSE)
                {
                    SetPlotFlag(oTarget, TRUE);
                    AssignCommand(GetModule(), DelayCommand(fTime, SetPlotFlag(oTarget, FALSE)));
                }
            }
        }
        if(fSize > 0.0)
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, lTarget);
        else
            oTarget = GetNextObjectInArea(oArea);
    }
    if(fTime > 1.0f)
        DelayCommand(1.0f, ApplyTimestop(oChar, fTime - 1.0f));
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

  if(!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook
  object oItm = GetSpellCastItem();
  if(GetIsPC(OBJECT_SELF) == TRUE &&
     oItm == OBJECT_INVALID &&
     GetIsDM(OBJECT_SELF) == FALSE &&
     GetIsDMPossessed(OBJECT_SELF) == FALSE)
  {
      int nLastSpellCastClass = GetLastSpellCastClass();
      if(nLastSpellCastClass == CLASS_TYPE_CLERIC || nLastSpellCastClass == CLASS_TYPE_FAVORED_SOUL) // Clerigos...
      {
          string sFocoPersonalizado = ObtenerStringPersistente(OBJECT_SELF, "FOCODIVINO");

          object oYelmo = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
          object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
          object oCapa = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
          object oBrazales = GetItemInSlot(INVENTORY_SLOT_ARMS, OBJECT_SELF);
          object oCinto = GetItemInSlot(INVENTORY_SLOT_BELT, OBJECT_SELF);
          object oCollar = GetItemInSlot(INVENTORY_SLOT_NECK, OBJECT_SELF);
          object oAnilloI = GetItemInSlot(INVENTORY_SLOT_LEFTRING, OBJECT_SELF);
          object oAnilloD = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, OBJECT_SELF);
          object oReliquia = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);

          if(GetName(oYelmo) != sFocoPersonalizado &&
             GetName(oArmadura) != sFocoPersonalizado &&
             GetName(oCapa) != sFocoPersonalizado &&
             GetName(oBrazales) != sFocoPersonalizado &&
             GetName(oCinto) != sFocoPersonalizado &&
             GetName(oCollar) != sFocoPersonalizado &&
             GetName(oAnilloI) != sFocoPersonalizado &&
             GetName(oAnilloD) != sFocoPersonalizado &&
             GetName(oReliquia) != sFocoPersonalizado &&
             GetTag(oCollar) != "focodivino" &&
             GetTag(oReliquia) != "focodivino" &&
             GetTag(oCinto) != "focodivino")
          {
              SendMessageToPC(OBJECT_SELF,"¡Necesitas sujetar con fuerza un foco divino dotado de significado espiritual para lanzar este conjuro!");
              return;
          }

          else AssignCommand(OBJECT_SELF, ActionSpeakString("<c!}þ>*Te concentras unos instantes en tu foco divino para lanzar el conjuro*</c>"));
      }
      else// Hechieros y magos...
      {
          // Si tienes la dote Abstencion de materiales, no necesitas componentes
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes lanzar el conjuro sin necesitar ningún componente.</c>");
          else
          {
              if(GetItemPossessedBy(OBJECT_SELF, "reloj_ins")==OBJECT_INVALID)
              {
                  SendMessageToPC(OBJECT_SELF,"¡Necesitas un reloj inservible para lanzar el conjuro!");
                  return;
              }
              else
              {
                  object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"reloj_ins");
                  int iUsosIngrediente = GetLocalInt(oIngrediente, "USOS");

                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oIngrediente, "USOS", 4);
                      SendMessageToPC(OBJECT_SELF,"Haces uso del reloj inservible para lanzar este conjuro.");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oIngrediente);
                      SendMessageToPC(OBJECT_SELF,"El reloj inservible vuelve a funcionar y decides tirarlo.");
                  }
                  else
                  {
                      SetLocalInt(oIngrediente, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Haces uso del reloj inservible para lanzar este conjuro.");
                   DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
                  }
              }
          }
      }
  }

  //Declare major variables
  object oChar = OBJECT_SELF;
  location lTarget = GetSpellTargetLocation();
  effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
  effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
  int nRoll = 1 + d4();
  float fTime = RoundsToSeconds(nRoll);

  //Fire cast spell at event for the specified target
  SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));

  //Apply the VFX impact and effects
  DelayCommand(0.75, ApplyTimestop(oChar, fTime));
  DelayCommand(0.75, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oChar, fTime));

  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);

  //Let caster know duration of effect.
  SendMessageToPC(oChar, "*El tiempo detenido durará "+ FloatToString(fTime,0,0) + " segundos*");
}
