void main()
{
object oPC = GetEnteringObject();
string sTesoro = GetLocalString(OBJECT_SELF,"Tesoro");
string sTesoroarea = GetLocalString(OBJECT_SELF,"Tesoroarea");

SetLocalInt(oPC,"vgz_cercadeuntesoro",1);
SetLocalString(oPC,"vgz_tesoroenterrado",sTesoro);
SetLocalString(oPC,"vgz_tesoroareaenterrado",sTesoroarea);
}
