 void main()
{
    object oPC=GetPCSpeaker();
    int iDistancia = StringToInt(GetScriptParam("Modo"));
    SetFogAmount(FOG_TYPE_ALL,iDistancia,GetArea(oPC));
}


