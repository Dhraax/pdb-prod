void main()
{
object oPJ = GetPCSpeaker();
//Borramos variables selectivas
DeleteLocalInt(oPJ, "apuesta_tril_poco");
DeleteLocalInt(oPJ, "apuesta_tril_normal");
DeleteLocalInt(oPJ, "apuesta_tril_mucho");
//Borramos variables 100,500,800
DeleteLocalInt(oPJ, "apuesta_tril_100");
DeleteLocalInt(oPJ, "apuesta_tril_500");
DeleteLocalInt(oPJ, "apuesta_tril_800");
//Borramos variables 1000,5000,8000
DeleteLocalInt(oPJ, "apuesta_tril_1000");
DeleteLocalInt(oPJ, "apuesta_tril_5000");
DeleteLocalInt(oPJ, "apuesta_tril_8000");
//Borramos variables 10000,50000,80000
DeleteLocalInt(oPJ, "apuesta_tril_10000");
DeleteLocalInt(oPJ, "apuesta_tril_50000");
DeleteLocalInt(oPJ, "apuesta_tril_80000");
}
