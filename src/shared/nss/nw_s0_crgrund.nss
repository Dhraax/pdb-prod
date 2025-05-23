//::///////////////////////////////////////////////
//:: Create Greater Undead
//:: NW_S0_CrGrUnd.nss
//:: Copyright (c) 2001 Bioware Corp.
//::///////////////////////////////////////////////
//:: Create Great Undead - by Darth
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
//#include "mti_libreria"
#include "pb_nivellanzador"
#include "prc_inc_util"
#include "nwnx_creature"

void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int nNivel, object oPC = OBJECT_SELF)
{
    //Variables
    int nDG = GetLocalInt(oPC, "UNDEADDG");
    string nNombre = GetLocalString(oPC, "DEADNAME");
    int nApariencia = GetLocalInt(oPC, "AparienciaNomuerto");
    int nPackage = GetLocalInt(oPC, "UNDEADPACK");

    //Efectos
    effect eOcultacion = SupernaturalEffect(EffectConcealment(50));
    effect eVis = SupernaturalEffect(EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE));
    effect eLink = EffectLinkEffects(eOcultacion, eVis);

    //Creamos la criatura
    object oCreature;
    oCreature = CreateObject(nObjectType, "animarmuerto3", lLoc);
    DelayCommand(0.7, SetLocalInt(oCreature, "X0_L_LEVELRULES", 1));
    DelayCommand(1.2, SetName(oCreature, nNombre + " Espectral"));
    DelayCommand(1.3, AddHenchman(oPC, oCreature));
    DelayCommand(1.5, SetCreatureAppearanceType(oCreature, nApariencia));
    DelayCommand(1.5, LevelHenchmanUpTo(oCreature, nNivel, CLASS_TYPE_FIGHTER, 20, 81, nPackage));
    DelayCommand(2.5, ForceRest(oCreature)); //Descansa para recuperar conjuros
    DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1109)); //Le quitamos la dote Ausente
    DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1110)); //Guardar PJ
    DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1111)); //Controlar Convocados
    DelayCommand(1.6, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCreature));
    DelayCommand(1.8, SetLocalString(oCreature, "AMO", GetName(oPC)));

    //Guardamos variable para calculo en DG
    SetLocalInt(oCreature, "NOMUERTO", nNivel);
    SetLocalInt(oPC, "UNDEADDG", nDG + nNivel);
    DeleteLocalString(oPC, "DEADNAME");
    DeleteLocalInt(oPC, "AparienciaNomuerto");
}

void main()
{
    object oPC = OBJECT_SELF;
    object oObjetoLanzador = GetSpellCastItem();

    if (GetIsObjectValid(oObjetoLanzador) && GetResRef(oObjetoLanzador) == "item_inmortal") SetLocalInt(oPC, "Poder_Especial", 1);

    DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode()) return;

    object oObjetivo = GetSpellTargetObject();
    location lLugarActivado = GetSpellTargetLocation();
    int nCasterLevel = GetTotalCasterLevel(oPC);
    int nControlDG = nCasterLevel * 2;
    int nNiveles = GetHitDice(oObjetivo);
    int nDG = GetLocalInt(oPC, "UNDEADDG");
    int iMaxHenchmen = 4;
    SetMaxHenchmen(iMaxHenchmen);

    //Restricciones para crear el nomuerto
    if(GetIsDead(oObjetivo) == FALSE)
    {
        SendMessageToPC(oPC,"¡Debes lanzar el conjuro a un cadáver!");
        return;
    }

    if(GetIsPC(oObjetivo) == TRUE)
    {
        SendMessageToPC(oPC,"¡No puedes lanzar este conjuro sobre un jugador muerto!");
        return;
    }

    int iRacial = GetRacialType(oObjetivo);
    if (PB_Race_GetIsUndead(oObjetivo) || iRacial == RACIAL_TYPE_CONSTRUCT || iRacial == RACIAL_TYPE_VERMIN || iRacial == RACIAL_TYPE_ELEMENTAL)
    {
        SendMessageToPC(oPC,"¡No puedes lanzar este conjuro sobre este tipo de criatura!");
        return;
    }

    // Si tiene mas DG que el jugador, cancelar
    if(nNiveles > nCasterLevel) {
        SendMessageToPC(oPC, "No tienes suficiente poder para alzar a esta criatura.");
        return;
    }

    int nAlign = GetAlignmentGoodEvil(oPC);
    if(nAlign == ALIGNMENT_GOOD)
    {
        SendMessageToPC(oPC,"¡Esto es un conjuro maligno! ¡Corromperia tu alma!");
        return;
    }

    //Asignamos nivel, apariencia y nombre según el nivel del lanzador
    if (nCasterLevel > 16) nNiveles = 17;
    else if (nCasterLevel >= 13 && nCasterLevel <= 16) nNiveles = 15;
    else nNiveles = 13;

    //Guardamos los datos del cadaver
    int iPackage = GetCreatureStartingPackage(oObjetivo);
    int iAparienciaCadaver = GetAppearanceType(oObjetivo);
    string iNombre = GetName(oObjetivo);

    //Los datos guardados a variables para usar luego
    SetLocalString(oPC, "DEADNAME", iNombre);
    SetLocalInt(oPC,"AparienciaNomuerto", iAparienciaCadaver);
    SetLocalInt(oPC, "UNDEADPACK", iPackage);

    //Nivel aparte
    SetLocalInt(oPC, "NivelNomuerto", nNiveles);
    int nNivel = GetLocalInt(oPC,"NivelNomuerto");

    // El Bicho
    string sSummon = "animarmuerto3";

    // Solo si tenemos menos de 4 y no se supera el control de DG (incluyendo el nuevo alzado)
    if ((nDG + nNivel) <= nControlDG)
    {
        if (GetNumHenchmen(oPC) < iMaxHenchmen)
        {
            // Destruir cadaver
            DelayCommand(0.2,AssignCommand(oObjetivo,SetIsDestroyable(TRUE,FALSE,FALSE)));
            DelayCommand(0.3,DestroyObject(oObjetivo));

            // Efectos visuales
            effect e1 = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_SMALL);
            effect e2 = EffectVisualEffect(VFX_IMP_HARM);
            effect e3 = EffectVisualEffect(VFX_IMP_DESTRUCTION);
            effect eSangre = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            effect eV2 = EffectVisualEffect(VFX_IMP_DEATH_L);


            //Aplicamos efectos
            DelayCommand(0.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e2,lLugarActivado));
            DelayCommand(0.7, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eSangre,lLugarActivado));
            DelayCommand(1.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
            DelayCommand(1.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e3,lLugarActivado));
            DelayCommand(1.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eV2,lLugarActivado));

            //Creamos el bicho
            DelayCommand(1.5, CreateObjectVoid(OBJECT_TYPE_CREATURE, sSummon, lLugarActivado, nNivel, OBJECT_SELF));
        }
        else
        {
            SendMessageToPC(oPC, "No puedes tener más aliados.");
            return;
        }
    }
    else SendMessageToPC(oPC, "Has alcanzado el maximo de DG por nivel para controlar muertos vivientes.");

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
