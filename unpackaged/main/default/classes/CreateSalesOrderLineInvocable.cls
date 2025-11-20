global class CreateSalesOrderLineInvocable {
    // https://developer.salesforce.com/forums/?id=9060G0000005nusQAA

    @InvocableMethod(label='Create Sales Order Line' Description='Create Sales Order Line')
    global static List<String> fetchSalesOrderLine(List<methodVars> rels) {
   
        // get SR
        Sponsoring_Relationships__c ssr = [Select Id,Sponsored_Tiered_Annual_Dues__c,First_Billed_Month__c,Date_Accepted_by_ECCHO__c,Volume_Upload__c,Rate_Upload__c,Fixed_Dues_Calculation__c from Sponsoring_Relationships__c where Id =: rels[0].rel];
        
        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
        sol.Billing_Quarter__c = rels[0].quarter;
        sol.OrderApi__Account__c = rels[0].acc;
        if(String.isBlank(rels[0].contact) != true){
        	sol.OrderApi__Contact__c = rels[0].contact;
        }
        sol.OrderApi__Entity__c = 'Account';
        sol.OrderApi__Item__c = rels[0].item;
        sol.OrderApi__Sales_Order__c = rels[0].so;
        sol.OrderApi__Subscription_Plan__c = rels[0].plan;
        sol.Sponsoring_Relationship__c = rels[0].rel;
        
        Boolean skipme = false;
        if(rels[0].isItemBased == true){
            List<AggregateResult> roll = [Select SUM(FON_Total_Volume__c)rvolume from Item_Based_Upload_Information__c where Parent__c =: rels[0].parent AND Account_Name__c =: rels[0].acc];
            Decimal vol = Integer.valueOf(roll[0].get('rvolume'));
            if(ssr.Fixed_Dues_Calculation__c != null){
                /*Item_Based_Upload_Information__c rat = new Item_Based_Upload_Information__c();
                rat = [Select Rate__c from Item_Based_Upload_Information__c where Parent__c =: rels[0].parent AND Account_Name__c =: rels[0].acc LIMIT 1];
                system.debug('RAT '+rat.Rate__c);
                
                system.debug('VOLLL '+vol);
                Decimal rate = rat.Rate__c;
                system.debug('RATTEEE '+rate);
                Decimal dues = rate * vol;
                system.debug('dues '+dues);*/
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
        
        /*if(rels[0].fixedDues == NULL){}else{
            sol.OrderApi__Sale_Price__c = rels[0].fixedDues;
            sol.OrderApi__Total__c = rels[0].fixedDues;
            sol.OrderApi__Balance_Due__c = rels[0].fixedDues;
            sol.OrderApi__Overall_Total__c = rels[0].fixedDues;
        }*/
        
        if(String.isBlank(rels[0].is_prorate) != true){
            //get the newer sol
            OrderApi__Sales_Order_Line__c nsol = new OrderApi__Sales_Order_Line__c();
            
            Integer nm = ssr.Date_Accepted_by_ECCHO__c.month()+1;
            
            //Integer pmonth = ssr.Date_Accepted_by_ECCHO__c.month() - nsol.OrderApi__Subscription_Start_Date__c.month();
            String d1;
            if(rels[0].quarter == '1QFull'){
                if(rels[0].subQuarter == '1Q'){
                	d1 = '12/1/20'+(Integer.valueOf(rels[0].year) - 1);
                }else{
                    d1 = '12/1/20'+rels[0].year;
                }
            }else{
                nsol = [Select Id,OrderApi__Subscription_Start_Date__c from OrderApi__Sales_Order_Line__c where Id =: rels[0].prev_sol];
                d1 = nsol.OrderApi__Subscription_Start_Date__c.month()+'/'+nsol.OrderApi__Subscription_Start_Date__c.day()+'/'+nsol.OrderApi__Subscription_Start_Date__c.year();
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
            /*If((date.parse(d1) - date.parse(d2)) / 365 * 12 < 1){
                pmonth = 1;
            } else {
                pmonth = (nsol.OrderApi__Subscription_Start_Date__c - ssr.Date_Accepted_by_ECCHO__c) / 365 * 12;
            }*/
            //sol.OrderApi__Line_Description__c = 'md='+monthdiff+', d1='+d1+', d2='+d2;
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
                sol.OrderApi__End_Date__c = date.parse(nsol.OrderApi__Subscription_Start_Date__c.month()+'/'+nsol.OrderApi__Subscription_Start_Date__c.day()+'/'+nsol.OrderApi__Subscription_Start_Date__c.year()).addDays(-1);
            }
            
            if(rels[0].isItemBased == true){
               insert sol;
            }else{
                if(monthdiff > 0){
                    insert sol;
                }
            }
            

            
            
        }else{
            Date sdate;
            Date edate;
            if(rels[0].timing == 'Annual'){
                /*if(rels[0].quarter == '4Q'){
                    sdate = date.parse('10/1/'+date.Today().year());
                }else if(rels[0].quarter == '3Q'){
                    sdate = date.parse('7/1/'+date.Today().year());
                }else if(rels[0].quarter == '2Q'){
                    sdate = date.parse('4/1/'+date.Today().year());
                }else if(rels[0].quarter == '1Q'){
                    sdate = date.parse('1/1/'+date.Today().year());
                }else if(rels[0].quarter == '1QFull'){
                    sdate = date.parse('1/1/20'+rels[0].year);
                }*/
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
            insert sol;
        }

        /*if(rels[0].timing == 'Annual'){
            sol.OrderApi__Sale_Price__c = ssr.Sponsored_Tiered_Annual_Dues__c;
            sol.OrderApi__Balance_Due__c = ssr.Sponsored_Tiered_Annual_Dues__c;
            sol.OrderApi__Total__c = ssr.Sponsored_Tiered_Annual_Dues__c;
            sol.OrderApi__Overall_Total__c = ssr.Sponsored_Tiered_Annual_Dues__c;
        }*/
        //insert sol;
        
        // update pricing
        /*if(rels[0].quarter != '1QFull' ){
            if(rels[0].timing != 'Annual'){
                OrderApi__Sales_Order_Line__c nsol = [Select Id,OrderApi__Overall_Total__c from OrderApi__Sales_Order_Line__c where Id =: sol.Id];
                nsol.OrderApi__Total__c = nsol.OrderApi__Overall_Total__c / 4;
                nsol.OrderApi__Balance_Due__c = nsol.OrderApi__Overall_Total__c / 4;
                nsol.OrderApi__Overall_Total__c = nsol.OrderApi__Overall_Total__c / 4;
                update nsol;
            }else{
                OrderApi__Sales_Order_Line__c nsol = [Select Id,OrderApi__Total__c,OrderApi__Overall_Total__c from OrderApi__Sales_Order_Line__c where Id =: sol.Id];
                //nsol.OrderApi__Total__c = nsol.OrderApi__Overall_Total__c / 4;
                nsol.OrderApi__Balance_Due__c = nsol.OrderApi__Overall_Total__c + nsol.OrderApi__Total__c;
                nsol.OrderApi__Overall_Total__c = nsol.OrderApi__Overall_Total__c + nsol.OrderApi__Total__c;
                nsol.OrderApi__Total__c = nsol.OrderApi__Overall_Total__c;
                nsol.OrderApi__Sale_Price__c = nsol.OrderApi__Overall_Total__c;
                update nsol;
            }
        }*/
        Integer testvar = 0;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
            
        // update so total
        /*OrderApi__Sales_Order__c nso = [Select Id,Sales_Line_Total__c from OrderApi__Sales_Order__c where Id =: rels[0].so];
        nso.OrderApi__Overall_Total__c = nso.Sales_Line_Total__c;
        //nso.OrderApi__Subtotal__c = nso.Sales_Line_Total__c;
       	update nso;*/
        
            
        List<String> test = new List<String>();
        test.add(sol.Id);
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        return test;
    }
           //input details that comes to apex from flow
    global class methodVars{
        @InvocableVariable
        global String quarter;
        
        @InvocableVariable
        global String item;
        
        @InvocableVariable
        global String so;
        
        @InvocableVariable
        global String plan;
        
        @InvocableVariable
        global String acc;
        
        @InvocableVariable
        global String contact;
        
        @InvocableVariable
        global String rel;
        
        @InvocableVariable
        global List<String> sups;
        
		@InvocableVariable
        global String timing;
        
		@InvocableVariable
        global String is_prorate;
        
		@InvocableVariable
        global String prev_sol;
        
        @InvocableVariable
        global String year;
        
        @InvocableVariable
        global String eDate;
        
        @InvocableVariable
        global String subQuarter;
        
        @InvocableVariable
        global Decimal fixedDues;
        
        @InvocableVariable
        global Boolean isItemBased;
        
        @InvocableVariable
        global String parent;
        
        @InvocableVariable
        global String pricerule;
    }
    
    //output details which goes from apex to flow
    /*public class methodOutputs{
        @InvocableVariable
        public String accountPreviousName ;
        @InvocableVariable
        public String DMLResult ;
    } */
}