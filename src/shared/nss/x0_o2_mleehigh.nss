void main()
{
  if(GetLocalInt(OBJECT_SELF, "TIPOTESORO") == 0) SetLocalInt(OBJECT_SELF, "TIPOTESORO", 3);
  ExecuteScript("pb_tesoros_ubic", OBJECT_SELF);
}
