// -----------------------------------------------------------------------------
//  sj_rgb_x
// -----------------------------------------------------------------------------
/*
    Temporary library for Sunjammer's RGB Color Library containing functions
    which are part of the SJ Framework's Core library.

    If when you install the SJ Framework this file can be removed and the
    reference in sj_rgb_i replaced with a reference to sj_core_i.
*/
// -----------------------------------------------------------------------------
/*
    Version 0.01 - 14 May 2006 - Sunjammer
    - created
*/
// -----------------------------------------------------------------------------

// Restricts a value to a specified range. Returns the original value if it is
// within the specified range or the upper/lower bound if it is not.
//  - nValue:           value to be restricted
//  - nLower:           lower bound
//  - nUpper:           upper bound
//  * Returns:          nValue, nLower or nUpper
int RestrictIntToRange(int nValue, int nLower, int nUpper);
int RestrictIntToRange(int nValue, int nLower, int nUpper)
{
    if(nValue < nLower) return nLower;
    if(nValue > nUpper) return nUpper;
    return nValue;
}



