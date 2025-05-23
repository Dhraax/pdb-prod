//Invocaciones//

#include "mti_libreria"
#include "nwnx_creature"

void main ()
{

object oPC = GetPCSpeaker();
int InvConocidas = ObtenerIntPersistente(oPC, "INVOCACIONES");

if(GetHasFeat(1478, oPC)) { SendMessageToPC(oPC, "¡Ya tienes este poder!"); return; }

NWNX_Creature_AddFeat(oPC, 1478); //Tentaculos Oscuros
GuardarIntPersistente(oPC, "INVOCACIONES", InvConocidas + 1 );
SendMessageToPC(oPC, "¡Has aprendido una nueva invocación!");
ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(20), oPC);
}
