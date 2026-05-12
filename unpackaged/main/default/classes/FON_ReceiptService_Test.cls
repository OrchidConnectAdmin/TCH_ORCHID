@IsTest
public class FON_ReceiptService_Test {
    
    public static boolean isInstalled = false;
    public static void install(){
        if (!isInstalled) {
            //Fon_PackageScripts.install();
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            
            // Create a routing rule for Contact
            Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            Framework.RoutingRule cons = new Framework.RoutingRule();
            cons.apexClass = FON_ReceiptTrigger.class.getName();
            cons.namespace = '';
            cons.isEnabled = true;
            cons.sObjectName = 'OrderApi__Receipt__c';
            cons.executionOrder = 0;
            rules.add(cons);
            Framework.Config.push(rules);               
            
            isInstalled = true;
            
        }
    }
    
    @isTest
    public static void testMethod1(){
        
        
        
        Contact con = Fon_TestDataFactory.createContact('salesOrder','ContactTest');
        con.Email = 'ppContact@test.com';
        con.OrderApi__Badges__c = 'Enterprise Elite Badge';
        insert con;  
        
        ProgramApi__Program__c pp = new ProgramApi__Program__c();
        pp.Name = 'NCP';
         pp.ProgramApi__Entity__c = 'Contact';
        insert pp;
        
        
        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = 'NCP Session Application Fee';
        itm.ProgramApi__Program__c = pp.Id;
        itm.Is_NCP_Filing_Fee__c = true;
        insert itm;
        
        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        //so.OrderApi__Account__c = acc.Id;
        so.OrderApi__Contact__c = con.Id;
        insert so;
        
        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
        sol.OrderApi__Item__c = itm.Id;
        sol.OrderApi__Sales_Order__c = so.Id;
        //sol.OrderApi__Account__c = acc.Id;
        sol.OrderApi__Contact__c = con.Id;
        insert sol;
        
        install();
        OrderApi__Receipt__c rec = new OrderApi__Receipt__c();
        rec.OrderApi__Contact__c = con.Id;
        rec.OrderApi__Sales_Order__c = so.Id;
        insert rec;
        
        OrderApi__Receipt_Line__c rl = new OrderApi__Receipt_Line__c();
        rl.OrderApi__Receipt__c = rec.Id;
        rl.OrderApi__Item__c = itm.Id;
        insert rl;
        
        
        
        rec.OrderApi__Is_Posted__c = true;
        rec.OrderApi__Total__c = 0;
        update rec;
        
    }
    
}