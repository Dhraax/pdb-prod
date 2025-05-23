#include "f_vampire_h"
void main()
{
    object oPC = GetPCSpeaker();
    //Llamar plagas de murcielagos
    int num_murci = d4()+1;
    float num_asal = (IntToFloat(d6()+ d6()))*3;

    DelayCommand(0.9,AssignCommand(oPC, PlaySound("as_an_x2cvbat2")));
    DelayCommand(1.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2,1.0,6.0)));
    DelayCommand(1.1,SetCommandable(FALSE,oPC));
    effect eEspecial = EffectVisualEffect(134);
    DelayCommand(1.2,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEspecial,oPC));
    DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEspecial,oPC));
    DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEspecial,oPC));
    DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEspecial,oPC));
    DelayCommand(5.1,SetCommandable(TRUE,oPC));
    FloatingTextStringOnCreature("Las criaturas han sido llamadas en breves momentos aparecerán.", oPC, FALSE);
    DelayCommand(num_asal,LlamarHijosNoche(2,num_murci,oPC));

}
