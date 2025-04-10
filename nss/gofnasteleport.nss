void TransportAssociate(object target,object wp)
{
    object associate = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,target);
    DelayCommand(1.0,AssignCommand(associate,JumpToObject(wp)));

    associate = GetAssociate(ASSOCIATE_TYPE_FAMILIAR,target);
    DelayCommand(1.0,AssignCommand(associate,JumpToObject(wp)));

    associate = GetAssociate(ASSOCIATE_TYPE_SUMMONED,target);
    DelayCommand(1.0,AssignCommand(associate,JumpToObject(wp)));

    associate = GetAssociate(ASSOCIATE_TYPE_DOMINATED,target);
    DelayCommand(1.0,AssignCommand(associate,JumpToObject(wp)));

    int i = 1;
    associate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,target,i++);
    while(GetIsObjectValid(associate))
    {
        DelayCommand(1.0,AssignCommand(associate,JumpToObject(wp)));
        associate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,target,i++);
    }
}
void main()
{
    string tag = GetLocalString(OBJECT_SELF,"Destination");
    object wp = GetObjectByTag(tag);
    object target = GetPCSpeaker();
    if(GetArea(OBJECT_SELF) == GetArea(wp))
    {
        AssignCommand(target,FadeToBlack(target,FADE_SPEED_FASTEST));
        AssignCommand(target,DelayCommand(3.0,FadeFromBlack(target,FADE_SPEED_FASTEST)));
        AssignCommand(target,TransportAssociate(target,wp));
    }
    AssignCommand(target,JumpToObject(wp));
}

