void main()
{
object oPC = GetPCSpeaker();
SetLocalInt(oPC, "FALLO_BUSQUEDA_GATO", 1);
DelayCommand(600.0, DeleteLocalInt(oPC, "FALLO_BUSQUEDA_GATO"));
}
