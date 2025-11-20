/******
 * Class Name       :   CustomLookUpController
 * Description      :   This class will be used for the custom look up ( type a head seach )
 ***/
public class CustomLookUpController {
    
    /****
     * Name             : fetchLookUpValues
     * Description      : This Method will be used to query any sobject and return the result
     *                    of 5 records
     * Params           : ObjectName - API name of the object, searchKeyWord - Key worked types by the User,
                          wherecaluse - if any where caluse ( will have only have api name with condition ), returnfields - query the field required to return ( should have name nad id ), this will be used to filter data - default is name
     */                       
     
    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String ObjectName, String searchKeyWord,string wherecaluse, string returnFields, string filterField) {
        system.debug('\n--searchKeyWord--'+searchKeyWord+'\n--ObjectName--' + ObjectName+'\n--returnFields--'+returnFields+'\n--wherecaluse--'+wherecaluse+'\n--filterField--'+filterField);
        
        // this list needs will be rturned by method
        List <sObject> returnList = new List <sObject> ();
        
        if(!string.isBlank(ObjectName)){
            String searchKey = searchKeyWord + '%';
            
            // checking if we have filter field
            if(string.isBlank(filterField)){
                filterField = 'Name';
            }
            
            // this will save the query
            string query = 'SELECT ';
            
            // query id and name
            string fielstoQuery = 'Id,Name';
            
            // if we have the others field to be queried
            if(!string.isBlank(returnFields)){
                fielstoQuery += ','+returnFields;
            }
            system.debug('\n--fielstoQuery--'+fielstoQuery);
            
            // constructng query
            query += fielstoQuery + ' FROM '+ ObjectName;
            system.debug('\n--query--'+query);
            
            // checking if any where caluse is there
            if(!string.isBlank(wherecaluse)){
                query += ' WHERE '+ wherecaluse+' AND '+filterField+' LIKE: searchKey order by createdDate desc limit 5';
            }
            
            else {
                query += ' WHERE '+filterField+' LIKE: searchKey order by createdDate desc limit 5';
            }
            system.debug('\n--Final Query--'+query);
            
            returnList = Database.query(query);
            system.debug('\n--returnList--'+returnList);
        }
        return returnList;
    }
}