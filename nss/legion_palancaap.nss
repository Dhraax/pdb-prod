void main()
{
object oPC = GetLastUsedBy();
object sellado1 = GetObjectByTag("LEGION_selladotemporal1",0);
object sellado2 = GetObjectByTag("LEGION_selladotemporal2",0);
DestroyObject(sellado1,0.0);
DestroyObject(sellado2,0.0);
DelayCommand(1.0, SendMessageToPC(oPC, "*Escuchas un chirrido metalico, indicando que los portones exteriores han sido reabiertos*."));
}
