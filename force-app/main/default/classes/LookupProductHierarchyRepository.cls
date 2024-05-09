public with sharing class LookupProductHierarchyRepository {
    public static List<List<SObject>> getAllCategories(String searchTerm, List<String> selectedIds) {
        searchTerm += '*';
        return [FIND :searchTerm 
                IN ALL FIELDS 
                RETURNING
                    ProductHierarchy__c(Id, Name, Category__c, CategoryDescription__c  WHERE IsCategory__c = true AND Id NOT IN :selectedIds ORDER BY CategoryDescription__c ASC)
                LIMIT 5
        ];
    }
    public static List<SObject> getAllCategories() {
        return [SELECT Id, Name, Category__c, CategoryDescription__c FROM ProductHierarchy__c  WHERE IsCategory__c = true ORDER BY CategoryDescription__c ASC];
    }
    public static List<List<SObject>> getBrands(String searchTerm, List<String> selectedIds, List<String> valuesCategories) {
        searchTerm += '*';
        return [FIND :searchTerm 
                IN ALL FIELDS 
                RETURNING
                    ProductHierarchy__c(Id, Name, Category__c, Brand__c, BrandDescription__c WHERE IsBrand__c = true AND Id NOT IN :selectedIds AND Category__c IN :valuesCategories ORDER BY BrandDescription__c ASC)
                LIMIT 5
        ];
    }

    public static List<SObject> getAllBrands(List<String> valuesCategories) {
        return [SELECT Id, Name, Brand__c,Category__c, BrandDescription__c FROM ProductHierarchy__c  WHERE IsBrand__c = true AND Category__c IN :valuesCategories ORDER BY BrandDescription__c ASC];
    }


    public static List<List<SObject>> getSubBrands(String searchTerm, List<String> selectedIds, List<String> valuesCategories, List<String> valuesBrands) {
        searchTerm += '*';
        return [FIND :searchTerm 
                IN ALL FIELDS 
                RETURNING
                    ProductHierarchy__c(Id, Name, Category__c, Brand__c, SubBrand__c, SubBrandDescription__c WHERE IsSubrand__c = true AND Id NOT IN :selectedIds AND Category__c IN :valuesCategories AND Brand__c IN :valuesBrands ORDER BY SubBrandDescription__c ASC)
                LIMIT 5
        ];
    }

    public static List<SObject> getAllSubBrands(List<String> valuesCategories, List<String> valuesBrands) {
        return [SELECT Id, Name, Brand__c,Category__c,SubBrand__c, SubBrandDescription__c FROM ProductHierarchy__c  WHERE IsSubrand__c = true AND Category__c IN :valuesCategories AND Brand__c IN :valuesBrands ORDER BY SubBrandDescription__c ASC];
    }


    public static List<List<SObject>> getFlavours(String searchTerm, List<String> selectedIds, List<String> valuesCategories, List<String> valuesBrands, List<String> valuesSubBrands) {
        searchTerm += '*';
        return [FIND :searchTerm 
                IN ALL FIELDS 
                RETURNING
                    ProductHierarchy__c(Id, Name, Category__c, Brand__c, SubBrand__c, Flavour__c, 	FlavourDescription__c WHERE IsFlavour__c = true AND Id NOT IN :selectedIds AND Category__c IN :valuesCategories AND Brand__c IN :valuesBrands AND SubBrand__c IN :valuesSubBrands ORDER BY FlavourDescription__c ASC)
                LIMIT 5
        ];
    }

    public static List<SObject> getAllFlavours(List<String> valuesCategories, List<String> valuesBrands, List<String> valuesSubBrands) {
        return [SELECT Id, Name, Brand__c,Category__c,SubBrand__c,Flavour__c, 	FlavourDescription__c FROM ProductHierarchy__c  WHERE IsFlavour__c = true AND Category__c IN :valuesCategories AND Brand__c IN :valuesBrands AND SubBrand__c IN :valuesSubBrands ORDER BY FlavourDescription__c ASC];
    }
    public static List<List<SObject>> getSizes(String searchTerm, List<String> selectedIds, List<String> valuesCategories, List<String> valuesBrands, List<String> valuesSubBrands, List<String> valuesFlavours) {
        
        searchTerm += '*';
        return [FIND :searchTerm 
                IN ALL FIELDS 
                RETURNING
                    ProductHierarchy__c(Id, Name, Category__c, Brand__c, SubBrand__c, Flavour__c, Size__c, SizeDescription__c WHERE IsSize__c = true AND Id NOT IN :selectedIds AND Category__c IN :valuesCategories AND Brand__c IN :valuesBrands AND SubBrand__c IN :valuesSubBrands AND Flavour__c IN :valuesFlavours ORDER BY SizeDescription__c ASC)
                LIMIT 5
        ];
    }
    public static List<SObject> getAllSizes(List<String> valuesCategories, List<String> valuesBrands, List<String> valuesSubBrands, List<String> valuesFlavours) {
        return [SELECT Id, Name, Brand__c,Category__c,SubBrand__c,Flavour__c,Size__c, SizeDescription__c FROM ProductHierarchy__c  WHERE IsSize__c = true AND Category__c IN :valuesCategories AND Brand__c IN :valuesBrands AND SubBrand__c IN :valuesSubBrands AND Flavour__c IN :valuesFlavours ORDER BY SizeDescription__c ASC];
    }

    public static Project__c getProject(Id id) {
        return [SELECT Id, Brand__c,Category__c,Subrand__c,Flavour__c,Size__c FROM Project__c WHERE Id = :id];
    }
    public static Map<String, String> getIdsByCategory(List<String> descriptions) {
        list<ProductHierarchy__c> categories = [SELECT Category__c, CategoryDescription__c FROM ProductHierarchy__c WHERE IsCategory__c = true AND CategoryDescription__c IN :descriptions];
        Map<String,String> result = new Map<String,String>();

        for (ProductHierarchy__c product: categories) {
            result.put(product.CategoryDescription__c, product.Category__c);
        }
        return result;
    }
    public static Map<String, String> getIdsByBrand(List<String> descriptions) {
        list<ProductHierarchy__c> brands = [SELECT Brand__c, BrandDescription__c FROM ProductHierarchy__c WHERE IsBrand__c = true AND BrandDescription__c IN :descriptions];
        Map<String,String> result = new Map<String,String>();

        for (ProductHierarchy__c product: brands) {
            result.put(product.BrandDescription__c, product.Brand__c);
        }
        return result;
    }
    public static Map<String, String> getIdsBySubBrand(List<String> descriptions) {
        list<ProductHierarchy__c> subrands = [SELECT SubBrand__c, SubBrandDescription__c FROM ProductHierarchy__c WHERE IsSubrand__c = true AND SubBrandDescription__c IN :descriptions];
        Map<String,String> result = new Map<String,String>();

        for (ProductHierarchy__c product: subrands) {
            result.put(product.SubBrandDescription__c, product.SubBrand__c);
        }
        return result;
    }
    public static Map<String, String> getIdsByFlavour(List<String> descriptions) {
        list<ProductHierarchy__c> flavours = [SELECT Flavour__c, FlavourDescription__c FROM ProductHierarchy__c WHERE IsFlavour__c = true AND FlavourDescription__c IN :descriptions];
        Map<String,String> result = new Map<String,String>();

        for (ProductHierarchy__c product: flavours) {
            result.put(product.FlavourDescription__c, product.Flavour__c);
        }
        return result;
    }
    public static Map<String, String> getIdsBySize(List<String> descriptions) {
        list<ProductHierarchy__c> sizes = [SELECT Size__c, SizeDescription__c FROM ProductHierarchy__c WHERE IsSize__c = true AND SizeDescription__c IN :descriptions];
        Map<String,String> result = new Map<String,String>();

        for (ProductHierarchy__c product: sizes) {
            result.put(product.SizeDescription__c, product.Size__c);
        }
        return result;
    }
}