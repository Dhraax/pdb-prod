#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nw_i0_plot"


void main()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   object oNPC = GetObjectByTag(GetLocalString(oContenedor, "Raza"));

//   effect eParalyze = EffectParalyze();

//   DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParalyze, oNPC));
//   DelayCommand(1.0,RemoveEffects(oNPC));
   object oPC=GetPCSpeaker();
   object oArea = GetArea(oPC);
   object oObject = GetFirstObjectInArea(oArea);
//   DelayCommand(1.0,RemoveHenchman(oPC, oNPC));
   while(GetIsObjectValid(oObject))
   {

   if(GetIsPC(oObject) == FALSE && GetObjectType(oObject) == 1 && GetHenchman(oPC) != OBJECT_INVALID)
   {
   RemoveHenchman(oPC, oObject);
   RemoveEffects(oObject);
   }
         //}
   oObject = GetNextObjectInArea(oArea);
   }

}
