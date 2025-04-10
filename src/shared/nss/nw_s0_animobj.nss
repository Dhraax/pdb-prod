//::///////////////////////////////////////////////
//:: Animate Object
//:: NW_S0_AnimObj
//:: Copyright (c) 2024 Puerta de Baldur (Ukiah)
//:://////////////////////////////////////////////
/*
    You imbue inanimate objects with mobility and a semblance of life.
    Each such animated object then immediately attacks whomever or whatever you
    initially designate.
    An animated object can be of any nonmagical material.
    This spell cannot animate objects carried or worn by a creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Puerta de Baldur
//:: Modified By: Mimiqp (mimiqp100@gmail.com)
//:: Modified On: May 20, 2024
//:: Modifications: MVP conversion from
//:: being a function called on object usage to
//:: a spell memorised from the spellbook and used
//:: as any other spell from the game.
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"
#include "inc_spells"


void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);


    object oPC = OBJECT_SELF;
    object oObjetivo = GetSpellTargetObject();;
    location lLugarActivado = GetLocation(oObjetivo);
    string nombrearea = GetName(GetArea(oPC),TRUE);
    int iItemTipo = GetBaseItemType(oObjetivo);

    //Fix para el conjuro y crear pergaminos o varitas.
    if(iItemTipo == BASE_ITEM_BLANK_SCROLL || iItemTipo == BASE_ITEM_BLANK_WAND)
    {
        if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }
    }


    string sTagDelObjetivo = GetTag(oObjetivo);
    string sTagDelObjetivo4 = GetStringLeft(GetTag(oObjetivo), 4);
    string sTagDelObjetivo5 = GetStringLeft(GetTag(oObjetivo), 5);
    string sTagDelObjetivo13 = GetStringLeft(GetTag(oObjetivo), 13);
    string sTagDelObjetivo15 = GetStringLeft(GetTag(oObjetivo), 15);
    int iTipo = GetBaseItemType(oObjetivo);

    // Se obtienen los henchmen para mirar que haya solo una mesa o baúl animado a la vez
    object oAyudante1 = GetHenchman(oPC,1);
    object oAyudante2 = GetHenchman(oPC,2);
    object oAyudante3 = GetHenchman(oPC,3);

    //-------------------------------------------------------------------------
    //ANIMATE BOOK
    if(iTipo == BASE_ITEM_BOOK == TRUE && GetPlotFlag(oObjetivo)== FALSE)
    {
        // Debe estar en el suelo
        if(GetItemPossessor(oObjetivo) != OBJECT_INVALID)
        {
          SendMessageToPC(oPC, "El libro debe estar en el suelo.");
        }
        else
        {
            AssignCommand(oPC,ActionSpeakString("¡Ivath oh "+GetName(oObjetivo)+"!"));
            AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1,2.0,2.0));
            effect e1 = EffectVisualEffect(VFX_FNF_DECK);
            effect e2 = EffectVisualEffect(VFX_FNF_SOUND_BURST);
            DestroyObject(oObjetivo);
            DelayCommand(0.3,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e2,lLugarActivado));
            DelayCommand(0.5,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
            DelayCommand(0.7,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
            DelayCommand(0.9,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
            DelayCommand(1.1,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
            DelayCommand(1.3,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
            DelayCommand(1.5,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
            DelayCommand(1.7,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
            object libro1 = CreateObject(OBJECT_TYPE_CREATURE,"libroanimado",lLugarActivado,FALSE,"libroanimado");
            DelayCommand(1.8,SetLocalString( libro1, "AMO", GetName(oPC, TRUE)) );
            DelayCommand(1.9,AddHenchman(oPC,libro1));
        }
    }
    //-------------------------------------------------------------------------
    //ANIMATE TABLE
    else if(sTagDelObjetivo == "vgz_mesa" ||
            sTagDelObjetivo == "X2_PLC_TABLEDROW" ||
            sTagDelObjetivo4 == "mesa" ||
            sTagDelObjetivo5 == "Table")

    {
        if(GetItemPossessor(oObjetivo) != OBJECT_INVALID)
        {
            SendMessageToPC(oPC, "La mesa debe estar en el suelo.");
        }
        // Solo una mesa animada a la vez
        else if(GetTag(oAyudante1) == "vgz_mesaanimado" ||
                GetTag(oAyudante2) == "vgz_mesaanimado" ||
                GetTag(oAyudante3) == "vgz_mesaanimado")
        {
          SendMessageToPC(oPC, "No puedes tener mas de una mesa animada al mismo tiempo.");
        }
        else
        {
            // Animaciones
            effect eVisual1 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
            AssignCommand(oPC,ActionCastFakeSpellAtLocation(SPELL_GREATER_SPELL_MANTLE,lLugarActivado));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisual1,lLugarActivado);

            // Ayudante
            object mesa1 = CreateObject(OBJECT_TYPE_CREATURE,"vgz_mesaanimada",lLugarActivado,FALSE);
            SetLocalString(mesa1, "AMO", GetName(oPC, TRUE));
            AddHenchman(oPC,mesa1);
            DestroyObject(oObjetivo);
        }
    }
    //-------------------------------------------------------------------------
    //ANIMATE CHEST
    else if(sTagDelObjetivo == "vgz_baul" ||
       sTagDelObjetivo == "X2_PLC_CHEST_DROW" ||
       sTagDelObjetivo5 == "cofre" ||
       sTagDelObjetivo5 == "Chest" ||
       sTagDelObjetivo13 == "x2_easy_Chest" ||
       sTagDelObjetivo13 == "x2_hard_Chest" ||
       sTagDelObjetivo15 == "x2_medium_Chest")
    {

        // Debe estar en el suelo
        if(GetItemPossessor(oObjetivo) != OBJECT_INVALID)
        {
          SendMessageToPC(oPC, "El baul debe estar en el suelo.");
        }
        // Solo un cofre animado a la vez
        else if(GetTag(oAyudante1) == "vgz_baulanimado" ||
                GetTag(oAyudante2) == "vgz_baulanimado" ||
                GetTag(oAyudante3) == "vgz_baulanimado")
        {
          SendMessageToPC(oPC, "No puedes tener mas de un cofre animado al mismo tiempo.");
        }
        else
        {
            // Animaciones
            effect eVisual1 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
            AssignCommand(oPC,ActionCastFakeSpellAtLocation(SPELL_GREATER_SPELL_MANTLE,lLugarActivado));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisual1,lLugarActivado);

            // Ayudante
            object cofre1 = CreateObject(OBJECT_TYPE_CREATURE,"vgz_baulanimado",lLugarActivado,FALSE);
            SetLocalString(cofre1, "AMO", GetName(oPC, TRUE));
            AddHenchman(oPC,cofre1);
            DestroyObject(oObjetivo);
        }
    }
    else
    {
      SendMessageToPC(oPC,"No puedo animar eso.");
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
