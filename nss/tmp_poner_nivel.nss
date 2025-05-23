void main()
{

    object oPJ = GetLastUsedBy();
    int iProfesion = GetLocalInt(OBJECT_SELF, "Profesion");
    int iNivel = GetLocalInt(OBJECT_SELF, "Nivel");
    SetLocalInt(oPJ, "Profesion" + IntToString(iProfesion), iNivel);
    SendMessageToPC(oPJ, "Profesion " + IntToString(iProfesion) + ": " + IntToString(iNivel));
}
