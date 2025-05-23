//::///////////////////////////////////////////////
//:: Umbral
//:: NW_S0_Gate.nss
//:://////////////////////////////////////////////
//:: Convoca una Deva astral, Asesino concordante o Balor para el lanzador.
//:://////////////////////////////////////////////
//:: Creado por Asyel el 20 de Abril del 2009
//:: - Modificado 1 Enero 2010 por Monti: Los PNJs neutrales no les sale conversacion
//:: - Modificado 20 de Septiembre de 2010 por Monti: Nuevo convocado Asesino concordante y adios conversacion y sus scripts
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nwnx_creature"
#include "mti_libreria"
#include "nw_i0_spells"
#include "pb_nivellanzador"


void BonosLigadura(object oPC = OBJECT_SELF)
{
    object oConvocado = GetLocalObject(oPC, "LIGADURA");

    if(oConvocado == OBJECT_INVALID) return;

        effect eEfectoElegido;
        string sFrase;
        int iSuerte = d6();

        if(iSuerte == 1)
        {
            eEfectoElegido = SupernaturalEffect(EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, 0));
            sFrase = "<c¦ó->Ligadura: La criatura llamada tiene resistencia al daño extra (reducción 10/5+).</c>";
        }
        else if(iSuerte == 2)
        {
            eEfectoElegido = SupernaturalEffect(EffectRegenerate(5, 6.0));
            sFrase = "<c¦ó->Ligadura: La criatura llamada tiene el don de la regeneración (5pg cada asalto).</c>";
        }
        else if(iSuerte == 3)
        {
            eEfectoElegido = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2d10, DAMAGE_TYPE_PIERCING));
            sFrase = "<c¦ó->Ligadura: La criatura llamada tiene un ataque superior (+2d10 daño perforante).</c>";
        }
        else  if(iSuerte == 4)
        {
             eEfectoElegido = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, 6));
             sFrase = "<c¦ó->Ligadura: La criatura llamada tiene una constitución mejorada (+6 Constitución).</c>";
        }
        else  if(iSuerte == 5)
        {
              eEfectoElegido = SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH, 6));
              sFrase = "<c¦ó->Ligadura: La criatura llamada tiene una fuerza mejorada (+6 Fuerza).</c>";
        }
        else  if(iSuerte == 6)
         {
              eEfectoElegido = SupernaturalEffect(EffectAbilityIncrease(ABILITY_DEXTERITY, 6));
              sFrase = "<c¦ó->Ligadura: La criatura llamada tiene una destreza mejorada (+6 Destreza).</c>";
         }

        SendMessageToPC(oPC, sFrase);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfectoElegido, oConvocado);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(29), oConvocado);
}

int Negociacion(object oCaster, object oCreature)
{
    int iDadoEjecutor = d20();
    int iBonoEjecutor = GetAbilityModifier(ABILITY_CHARISMA, oCaster);

    int iDadoDefensor = d20();
    int iBonoDefensor = GetAbilityModifier(ABILITY_CHARISMA, oCreature);
    int iTiradaDefensor = iDadoDefensor + iBonoDefensor;

    int oOfrenda, oOro;
    //Comprobamos si tenemos oro
    if(GetGold(oCaster) > 1999 ) {  oOfrenda = 10; oOro = 2000; }
    else if(GetGold(oCaster) > 999 ) { oOfrenda = 8; oOro = 1000; }
    else if(GetGold(oCaster) > 499 ) { oOfrenda = 6; oOro = 500; }
    else { oOfrenda = 0; oOro = 0;  }

    SendMessageToPC(oCaster, "Haces una ofrenda de "+IntToString(oOro)+" monedas");

    int iTiradaEjecutor = iDadoEjecutor + iBonoEjecutor + oOfrenda;

    //Tirada enfrentada de Carisma + Ofrenda
    if(iTiradaEjecutor > iTiradaDefensor) // Exito
    {
        DelayCommand(18.0, TakeGoldFromCreature(oOro, oCaster, TRUE));
        return TRUE;
    }
    else return FALSE;
}

void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, object oPC = OBJECT_SELF)
{

    //Generamos efectos y la criatura
    object oCreature;
    int nDC  = 20;
    string nName;
    int eApariencia;
    effect eUnsummon = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eDomi = SupernaturalEffect(EffectCutsceneDominated());
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eLink = EffectLinkEffects(eDur, EffectParalyze());
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eDur3);

    oCreature = CreateObject(nObjectType, sTemplate, lLoc);
    DestroyObject(oCreature, HoursToSeconds(24));

    //Apariencia
    if(sTemplate == "conv_balor")
    {
        switch(d6())
        {
            case 1: eApariencia = 38; break;
            case 2: eApariencia = 461; break;
            case 3: eApariencia = 392; break;
            case 4: eApariencia = 471; break;
            case 5: eApariencia = 2319; break;
            case 6: eApariencia = 4873; break;
        }
    }
    if(sTemplate == "asy_solarconv")
    {
        //Efectos para los buenos
        effect eBuenos = SupernaturalEffect(EffectVisualEffect(553));
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuenos, oCreature));
        SetObjectVisualTransform(oCreature, OBJECT_VISUAL_TRANSFORM_SCALE, 1.5);

        switch(d3())
        {
            case 1: eApariencia = 313; break;
            case 2: eApariencia = 190; break;
            case 3: eApariencia = 4010; break;
        }
    }
    if(sTemplate == "con_asecon")
    {
        switch(d3())
        {
            case 1: eApariencia = 4029; break;
            case 2: eApariencia = 427; break;
            case 3: eApariencia = 363; break;
        }
    }

    //Nombre
    switch(d20(2))
    {
        case 1: nName = "Aniel"; break;
        case 2: nName = "Nuriel"; break;
        case 3: nName = "Hanael"; break;
        case 4: nName = "Shamsiel"; break;
        case 5: nName = "Uriel"; break;
        case 6: nName = "Azrael"; break;
        case 7: nName = "Sariel"; break;
        case 8: nName = "Maalik"; break;
        case 9: nName = "Kushiel"; break;
        case 10: nName = "Dumah"; break;
        case 11: nName = "Apolion"; break;
        case 12: nName = "Abadon"; break;
        case 13: nName = "Raguel"; break;
        case 14: nName = "Abathar" ; break;
        case 15: nName = "Muzania"; break;
        case 16: nName = "Lailah"; break;
        case 17: nName = "Puriel"; break;
        case 18: nName = "Azariel"; break;
        case 19: nName = "Arariel"; break;
        case 20: nName = "Jofiel"; break;
        case 21: nName = "Adaddon"; break;
        case 22: nName = "Adadese"; break;
        case 23: nName = "Akinurb"; break;
        case 24: nName = "Babzidu"; break;
        case 25: nName = "Bisrib"; break;
        case 26: nName = "Damasze"; break;
        case 27: nName = "Dingidnin"; break;
        case 28: nName = "Hursag"; break;
        case 29: nName = "Huszi"; break;
        case 30: nName = "Iduduamnaa"; break;
        case 31: nName = "Ibza"; break;
        case 32: nName = "Ehurtar"; break;
        case 33: nName = "Elamash"; break;
        case 34: nName = "Gaszarsir" ; break;
        case 35: nName = "Imhiakaam"; break;
        case 36: nName = "Jezirpa"; break;
        case 37: nName = "Kuninin"; break;
        case 38: nName = "Nimrisr"; break;
        case 39: nName = "Sharruk"; break;
        case 40: nName = "Tumunnu"; break;
    }

    //Asignamos valores a la criatura para subir de nivel y apariencia
    int nClass;
    int nPack;
    switch(d4())
    {
        case 1:
        {
            nClass = CLASS_TYPE_FIGHTER;
            nPack = 4;
        }
        break;
        case 2:
        {
            nClass = CLASS_TYPE_CLERIC;
            nPack = 22;
        }
        break;
        case 3:
        {
            nClass = CLASS_TYPE_WIZARD;
            nPack = 31;
        }
        break;
        case 4:
        {
            nClass = CLASS_TYPE_SORCERER;
            nPack = 38;
        }
        break;
    }
    SetLocalInt(oCreature, "X0_L_LEVELRULES", 1);
    SetLocalInt(oCreature, "X2_JUST_A_DISABLEEQUIP", 1); //Script que hace no poder tocar el inventario de un ayudante.
    SetName(oCreature, nName);
    SetCreatureAppearanceType(oCreature, eApariencia);
    DelayCommand(1.0, LevelHenchmanUpTo(oCreature, 18, nClass, 20, 86, nPack));
    DelayCommand(2.5, ForceRest(oCreature)); //Descansa para recuperar conjuros
    DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1109)); //Le quitamos la dote Ausente
    DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1110)); //Guardar PJ
    DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1111)); //Controlar Convocados
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 18.0));
    FloatingTextStringOnCreature("<c´þd>* Comenzando Negociación... *</c>", oPC, FALSE);

    if(GetLocalInt(oPC, "CIRCULOTRUE") == TRUE ) //Esta el circulo correcto.
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCreature);
        SetIsTemporaryFriend(oCreature, oPC);
        int iNegociacion = Negociacion(oPC, oCreature);

        if(iNegociacion == 1)
        {
            DelayCommand(18.0, FloatingTextStringOnCreature("<c´þd>* Negociación: éxito *</c>", oPC, FALSE)); // Exito en la negociacion.
            DelayCommand(19.0f, RemoveEffect(oCreature, eLink));
            DelayCommand(20.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oCreature));
            DelayCommand(21.0f, SetLocalString(oCreature, "AMO", GetName(oPC)));
            DelayCommand(21.0f, SetLocalObject(oPC, "LIGADURA", oCreature));
        }
        else if (iNegociacion == 0)
        {
            DelayCommand(18.0,FloatingTextStringOnCreature("<c´þd>* Negociación: Fallida *</c>", oPC, FALSE));
            DelayCommand(19.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eUnsummon, oCreature));
            DelayCommand(20.0, DestroyObject(oCreature));
        }

    }
    //Si el circulo esta mal, tirada...
    else
    {
        if(!MySavingThrow(SAVING_THROW_WILL, oCreature, nDC, SAVING_THROW_TYPE_SPELL))
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCreature);
            int iNegociacion = Negociacion(oPC, oCreature);

            if(iNegociacion == 1)
            {
                DelayCommand(18.0, FloatingTextStringOnCreature("<c´þd>* Negociación: éxito *</c>", oPC, FALSE)); // Exito en la negociacion.
                DelayCommand(19.0f,RemoveEffect(oCreature, eLink));
                DelayCommand(20.0f,ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oCreature));
                DelayCommand(21.0f, SetLocalString(oCreature, "AMO", GetName(oPC)));
                DelayCommand(21.0f,SetLocalObject(oPC, "LIGADURA", oCreature));
            }
            else if (iNegociacion == 0)
            {
                DelayCommand(18.0, FloatingTextStringOnCreature("<c´þd>* Negociación: Fallida *</c>", oPC, FALSE));
                DelayCommand(19.0f,RemoveEffect(oCreature, eLink));
                SetIsTemporaryEnemy(oCreature, oPC);
                SetIsTemporaryEnemy(oPC, oCreature);
                AssignCommand(oCreature, ActionAttack(oPC, FALSE));
            }
        }
        else
        {
            FloatingTextStringOnCreature("<c´þd>* ¡La criatura se ha liberado! *</c>", oPC, TRUE);
            SetIsTemporaryEnemy(oCreature, oPC);
            SetIsTemporaryEnemy(oPC, oCreature);
            AssignCommand(oCreature, ActionAttack(oPC, FALSE));
        }
    }
}
void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    DeleteLocalInt(OBJECT_SELF, "CIRCULOTRUE");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
    /*
        Spellcast Hook Code
        Added 2003-06-20 by Georg
        If you want to make changes to all spells,
        check x2_inc_spellhook.nss to find out more
    */

    if(!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oPC = OBJECT_SELF;
    object oCopyAntiguo = GetLocalObject(oPC, "LIGADURA");
    object oCirc;

    //Efectos y ResRef
    effect eGate;
    effect eCirc;
    string sResRefConvocacion;
    string sConvocarUmbralMemorizado = ObtenerStringPersistente(OBJECT_SELF, "CONV15");

    // Verificar si ya se está conjurando el hechizo
    if (GetLocalInt(oPC, "GATE_IS_CASTING") == TRUE)
    {
        SendMessageToPC(oPC, "Ya estás conjurando o terminando de negociar con un aliado.");
        return;
    }

    //Destruimos el antiguo si existe
    if(GetIsObjectValid(oCopyAntiguo))
        {
            AssignCommand(oCopyAntiguo, SetIsDestroyable(TRUE,FALSE,FALSE));
            DestroyObject(oCopyAntiguo, 0.5);
        }

    if(sConvocarUmbralMemorizado != "") sResRefConvocacion = sConvocarUmbralMemorizado;
    else
    {
        int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
        switch (nAlign)
        {
            //Asignamos la criatura segun alineamiento
            case ALIGNMENT_EVIL:
            {
                sResRefConvocacion = "conv_balor";
            }
            break;
            case ALIGNMENT_GOOD:
            {
                sResRefConvocacion = "asy_solarconv";
                SetLocalInt(oPC, "EFECTOLIGADURA", 1);
            }
            break;
            case ALIGNMENT_NEUTRAL:
            {
                sResRefConvocacion = "con_asecon";
            }
            break;
        }
    }

    // Convocando una Deva...
    if(sResRefConvocacion == "asy_solarconv")
    {
        if(GetHasSpellEffect(SPELL_PROTECTION_FROM_GOOD, oPC)      ||
            GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, oPC) ||
            GetHasSpellEffect(SPELL_HOLY_AURA, oPC)) SetLocalInt(oPC, "CIRCULOTRUE", TRUE);

        eGate = EffectVisualEffect(1234);
        eCirc = EffectVisualEffect(945);

    }

    // Convocando un Balor...
    else if(sResRefConvocacion == "conv_balor")
    {
        if(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oPC)      ||
            GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oPC) ||
            GetHasSpellEffect(SPELL_UNHOLY_AURA, oPC)) SetLocalInt(oPC, "CIRCULOTRUE", TRUE);

        eGate = EffectVisualEffect(496);
        eCirc = EffectVisualEffect(925);
    }
    // Convocando un Asesino Concordante...
    else
    {
        if(GetHasSpellEffect(SPELL_PROTECTION_FROM_GOOD, oPC)      ||
            GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, oPC) ||
            GetHasSpellEffect(SPELL_HOLY_AURA, oPC)                 ||
            GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oPC)      ||
            GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oPC) ||
            GetHasSpellEffect(SPELL_UNHOLY_AURA, oPC)) SetLocalInt(oPC, "CIRCULOTRUE", TRUE);

        eGate = EffectVisualEffect(893);
        eCirc = EffectVisualEffect(945);
    }
    // Establecer la variable local que indica que se está conjurando
    SetLocalInt(oPC, "GATE_IS_CASTING", TRUE);
    //Creamos el circulo y la criatura despues:
    oCirc = CreateObject(OBJECT_TYPE_PLACEABLE, "invisobj002", GetSpellTargetLocation());
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCirc, oCirc, 40.0);
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 12.0));
    DelayCommand(11.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, GetSpellTargetLocation()));
    DelayCommand(12.0, CreateObjectVoid(OBJECT_TYPE_CREATURE, sResRefConvocacion, GetSpellTargetLocation(), oPC));
    DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Restablecer la variable local después de terminar de conjurar
    DelayCommand(35.0f, SetLocalInt(oPC, "GATE_IS_CASTING", FALSE));
}
