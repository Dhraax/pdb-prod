void main()
{
object oPC = GetEnteringObject();


if (GetLocalInt(oPC,"vgz_cs_aracnoputeado") == 0)
{
SendMessageToPC(oPC,"*Parece que has caido en una trampa aracnida. Quizas con una cuerda podras cruzar al otro lado y tratar de salir de aqui*");
SetLocalInt(oPC,"vgz_cs_aracnoputeado",1);
}
}
