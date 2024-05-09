public class LookupProductHierarchyController {
    private static final String CATEGORY_TYPE = 'Category';
    private static final String BRAND_TYPE = 'Brand';
    private static final String SUBBRAND_TYPE = 'SubBrand';
    private static final String FLAVOUR_TYPE = 'Flavour';
    private static final String SIZE_TYPE = 'Size';
    private static final String PRODUCT_NEW = 'New';
    private static final String STANDARD_PRODUCT_ICON = 'standard:product';

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchCategories(String searchTerm, List<String> selectedIds) {
        List<List<SObject>> searchResults = LookupProductHierarchyRepository.getAllCategories(searchTerm, selectedIds);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults[0].size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults[0];
            for (ProductHierarchy__c prod: products) {
                results.add(
                    new LookupSearchResult(
                        prod.Id,
                        'ProductHierarchy__c',
                        STANDARD_PRODUCT_ICON,
                        prod.CategoryDescription__c,
                        prod.CategoryDescription__c,
                        prod.Category__c
                    )
                );
            }
        }
        return results;
    } 
    @AuraEnabled(cacheable=true )
    public static List<LookupSearchResult> searchAllCategories() {
        List<SObject> searchResults = LookupProductHierarchyRepository.getAllCategories();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults.size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults;
            for (ProductHierarchy__c prod: products) {
                results.add(
                    new LookupSearchResult(
                        prod.Id,
                        'ProductHierarchy__c',
                        STANDARD_PRODUCT_ICON,
                        prod.CategoryDescription__c,
                        prod.CategoryDescription__c,
                        prod.Category__c
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchBrands(String searchTerm, List<String> selectedIds, List<String> selectedCategories) {
        List<List<SObject>> searchResults = LookupProductHierarchyRepository.getBrands(searchTerm, selectedIds, selectedCategories);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults[0].size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults[0];
            for (ProductHierarchy__c prod: products) {
                results.add(
                    new LookupSearchResult(
                        prod.Id,
                        'ProductHierarchy__c',
                        STANDARD_PRODUCT_ICON,
                        prod.BrandDescription__c,
                        prod.BrandDescription__c,
                        prod.Brand__c
                    )
                );
            }
        }
        return results;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchAllBrands(List<String> selectedCategories) {

        List<SObject> searchResults = LookupProductHierarchyRepository.getAllBrands(selectedCategories);
        Set<String> brands = new Set<String>();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults.size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults;
            for (ProductHierarchy__c prod: products) {
                if (!brands.contains(prod.Brand__c)) {
                    results.add(
                        new LookupSearchResult(
                            prod.Id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            prod.BrandDescription__c,
                            prod.BrandDescription__c,
                            prod.Brand__c
                        )
                    );
                    brands.add(prod.Brand__c);
                }
                
            }
        }

        return results;
    }
    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchSubBrands(String searchTerm, List<String> selectedIds, List<String> selectedCategories, List<String> selectedBrands) {
        List<List<SObject>> searchResults = LookupProductHierarchyRepository.getSubBrands(searchTerm, selectedIds, selectedCategories, selectedBrands);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults[0].size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults[0];
            for (ProductHierarchy__c prod: products) {
                results.add(
                    new LookupSearchResult(
                        prod.Id,
                        'ProductHierarchy__c',
                        STANDARD_PRODUCT_ICON,
                        prod.SubBrandDescription__c,
                        prod.SubBrandDescription__c,
                        prod.SubBrand__c
                    )
                );
            }
        }
        return results;
    }
    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchAllSubBrands(List<String> selectedCategories, List<String> selectedBrands) {
        List<SObject> searchResults = LookupProductHierarchyRepository.getAllSubBrands(selectedCategories, selectedBrands);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        Set<String> subrands = new Set<String>();

        if (searchResults.size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults;
            for (ProductHierarchy__c prod: products) {
                if (!subrands.contains(prod.SubBrand__c)) {
                    results.add(
                        new LookupSearchResult(
                            prod.Id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            prod.SubBrandDescription__c,
                            prod.SubBrandDescription__c,
                            prod.SubBrand__c
                        )
                    );
                    subrands.add(prod.SubBrand__c);
                }
                
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchFlavours(String searchTerm, List<String> selectedIds, List<String> selectedCategories, List<String> selectedBrands, List<String> selectedSubBrands) {
        List<List<SObject>> searchResults = LookupProductHierarchyRepository.getFlavours(searchTerm, selectedIds, selectedCategories, selectedBrands, selectedSubBrands);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults[0].size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults[0];
            for (ProductHierarchy__c prod: products) {
                results.add(
                    new LookupSearchResult(
                        prod.Id,
                        'ProductHierarchy__c',
                        STANDARD_PRODUCT_ICON,
                        prod.FlavourDescription__c,
                        prod.FlavourDescription__c,
                        prod.Flavour__c
                    )
                );
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchAllFlavours(List<String> selectedCategories, List<String> selectedBrands, List<String> selectedSubBrands) {
        List<SObject> searchResults = LookupProductHierarchyRepository.getAllFlavours(selectedCategories, selectedBrands, selectedSubBrands);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults.size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults;
            Set<String> flavours = new Set<String>();
            for (ProductHierarchy__c prod: products) {
                if (!flavours.contains(prod.Flavour__c)) {
                    results.add(
                        new LookupSearchResult(
                            prod.Id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            prod.FlavourDescription__c,
                            prod.FlavourDescription__c,
                            prod.Flavour__c
                        )
                    );
                    flavours.add(prod.Flavour__c);
                }
                
            }
        }
        return results;
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchSizes(String searchTerm, List<String> selectedIds, List<String> selectedCategories, List<String> selectedBrands, List<String> selectedSubBrands, List<String> selectedFlavours) {
        List<List<SObject>> searchResults = LookupProductHierarchyRepository.getSizes(searchTerm, selectedIds, selectedCategories, selectedBrands, selectedSubBrands, selectedFlavours);
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults[0].size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults[0];
            for (ProductHierarchy__c prod: products) {
                results.add(
                    new LookupSearchResult(
                        prod.Id,
                        'ProductHierarchy__c',
                        STANDARD_PRODUCT_ICON,
                        prod.SizeDescription__c,
                        prod.SizeDescription__c,
                        prod.Size__c
                    )
                );
            }
        }
        return results;
    }
    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchAllSizes(List<String> selectedCategories, List<String> selectedBrands, List<String> selectedSubBrands, List<String> selectedFlavours) {
        List<SObject> searchResults = LookupProductHierarchyRepository.getAllSizes(selectedCategories, selectedBrands, selectedSubBrands, selectedFlavours);

        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (searchResults.size() > 0) {
            ProductHierarchy__c[] products = (List<ProductHierarchy__c>) searchResults;
            Set<String> sizes = new Set<String>();
            for (ProductHierarchy__c prod: products) {
                if (!sizes.contains(prod.Size__c)) {
                    results.add(
                        new LookupSearchResult(
                            prod.Id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            prod.SizeDescription__c,
                            prod.SizeDescription__c,
                            prod.Size__c
                        )
                    );
                    sizes.add(prod.Size__c);
                }
                
            }
        }
        return results;
    }

    @InvocableMethod(label='Transform Hierarchies')
    public static List<List<LookupSearchResult>> transformToLookupResult(List<FlowRequest> requests){
        FlowRequest request = requests.get(0);
        Id projectId = request.projectId;
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        Project__c project = LookupProductHierarchyRepository.getProject(projectId);

        if (CATEGORY_TYPE.equals(request.type)) {
            results = transformCategories(project);
        } else if (BRAND_TYPE.equals(request.type)) {
            results = transformBrands(project);
        } else if (SUBBRAND_TYPE.equals(request.type)) {
            results = transformSubBrands(project);
        } else if (FLAVOUR_TYPE.equals(request.type)) {
            results = transformFlavours(project);
        } else if (SIZE_TYPE.equals(request.type)) {
            results = transformSize(project);
        }

        List<List<LookupSearchResult>> resultList = new List<List<LookupSearchResult>>();
        Map<String,LookupSearchResult> mapResult = new Map<String,LookupSearchResult>();
        for(LookupSearchResult result : results){
            mapResult.put(result.value,result);
        }
        resultList.add(mapResult.values());
        return resultList;
    }

    private static List<LookupSearchResult> transformCategories(Project__c project) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        if (!String.isBlank(project.Category__c)) {
            List<String> projectCategories = project.Category__c.split(';');
            Map<String,String> categoriesResult = LookupProductHierarchyRepository.getIdsByCategory(projectCategories);

            for (String category: projectCategories) {
                if (categoriesResult.containsKey(category)) {
                    String id = categoriesResult.get(category);
                    results.add(
                        new LookupSearchResult(
                            id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            category,
                            category,
                            id
                        )
                    );
                } else {
                    if (PRODUCT_NEW.equals(category)) {
                        results.add(
                            new LookupSearchResult(
                                category,
                                'ProductHierarchy__c',
                                STANDARD_PRODUCT_ICON,
                                category,
                                category,
                                category
                            )
                        );
                    }
                }
            }
        }
        
        return results;
    }
    private static List<LookupSearchResult> transformBrands(Project__c project) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        if (!String.isBlank(project.Brand__c)) {
            List<String> projectBrands = project.Brand__c.split(';');
            Map<String,String> brandsResult = LookupProductHierarchyRepository.getIdsByBrand(projectBrands);

            for (String brand: projectBrands) {
                if (brandsResult.containsKey(brand)) {
                    String id = brandsResult.get(brand);
                    results.add(
                        new LookupSearchResult(
                            id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            brand,
                            brand,
                            id
                        )
                    );
                } else {
                    if (PRODUCT_NEW.equals(brand)) {
                        results.add(
                            new LookupSearchResult(
                                brand,
                                'ProductHierarchy__c',
                                STANDARD_PRODUCT_ICON,
                                brand,
                                brand,
                                brand
                            )
                        );
                    }
                }
            }
        }
        return results;
    }

    private static List<LookupSearchResult> transformSubBrands(Project__c project) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        if (!String.isBlank(project.Subrand__c)) {
            List<String> projectSubBrands = project.Subrand__c.split(';');
            Map<String,String> subrandsResult = LookupProductHierarchyRepository.getIdsBySubBrand(projectSubBrands);

            for (String subbrand: projectSubBrands) {
                if (subrandsResult.containsKey(subbrand)) {
                    String id = subrandsResult.get(subbrand);
                    results.add(
                        new LookupSearchResult(
                            id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            subbrand,
                            subbrand,
                            id
                        )
                    );
                } else {
                    if (PRODUCT_NEW.equals(subbrand)) {
                        results.add(
                            new LookupSearchResult(
                                subbrand,
                                'ProductHierarchy__c',
                                STANDARD_PRODUCT_ICON,
                                subbrand,
                                subbrand,
                                subbrand
                            )
                        );
                    }
                }
            }
        }

        
        return results;
    }

    private static List<LookupSearchResult> transformFlavours(Project__c project) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        
        if (!String.isBlank(project.Flavour__c)) {
            List<String> projectFlavours = project.Flavour__c.split(';');
            Map<String,String> flavoursResult = LookupProductHierarchyRepository.getIdsByFlavour(projectFlavours);
            for (String flavour: projectFlavours) {
                if (flavoursResult.containsKey(flavour)) {
                    String id = flavoursResult.get(flavour);
                    results.add(
                        new LookupSearchResult(
                            id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            flavour,
                            flavour,
                            id
                        )
                    );
                } else {
                    if (PRODUCT_NEW.equals(flavour)) {
                        results.add(
                            new LookupSearchResult(
                                flavour,
                                'ProductHierarchy__c',
                                STANDARD_PRODUCT_ICON,
                                flavour,
                                flavour,
                                flavour
                            )
                        );
                    }
                }
            }
        }
        return results;
    }

    private static List<LookupSearchResult> transformSize(Project__c project) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        if (!String.isBlank(project.Size__c)) {
            List<String> projectSizes = project.Size__c.split(';');
            Map<String,String> sizeResult = LookupProductHierarchyRepository.getIdsBySize(projectSizes);
            for (String size: projectSizes) {
                if (sizeResult.containsKey(size)) {
                    String id = sizeResult.get(size);
                    results.add(
                        new LookupSearchResult(
                            id,
                            'ProductHierarchy__c',
                            STANDARD_PRODUCT_ICON,
                            size,
                            size,
                            id
                        )
                    );
                } else {
                    if (PRODUCT_NEW.equals(size)) {
                        results.add(
                            new LookupSearchResult(
                                size,
                                'ProductHierarchy__c',
                                STANDARD_PRODUCT_ICON,
                                size,
                                size,
                                size
                            )
                        );
                    }
                }
            }
        }
        return results;
    }

    public class FlowRequest{
        @InvocableVariable
        public Id projectId;

        @InvocableVariable
        public String type;
    }
}