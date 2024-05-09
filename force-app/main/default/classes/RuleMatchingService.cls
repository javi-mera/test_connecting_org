public with sharing class RuleMatchingService {
    
    public static Boolean isRuleMatching(String criteria, String field) {
        Boolean matches = false;
        List<String> fieldSplit = new List<String>();
        if (field != null) {
            fieldSplit = field.split(';');
        }
        if (criteria != null) {
            for (String entry : criteria.split(';')) {
                if (fieldSplit.contains(entry)) {
                    matches = true;
                }
            }
        } else {
            matches = true;
        }
        return matches;
    }
    
    public static Boolean isRuleMatching(String criteria, String field, String fieldName) {
        Boolean matches = RuleMatchingService.isRuleMatching(criteria, field);
        if (!matches) {
        }
        return matches;
    }

    public static Boolean isRuleMatching(String criteria, String field, String fieldName, Boolean isGlobalMatch) {
        Boolean matches = isGlobalMatch;
        if (isGlobalMatch) {
            matches = RuleMatchingService.isRuleMatching(criteria, field, fieldName);
        }
        return matches;
    }
    
}