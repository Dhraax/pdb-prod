void main()
{
object oPC = GetClickingObject();
object oSalida_Perdido = GetObjectByTag("ir_cloak_esmel_perd");
object oSalida = GetObjectByTag("ir_cloak_esmel_puerto_pc");
{
if (GetLocalInt(oPC,"ESMEL_MALOS_PUERT_CIUD") == 1)
    {
     DeleteLocalInt(oPC, "ESMEL_MALOS_PUERT_CIUD");
     AssignCommand(oPC, JumpToObject(oSalida_Perdido));
    }
else
    {
     AssignCommand(oPC, JumpToObject(oSalida));
    }
  }
}

