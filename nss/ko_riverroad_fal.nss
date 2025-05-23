void main()
{
object oPC = GetPCSpeaker();
SetLocalInt(oPC, "FALLO_ABRIR_TIENDA_ENANOCAMRIO", 1);
DelayCommand(2000.0, DeleteLocalInt(oPC, "FALLO_ABRIR_TIENDA_ENANOCAMRIO"));
}
