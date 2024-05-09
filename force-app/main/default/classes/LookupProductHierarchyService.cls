public with sharing class LookupProductHierarchyService {

    @InvocableMethod(label='Transform LookupSearchResults')    
    public static void generateProductHierarchyRecords(List<FlowLookups> lookups) {

        FlowLookups lookup = lookups.get(0);
        Id projectId = lookup.projectId;

        List<String> selectedCategoriesDescriptions = new List<String>();
        List<String> selectedBrandsDescriptions = new List<String>();
        List<String> selectedSubBrandsDescriptions = new List<String>();
        List<String> selectedFlavoursDescription = new List<String>();
        List<String> selectedSizesDescriptions = new List<String>();

        for(LookupSearchResult resultCategory: lookup.categories){
            selectedCategoriesDescriptions.add(resultCategory.subtitle);
        }
        for(LookupSearchResult resultBrand: lookup.brands){
            selectedBrandsDescriptions.add(resultBrand.subtitle);
        }
        for(LookupSearchResult resultSubBrand: lookup.subbrands){
            selectedSubBrandsDescriptions.add(resultSubBrand.subtitle);
        }
        for(LookupSearchResult resultSize: lookup.sizes){
            selectedSizesDescriptions.add(resultSize.subtitle);
        }
        for(LookupSearchResult resultFlavour: lookup.flavours){
            selectedFlavoursDescription.add(resultFlavour.subtitle);
        }

        Project__c project = LookupProductHierarchyRepository.getProject(projectId);

        for (String category: selectedCategoriesDescriptions) {
            if (String.isBlank(project.Category__c)) {
                project.Category__c = category;
            } else {
                project.Category__c += ';';
                project.Category__c += category;
            }
        }
        for (String brand: selectedBrandsDescriptions) {
            if (String.isBlank(project.Brand__c)) {
                project.Brand__c = brand;
            } else {
                project.Brand__c += ';';
                project.Brand__c += brand;
            }
        }
        for (String subrand: selectedSubBrandsDescriptions) {
            if (String.isBlank(project.Subrand__c)) {
                project.Subrand__c = subrand;
            } else {
                project.Subrand__c += ';';
                project.Subrand__c += subrand;
            }
        }
        for (String flavour: selectedFlavoursDescription) {
            if (String.isBlank(project.Flavour__c)) {
                project.Flavour__c = flavour;
            } else {
                project.Flavour__c += ';';
                project.Flavour__c += flavour;
            }
        }
        for (String size: selectedSizesDescriptions) {
            if (String.isBlank(project.Size__c)) {
                project.Size__c = size;
            } else {
                project.Size__c += ';';
                project.Size__c += size;
            }
        }
        
        update project;
    }

    public class FlowLookups{
        @InvocableVariable
        public List<LookupSearchResult> categories;
        @InvocableVariable
        public List<LookupSearchResult> brands;
        @InvocableVariable
        public List<LookupSearchResult> subbrands;
        @InvocableVariable
        public List<LookupSearchResult> sizes;
        @InvocableVariable
        public List<LookupSearchResult> flavours;
        @InvocableVariable
        public Id projectId; 
    }
}