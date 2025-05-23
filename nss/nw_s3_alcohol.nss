//::///////////////////////////////////////////////
//:: NW_S3_Alcohol.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Makes beverages fun.
  May 2002: Removed fortitude saves. Just instant intelligence loss
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   February 2002
//:://////////////////////////////////////////////

void DrinkIt(object oTarget)
{
   //AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
   AssignCommand(oTarget,ActionSpeakStringByStrRef(10499));
}

void MakeDrunk(object oTarget, int nPoints)
{
    if (Random(100) + 1 < 40)
        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
    else
        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK));

    effect eDumb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nPoints);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDumb, oTarget, 60.0);
    //AssignCommand(oTarget, SpeakString(IntToString(GetAbilityScore(oTarget,ABILITY_INTELLIGENCE))));
}
void main()
{
    object oTarget = GetSpellTargetObject();
    //--------------------------------------------------------------------------
    //Alcohol envenenado
    //--------------------------------------------------------------------------
    string sTag = GetTag(GetSpellCastItem());
    sTag = GetStringRight(sTag, 10);

    if (sTag == "envenenada")
    {
        //Obtiene nuevamente el tag de la pocion
        sTag = GetTag(GetSpellCastItem());
        //Y obtiene el id de la pocion cargado en el tag
        sTag = GetStringRight(sTag, 13);
        sTag = GetStringLeft(sTag, 2);
        //Aplica la pocion al efecto
        effect eVenon = EffectPoison(StringToInt(sTag));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVenon, oTarget);
        SendMessageToPC(oTarget, "¡La bebida está envenenada!");
        //evita que se desencadene el alcohol
        return;
    }
    //--------------------------------------------------------------------------
    //SpeakString("here");
    // * Beer
    if (GetSpellId() == 406)
    {
        //*burp*
        //AssignCommand(oTarget, SpeakString("Beer"));
        DrinkIt(oTarget);
        //if (FortitudeSave(oTarget, d20()+10) == TRUE)
        {
            MakeDrunk(oTarget, 1);
        }
    }
    else
    //*Wine
    if (GetSpellId() == 407)
    {
        DrinkIt(oTarget);
    //if (FortitudeSave(oTarget, d20()+10 +2) == TRUE)
        {
            MakeDrunk(oTarget, 2);
        }
    }
    else
    //* Spirits
    if (GetSpellId() == 408)
    {
        DrinkIt(oTarget);
    //if (FortitudeSave(oTarget, d20()+10) == TRUE)
        {
            MakeDrunk(oTarget, 3);
        }
     }

}
