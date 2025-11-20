public class FON_ContactFilterCls {
    List <Contact> PBcon {get;set;}
    List <Contact> Bcon {get;set;}
    List <Contact> SMcon {get;set;}
    List <Contact> SMrepcon {get;set;}
    List <Contact> Oppsconalt {get;set;}
    List <Contact> LPCcon {get;set;}
    List <Contact> LPRcon {get;set;}
    List <Contact> BusComMaincon {get;set;}
    List <Contact> BusComAltcon {get;set;}
    List <Contact> MainOpscon {get;set;}
    public List <Contact>  GetPBcon() {
        PBcon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_Is_Primary_Billing_Contact__c = true];
        return PBcon; 
    }
    public List <Contact>  GetBcon() {
        Bcon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_Is_Billing_Contact__c = true];
        return Bcon; 
    }
    public List <Contact>  GetSMcon() {
        SMcon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_SM_Coordinator__c = true];
        return SMcon;

    }
    public List <Contact>  GetSMrepcon() {
        SMrepcon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_SM_Representative__c = true];
        return SMrepcon;

    }
    public List <Contact>  GetOppsconalt() {
        Oppsconalt= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_Ops_Committee_Alternate__c = true];
        return Oppsconalt;

    }
    public List <Contact>  GetLPCcon() {
        LPCcon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_LP_Coordinator__c = true];
        return LPCcon;

    }
    public List <Contact>  GetLPRcon() {
        LPRcon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_LP_Representative__c = true];
        return LPRcon;

    }
    public List <Contact>  GetBusComMaincon() {
        BusComMaincon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_Is_Main_Business_Committee_Contact__c = true];
        return BusComMaincon;

    }
    public List <Contact>  GetBusComAltcon() {
        BusComAltcon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_Is_Business_Committee_Alternate__c = true];
        return BusComAltcon;

    }
    public List <Contact>  GetMainOpscon() {
        MainOpscon= [select Id, name, email, phone, title from contact where Accountid = :ApexPages.currentPage().getParameters().get('id') AND FON_Is_Main_Operations_Committee_Contact__c = true];
        return MainOpscon;

    }
    
}