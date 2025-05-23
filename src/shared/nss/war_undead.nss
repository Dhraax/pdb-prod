//::///////////////////////////////////////////////
//Animar muertos para PdB
//By_Darth
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
//#include "mti_libreria"
#include "pb_nivellanzador"
//#include "x0_i0_henchman"
#include "prc_inc_util"
#include "nwnx_creature"
#include "war_utilities"


void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int nApariencia, int nNivel, object oPC = OBJECT_SELF)
{
     //Creamos la criatura
      object oCreature;
      int nDG = GetLocalInt(oPC, "UNDEADDG");
      int nPackage = GetLocalInt(oPC, "UNDEADPACK");
      int nClass = GetLocalInt(oPC, "UNDEADCLASS");
      int nDragon = GetLocalInt(oPC, "UNDEADDRAGON");
      float nModifier = GetLocalFloat(oPC, "UNDEADDRAGONSIZE");

      oCreature = CreateObject(nObjectType, "animarmuerto", lLoc);

      //Asignamos el valor de DG para poder quitarlo al morir
      SetLocalInt(oCreature, "NOMUERTO", nNivel);
      SetLocalInt(oPC, "UNDEADDG", nDG + nNivel);

      //Aplicamos cambios a la criatura
      DelayCommand(0.5, SetCreatureAppearanceType(oCreature, nApariencia));
      DelayCommand(0.7, SetLocalInt(oCreature, "X0_L_LEVELRULES", 1));
      DelayCommand(1.0, AddHenchman(oPC, oCreature));
      DelayCommand(1.5, LevelHenchmanUpTo(oCreature, nNivel, nClass, 20, 81, nPackage));
      DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1109)); //Le quitamos la dote Ausente
      DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1110)); //Guardar PJ
      DelayCommand(3.0, NWNX_Creature_RemoveFeat(oCreature, 1111)); //Controlar Convocados
      DelayCommand(1.8, SetLocalString(oCreature, "AMO", GetName(oPC)));

       if(nDragon > 0 ){
          SetObjectVisualTransform(oCreature, OBJECT_VISUAL_TRANSFORM_SCALE, nModifier);
          DeleteLocalInt(oPC, "UNDEADDRAGON");
          DeleteLocalFloat(oPC, "UNDEADDRAGONSIZE");
            }

}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

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

    if (!CheckWarlockSpellCharisma()) return;
// End of Spell Cast Hook


    //Declare major variables
    object oPC = OBJECT_SELF;
    object oObjetivo = GetSpellTargetObject();
    location lLugarActivado = GetSpellTargetLocation();
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nControlDG = nCasterLevel*2;
    int nDG = GetLocalInt(oPC, "UNDEADDG");
    int nNiveles = GetHitDice(oObjetivo);
    int iMaxHenchmen = 4;
    SetMaxHenchmen(iMaxHenchmen);
    string eSummon;

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
        if(PB_Race_GetIsUndead(oObjetivo) || iRacial == RACIAL_TYPE_CONSTRUCT || iRacial == RACIAL_TYPE_VERMIN || iRacial == RACIAL_TYPE_ELEMENTAL)
        {
            SendMessageToPC(oPC,"¡No puedes lanzar este conjuro sobre este tipo de criatura!");
            return;
        }

        int nAlign = GetAlignmentGoodEvil(oPC);
        if(nAlign == ALIGNMENT_GOOD)
            {
            SendMessageToPC(oPC,"¡Esto es un conjuro maligno! ¡Corromperia tu alma!");
            return;
            }

        //Si tiene mas DG que el doble de nuestro nivel, nanay
     if(nNiveles > nControlDG) {
        SendMessageToPC(oPC, "No tienes suficiente poder para alzar a esta criatura.");
        return;
        }

     //El Bicho default
     eSummon = "animarmuerto";

          int iAparienciaCadaver;
          float nModifier = 0.0;

      switch(iRacial)
        {
         case RACIAL_TYPE_ANIMAL:               iAparienciaCadaver = 4083; nNiveles = 5; break;
         case RACIAL_TYPE_DWARF:                iAparienciaCadaver = 2278; nNiveles = 7; break;
         case RACIAL_TYPE_GIANT:                iAparienciaCadaver = 1109; nNiveles = 11; break; //2452
         case RACIAL_TYPE_GNOME:                iAparienciaCadaver = 2278; nNiveles = 5; break;
         case RACIAL_TYPE_HUMAN:                iAparienciaCadaver = 1386; nNiveles = 7; break;
         case RACIAL_TYPE_HUMANOID_REPTILIAN:   iAparienciaCadaver = 2580; nNiveles = 5; break;
         case RACIAL_TYPE_HUMANOID_GOBLINOID:   iAparienciaCadaver = 2278; nNiveles = 5; break;
         case RACIAL_TYPE_HALFLING:             iAparienciaCadaver = 2278; nNiveles = 5; break;
         case RACIAL_TYPE_HALFORC:              iAparienciaCadaver = 1286; nNiveles = 7; break;
         case RACIAL_TYPE_DRAGON:
                                        {
                                        int nSize = GetCreatureSize(oObjetivo);
                                        switch (nSize)
                                              {
                                              case CREATURE_SIZE_TINY: nModifier = 0.20; nNiveles = 5; break;
                                              case CREATURE_SIZE_SMALL: nModifier = 0.40; nNiveles = 6; break;
                                              case CREATURE_SIZE_MEDIUM: nModifier = 0.60; nNiveles = 9; break;
                                              case CREATURE_SIZE_LARGE: nModifier = 0.80; nNiveles = 11; break;
                                              case CREATURE_SIZE_HUGE: nModifier = 0.0; nNiveles = 13; break;
                                              }

                                        iAparienciaCadaver = 1236;
                                        SetLocalInt(oPC, "UNDEADDRAGON", 1);
                                        SetLocalFloat(oPC, "UNDEADDRAGONSIZE", nModifier);
                                        }
                                 break;
         default:                               iAparienciaCadaver = 3981; nNiveles = 6; break;
        }


      //Si nos pasamos de nuestro nivel ajustamos
        if(nNiveles > nCasterLevel) nNiveles = nCasterLevel+1;

      // Variables: nivel de la criatura muerta objetivo y apariencia
          int iClass = GetClassByPosition(1, oObjetivo);
          int iPackage = GetCreatureStartingPackage(oObjetivo);
          SetLocalInt(oPC, "UNDEADCLASS", iClass);
          SetLocalInt(oPC, "UNDEADPACK", iPackage);

          //Apariencia
          SetLocalInt(oPC,"AparienciaNomuerto", iAparienciaCadaver);
          int nApariencia = GetLocalInt(oPC,"AparienciaNomuerto");

          //Nivel aparte
          SetLocalInt(oPC,"NivelNomuerto", nNiveles);
          int nNivel = GetLocalInt(oPC,"NivelNomuerto");


    //Solo si tenemos menos de 4 y no se supera el control de DG
   if(nDG < nControlDG)
   {
    if(GetNumHenchmen(oPC) < iMaxHenchmen)
     {
        // Destruir cadaver
        DelayCommand(0.2,AssignCommand(oObjetivo,SetIsDestroyable(TRUE,FALSE,FALSE)));
        DelayCommand(0.3,DestroyObject(oObjetivo));

        // Efectos visuales
        effect e1 = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_SMALL);
        effect e2 = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
        effect e3 = EffectVisualEffect(VFX_IMP_DESTRUCTION);
        effect eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
        effect eV2 = EffectVisualEffect(91);

        //Aplicamos efectos y creacion del bicho
        DelayCommand(0.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e2,lLugarActivado));
        DelayCommand(0.7, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eSangre,lLugarActivado));
        DelayCommand(1.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLugarActivado));
        DelayCommand(1.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e3,lLugarActivado));
        DelayCommand(1.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eV2,lLugarActivado));
        DelayCommand(1.5, CreateObjectVoid(OBJECT_TYPE_CREATURE, eSummon, GetSpellTargetLocation(), nApariencia, nNivel, OBJECT_SELF));
        }
    else
     {
       SendMessageToPC(oPC, "No puedes controlar a más nomuertos.");
       return;
     }
   }
   else SendMessageToPC(oPC, "Has alcanzado el maximo de DG por nivel para controlar muertos vivientes.");

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}




