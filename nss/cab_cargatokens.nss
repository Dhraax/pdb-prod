int StartingConditional()
{
  string sStockPin = IntToString(GetLocalInt(OBJECT_SELF, "STOCKPIN"));
  string sStockTej = IntToString(GetLocalInt(OBJECT_SELF, "STOCKTEJ"));
  string sStockJab = IntToString(GetLocalInt(OBJECT_SELF, "STOCKJAB"));
  string sStockEsc = IntToString(GetLocalInt(OBJECT_SELF, "STOCKESC"));
  string sStockPon = IntToString(GetLocalInt(OBJECT_SELF, "STOCKPON"));
  string sStockBue = IntToString(GetLocalInt(OBJECT_SELF, "STOCKBUE"));
  string sStockCab = IntToString(GetLocalInt(OBJECT_SELF, "STOCKCAB"));
  string sStockCam = IntToString(GetLocalInt(OBJECT_SELF, "STOCKCAM"));
  string sStockOso = IntToString(GetLocalInt(OBJECT_SELF, "STOCKOSO"));

  SetCustomToken(491, sStockPin);
  SetCustomToken(492, sStockTej);
  SetCustomToken(493, sStockJab);
  SetCustomToken(494, sStockEsc);
  SetCustomToken(495, sStockPon);
  SetCustomToken(496, sStockBue);
  SetCustomToken(497, sStockCab);
  SetCustomToken(498, sStockCam);
  SetCustomToken(499, sStockOso);

  return TRUE;
}
