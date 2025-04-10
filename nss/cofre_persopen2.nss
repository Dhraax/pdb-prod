void main()
{
object oCofre = GetNearestObjectByTag("cofre_persistente", OBJECT_SELF);
SetLocalInt(oCofre, "in_use", 1);
}
