//::////////////////////////////////////////////////////////////////////////:://
/* MONTI - SENTARSE EN UBICADOS CON DOS SCRIPTS, ON CONVERSATION */
//::////////////////////////////////////////////////////////////////////////:://
void main()
{
string sEtiketaDeLaSilla = "SILLA_" + GetTag(OBJECT_SELF);
object oSilla = GetNearestObjectByTag(sEtiketaDeLaSilla, OBJECT_SELF, 1);

if(GetCommandable(OBJECT_SELF))
 {
    {
      BeginConversation();
    }

  ClearAllActions();
  ActionSit(oSilla);
 }
}
