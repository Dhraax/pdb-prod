void main()
{
     if(GetCommandable(OBJECT_SELF))
          {
               {
               BeginConversation();
               }
          ClearAllActions();
          int nChair = 1;
          string sMyTagName = GetTag(OBJECT_SELF);
          string sSittableTagName = "SILLA_" + sMyTagName;
          object oChair = GetNearestObjectByTag(sSittableTagName,
OBJECT_SELF, nChair);
          ActionSit(oChair);
          }
}

