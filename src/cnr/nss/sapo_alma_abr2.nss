// modified by: Dhraax
void main()
{
  object oCofre = GetNearestObjectByTag("cnr_almacen", OBJECT_SELF);
  object oPJ = GetLastOpenedBy();
  string sNam=GetName(oPJ, TRUE);
  SetLocalInt(oCofre,"abierto",1);
  SetLocalString(oCofre,"abridor",sNam);
}
