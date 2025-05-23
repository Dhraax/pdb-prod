void main()
{
    object oPC= GetItemActivator();

    int iEffect =GetAlignmentGoodEvil(oPC);


        switch (iEffect)
        {
            case 1: //ALIGNMENT_NEUTRAL:
                iEffect =  1851;
                break;
            case 4: //ALIGNMENT_GOOD:
                iEffect =  902;
                break;

            case 5: //ALIGNMENT_EVIL:
                iEffect =  939;
                break;
           default:
                iEffect = 1851;
        }
        effect eVisual = EffectVisualEffect(iEffect);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVisual,oPC);

}
