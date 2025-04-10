#include "lib_race"

void main()
{
object oEnter = GetEnteringObject();

object oPortal = GetNearestObjectByTag("cripnigroport");
int iVariable = GetLocalInt(oPortal, "criptanigro");

if(iVariable < 9)
{
 if(PB_Race_GetIsUndead(oEnter) && !GetIsPC(oEnter))
      {

effect eEfecto1 = EffectVisualEffect(VFX_FNF_PWKILL);
effect eEfecto2 = EffectVisualEffect(VFX_FNF_PWSTUN);
effect eMuerto = EffectDeath();
effect eCut = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
effect eOscuro = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
object oVortice = GetNearestObjectByTag("vorticenigro");

    if(iVariable == 1)
        {
        object oEspejo1 = GetObjectByTag("esp_refrac_01");
        effect eBeam1 = EffectBeam(VFX_BEAM_BLACK,oEspejo1,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo1));
         object oEspejo2 = GetObjectByTag("esp_refrac_02");
        effect eBeam2 = EffectBeam(VFX_BEAM_BLACK,oEspejo2,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo2));
        SetLocalInt(oPortal,"criptanigro",3);
        }
    else if(iVariable == 3)
        {
        object oEspejo3 = GetObjectByTag("esp_refrac_03");
        effect eBeam3 = EffectBeam(VFX_BEAM_BLACK,oEspejo3,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo3));
        object oEspejo4 = GetObjectByTag("esp_refrac_04");
        effect eBeam4 = EffectBeam(VFX_BEAM_BLACK,oEspejo4,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo4));
        SetLocalInt(oPortal,"criptanigro",5);
        }
    else if(iVariable == 5)
        {
        object oEspejo5 = GetObjectByTag("esp_refrac_05");
        effect eBeam5 = EffectBeam(VFX_BEAM_BLACK,oEspejo5,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam5,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo5));
        object oEspejo6 = GetObjectByTag("esp_refrac_06");
        effect eBeam6 = EffectBeam(VFX_BEAM_BLACK,oEspejo6,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam6,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo6));
        SetLocalInt(oPortal,"criptanigro",7);
        }
    else if(iVariable == 7)
        {
        object oEspejo7 = GetObjectByTag("esp_refrac_07");
        effect eBeam7 = EffectBeam(VFX_BEAM_BLACK,oEspejo7,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam7,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo7));
        object oEspejo8 = GetObjectByTag("esp_refrac_08");
        effect eBeam8 = EffectBeam(VFX_BEAM_BLACK,oEspejo8,BODY_NODE_CHEST,FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam8,oEnter,11.0);
        DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOscuro,oEspejo8));
        SetLocalInt(oPortal,"criptanigro",7);
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
   if(iVariable == 7)
    {
    object oEspejo1 = GetObjectByTag("esp_refrac_01");
    object oEspejo2 = GetObjectByTag("esp_refrac_02");
    object oEspejo3 = GetObjectByTag("esp_refrac_03");
    object oEspejo4 = GetObjectByTag("esp_refrac_04");
    object oEspejo5 = GetObjectByTag("esp_refrac_05");
    object oEspejo6 = GetObjectByTag("esp_refrac_06");
    object oEspejo7 = GetObjectByTag("esp_refrac_07");
    object oEspejo8 = GetObjectByTag("esp_refrac_08");

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eCut,oVortice,10.0);
    DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eCut,oVortice,10.0));

     effect eBeam1 = EffectBeam(VFX_BEAM_BLACK,oEspejo1,BODY_NODE_CHEST,FALSE);
     effect eBeam2 = EffectBeam(VFX_BEAM_BLACK,oEspejo2,BODY_NODE_CHEST,FALSE);
     effect eBeam3 = EffectBeam(VFX_BEAM_BLACK,oEspejo3,BODY_NODE_CHEST,FALSE);
     effect eBeam4 = EffectBeam(VFX_BEAM_BLACK,oEspejo4,BODY_NODE_CHEST,FALSE);
     effect eBeam5 = EffectBeam(VFX_BEAM_BLACK,oEspejo5,BODY_NODE_CHEST,FALSE);
     effect eBeam6 = EffectBeam(VFX_BEAM_BLACK,oEspejo6,BODY_NODE_CHEST,FALSE);
     effect eBeam7 = EffectBeam(VFX_BEAM_BLACK,oEspejo7,BODY_NODE_CHEST,FALSE);
     effect eBeam8 = EffectBeam(VFX_BEAM_BLACK,oEspejo8,BODY_NODE_CHEST,FALSE);
     effect eAM = EffectVisualEffect(VFX_DUR_DEATH_ARMOR);
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam5,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam6,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam7,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam8,oVortice,25.0));
     DelayCommand(14.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAM,oVortice));
     SetLocalInt(oPortal,"criptanigro",9);
    }
    }
}
}

