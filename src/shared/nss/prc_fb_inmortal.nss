// Frenesi Inmortal //

void main()
{
     int iDam = GetTotalDamageDealt();
     iDam += GetLocalInt(OBJECT_SELF, "PC_Damage");
     SetLocalInt(OBJECT_SELF, "PC_Damage", iDam);
}
