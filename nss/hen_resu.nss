#include "mti_libreria"

void main()
{
    object oPC = GetPCSpeaker();

    // Calculo oro a pagar
    int nHD =(GetHitDice(oPC)-4);
    int iHD = nHD *400; // 1000po por nivel de aliado a resucitar
    int iOroRevivir = 0;
    string sRevivir = IntToString(iOroRevivir);


    //Aliados Muranii
    int bHasAlliesToResurrect = FALSE;

    if(GetLevelByClass(49, oPC))
    {
        if (ObtenerIntPersistente(oPC, "BARBMUERTO") || ObtenerIntPersistente(oPC, "AXEMUERTO") || ObtenerIntPersistente(oPC, "SHAMMUERTO") || ObtenerIntPersistente(oPC, "FGHTMUERTO"))
            bHasAlliesToResurrect = TRUE;
    }

    //Aliados Ladron Cofrade
    if (GetLevelByClass(44, oPC))
    {
        if (ObtenerIntPersistente(oPC, "LADMUERTO1") || ObtenerIntPersistente(oPC, "LADMUERTO2") || ObtenerIntPersistente(oPC, "LADMUERTO3"))
            bHasAlliesToResurrect = TRUE;
    }

    //Aliados Guerrero
    if (GetLevelByClass(4, oPC))
    {
        if(ObtenerIntPersistente(oPC, "ALIADOGUERRERO"))
            bHasAlliesToResurrect = TRUE;
    }

    if (!bHasAlliesToResurrect) {
        SendMessageToPC(oPC, "No tienes ningún aliado que resucitar.");
        return;
    }

    // Precio a pagar por aliado caido
    if(ObtenerIntPersistente(oPC, "BARBMUERTO") > 0 ) iOroRevivir += iHD;
    if(ObtenerIntPersistente(oPC, "FGHTMUERTO") > 0 ) iOroRevivir += iHD;
    if(ObtenerIntPersistente(oPC, "SHAMMUERTO") > 0 ) iOroRevivir += iHD;
    if(ObtenerIntPersistente(oPC, "AXEMUERTO") > 0 )  iOroRevivir += iHD;
    if(ObtenerIntPersistente(oPC, "LADMUERTO1") > 0 ) iOroRevivir += iHD;
    if(ObtenerIntPersistente(oPC, "LADMUERTO2") > 0 ) iOroRevivir += iHD;
    if(ObtenerIntPersistente(oPC, "LADMUERTO3") > 0 ) iOroRevivir += iHD;
    if(ObtenerIntPersistente(oPC, "ALIADOGUERRERO") > 0 ) iOroRevivir += iHD;

    //Si no tenemos oro suficiente para pagar
    if(GetGold(oPC) < iOroRevivir)
    {
        SendMessageToPC(oPC, "<cþ>¡No tienes las monedas de oro necesarias para pagar el conjuro [Revivir a los muertos]!</c>");
        return;
    }

    // Obtener al clerigo de la conversacion y ejecutar sus animaciones
    object oClerigo = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPC));
    int iUnaSolaVez = 0;
    while(GetIsObjectValid(oClerigo) == TRUE && iUnaSolaVez == 0)
    {
        if(GetLocalInt(oClerigo, "RESUCITADOR") == 1)
        {
            AssignCommand(oClerigo, ClearAllActions());
            AssignCommand(oClerigo, ActionCastFakeSpellAtObject(SPELL_RAISE_DEAD, oClerigo));
            AssignCommand(oClerigo, ActionSpeakString("¡Muy bien! Prepárate, tus aliados pronto estarán de vuelta con nosotros."));
            iUnaSolaVez = 1;
        }

        oClerigo = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPC));
    }

    // Funciones principales
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), oPC);
    AssignCommand(oPC, TakeGoldFromCreature(iOroRevivir, oPC, TRUE));
    GuardarIntPersistente(oPC, "AXEMUERTO", 0);
    GuardarIntPersistente(oPC, "SHAMMUERTO", 0);
    GuardarIntPersistente(oPC, "FGHTMUERTO", 0);
    GuardarIntPersistente(oPC, "BARBMUERTO", 0);
    GuardarIntPersistente(oPC, "LADMUERTO1", 0);
    GuardarIntPersistente(oPC, "LADMUERTO2", 0);
    GuardarIntPersistente(oPC, "LADMUERTO3", 0);
    GuardarIntPersistente(oPC, "ALIADOGUERRERO", 0);
}
