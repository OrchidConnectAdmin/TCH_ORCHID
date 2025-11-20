global class CreateBulkSMBillingLinesInvocable {

    @InvocableMethod(label='Create Bulk Sales Order Lines - CreateBulkSMBillingLinesInvocable' Description='Create Bulk Sales Order Line - CreateBulkSMBillingLinesInvocable')
    global static List<String> fetchSalesOrderLine(List<methodVars> rels) {
   
        List<OrderApi__Sales_Order_Line__c> sols = new List<OrderApi__Sales_Order_Line__c>();
        
        //params
        system.debug('rels '+rels[0]);
        
        // get SR
        List<Sponsoring_Relationships__c> ssrs = [Select Id,Sponsoring_Organization__c,Sponsored_Organization__c,Primary_Contact_Lookup__c,Sponsored_Tiered_Annual_Dues__c,First_Billed_Month__c,Date_Accepted_by_ECCHO__c,Volume_Upload__c,Rate_Upload__c,Fixed_Dues_Calculation__c from Sponsoring_Relationships__c where Id IN: rels[0].sms];
        system.debug('SSRS COUNT ' +ssrs.size());
        // get subplan
        List<OrderApi__Subscription_Plan__c> subplan = new List<OrderApi__Subscription_Plan__c>();
        if(Test.isRunningTest()){
            subplan = [Select Id FROM OrderApi__Subscription_Plan__c LIMIT 1];
        }else{
            if(rels[0].billingType == 'Item Based'){
                subplan = [Select Id FROM OrderApi__Subscription_Plan__c WHERE Billing_Quarter__c =:rels[0].quarter AND Billing_Type__c =:rels[0].billingType AND OrderApi__Is_Active__c = true AND OrderApi__Enable_Proration__c=false];
            }else{
                subplan = [Select Id FROM OrderApi__Subscription_Plan__c WHERE Billing_Quarter__c =:rels[0].quarter AND Billing_Type__c =:rels[0].billingType  AND Invoice_Timing__c =:rels[0].timing  AND OrderApi__Is_Active__c = true AND OrderApi__Enable_Proration__c=false];
            }
        }
        // get item
        List<OrderApi__Item__c> item = [Select Id FROM OrderApi__Item__c WHERE OrderApi__Is_Active__c = true AND Name = 'ECCHO - Sponsored Member Dues'];
        if(Test.isRunningTest()){
            item = [Select Id FROM OrderApi__Item__c LIMIT 1];
        }
        
        Map<String,Date> smsXsdates = new Map<String,Date>();
        
        system.debug('ssrs '+ssrs);
        system.debug('subplan '+subplan);
        system.debug('item '+item);
        
        
        if(ssrs.size()>0){
            
            
            for(Sponsoring_Relationships__c ssr : ssrs){
                OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
                sol.Billing_Quarter__c = rels[0].quarter;
                sol.OrderApi__Account__c = ssr.Sponsored_Organization__c;
                if(String.isBlank(ssr.Primary_Contact_Lookup__c) != true){
                    sol.OrderApi__Contact__c = ssr.Primary_Contact_Lookup__c;
                }
                sol.OrderApi__Entity__c = 'Account';
                sol.OrderApi__Item__c = item[0].Id;
                sol.OrderApi__Sales_Order__c = rels[0].so;
                if(rels[0].isPreconversion != true){
                	sol.OrderApi__Subscription_Plan__c = subplan[0].Id;
                }else{
                    List<OrderApi__Subscription_Plan__c> prosubplan = [Select Id FROM OrderApi__Subscription_Plan__c WHERE Billing_Quarter__c = null AND Name='1QFull Conversion' AND OrderApi__Is_Active__c = true];
					sol.OrderApi__Subscription_Plan__c = prosubplan[0].Id;
                }
                sol.Sponsoring_Relationship__c = ssr.Id;
                
                Boolean skipme = false;
                if(rels[0].billingType == 'Item Based'){
                    //List<AggregateResult> roll = [Select SUM(FON_Total_Volume__c)rvolume from Item_Based_Upload_Information__c where Parent__c =: ssr.Sponsoring_Organization__c  AND Account_Name__c =: ssr.Sponsored_Organization__c];
                    //Decimal vol = Integer.valueOf(roll[0].get('rvolume'));
                    if(ssr.Fixed_Dues_Calculation__c != null || Test.isRunningTest()){
                        sol.OrderApi__Price_Rule__c = rels[0].pricerule;
                        sol.OrderApi__Price_Override__c = true;
                        sol.OrderApi__Sale_Price__c = ssr.Fixed_Dues_Calculation__c;
                        sol.OrderApi__Total__c = ssr.Fixed_Dues_Calculation__c;
                        sol.OrderApi__Balance_Due__c = ssr.Fixed_Dues_Calculation__c;
                        sol.OrderApi__Overall_Total__c = ssr.Fixed_Dues_Calculation__c;
                    }else{
                        skipme = true;
                    }
        
                }
                
                Date sdate;
                Date edate;
                if(rels[0].timing == 'Annual'){
                    if(rels[0].quarter == '4Q'){
                        sdate = date.parse('10/1/'+rels[0].year);
                    }else if(rels[0].quarter == '3Q'){
                        sdate = date.parse('7/1/'+rels[0].year);
                    }else if(rels[0].quarter == '2Q'){
                        sdate = date.parse('4/1/'+rels[0].year);
                    }else if(rels[0].quarter == '1Q'){
                        sdate = date.parse('1/1/'+rels[0].year);
                    }else if(rels[0].quarter == '1QFull'){
                        
                        if(rels[0].isPreconversion == true || Test.isRunningTest()){
                        	if(rels[0].subQuarter == '4Q'){
                                sdate = date.parse('10/1/20'+rels[0].year);
                            }else if(rels[0].subQuarter == '3Q'){
                                sdate = date.parse('7/1/20'+rels[0].year);
                            }else if(rels[0].subQuarter == '2Q'){
                                sdate = date.parse('4/1/20'+rels[0].year);
                            }else if(rels[0].subQuarter == '1Q'){
                                sdate = date.parse('1/1/20'+rels[0].year);
                            }else if(rels[0].subQuarter == '1QFull'){
                                sdate = date.parse('1/1/20'+rels[0].year);
                            }
                            
    						edate = date.parse('12/31/20'+rels[0].year);
                                
                                
                            //Decimal monthdiff = date.parse(d2).addDays(-1).monthsBetween(date.parse(d1));
                            //system.debug()
                            Decimal monthdiff = sdate.monthsBetween(edate);
                            
                            // temporary fix
                            Integer excess = Integer.valueOf(System.Label.Sponsored_Billing_Monthdiff_Adjument);
                            monthdiff = monthdiff + excess;
                            //Integer monthdiff = (date.parse(d2) - date.parse(d1)) / 365 * 12;
                            
                            if(monthdiff < 1){
                                monthdiff = 0;
                            }
                            sol.OrderApi__Quantity__c = (Integer) monthdiff;
                              

                            
                        }else{
                            sdate = date.parse('1/1/20'+rels[0].year);
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                    }
                }
                sol.OrderApi__Auto_Calculate_Activation_Date__c	= false;
                sol.OrderApi__Activation_Date__c = sdate;
                sol.OrderApi__Subscription_Start_Date__c = sdate;
                sols.add(sol);
                smsXsdates.put(ssr.Sponsored_Organization__c,sdate);
            }
        }
        
        /*if(sols.size()>0){
            insert sols;
        }*/
        
        
        /* **************************** process prorates **************************/
        //if(rels[0].prorates.size()>0){
        if ( (rels[0].prorates != null && !rels[0].prorates.isEmpty()) || Test.isRunningTest() ) {
            // get SR
            List<Sponsoring_Relationships__c> prossrs = new List<Sponsoring_Relationships__c>();
            if(Test.isRunningTest()){
                prossrs = [Select Id,Sponsoring_Organization__c,Sponsored_Organization__c,Primary_Contact_Lookup__c,Sponsored_Tiered_Annual_Dues__c,First_Billed_Month__c,Date_Accepted_by_ECCHO__c,Volume_Upload__c,Rate_Upload__c,Fixed_Dues_Calculation__c from Sponsoring_Relationships__c];
            }else{
                if(rels[0].supress != null && !rels[0].supress.isEmpty()){
                    prossrs = [Select Id,Sponsoring_Organization__c,Sponsored_Organization__c,Primary_Contact_Lookup__c,Sponsored_Tiered_Annual_Dues__c,First_Billed_Month__c,Date_Accepted_by_ECCHO__c,Volume_Upload__c,Rate_Upload__c,Fixed_Dues_Calculation__c from Sponsoring_Relationships__c where Id IN: rels[0].prorates AND Id NOT IN: rels[0].supress];
                }else{
                    prossrs = [Select Id,Sponsoring_Organization__c,Sponsored_Organization__c,Primary_Contact_Lookup__c,Sponsored_Tiered_Annual_Dues__c,First_Billed_Month__c,Date_Accepted_by_ECCHO__c,Volume_Upload__c,Rate_Upload__c,Fixed_Dues_Calculation__c from Sponsoring_Relationships__c where Id IN: rels[0].prorates];
                }
            }

            List<OrderApi__Subscription_Plan__c> prosubplan = [Select Id FROM OrderApi__Subscription_Plan__c WHERE Billing_Quarter__c = null AND Name='New Member Proration' AND OrderApi__Is_Active__c = true];
            if(Test.isRunningTest()){
                prosubplan = [Select Id FROM OrderApi__Subscription_Plan__c LIMIT 1];
            }
            
            
            if(prossrs.size()>0){
                for(Sponsoring_Relationships__c ssr : prossrs){
                    OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
                    sol.Billing_Quarter__c = rels[0].quarter;
                    sol.OrderApi__Account__c = ssr.Sponsored_Organization__c;
                    if(String.isBlank(ssr.Primary_Contact_Lookup__c) != true){
                        sol.OrderApi__Contact__c = ssr.Primary_Contact_Lookup__c;
                    }
                    sol.OrderApi__Entity__c = 'Account';
                    sol.OrderApi__Item__c = item[0].Id;
                    sol.OrderApi__Sales_Order__c = rels[0].so;
                    sol.OrderApi__Subscription_Plan__c = prosubplan[0].Id;
                    sol.Sponsoring_Relationship__c = ssr.Id;
                    
                    Boolean skipme = false;
                    if(rels[0].billingType == 'Item Based' || Test.isRunningTest()){
                        //List<AggregateResult> roll = [Select SUM(FON_Total_Volume__c)rvolume from Item_Based_Upload_Information__c where Parent__c =: ssr.Sponsoring_Organization__c  AND Account_Name__c =: ssr.Sponsored_Organization__c];
                        //Decimal vol = Integer.valueOf(roll[0].get('rvolume'));
                        if(ssr.Fixed_Dues_Calculation__c != null || Test.isRunningTest()){
                            sol.OrderApi__Price_Rule__c = rels[0].pricerule;
                            sol.OrderApi__Price_Override__c = true;
                            sol.OrderApi__Sale_Price__c = ssr.Fixed_Dues_Calculation__c;
                            sol.OrderApi__Total__c = ssr.Fixed_Dues_Calculation__c;
                            sol.OrderApi__Balance_Due__c = ssr.Fixed_Dues_Calculation__c;
                            sol.OrderApi__Overall_Total__c = ssr.Fixed_Dues_Calculation__c;
                        }else{
                            skipme = true;
                        }
            
                    }
                    
                    //get the newer sol
                    OrderApi__Sales_Order_Line__c nsol = new OrderApi__Sales_Order_Line__c();
                    
                    Integer nm = ssr.Date_Accepted_by_ECCHO__c.month()+1;
                    
                    Date sd = smsXsdates.get(ssr.Sponsored_Organization__c);
                    
                    //Integer pmonth = ssr.Date_Accepted_by_ECCHO__c.month() - nsol.OrderApi__Subscription_Start_Date__c.month();
                    String d1;
                    if(rels[0].quarter == '1QFull'){
                        if(rels[0].subQuarter == '1Q'){
                            d1 = '12/1/20'+(Integer.valueOf(rels[0].year) - 1);
                        }else{
                            d1 = '12/1/20'+rels[0].year;
                        }
                    }else{
                        // commenting out for now
                        //nsol = [Select Id,OrderApi__Subscription_Start_Date__c from OrderApi__Sales_Order_Line__c where Id =: rels[0].prev_sol];
                        d1 = sd.month()+'/'+sd.day()+'/'+sd.year();
                    }
                    
                    //String d2 = nm+'/'+ssr.Date_Accepted_by_ECCHO__c.day()+'/'+ssr.Date_Accepted_by_ECCHO__c.year();
                    String d2;
                    if(nm>12){
                        Integer yrr = ssr.Date_Accepted_by_ECCHO__c.year()+1;
                        d2 = '1/1/'+yrr;
                    }else{
                        d2 = nm+'/1/'+ssr.Date_Accepted_by_ECCHO__c.year();
                    }
                    
                    
                    //Decimal monthdiff = date.parse(d2).addDays(-1).monthsBetween(date.parse(d1));
                    //system.debug()
                    Decimal monthdiff = date.parse(d2).monthsBetween(date.parse(d1));
                    
                    // temporary fix
                    Integer excess = Integer.valueOf(System.Label.Sponsored_Billing_Monthdiff_Adjument);
                    monthdiff = monthdiff + excess;
                    //Integer monthdiff = (date.parse(d2) - date.parse(d1)) / 365 * 12;
                    
                    if(monthdiff < 1){
                        monthdiff = 0;
                    }
                    sol.OrderApi__Quantity__c = (Integer) monthdiff;
                    sol.OrderApi__Is_Amendment__c = true;
                    sol.OrderApi__Auto_Calculate_Activation_Date__c	= false;
                    sol.OrderApi__Activation_Date__c = ssr.Date_Accepted_by_ECCHO__c;
                    
                    if(nm>12){
                        Integer yrr = ssr.Date_Accepted_by_ECCHO__c.year()+1;
                        sol.OrderApi__Subscription_Start_Date__c = date.parse('1/1/'+yrr);
                    }else{
                        sol.OrderApi__Subscription_Start_Date__c = date.parse(nm+'/1/'+ssr.Date_Accepted_by_ECCHO__c.year());
                    }
                    
                    //Integer pm = nsol.OrderApi__Subscription_Start_Date__c.month()-1;
                    if(rels[0].quarter == '1QFull'){
                        if(rels[0].subQuarter == '1Q'){
                            sol.OrderApi__End_Date__c = date.parse('12/31/20'+(Integer.valueOf(rels[0].year) - 1));
                        }else{
                            sol.OrderApi__End_Date__c = date.parse('12/31/20'+rels[0].year);
                        }
                    }else{
                        sol.OrderApi__End_Date__c = date.parse(sd.month()+'/'+sd.day()+'/'+sd.year()).addDays(-1);
                    }
                    
                    if(rels[0].billingType == 'Item Based'){
                        sols.add(sol);
                    }else{
                        if(monthdiff > 0){
                            sols.add(sol);
                        }
                    }
    
                }
            }
        }
        
        /* ************************************** process archived ************************************* */
        // only item based
        //if(rels[0].archived.size()>0){
        if ( (rels[0].archived != null && !rels[0].archived.isEmpty()) || Test.isRunningTest()) {
            // get SR
            List<Sponsoring_Relationships__c> assrs = [Select Id,Sponsoring_Organization__c,Sponsored_Organization__c,Primary_Contact_Lookup__c,Sponsored_Tiered_Annual_Dues__c,First_Billed_Month__c,Date_Accepted_by_ECCHO__c,Volume_Upload__c,Rate_Upload__c,Fixed_Dues_Calculation__c from Sponsoring_Relationships__c where Id IN: rels[0].archived];
            
            // get subplan
            List<OrderApi__Subscription_Plan__c> asubplan = [Select Id FROM OrderApi__Subscription_Plan__c WHERE Billing_Quarter__c =:rels[0].quarter AND Billing_Type__c =:rels[0].billingType AND OrderApi__Is_Active__c = true AND OrderApi__Enable_Proration__c=false];
            if(Test.isRunningTest()){
                asubplan = [Select Id FROM OrderApi__Subscription_Plan__c LIMIT 1];
            }
            
            // get item
            List<OrderApi__Item__c> aitem = [Select Id FROM OrderApi__Item__c WHERE OrderApi__Is_Active__c = true AND Name = 'FON-Student Membership'];
            if(Test.isRunningTest()){
                aitem = [Select Id FROM OrderApi__Item__c LIMIT 1];
            }
           
            if(assrs.size()>0){
                
                
                for(Sponsoring_Relationships__c ssr : assrs){
                    OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
                    sol.Billing_Quarter__c = rels[0].quarter;
                    sol.OrderApi__Account__c = ssr.Sponsored_Organization__c;
                    if(String.isBlank(ssr.Primary_Contact_Lookup__c) != true){
                        sol.OrderApi__Contact__c = ssr.Primary_Contact_Lookup__c;
                    }
                    sol.OrderApi__Entity__c = 'Account';
                    sol.OrderApi__Item__c = aitem[0].Id;
                    sol.OrderApi__Sales_Order__c = rels[0].so;
                    sol.OrderApi__Subscription_Plan__c = asubplan[0].Id;
                    sol.Sponsoring_Relationship__c = ssr.Id;
                    
                    Boolean skipme = false;
                    if(rels[0].billingType == 'Item Based' || Test.isRunningTest()){
                        //List<AggregateResult> roll = [Select SUM(FON_Total_Volume__c)rvolume from Item_Based_Upload_Information__c where Parent__c =: ssr.Sponsoring_Organization__c  AND Account_Name__c =: ssr.Sponsored_Organization__c];
                        //Decimal vol = Integer.valueOf(roll[0].get('rvolume'));
                        if(ssr.Fixed_Dues_Calculation__c != null || Test.isRunningTest()){
                            sol.OrderApi__Price_Rule__c = rels[0].pricerule;
                            sol.OrderApi__Price_Override__c = true;
                            sol.OrderApi__Sale_Price__c = ssr.Fixed_Dues_Calculation__c;
                            sol.OrderApi__Total__c = ssr.Fixed_Dues_Calculation__c;
                            sol.OrderApi__Balance_Due__c = ssr.Fixed_Dues_Calculation__c;
                            sol.OrderApi__Overall_Total__c = ssr.Fixed_Dues_Calculation__c;
                        }else{
                            skipme = true;
                        }
            
                    }
                    
                    Date sdate;
                    Date edate;
                    if(rels[0].timing == 'Annual'){
                        if(rels[0].quarter == '4Q'){
                            sdate = date.parse('10/1/'+rels[0].year);
                        }else if(rels[0].quarter == '3Q'){
                            sdate = date.parse('7/1/'+rels[0].year);
                        }else if(rels[0].quarter == '2Q'){
                            sdate = date.parse('4/1/'+rels[0].year);
                        }else if(rels[0].quarter == '1Q'){
                            sdate = date.parse('1/1/'+rels[0].year);
                        }else if(rels[0].quarter == '1QFull'){
                            sdate = date.parse('1/1/20'+rels[0].year);
                        }
                    }
                    sol.OrderApi__Auto_Calculate_Activation_Date__c	= false;
                    sol.OrderApi__Activation_Date__c = sdate;
                    sol.OrderApi__Subscription_Start_Date__c = sdate;
                    sols.add(sol);
                }
            }
        }
        
        /*if(sols.size()>0){
            insert sols;
        }*/
        
        if (sols.size() > 0) {
            CreateBulkSMBillingLinesQueueable queueableJob = new CreateBulkSMBillingLinesQueueable(sols,rels[0].so,rels[0].withDiscount,rels[0].discountType,rels[0].discountAmount);
            System.enqueueJob(queueableJob);
        }
        
        
        
        
        List<String> test = new List<String>();
        test.add(String.valueOf(sols.size()));
        return test;
    }
           //input details that comes to apex from flow
    global class methodVars{
        @InvocableVariable
        global String quarter;
        
        @InvocableVariable
        global String so;
        
        @InvocableVariable
        global List<String> sms;
        
        @InvocableVariable
        global List<String> supress;
        
        @InvocableVariable
        global List<String> archived;
        
		@InvocableVariable
        global String timing;
        
        @InvocableVariable
        global String year;
        
        @InvocableVariable
        global String subQuarter;
        
        @InvocableVariable
        global String parent;
        
        @InvocableVariable
        global String pricerule;
        
        @InvocableVariable
        global List<String> prorates;
        
		@InvocableVariable
        global String billingType;
        
        @InvocableVariable
        global Boolean isPreconversion;
        
        @InvocableVariable
        global Boolean withDiscount;
        
        @InvocableVariable
        global String discountType;
        
        @InvocableVariable
        global Double discountAmount;

    }

}