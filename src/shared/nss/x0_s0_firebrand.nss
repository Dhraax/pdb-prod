//::///////////////////////////////////////////////
//:: Firebrand
//:: x0_x0_Firebrand
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// * Fires a flame arrow to every target in a
// * colossal area
// * Each target explodes into a small fireball for
// * 1d6 damage / level (max = 15 levels)
// * Only nLevel targets can be affected
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 29 2002
//:://////////////////////////////////////////////
//:: Last Updated By:

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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

  // COMPONENTE MATERIAL
  object oItm = GetSpellCastItem();
  if(GetIsPC(OBJECT_SELF) == TRUE &&
     oItm == OBJECT_INVALID &&
     GetIsDM(OBJECT_SELF) == FALSE &&
     GetIsDMPossessed(OBJECT_SELF) == FALSE)
  {
      // Si tienes la dote Abstencion de materiales, no necesitas componentes
      if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes lanzar el conjuro sin necesitar ningún componente.</c>");
      else
      {
          if(GetItemPossessedBy(OBJECT_SELF, "polvoardor")==OBJECT_INVALID)
          {
              SendMessageToPC(OBJECT_SELF,"¡Necesitas un poco de pasta de ardor desértico para lanzar el conjuro!");
              return;
          }
          else
          {
              object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"polvoardor");
              int iUsosIngrediente = GetLocalInt(oIngrediente, "USOS");

              if(iUsosIngrediente == 0)
              {
                  SetLocalInt(oIngrediente, "USOS", 1 + d2());
                  SendMessageToPC(OBJECT_SELF,"Utilizas un poco de pasta de ardor desértico para lanzar este conjuro.");
              }
              else if(iUsosIngrediente == 1)
              {
                  DestroyObject(oIngrediente);
                  SendMessageToPC(OBJECT_SELF,"Consumes toda la pasta de ardor desértico para lanzar este conjuro.");
              }
              else
              {
                  SetLocalInt(oIngrediente, "USOS", iUsosIngrediente - 1);
                  SendMessageToPC(OBJECT_SELF,"Utilizas un poco de pasta de ardor desértico para lanzar este conjuro.");
              }
          }
      }
  }

  int nDamage =  GetTotalCasterLevel(OBJECT_SELF);
  if (nDamage > 15) nDamage = 15;

  DoMissileStorm(nDamage, 15, SPELL_FIREBRAND, VFX_IMP_MIRV_FLAME, VFX_IMP_FLAME_M, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE),TRUE, TRUE);
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
