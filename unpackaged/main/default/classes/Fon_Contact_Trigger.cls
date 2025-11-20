/**
 *
 * Domain class for the Contact SObjectType
 * @author Sujitha Nandigam
 *
 **/

global class Fon_Contact_Trigger extends Framework.Domain{
    static boolean firstRun=false;
    public Fon_Contact_Trigger(List<Contact> sObjectList) {
        super(sObjectList);
    }

    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new Fon_Contact_Trigger(sObjectList);
        }
    }

   
    public override void afterUpdate(Map<Id,SObject> oldMap){
        Framework.Log.push(Fon_Contact_Trigger.class.getName(),'afterUpdate'); 
        if(!firstRun){
            Fon_Contact_Service.updateName((Contact []) records, (Map<Id,Contact>) oldMap);
            firstRun=true;
        }
        Framework.Log.pop();
    }
    
    public override void beforeUpdate(Map<Id,SObject> oldMap){
        Framework.Log.push(Fon_Contact_Trigger.class.getName(),'afterUpdate'); 
        Fon_Contact_Service.handleAuditEmail((Contact []) records, (Map<Id,Contact>) oldMap);
        Framework.Log.pop();
    }
    
 }