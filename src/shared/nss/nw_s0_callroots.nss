//::///////////////////////////////////////////////
//:: Call Roots
//:: NW_S0_CallRoots
//:: Copyright (c) 2024 Puerta de Baldur
//:://////////////////////////////////////////////
/*
    El druida entrará en comunión con el interior de la tierra para llamar en su
    ayuda a varias raíces venenosas. Éstas atenderán las peticiones básicas,
    enredando y emponzoñando a los enemigos del comulgante.
    Si hay enemigos cerca durante la conjuración, deberán librarse de la furia
    de raíces menores. Las más fuertes no podrán moverse y tras 5 minutos, se
    empezarán a marchitar, volviendo a las entrañas de la tierra.
    El druida no podrá llamarlas en áreas que no sean naturales.
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
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oPC = OBJECT_SELF;
    effect eSum = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
    effect eImplosion = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eNiebla = EffectAreaOfEffect(AOE_PER_ENTANGLE);

    location lLocation = GetLocation(oPC);
    object oArea = GetAreaFromLocation(lLocation);

    if(GetIsAreaNatural(GetArea(oPC)))
    {
      DelayCommand(0.5,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eNiebla,lLocation,6.0));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eImplosion,lLocation);

      object raiz1 = CreateObject(OBJECT_TYPE_CREATURE,"raicessutekhbis",lLocation);
      DelayCommand(3.6,SetLocalString( raiz1, "AMO", GetName(oPC, TRUE)) );
      DelayCommand(3.7,AddHenchman(oPC,raiz1));
      object raiz2 = CreateObject(OBJECT_TYPE_CREATURE,"raicessutekhbis",lLocation);
      DelayCommand(3.6,SetLocalString( raiz2, "AMO", GetName(oPC, TRUE)) );
      DelayCommand(3.7,AddHenchman(oPC,raiz2));
      object raiz3 = CreateObject(OBJECT_TYPE_CREATURE,"raicessutekhbis",lLocation);
      DelayCommand(3.6,SetLocalString( raiz3, "AMO", GetName(oPC, TRUE)) );
      DelayCommand(3.7,AddHenchman(oPC,raiz3));
      DelayCommand(2.5,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eSum,lLocation));
    }
    else
    {
      AssignCommand(oPC,ActionSpeakString("El poder de las raices no puede llegar hasta aqui..."));
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

