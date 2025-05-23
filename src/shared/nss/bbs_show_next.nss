#include "bbs_include"

int StartingConditional()
{
  object oBBS = GetLocalObject(GetModule(), "BBS_" + GetTag(OBJECT_SELF));
  int PageSize = GetLocalInt(oBBS, "PageSize");
  int PageIndex = GetLocalInt(GetPCSpeaker(), "PageIndex");
  int TotalItems = getFilterItems(oBBS);
  if (TotalItems > (PageIndex + 1) * PageSize) {
    return TRUE;
  }
  return FALSE;
}
