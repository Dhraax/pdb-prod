void main()
{
object oPC = GetLastUsedBy();

object sellado = GetObjectByTag("IB_selladotemporal",0);
DestroyObject(sellado,0.0);


FloatingTextStringOnCreature("Desactivado cierre de emergencia",oPC,FALSE);
}
