void main()
{
object oPC = GetPCSpeaker();
string sNombre = GetName(oPC);
string sCDKey = GetPCPublicCDKey(oPC);

WriteTimestampedLogEntry("[SISTEMA DE TRAMPAS EN CHUPICONJURO]: El pj: " + sNombre + ", con CDKey: " + sCDKey + " ha hecho trampichuelas al comprar el animar cofre para sacarlo gratis. Ainsss.");
}
