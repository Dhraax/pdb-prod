//::///////////////////////////////////////////////
//:: Planar Ally
//:: X0_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Modified from Planar binding
//:: Hold ability removed for cleric version of spell

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "nw_i0_spells"
//#include "mti_libreria"
#include "nwnx_creature"


void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, object oPC = OBJECT_SELF)
{

    //Generamos efectos y la criatura
    object oCreature;
    int nDC  = 20;
    int eApariencia;
    string nName;
    effect eUnsummon = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eDomi = SupernaturalEffect(EffectCutsceneDominated());
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eLink = EffectLinkEffects(eDur, EffectParalyze());
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eDur3);

    //Revisamos el alineamiento del creador
        int nAlign = GetAlignmentGoodEvil(oPC);
        switch (nAlign)
        {
            //Asignamos la criatura segun alineamiento y comprobamos protecciones
            case ALIGNMENT_EVIL:
                {

                    if(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oPC)      ||
                       GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oPC) ||
                       GetHasSpellEffect(SPELL_UNHOLY_AURA, oPC)) SetLocalInt(oPC, "CIRCULOTRUE", TRUE);

                    switch(d6())
                     {
                        case 1: eApariencia = 3519; break;
                        case 2: eApariencia = 3517; break;
                        case 3: eApariencia = 4008; break;
                        case 4: eApariencia = 4011; break;
                        case 5: eApariencia = 4039; break;
                        case 6: eApariencia = 293; break;
                     }
                }
            break;
            case ALIGNMENT_GOOD:
                {

                    if(GetHasSpellEffect(SPELL_PROTECTION_FROM_GOOD, oPC)      ||
                       GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, oPC) ||
                       GetHasSpellEffect(SPELL_HOLY_AURA, oPC)) SetLocalInt(oPC, "CIRCULOTRUE", TRUE);

                     switch(d6())
                     {
                        case 1: eApariencia = 923; break;
                        case 2: eApariencia = 1207; break;
                        case 3: eApariencia = 295; break;
                        case 4: eApariencia = 51; break;
                        case 5: eApariencia = 3533; break;
                        case 6: eApariencia = 3533; break;
                    }
                }
            break;
            case ALIGNMENT_NEUTRAL:
                {
                    if(GetHasSpellEffect(SPELL_PROTECTION_FROM_GOOD, oPC)      ||
                       GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, oPC) ||
                       GetHasSpellEffect(SPELL_HOLY_AURA, oPC)                 ||
                       GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oPC)      ||
                       GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oPC) ||
                       GetHasSpellEffect(SPELL_UNHOLY_AURA, oPC)) SetLocalInt(oPC, "CIRCULOTRUE", TRUE);

                     switch(d6())
                     {
                        case 1: eApariencia = 2111; break;
                        case 2: eApariencia = 32; break;
                        case 3: eApariencia = 362; break;
                        case 4: eApariencia = 1315; break;
                        case 5: eApariencia = 2110; break;
                        case 6: eApariencia = 2110; break;
                     }
                }
            break;
        }

    oCreature = CreateObject(nObjectType, sTemplate, lLoc);
    DestroyObject(oCreature, HoursToSeconds(24));

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
       DelayCommand(1.0, LevelHenchmanUpTo(oCreature, 12, nClass, 20, 86, nPack));
       DelayCommand(2.5, ForceRest(oCreature)); //Descansa para recuperar conjuros
       DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1109)); //Le quitamos la dote Ausente
       DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1110)); //Guardar PJ
       DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1111)); //Controlar Convocados
       SetName(oCreature, nName);
       SetCreatureAppearanceType(oCreature, eApariencia);
	   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCreature);
       SetIsTemporaryFriend(oCreature, oPC);
       AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 18.0));
       DelayCommand(19.0f, RemoveEffect(oCreature, eLink));
       DelayCommand(20.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oCreature));
       DelayCommand(21.0f, SetLocalString(oCreature, "AMO", GetName(oPC, TRUE)));
       DelayCommand(21.0f, SetLocalObject(oPC, "LIGADURA", oCreature));
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oPC = OBJECT_SELF;
    // Verificar si ya se está conjurando el hechizo
    if (GetLocalInt(oPC, "PLANAR_IS_CASTING") == TRUE)
    {
        SendMessageToPC(oPC, "Ya estás conjurando o terminando de negociar con un aliado planario.");
        return;
    }

    //Declare major variables
	   object oCopyAntiguo = GetLocalObject(OBJECT_SELF, "LIGADURA");
    object oCirc;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
        // Establecer la variable local que indica que se está conjurando
        SetLocalInt(oPC, "PLANAR_IS_CASTING", TRUE);
    //Revisamos el alineamiento del creador
        string eSummon;
        effect eGate;
        effect eCirc;
        int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
        switch (nAlign)
        {
            //Asignamos la criatura segun alineamiento y comprobamos protecciones
            case ALIGNMENT_EVIL:
                {
                    eSummon = "ligevil2";
                    eGate = EffectVisualEffect(496);
                    eCirc = EffectVisualEffect(925);
                }
            break;
            case ALIGNMENT_GOOD:
                {
                    eSummon = "liggood2";
                    eGate = EffectVisualEffect(1234);
                    eCirc = EffectVisualEffect(945);
                }
            break;
            case ALIGNMENT_NEUTRAL:
                {
                    eSummon = "ligneutral2";
                    eGate = EffectVisualEffect(893);
                    eCirc = EffectVisualEffect(945);
                }
            break;
        }

     //Creamos el circulo y la criatura despues:
      oCirc = CreateObject(OBJECT_TYPE_PLACEABLE, "invisobj002", GetSpellTargetLocation());
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCirc, oCirc, 40.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SPELLTURNING), OBJECT_SELF, 12.0);
      AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 12.0));
      DelayCommand(11.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, GetSpellTargetLocation()));
      DelayCommand(12.0, CreateObjectVoid(OBJECT_TYPE_CREATURE, eSummon, GetSpellTargetLocation(), OBJECT_SELF));
        // Restablecer la variable local después de terminar de conjurar
        DelayCommand(35.0f, SetLocalInt(oPC, "PLANAR_IS_CASTING", FALSE));
      //Destruimos el antiguo si existe
      if(GetIsObjectValid(oCopyAntiguo)){ AssignCommand(oCopyAntiguo, SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oCopyAntiguo, 0.5); }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


