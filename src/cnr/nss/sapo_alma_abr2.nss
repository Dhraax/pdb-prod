void main()
{
  object oCofre = GetNearestObjectByTag("sapo_alma", OBJECT_SELF);
  object oPJ = GetLastOpenedBy();
  string sNam=GetName(oPJ, TRUE);
  SetLocalInt(oCofre,"abierto",1);
  SetLocalString(oCofre,"abridor",sNam);
}
