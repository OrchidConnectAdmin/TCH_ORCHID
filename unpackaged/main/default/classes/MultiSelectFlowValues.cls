global class MultiSelectFlowValues {

   @InvocableMethod

   public static List<list<string>> CheckValues(List<string> values) {

      if(!(values.isEmpty())){

          string tempStr = values[0];

          List<String> lstnew = tempStr.split(';');
          
          list<list<string>> finalLst = new list<list<string>>();
          
          List<String> nlist = new List<String>();
          if(lstnew.size() > 0){
              for (Integer i = 0; i < lstnew.size(); i++) {
                  String v = lstnew[i].trim();
                  if(String.isBlank(v) != true){
                  	nlist.add(v);
                  }
              }
              //nlist.add('empty1');
              //finalLst.add(nlist);
              if(nlist.size() > 0){
                  finalLst.add(nlist);
              }else{
                  finalLst = null;
              }
              
          }else{
              nlist.add('empty');
              finalLst = null;
          }


          return finalLst;

      }

      else return null;

   }

}