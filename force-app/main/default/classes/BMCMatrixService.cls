public with sharing class BMCMatrixService {

    @AuraEnabled
    public static Map<String, String> calculateBMC(Id recordId, String leadMarket, String additionalMarkets) {
        if (leadMarket == null) {
            return new Map<String, String> {
                'BMC' => '',
                'Market' => ''
            };
        }
        Project__c project = ProjectRepository.getProject(recordId);
        project.LeadMarket__c = leadMarket;
        project.AddAdditionalMarketOrMarkets__c = additionalMarkets;
        List<ApprovalMatrix__c> approvalMatrixes = new List<ApprovalMatrix__c>();
        Id bmcRecordType = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(InnovatorConstants.BMC_RECORDTYPE).getRecordTypeId();
        approvalMatrixes = ApprovalMatrixRepository.loadBMCMatrixByRecordType(bmcRecordType);
        return calculateBMC(project, approvalMatrixes);
    }

    public static Map<String, Integer> bmcClassificationMap = new Map<String, Integer> {
        'New to World' => 1,
        'Boulder' => 2,
        'Stone' => 3,
        'Pebble' => 4,
        'Sand' => 5,
        'Air' => 6,
        '' => 7
    };

    public static Map<String, Integer> marketClassificationMap = new Map<String, Integer> {
        'New to World' => 1,
        'Must Win' => 2,
        'Future Star 1' => 3,
        'Future Star 2' => 4,
        'Future Star 3' => 5,
        'Established' => 5,
        'Global Footprint' => 6,
        'Hotspot' => 7,
        '' => 8
    };

    public static void setBMC(Project__c project) {
        List<ApprovalMatrix__c> approvalMatrixes = new List<ApprovalMatrix__c>();
        Id bmcRecordType = Schema.SObjectType.ApprovalMatrix__c.getRecordTypeInfosByDeveloperName().get(InnovatorConstants.BMC_RECORDTYPE).getRecordTypeId();
        approvalMatrixes = ApprovalMatrixRepository.loadBMCMatrixByRecordType(bmcRecordType);
        Map<String, String> classifications = calculateBMC(project, approvalMatrixes);
        project.BMCClassification__c = classifications.get('BMC');
        project.MarketClassification__c = classifications.get('Market');
    }

    public static Map<String, String> calculateBMC(Project__c project, List<ApprovalMatrix__c> approvalMatrixes) {
        Map<String, String> result = new Map<String, String> {
            'BMC' => '',
            'Market' => ''
        };
        if (approvalMatrixes != null && approvalMatrixes.size() > 0) {
            String leadMarket = project.LeadMarket__c;
            if (project.AddAdditionalMarketOrMarkets__c != null) {
                leadMarket += ';' + project.AddAdditionalMarketOrMarkets__c;
            }
            for (ApprovalMatrix__c approvalMatrix : approvalMatrixes) {
                Boolean isBrandMatching = RuleMatchingService.isRuleMatching(approvalMatrix.Brand__c, project.Brand__c) || approvalMatrix.Brand__c == 'All';
                if (!isBrandMatching && project.Brand__c != 'New') {
//                    System.debug('Brand is not Matching: Project Brand - ' +  project.Brand__c + ' | ' + ' Approval Matrix Brand - ' + approvalMatrix.Brand__c);
                    continue;
                } else if (project.Brand__c == 'New') {
                    result.put('BMC', 'New to World');
                    result.put('Market', 'New to World');
                    continue;
                }
                Boolean isLeadMarketMatching = RuleMatchingService.isRuleMatching(approvalMatrix.LeadMarket__c, leadMarket) || (leadMarket.contains('GTR') && approvalMatrix.LeadMarket__c.equals('GTR')) || approvalMatrix.LeadMarket__c == 'All';
                if ((!isLeadMarketMatching && isBrandMatching) && (result.get('BMC') == '' || result.get('Market') == '')) {
//                    System.debug('Lead Market is not Matching: Project Lead Market - ' +  leadMarket + ' | ' + ' Approval Matrix Lead Market - ' + approvalMatrix.LeadMarket__c);
                    result.put('BMC', 'Air');
                    result.put('Market', '');
                    continue;
                } 
                if (!isLeadMarketMatching) {
//                    System.debug('Lead Market is not Matching: Project Lead Market - ' +  leadMarket + ' | ' + ' Approval Matrix Lead Market - ' + approvalMatrix.LeadMarket__c);
                    continue;
                }
                Boolean isCategoryMatching = RuleMatchingService.isRuleMatching(approvalMatrix.Category__c, project.Category__c);
                if (!isCategoryMatching) {
//                    System.debug('Category is not Matching: Project Category - ' +  project.Category__c + ' | ' + ' Approval Matrix Category - ' + approvalMatrix.Category__c);
                    continue;
                }
                if (bmcClassificationMap.get(result.get('BMC')) > bmcClassificationMap.get(approvalMatrix.BMCClassification__c)) {
                    result.put('BMC', approvalMatrix.BMCClassification__c);
                }
                if (marketClassificationMap.get(result.get('Market')) > marketClassificationMap.get(approvalMatrix.MarketClassification__c)) {
                    result.put('Market', approvalMatrix.MarketClassification__c);
                }
            }
            if (result.get('BMC') == '' && result.get('Market') == '') {
                result.put('BMC', 'Air');
                result.put('Market', '');
            }
        }
        return result;
    }

}