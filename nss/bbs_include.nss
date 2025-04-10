//void main(){}
//BULLETIN BOARD SYSTEM VERSION 1.1

//This is an include file. Upon building your module you will get
//a compile error in this file. That is normal and does not
//affect the operation of the bulletin board.

void bbs_do_board_stats();
void bbs_initiate(object oBBS);
int bbs_can_show(int WhichEntry);
void bbs_change_page(int PageChange);
void bbs_select_entry(int WhichEntry);
void bbs_add_notice(object oBBS, string sPoster, string sTitle, string sMessage, string sDate, string sBBStag = "", string sRegion = "");
int getFilterItems(object oBBS);

//Loads into tokens the stats for a board
void bbs_do_board_stats() {
  object oBBS = GetLocalObject(GetModule(), "BBS_" + GetTag(OBJECT_SELF));
  int PageSize = GetLocalInt(oBBS, "PageSize");
  int PageIndex = GetLocalInt(GetPCSpeaker(), "PageIndex") + 1;
  int TotalItems = getFilterItems(oBBS);

  SetCustomToken(3671, IntToString(TotalItems));
  if (TotalItems == 0) {PageIndex = 0;}
  SetCustomToken(3672, IntToString(PageIndex));
  SetCustomToken(3673, IntToString((TotalItems + PageSize - 1) / PageSize));
}

int getFilterItems(object oBBS) {
  int totalItems = GetCampaignInt("DB_BBS",GetTag(oBBS)+"#C");
  int selectItem = GetCampaignInt("DB_BBS",GetTag(oBBS)+"#L");
  string sCity = GetLocalString(oBBS, "City");
  string sRegion = GetLocalString(oBBS, "Region");

  int iFilter = 0;
  int i = 1;

  //Borramos todas las variables locales antes de establecer los datos correctos.
  while (i <= totalItems) {
    DeleteLocalString(oBBS, "#P"+IntToString(i));
    DeleteLocalString(oBBS, "#D"+IntToString(i));
    DeleteLocalString(oBBS, "#T"+IntToString(i));
    DeleteLocalString(oBBS, "#M"+IntToString(i));
    DeleteLocalInt(oBBS, "#S"+IntToString(i));
    i++;
  }

  //Establecemos los datos correctos.
  i = 1;
  while (i <= totalItems) {
    string sPla = GetCampaignString("DB_BBS", GetTag(oBBS)+"#P"+IntToString(selectItem));
    string sDat = GetCampaignString("DB_BBS", GetTag(oBBS)+"#D"+IntToString(selectItem));
    string sTit = GetCampaignString("DB_BBS", GetTag(oBBS)+"#T"+IntToString(selectItem));
    string sDes = GetCampaignString("DB_BBS", GetTag(oBBS)+"#M"+IntToString(selectItem));
    string sReg = GetCampaignString("DB_BBS", GetTag(oBBS)+"#R"+IntToString(selectItem));
    int iHide = GetCampaignInt("DB_BBS", GetTag(oBBS)+"#A"+IntToString(selectItem));
    if(selectItem < 10) {
        sReg = GetCampaignString("DB_BBS", GetTag(oBBS)+"#R0"+IntToString(selectItem));
        iHide = GetCampaignInt("DB_BBS", GetTag(oBBS)+"#A0"+IntToString(selectItem));
    }
    if(sReg == sCity || sReg == sRegion) {
        iFilter++;
        SetLocalString(oBBS, "#P"+IntToString(iFilter), sPla);
        SetLocalString(oBBS, "#D"+IntToString(iFilter), sDat);
        SetLocalString(oBBS, "#T"+IntToString(iFilter), sTit);
        SetLocalString(oBBS, "#M"+IntToString(iFilter), sDes);
        SetLocalInt(oBBS, "#S"+IntToString(iFilter), selectItem);
        SetLocalInt(oBBS, "#A"+IntToString(iFilter), iHide);
    }
    selectItem++;
    if(selectItem > totalItems) selectItem = 1;
    i++;
  }

  return iFilter;
}

int ponerAnonimo(object oBBS) {
    object oPC = GetPCSpeaker();
    if(GetStealthMode(oPC) == STEALTH_MODE_DISABLED) return 0;
    int iAvistar = GetLocalInt(oBBS, "Avistar")+d20();
    int iEsconderse = GetSkillRank(SKILL_HIDE, oPC)+d20();

    if(iEsconderse > iAvistar) {
        return 1;
    } else {
        return 0;
    }
}

//Initiates a bulletin board's settings if neccessary
void bbs_initiate(object oBBS) {
  string sBBS = "BBS_" + GetTag(oBBS);
  object myBBS = GetLocalObject(GetModule(), sBBS);
  if (!GetIsObjectValid(myBBS)) {
    SetLocalObject(GetModule(), sBBS, oBBS);
    myBBS = oBBS;
    //MaxItems is the maximum number of messages
    SetLocalInt(myBBS, "MaxItems", 100);
    //PageSize is the number of entries per page, between 1 and 10
    SetLocalInt(myBBS, "PageSize", 5);
  }
  SetLocalString(myBBS, "City", GetLocalString(oBBS, "CIT"));
  SetLocalString(myBBS, "Region", GetLocalString(oBBS, "REG"));
  SetLocalInt(myBBS, "Avistar", GetLocalInt(oBBS, "AVI"));
}

//Determines whether a dialogue option is visible in conversation
int bbs_can_show(int WhichEntry) {
  object oBBS = GetLocalObject(GetModule(), "BBS_" + GetTag(OBJECT_SELF));
  int PageSize = GetLocalInt(oBBS, "PageSize");
  int nTotal = getFilterItems(oBBS);
  int nSpot = GetLocalInt(GetPCSpeaker(), "PageIndex") * PageSize + WhichEntry;

  if(nSpot <= nTotal && WhichEntry <= PageSize) {return TRUE;}
  return FALSE;
}

//Moves the page by the required PageFlip:
//0 to reload page, -1 for previous page, 1 for next page
void bbs_change_page(int PageFlip) {
  object oBBS = GetLocalObject(GetModule(), "BBS_" + GetTag(OBJECT_SELF));
  int PageSize = GetLocalInt(oBBS, "PageSize");
  int MaxItems = GetLocalInt(oBBS, "MaxItems");
  int TotalItems = getFilterItems(oBBS);

  int PageIndex = GetLocalInt(GetPCSpeaker(), "PageIndex") + 1 * PageFlip;
  if (PageIndex < 0) {PageIndex = 0;}
  SetLocalInt(GetPCSpeaker(), "PageIndex", PageIndex);
  SetLocalString(GetPCSpeaker(),"PostAuthor","");

  string sInfo;
  int iLoop;
  int iNotice;
  int iHide;

  for (iLoop = 0; iLoop < PageSize; iLoop++) {
    iNotice = 1 - PageIndex * PageSize - iLoop;
    if (iNotice < 1) {iNotice = TotalItems + iNotice;}
    sInfo = GetLocalString(oBBS, "#T"+IntToString(iNotice));
    SetCustomToken(3680 + iLoop, sInfo);
    iHide = GetLocalInt(oBBS, "#A"+IntToString(iNotice));
    if(GetIsDM(GetPCSpeaker())) iHide = 0;

    if(iHide == 0) {
        sInfo = GetLocalString(oBBS, "#P"+IntToString(iNotice));
    } else {
        sInfo = "Anónimo";
    }
    if (((PageIndex * PageSize + iLoop + 2) > TotalItems) || (iLoop == PageSize - 1)){
      sInfo = sInfo + "\n ";
    }
    SetCustomToken(3690 + iLoop, sInfo);
  }
  bbs_do_board_stats();
  SetCustomToken(3674, "");
  SetCustomToken(3675, "");
  SetCustomToken(3676, "");
  SetCustomToken(3677, "");
  SetCustomToken(3678, "");
}

//Displays the selected post
void bbs_select_entry(int WhichEntry) {
  object oBBS = GetLocalObject(GetModule(), "BBS_" + GetTag(OBJECT_SELF));
  int PageSize = GetLocalInt(oBBS, "PageSize");
  int MaxItems = GetLocalInt(oBBS, "MaxItems");
  int TotalItems = getFilterItems(oBBS);

  //int LatestItem = GetCampaignInt("DB_BBS",GetTag(oBBS)+"#L");
  int PageIndex = GetLocalInt(GetPCSpeaker(), "PageIndex");

  int iNotice = 1 - PageIndex * PageSize - WhichEntry + 1;
  if (iNotice < 1) {iNotice = TotalItems + iNotice;}

  SetLocalInt(GetPCSpeaker(),"CurrentEntry",GetLocalInt(oBBS, "#S"+IntToString(iNotice)));
  string sNotice = IntToString(GetLocalInt(oBBS, "#S"+IntToString(iNotice)));
  string sAuthor = GetCampaignString("DB_BBS",GetTag(oBBS)+"#P" + sNotice);
  int iHide = GetLocalInt(oBBS, "#A"+IntToString(iNotice));
  if(GetIsDM(GetPCSpeaker())) iHide = 0;

  SetLocalString(GetPCSpeaker(),"PostAuthor",sAuthor);
  bbs_do_board_stats();
  SetCustomToken(3674, "\n\n" + GetCampaignString("DB_BBS",GetTag(oBBS)+"#T" + sNotice) + "\nBy: ");
  if(iHide == 0) {
      SetCustomToken(3675, sAuthor);
  } else {
      SetCustomToken(3675, "Anónimo");
  }
  SetCustomToken(3676, "     On: ");
  SetCustomToken(3677, GetCampaignString("DB_BBS",GetTag(oBBS)+"#D" + sNotice));
  SetCustomToken(3678, "\n" + GetCampaignString("DB_BBS",GetTag(oBBS)+"#M" + sNotice));
}

//Adds a post to the bulletin board. This can be called at any time
//so you can insert your own notices. If you don't specify a sDate,
//it will use the current game time. The proper format for sDate is
//something like "6/30/1373 11:58". The last two lines write code to
//the log file for restoring the messages after a module edit.
void bbs_add_notice(object oBBS, string sPoster, string sTitle, string sMessage, string sDate, string sBBStag = "", string sRegion = "")
{
  int iHide = ponerAnonimo(oBBS);
  if (sBBStag != "") {oBBS = GetObjectByTag(sBBStag);}
  bbs_initiate(oBBS);
  oBBS = GetLocalObject(GetModule(), "BBS_" + GetTag(oBBS));
  if (sDate == "") {
    sDate = IntToString(GetTimeMinute());
    if (GetStringLength(sDate) == 1) {sDate = "0" + sDate;}
    sDate = IntToString(GetCalendarMonth()) + "/" + IntToString(GetCalendarDay()) + "/" + IntToString(GetCalendarYear()) + " " + IntToString(GetTimeHour()) + ":" + sDate;
  }
  int MaxItems = GetLocalInt(oBBS, "MaxItems");
  int TotalItems = GetCampaignInt("DB_BBS",GetTag(oBBS)+"#C");
  int nSpot = TotalItems + 1;
  if (nSpot > MaxItems)
  {
    nSpot = GetCampaignInt("DB_BBS",GetTag(oBBS)+"#L") +1;
    if (nSpot > MaxItems) nSpot = nSpot - MaxItems;
  }
  SetCampaignString("DB_BBS",GetTag(oBBS)+"#P" + IntToString(nSpot), sPoster);
  SetCampaignString("DB_BBS",GetTag(oBBS)+"#D" + IntToString(nSpot), sDate);
  SetCampaignString("DB_BBS",GetTag(oBBS)+"#T" + IntToString(nSpot), sTitle);
  SetCampaignString("DB_BBS",GetTag(oBBS)+"#M" + IntToString(nSpot), sMessage);
  if(nSpot < 10) {
    SetCampaignString("DB_BBS",GetTag(oBBS)+"#R0" + IntToString(nSpot), sRegion);
    SetCampaignInt("DB_BBS",GetTag(oBBS)+"#A0" + IntToString(nSpot), iHide);
  } else {
    SetCampaignString("DB_BBS",GetTag(oBBS)+"#R" + IntToString(nSpot), sRegion);
    SetCampaignInt("DB_BBS",GetTag(oBBS)+"#A" + IntToString(nSpot), iHide);
  }
  SetCampaignInt("DB_BBS",GetTag(oBBS)+"#L", nSpot);
  if (MaxItems > TotalItems)
    SetCampaignInt("DB_BBS",GetTag(oBBS)+"#C", TotalItems + 1);

  string sQuote = GetSubString(GetStringByStrRef(464), 13, 1);
  //PrintString("bbs_add_notice(OBJECT_SELF, " + sQuote + sPoster + sQuote + ", " + sQuote + sTitle + sQuote + ", " + sQuote + sMessage + sQuote + ", " + sQuote + sDate + sQuote + ", " + sQuote + GetTag(oBBS) + sQuote + "); //:::BBS:::");
}


void bbs_delete_entry() {
  int CurrentEntry = GetLocalInt(GetPCSpeaker(), "CurrentEntry");
  object oBBS = GetLocalObject(GetModule(), "BBS_" + GetTag(OBJECT_SELF));
  int LatestItem = GetCampaignInt("DB_BBS",GetTag(oBBS)+"#L");
  int TotalItems = GetCampaignInt("DB_BBS",GetTag(oBBS)+"#C");
  int iLoop;
  int i;

  SetCampaignString("DB_BBS",GetTag(oBBS)+"#P" + IntToString(CurrentEntry), "---");
  SetCampaignString("DB_BBS",GetTag(oBBS)+"#D" + IntToString(CurrentEntry), "---");
  SetCampaignString("DB_BBS",GetTag(oBBS)+"#T" + IntToString(CurrentEntry), "*ARRANCADO*");
  SetCampaignString("DB_BBS",GetTag(oBBS)+"#M" + IntToString(CurrentEntry), "---");
  if(CurrentEntry < 10) {
    SetCampaignString("DB_BBS",GetTag(oBBS)+"#R0" + IntToString(CurrentEntry), "---");
    SetCampaignInt("DB_BBS",GetTag(oBBS)+"#A0" + IntToString(CurrentEntry), 0);
  } else {
    SetCampaignString("DB_BBS",GetTag(oBBS)+"#R" + IntToString(CurrentEntry), "---");
    SetCampaignInt("DB_BBS",GetTag(oBBS)+"#A" + IntToString(CurrentEntry), 0);
  }

  bbs_change_page(0);
}
