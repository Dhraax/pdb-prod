//::////////////////////////////////////////////////////////////////////////:://
/* MONTI - SENTARSE EN UBICADOS CON DOS SCRIPTS, ON SPAWN */
//::////////////////////////////////////////////////////////////////////////:://
void main()
{
string sEtiketaDeLaSilla = "SILLA_" + GetTag(OBJECT_SELF);
object oSilla = GetNearestObjectByTag(sEtiketaDeLaSilla, OBJECT_SELF, 1);
 {
  ActionSit(oSilla);
 }
}
