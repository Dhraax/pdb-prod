void main()
{
//::////////////////////////////////////////////////////////////////////////:://
/*SCRIPT PARA SENTER EN EL SUELO A PNJs, SITUALO EN EL ONCONVERSATION DEL PNJ*/
//::////////////////////////////////////////////////////////////////////////:://
if(GetCommandable(OBJECT_SELF))
{
  {
   BeginConversation();
  }
ClearAllActions();

AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 0.0,999999999999999.9));
}
}
