void main()
{
    object oPC = GetExitingObject();

    // -------------------------------------------------------------------------
    // Project Q - Phenotype Log Off Fix
    //--------------------------------------------------------------------------
    // Reset the PC's base phenotype - ignores Normal, Large, Mounted Normal,
    // and Mounted Large phenotypes

    int nCurrPheno = GetPhenoType(oPC);
    int nBasePheno = GetLocalInt(oPC, "Q_BASE_PHENOTYPE");
    if (nCurrPheno > 5)
    {
        SetPhenoType(nBasePheno, oPC);
    }
    //--------------------------------------------------------------------------
}
