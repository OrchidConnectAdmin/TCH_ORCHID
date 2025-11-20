Public Class AccountwithVolume
{
@invocableMethod

public static void ItemBasedUploads(List <ID> ItemIds)
{
List<Item_Based_Upload_Information__C> ItemBasedUpload = [select id, Account_Name__C, FON_Total_Volume__C, Account_Name__r.ID, Account_Name__r.Volume__c from Item_Based_Upload_Information__C where createddate = TODAY and id in: Itemids];
List <Account> Acc = [select id, Name, Volume__C from account];
List <Account> Acc2 = New List <Account>();
For (Item_Based_Upload_Information__C IBU: ItemBasedUpload){
For (Account A: ACC){
IF (A.id==IBU.Account_Name__C){

    system.debug (a.name+' Account');
                              A.Volume__C = IBU.FON_Total_Volume__C;
                              Acc2.add(A);
                              }}}
                              Update ACC2;
                              }
                              }