//:::::::::::::::::::::::::\\
//:: Created By: Lincoln ::\\
//::     AKA: Killa      ::\\
//:::::::::::::::::::::::::\\
void Sitable(object sit)
{
object PC = GetSittingCreature(sit);
if (PC != OBJECT_INVALID){
   DestroyObject(sit);
   sit = CopyObject(sit,GetLocation(sit),OBJECT_INVALID);}
}
void main()
{
object Player = GetLastUsedBy();
object Bench = OBJECT_SELF;
object sit1 = GetLocalObject(OBJECT_SELF,"sit 1");
object sit2 = GetLocalObject(OBJECT_SELF,"sit 2");
object sit3 = GetLocalObject(OBJECT_SELF,"sit 3");
object sit4 = GetLocalObject(OBJECT_SELF,"sit 4");
object sit5 = GetLocalObject(OBJECT_SELF,"sit 5");
if(!GetIsObjectValid(sit1)){
object Area = GetArea(Bench);
vector locBench = GetPosition(Bench);
float Orient = GetFacing(Bench);
float Space = 0.7;
float Space2 = 1.4;
location locsit1 = Location(Area,locBench + AngleToVector(Orient + 90.0f ) * Space,Orient);
location locsit2 = Location(Area,locBench + AngleToVector(Orient + 90.0f ) * Space2,Orient);
location locsit3 = Location(Area,locBench + AngleToVector(Orient - 90.0f ) * Space2,Orient);
location locsit4 = Location(Area,locBench + AngleToVector(Orient - 90.0f ) * Space,Orient);
location locsit5 = Location(Area,locBench,Orient);
   sit1 = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_invisobj",locsit1);
   sit2 = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_invisobj",locsit2);
   sit3 = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_invisobj",locsit3);
   sit4 = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_invisobj",locsit4);
   sit5 = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_invisobj",locsit5);
   SetLocalObject(OBJECT_SELF,"sit 1",sit1);
   SetLocalObject(OBJECT_SELF,"sit 2",sit2);
   SetLocalObject(OBJECT_SELF,"sit 3",sit3);
   SetLocalObject(OBJECT_SELF,"sit 4",sit4);
   SetLocalObject(OBJECT_SELF,"sit 5",sit5);}
int Distance = 1;
object sit = GetNearestObjectByTag("InvisibleObject",Player,Distance);
int Count = 0;
while(GetIsObjectValid(sit) || Count < 5 ){
if( sit == sit1 || sit == sit2 || sit == sit3|| sit == sit4|| sit == sit5 ) {
   Count = Count + 1 ;
   Sitable(sit);
if( !GetIsObjectValid( GetSittingCreature(sit))){
   AssignCommand(Player,ActionSit(sit));
return;}
}
   Distance = Distance + 1;
   sit = GetNearestObjectByTag("InvisibleObject",Player,Distance );}
}
