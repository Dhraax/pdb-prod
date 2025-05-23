#include "lib_race"

void main()
{
object oEnter = GetEnteringObject();
int iRaza = GetRacialType(oEnter);

object oPortal = GetNearestObjectByTag("ib_base_sancta_balizaport");
int iVariable = GetLocalInt(oPortal, "ibbaseport");

if(iVariable < 6)
{
if(PB_Race_GetIsUndead(oEnter))
    {
effect eEfecto1 = EffectVisualEffect(VFX_FNF_PWKILL);
effect eEfecto2 = EffectVisualEffect(VFX_FNF_PWSTUN);
effect eMuerto = EffectDeath();
effect eCut = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
effect eOscuro = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
object oVortice = GetNearestObjectByTag("ib_base_sanctafuera");

    if(iVariable == 1)
        {
        object oEspejo1 = GetObjectByTag("ib_base_condensador_01");
        effect eBeam1 = EffectBeam(VFX_BEAM_BLACK,oEspejo1,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo1));
        SetLocalInt(oPortal,"ibbaseport",2);
        }
    else if(iVariable == 2)
        {
        object oEspejo2 = GetObjectByTag("ib_base_condensador_02");
        effect eBeam2 = EffectBeam(VFX_BEAM_BLACK,oEspejo2,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo2));
        SetLocalInt(oPortal,"ibbaseport",3);
        }
    else if(iVariable == 3)
        {
        object oEspejo3 = GetObjectByTag("ib_base_condensador_03");
        effect eBeam3 = EffectBeam(VFX_BEAM_BLACK,oEspejo3,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo3));
        SetLocalInt(oPortal,"ibbaseport",4);
        }
    else if(iVariable == 4)
        {
        object oEspejo4 = GetObjectByTag("ib_base_condensador_04");
        effect eBeam4 = EffectBeam(VFX_BEAM_BLACK,oEspejo4,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo4));
        SetLocalInt(oPortal,"ibbaseport",5);
        }
    else if(iVariable == 5)
        {
        object oEspejo5 = GetObjectByTag("ib_base_condensador_05");
        effect eBeam5 = EffectBeam(VFX_BEAM_BLACK,oEspejo5,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam5,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo5));
        }


ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEfecto1,oVortice,3.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eCut,oEnter,10.0);
DelayCommand(5.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eCut,oEnter,10.0));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEfecto2,oEnter,3.0));
DelayCommand(5.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEfecto2,oEnter,3.0));
DelayCommand(7.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEfecto2,oEnter,3.0));
AssignCommand(oEnter,PlayAnimation(ANIMATION_LOOPING_SPASM,2.0,10.0));
ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEfecto1,oEnter,3.0);
DelayCommand(9.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eMuerto,oEnter,3.0));
object oPC = GetMaster(oEnter);
int iXp = GetHitDice(oEnter);
DelayCommand(10.0,GiveXPToCreature(oPC,iXp));
   if(iVariable == 5)
    {
    object oEspejo1 = GetObjectByTag("ib_base_condensador_01");
    object oEspejo2 = GetObjectByTag("ib_base_condensador_02");
    object oEspejo3 = GetObjectByTag("ib_base_condensador_03");
    object oEspejo4 = GetObjectByTag("ib_base_condensador_04");
    object oEspejo5 = GetObjectByTag("ib_base_condensador_05");

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eCut,oVortice,10.0);
    DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eCut,oVortice,10.0));

     effect eBeam1 = EffectBeam(VFX_BEAM_BLACK,oEspejo1,BODY_NODE_CHEST,FALSE);
     effect eBeam2 = EffectBeam(VFX_BEAM_BLACK,oEspejo2,BODY_NODE_CHEST,FALSE);
     effect eBeam3 = EffectBeam(VFX_BEAM_BLACK,oEspejo3,BODY_NODE_CHEST,FALSE);
     effect eBeam4 = EffectBeam(VFX_BEAM_BLACK,oEspejo4,BODY_NODE_CHEST,FALSE);
     effect eBeam5 = EffectBeam(VFX_BEAM_BLACK,oEspejo5,BODY_NODE_CHEST,FALSE);
     effect eAM = EffectVisualEffect(VFX_DUR_DEATH_ARMOR);
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam5,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAM,oVortice));
            SetLocalInt(oPortal,"ibbaseport",6);
    }
    }
}
}
