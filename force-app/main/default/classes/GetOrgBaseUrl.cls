global class GetOrgBaseUrl {
  @InvocableMethod(Label='Get Salesforce base and record url')
  global static List<Results> getBaseUrl(List<sObject> sourceRecords) {
    List<Results> sfdcURLs = new List<Results>();
    for (sObject obj : sourceRecords) {
      if (obj != null) {
        Results r = new Results();
        r.sfdcRecordURL =
          URL.getSalesforceBaseUrl().toExternalForm() +
          '/' +
          obj.id;
        sfdcURLs.add(r);
      } else {
        sfdcURLs.add(new Results());
      }
    }
    return sfdcURLs;
  }

  global class Results {
    @InvocableVariable
    global String sfdcRecordURL;
  }
}