void main()
{
//::////////////////////////////////////////////////////////////////////////:://
/*SCRIPT PARA AGACHAR A PNJs, SITUALO EN EL ONCONVERSATION DEL PNJ*/
//::////////////////////////////////////////////////////////////////////////:://
if(GetCommandable(OBJECT_SELF))
{
  {
   BeginConversation();
  }
ClearAllActions();

AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 0.0,999999999999999.9));
}
}

