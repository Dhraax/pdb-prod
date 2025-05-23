// TELEPORTS LYTHARIS AL CLARO PLATEADO
#include "pb_constantes"

void main()
{
    object oPC = GetPlaceableLastClickedBy();
    int iRaza = GetRacialType(oPC);
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));;

    AssignCommand(oPC, ClearAllActions(TRUE));

    if(GetDistanceBetween(oPC, OBJECT_SELF) > 6.0)
    {
        SendMessageToPC(oPC, "¡Acércate más a la piedra!");
        return;
    }

    if(GetLocalInt(OBJECT_SELF, "QUI_PIEDANIMS") == FALSE)
    {
        int iEfectoVisual;
        string sPiedras, sMensaje;
        if(GetTag(OBJECT_SELF) == "tyr_piedracapi21")
        {
            iEfectoVisual = VFX_DUR_PROT_BARKSKIN;
            sPiedras = "tyr_piedracapi";
            sMensaje = "Al tocar la piedra misteriosamente los monolitos de alrededor son cubiertos por una fina corteza. Sientes que cierto poder oculto envuelve este lugar.";
        }
        else
        {
            iEfectoVisual = VFX_DUR_ICESKIN;
            sPiedras = "qui_piedracapi";
            sMensaje = "Al tocar la piedra misteriosamente los monolitos de alrededor se cubren por un manto de hielo. Sientes que cierto poder oculto envuelve este lugar.";
        }

        int i;
        object oPiedras;
        for(i=1; i<=20; i++)
        {
            oPiedras = GetNearestObjectByTag(sPiedras + IntToString(i)) ;
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(iEfectoVisual), oPiedras, 180.0);
        }

        SendMessageToPC(oPC, sMensaje);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(iEfectoVisual), OBJECT_SELF, 180.0);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_HEALING_X), GetLocation(OBJECT_SELF));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), GetLocation(OBJECT_SELF));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_DEATH_WARD), GetLocation(OBJECT_SELF));
        SetLocalInt(OBJECT_SELF, "QUI_PIEDANIMS", TRUE);
        DelayCommand(180.0, DeleteLocalInt(OBJECT_SELF, "QUI_PIEDANIMS"));
    }
    else
    {
        if(sSubRace == "Lythari" || sSubRace == "lythari" || sSubRace == "Semifata" || sSubRace == "semifata" || iRaza == RACIAL_TYPE_CELADRIN)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_IMP_HEALING_X),oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_FNF_BLINDDEAF),oPC);
            SendMessageToPC(oPC, "Un extraña sensación te invade mientras la luz te envuelve y una extraña fuerza tira de ti.");
            AssignCommand(oPC,ActionJumpToObject(GetObjectByTag("inicio_lythari")));
        }
        else
        {
            AssignCommand(oPC,ActionCastSpellAtObject(SPELL_BLESS, oPC, METAMAGIC_ANY, TRUE, 4,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
            SendMessageToPC(oPC, "Notas como estas piedras sorprendentemente te bendicen.");
        }
    }
}
