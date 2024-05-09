/**
 * Class used to serialize a single Lookup search result item
 * The Lookup controller returns a List<LookupSearchResult> when sending search result back to Lightning
 */
global class LookupSearchResult {
    @InvocableVariable
    public String id;
    @InvocableVariable
    public String sObjectType;
    @InvocableVariable
    public String icon;
    @InvocableVariable
    public String title;
    @InvocableVariable
    public String subtitle;
    @InvocableVariable
    public String value;

    public LookupSearchResult(String id, String sObjectType, String icon, String title, String subtitle, String value) {
        this.id = id;
        this.sObjectType = sObjectType;
        this.icon = icon;
        this.title = title;
        this.subtitle = subtitle;
        this.value = value;
    }

    @AuraEnabled
    public String getId() {
        return id;
    }

    @AuraEnabled
    public String getSObjectType() {
        return sObjectType;
    }

    @AuraEnabled
    public String getIcon() {
        return icon;
    }

    @AuraEnabled
    public String getTitle() {
        return title;
    }

    @AuraEnabled
    public String getSubtitle() {
        return subtitle;
    }
    @AuraEnabled
    public String getValue() {
        return value;
    }
}