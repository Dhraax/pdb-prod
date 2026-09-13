/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_persist_inc
//
//  Desc:  These functions are collected together to
//         facilitate interfacing to a persistent database.
//
//  Author: David Bobeck 20Apr03
/// modified by: Dhraax
//
/////////////////////////////////////////////////////////

// #include "your_persistent_db_inc_here"
// Note: no include is required to use Bioware's database.
// #include "aps_include"
 
#include "nwnx_sql"
#include "mti_libreria"
#include "cnr_i_skill"

// CNR defined return codes for CnrSQLFetch()
int CNR_SQL_ERROR = 0;
int CNR_SQL_SUCCESS = 1;

/////////////////////////////////////////////////////////
void CnrSetPersistentInt(object oHost, string sVarName, int nValue)
{
    // Solo se persiste la XP de oficios. El resto del estado que la CNR
    // original guardaba aqui (stock de mercader, XP de lider, flags de
    // dispositivo) no se usa en PDB y se descarta en silencio a proposito.
    if (GetStringLeft(sVarName, 16) != "CnrTradeskillXP_")
    {
        return;
    }

    int nSkill = StringToInt(GetStringRight(sVarName, GetStringLength(sVarName) - 16));

    // oHost es el contenedor de variables; el personaje es su poseedor.
    object oPC = GetItemPossessor(oHost);
    if (!GetIsObjectValid(oPC))
    {
        oPC = oHost;
    }

    CnrSkill_SetXP(oPC, nSkill, nValue);
}
 
/////////////////////////////////////////////////////////
int CnrGetPersistentInt(object oHost, string sVarName)
{
    if (GetStringLeft(sVarName, 16) != "CnrTradeskillXP_")
    {
        return 0;
    }

    int nSkill = StringToInt(GetStringRight(sVarName, GetStringLength(sVarName) - 16));

    object oPC = GetItemPossessor(oHost);
    if (!GetIsObjectValid(oPC))
    {
        oPC = oHost;
    }

    return CnrSkill_GetXP(oPC, nSkill);
}
 
/////////////////////////////////////////////////////////
void CnrSetPersistentFloat(object oHost, string sVarName, float fValue)
{
  // Change this function call to whatever function 
  // should be called from the above include file
  // for storing Floats in your Database

  // uncomment the following line for NO database support
  //SetLocalFloat(oHost, sVarName, fValue);

  // uncomment the following line for Bioware database support
  SetCampaignFloat("cnr_misc", sVarName, fValue, oHost);

  // uncomment the following line for APS database support
  //SetPersistentFloat(oHost, sVarName, fValue, 0, "cnr_misc");
}
 
/////////////////////////////////////////////////////////
float CnrGetPersistentFloat(object oHost, string sVarName)
{
  // Change this function call to whatever function 
  // should be called from the above include file
  // for retrieving Floats from your Database

  // uncomment the following line for NO database support
  //return GetLocalFloat(oHost, sVarName);

  // uncomment the following line for Bioware database support
  return GetCampaignFloat("cnr_misc", sVarName, oHost);

  // uncomment the following line for APS database support
  //return GetPersistentFloat(oHost, sVarName, "cnr_misc");
}
 
/////////////////////////////////////////////////////////
void CnrSetPersistentString(object oHost, string sVarName, string sValue)
{
  // Change this function call to whatever function 
  // should be called from the above include file
  // for storing Strings in your Database   

  // uncomment the following line for NO database support
  //SetLocalString(oHost, sVarName, sValue);

  // uncomment the following line for Bioware database support
  SetCampaignString("cnr_misc", sVarName, sValue, oHost);

  // uncomment the following line for APS database support
  //SetPersistentString(oHost, sVarName, sValue, 0, "cnr_misc");
}
 
/////////////////////////////////////////////////////////
string CnrGetPersistentString(object oHost, string sVarName)
{
  // Change this function call to whatever function 
  // should be called from the above include file
  // for retrieving Strings from your Database   

  // uncomment the following line for NO database support
  //return GetLocalString(oHost, sVarName);

  // uncomment the following line for Bioware database support
  return GetCampaignString("cnr_misc", sVarName, oHost);

  // uncomment the following line for APS database support
  //return GetPersistentString(oHost, sVarName, "cnr_misc");
}

/////////////////////////////////////////////////////////
void CnrSQLExecDirect(string sSQL)
{
  // If you're using APS, uncomment the following line
  //SQLExecDirect(sSQL);
}
 
/////////////////////////////////////////////////////////
int CnrSQLFetch()
{
  // If you're using APS, comment out the following line
  return CNR_SQL_ERROR;

  // If you're using APS, uncomment the following line
  //return SQLFetch();
}

/////////////////////////////////////////////////////////
string CnrSQLGetData(int iCol)
{
  // If you're using APS, comment out the following line
  return "";

  // If you're using APS, uncomment the following line
  //return SQLGetData(iCol);
}
