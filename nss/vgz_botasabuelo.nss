#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object obotas = GetItemPossessedBy(oPC,"_botasdelabuelete");
int iOro = GetGold(oPC);
if(iOro < 500)
{
ActionSpeakString("No tienes suficiente oro. Curioso, ¡teniendo en cuenta que me lo acabas de mostrar!");
return;
}
TakeGoldFromCreature(500,oPC);
ActionSpeakString("Aqui tiene, perfectamente lustradas con mi mejor unguento. ¡Que las disfrute!");
DestroyObject(obotas);
CreateItemOnObject("_botasdelabuele2",oPC);
GiveXPToCreature(oPC,400);
GuardarIntPersistente(oPC,"vgz_lustrabotasabuelete",1);
}
