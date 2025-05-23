void main()
{
object oPC = GetPCSpeaker();
object oContenedor = GetObjectByTag("spawn_encuentros");
SetLocalInt(oContenedor, "intLevel",1);
ActionStartConversation(oPC,"asistente_nivel");
}
