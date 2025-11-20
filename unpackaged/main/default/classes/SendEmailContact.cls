public without sharing class SendEmailContact {
  public Boolean displaySpinner {get;set;}
    public SendEmailContact(ApexPages.StandardSetController controller){
     
    }
    
    /*
     * Name : updateContactRecords
     * Des : ths method will be used to update Contact record.
     * */
    public  void updateContactRecords(){
        displaySpinner = true;
        String orgUrl = URL.getSalesforceBaseUrl().getHost();
        string urlId = ApexPages.currentPage().getParameters().get('id');
        List<Contact> conList = [SELECT Id,Send_Email__c,FON_Exam_Results__c 
                                 FROM Contact
                                 WHERE Send_Email__c = false
                                 AND (FON_Exam_Results__c = 'Pass' OR FON_Exam_Results__c = 'Fail')
                                 LIMIT 10000];
        if(conList != null && !conList.isEmpty()){
            for(Contact con : conList){
                con.Send_Email__c = true;
            }
            try{
                update conList;
                
            }catch(exception ex){
                displaySpinner = false;
                System.debug('Error MSG : '+ ex.getMessage());
            }
        }
        displaySpinner = false;
       // string finalurlval = orgUrl+'/'+urlId;
       // PageReference redirectToUrl = redirect(finalurlval);
    }
    
    /*
     * Name : redirect
     * Des : ths method will be used to redirect the contact list view.
     * */
    public PageReference redirect(){
        String orgUrl = URL.getSalesforceBaseUrl().getHost();
    string url = 'https://'+orgUrl+'/lightning/o/Contact/list?filterName=00B6g000001TMiDEAW&0.source=alohaHeader';
        System.debug('inside redirect');
        PageReference pageRef  = new PageReference(url);
        pageRef .setRedirect(true);
        System.debug('pageRef  : ' + pageRef  );
        return pageRef  ;
    }
}