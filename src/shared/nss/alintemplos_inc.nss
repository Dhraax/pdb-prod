#include "mti_libreria"

void alineamiento_templo(object oPC);
void alineamiento_templo_salir(object oPC);

void alineamiento_templo(object oPC){

    if(GetLocalInt(OBJECT_SELF, "ALINEAMIENTO") == 1) //alineamiento maligno
    {
        effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);
        eAC = VersusAlignmentEffect(eAC, ALIGNMENT_ALL, ALIGNMENT_GOOD);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
        eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, ALIGNMENT_GOOD);
        effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
        eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, ALIGNMENT_GOOD);


        //aplicando circulo contra alineamiento bueno
        effect eLink = EffectLinkEffects(eImmune, eSave);
        eLink = EffectLinkEffects(eLink, eAC);

        //si tiene un convocado bueno se desconvoca
        if(GetAssociateType(oPC)==ASSOCIATE_TYPE_SUMMONED){
            if(GetAlignmentGoodEvil(oPC)==4){
                DelayCommand( 1.0, FloatingTextStringOnCreature("El convocado se ve rechazado el lugar.", oPC) );
                DelayCommand( 1.0, DestroyObject(oPC) );
            }
        }

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oPC);
        //si esta sacralizado por druidas no tiene el bono a expulsar
        if(GetLocalInt(OBJECT_SELF, "SACADRUIDA") == 1) SetLocalInt(oPC, "ALINEAMIENTO", 1);
    }
    else if (GetLocalInt(OBJECT_SELF, "ALINEAMIENTO") == 2) //alineamiento benigno
   {
        effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);
        eAC = VersusAlignmentEffect(eAC,ALIGNMENT_ALL, ALIGNMENT_EVIL);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
        eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, ALIGNMENT_EVIL);
        effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
        eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, ALIGNMENT_EVIL);

        //aplicando circulo contra alineamiento malo
        effect eLink = EffectLinkEffects(eImmune, eSave);
        eLink = EffectLinkEffects(eLink, eAC);
        //si tiene un convocado malo se desconvoca o si es un muerto viviente
        if(GetAssociateType(oPC)==ASSOCIATE_TYPE_SUMMONED){
            if(GetAlignmentGoodEvil(oPC)==5){
                DelayCommand( 1.0, FloatingTextStringOnCreature("El convocado se ve rechazado el lugar.", oPC) );
                DelayCommand( 1.0, DestroyObject(oPC) );
            }
        }


        ApplyEffectToObject(2, ExtraordinaryEffect(eLink), oPC);
        //si esta sacralizado por druidas no tiene el bono a expulsar
        if(GetLocalInt(OBJECT_SELF, "SACADRUIDA") == 1) SetLocalInt(oPC, "ALINEAMIENTO", 2);
   }

}

void alineamiento_templo_salir(object oPC)
{
  DeleteLocalInt(oPC, "ALINEAMIENTO");

  effect efectoQuitar = GetFirstEffect(oPC);
  while(GetIsEffectValid(efectoQuitar))
  {
      if(GetEffectSubType(efectoQuitar) == SUBTYPE_EXTRAORDINARY &&
        (GetEffectType(efectoQuitar) == EFFECT_TYPE_AC_INCREASE ||
         GetEffectType(efectoQuitar) == EFFECT_TYPE_SAVING_THROW_INCREASE ||
         GetEffectType(efectoQuitar) == IMMUNITY_TYPE_MIND_SPELLS))
      {
          RemoveEffect(oPC, efectoQuitar);
      }

      efectoQuitar = GetNextEffect(oPC);
  }
}
