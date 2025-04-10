void main()
{
  string sTalk = GetLocalString(OBJECT_SELF, "Stack");
  if (sTalk != "") {
    string sSearch = GetStringLowerCase(sTalk);
    if(FindSubString(sSearch, "arranca") >= 0) {
        FloatingTextStringOnCreature("ATENCIÓN: Está prohibido por normativa arrancar carteles de otros personajes. Si deseas arrancar un cartel deberás contactar con un DM.", GetPCSpeaker());
    }

    if (GetStringLength(sTalk) > 200) {sTalk = GetStringLeft(sTalk, 200);}
    SetLocalString(OBJECT_SELF, "#M", sTalk);
    SetLocalString(OBJECT_SELF, "Stack", "");
  }
}
