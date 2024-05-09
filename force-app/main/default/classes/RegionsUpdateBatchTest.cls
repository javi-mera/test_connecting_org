@IsTest
public class RegionsUpdateBatchTest {

    @TestSetup
    static void makeData() {
        TestFactory.generateBasicSetUp();
    }

    @IsTest
    static void projectRegionsUpdateTest() {
        List<Project__c> projects = [
            SELECT ProjectClassification__c, Region__c, Hub__c, Cluster__c, LeadMarket__c, AddAdditionalRegionOrRegions__c, AddAdditionalHubOrHubs__c, AddAdditionalClusterOrClusters__c, AddAdditionalMarketOrMarkets__c
            FROM Project__c
        ];

        for (Project__c project : projects) {
            if (project.ProjectClassification__c == InnovatorConstants.FEARLESS_BET) {
                project.Region__c = 'ASIA, MIDDLE EAST & AFRICA';
                project.Hub__c = 'ASIA';
                project.Cluster__c = 'INDIA CLUSTER';
                project.LeadMarket__c = 'Bangladesh';
                project.AddAdditionalRegionOrRegions__c = 'ASIA, MIDDLE EAST & AFRICA;LATIN AMERICA;GTR-NORTH AMERICA';
                project.AddAdditionalHubOrHubs__c = 'ASIA;LAC;GTR-NAM';
                project.AddAdditionalClusterOrClusters__c = 'SOUTH EAST ASIA;BUP;WESTLAC;GTR-UNITED STATES';
                project.AddAdditionalMarketOrMarkets__c = 'Indonesia;Brazil;Argentina;GTR-USA';
            } else if (project.ProjectClassification__c == InnovatorConstants.PROMOTIONAL_PACK) {
                project.Region__c = 'GTR-ASIA, MIDDLE EAST & AFRICA';
                project.Hub__c = 'GTR-ASIA';
                project.Cluster__c = 'GTR-INDIA CLUSTER';
                project.LeadMarket__c = 'GTR-Bhutan';
                project.AddAdditionalRegionOrRegions__c = 'GTR-ASIA, MIDDLE EAST & AFRICA;GTR-LATIN AMERICA;NORTH AMERICA';
                project.AddAdditionalHubOrHubs__c = 'GTR-ASIA;GTR-LAC;NAM';
                project.AddAdditionalClusterOrClusters__c = 'GTR-SOUTH EAST ASIA;GTR-BUP;GTR-WESTLAC;UNITED STATES';
                project.AddAdditionalMarketOrMarkets__c = 'GTR-Cambodia;GTR-Paraguay;GTR-Bolivia;USA';
            } else if (project.ProjectClassification__c == InnovatorConstants.CONTINUOUS_IMPROVEMENT) {
                project.Region__c = 'WEUR';
                project.Hub__c = 'WEUR';
                project.Cluster__c = 'BENELUX & NORDICS';
                project.LeadMarket__c = 'Belgium';
                project.AddAdditionalRegionOrRegions__c = 'EEURA';
                project.AddAdditionalHubOrHubs__c = 'EAST ASIA;EEUR';
                project.AddAdditionalClusterOrClusters__c = 'CHINA CLUSTER;UA, KZ & CIS;CEEBB';
                project.AddAdditionalMarketOrMarkets__c = 'Hong Kong;Belarus;Romania';
            } else if (project.ProjectClassification__c == InnovatorConstants.MANDATORY) {
                project.Region__c = 'GTR-WEUR';
                project.Hub__c = 'GTR-WEUR';
                project.Cluster__c = 'GTR-BENELUX & NORDICS';
                project.LeadMarket__c = 'GTR-Luxembourg';
                project.AddAdditionalRegionOrRegions__c = 'GTR-EEURA';
                project.AddAdditionalHubOrHubs__c = 'GTR-EAST ASIA;GTR-EEUR';
                project.AddAdditionalClusterOrClusters__c = 'GTR-CHINA CLUSTER;GTR-UA, KZ & CIS;GTR-CEEBB';
                project.AddAdditionalMarketOrMarkets__c = 'GTR-Macau;GTR-Belarus;GTR-Serbia';
            } else if (project.ProjectClassification__c == InnovatorConstants.BUSINESS_ENABLER) {
                project.Region__c = 'EEURA';
                project.Hub__c = 'EAST ASIA';
                project.Cluster__c = 'JAPAN & KOREA';
                project.LeadMarket__c = 'Guam';
                project.AddAdditionalRegionOrRegions__c = 'ASIA, MIDDLE EAST & AFRICA;GTR-ASIA, MIDDLE EAST & AFRICA;WEUR;GTR-WEUR';
                project.AddAdditionalHubOrHubs__c = 'MEA;GTR-MEA;WEUR;GTR-WEUR';
                project.AddAdditionalClusterOrClusters__c = 'EAST AFRICA;GTR-EAST AFRICA;BENELUX & NORDICS;GERMANY & ALPS;UK AND IRELAND;GTR-BENELUX & NORDICS;GTR-GERMANY & ALPS;GTR-UK AND IRELAND;FIT;IBERIA & GREECE;GTR-FIT;GTR-IBERIA & GREECE';
                project.AddAdditionalMarketOrMarkets__c = 'Burundi;Kenya;GTR-Burundi;GTR-Kenya;Denmark;Austria;Germany;United Kingdom;GTR-Denmark;GTR-Austria;GTR-Germany;GTR-United Kingdom;Italy;Andorra;Spain;Portugal;GTR-Italy;GTR-Andorra;GTR-Spain;GTR-Portugal;Belgium;Netherlands;France;GTR-Belgium;GTR-Netherlands;GTR-France';
            } else if (project.ProjectClassification__c == InnovatorConstants.BRAND_ENERGIZER) {
                project.Region__c = 'GTR-EEURA';
                project.Hub__c = 'GTR-EAST ASIA';
                project.Cluster__c = 'GTR-JAPAN & KOREA';
                project.LeadMarket__c = 'GTR-Guam';
                project.AddAdditionalRegionOrRegions__c = 'EEURA;GTR-EEURA;ASIA, MIDDLE EAST & AFRICA;GTR-ASIA, MIDDLE EAST & AFRICA';
                project.AddAdditionalHubOrHubs__c = 'EEUR;GTR-EEUR;MEA;GTR-MEA;';
                project.AddAdditionalClusterOrClusters__c = 'CEEBB;GTR-CEEBB;SOUTH AFRICA;GTR-SOUTH AFRICA;UA, KZ & CIS;GTR-UA, KZ & CIS';
                project.AddAdditionalMarketOrMarkets__c = 'Poland;GTR-Poland;Mozambique;GTR-Mozambique;South Africa;GTR-South Africa;Moldova;GTR-Moldova';
            }
        }

        update projects;

        Test.startTest();
        Database.executeBatch(new ProjectRegionsUpdateBatch());
        Test.stopTest();

        List<Project__c> newProjects = [
            SELECT ProjectClassification__c, Region__c, Hub__c, Cluster__c, LeadMarket__c, AddAdditionalRegionOrRegions__c, AddAdditionalHubOrHubs__c, AddAdditionalClusterOrClusters__c, AddAdditionalMarketOrMarkets__c
            FROM Project__c
        ];

        for (Project__c project : newProjects) {
            if (project.ProjectClassification__c == InnovatorConstants.FEARLESS_BET) {
                Assert.areEqual('AMEA', project.Region__c);
                Assert.areEqual('INDIA & SEA CLUSTER', project.Hub__c);
                Assert.areEqual('INDIA CLUSTER', project.Cluster__c);
                Assert.areEqual('AMEA;EUROPE & LAC;GTR-NORTH AMERICA', project.AddAdditionalRegionOrRegions__c);
                Assert.areEqual('INDIA & SEA CLUSTER;LAC;GTR-NAM', project.AddAdditionalHubOrHubs__c);
                Assert.areEqual('SOUTH EAST ASIA;SOUTH AMERICA;GTR-UNITED STATES', project.AddAdditionalClusterOrClusters__c);
            } else if (project.ProjectClassification__c == InnovatorConstants.PROMOTIONAL_PACK) {
                Assert.areEqual('GTR-AMEA', project.Region__c);
                Assert.areEqual('GTR-INDIA & SEA CLUSTER', project.Hub__c);
                Assert.areEqual('GTR-INDIA CLUSTER', project.Cluster__c);
                Assert.areEqual('GTR-AMEA;GTR-EUROPE & LAC;NORTH AMERICA', project.AddAdditionalRegionOrRegions__c);
                Assert.areEqual('GTR-INDIA & SEA CLUSTER;GTR-LAC;NAM', project.AddAdditionalHubOrHubs__c);
                System.debug(project.AddAdditionalClusterOrClusters__c);
                Assert.areEqual('GTR-SOUTH EAST ASIA;GTR-SOUTH AMERICA;UNITED STATES', project.AddAdditionalClusterOrClusters__c);
            } else if (project.ProjectClassification__c == InnovatorConstants.CONTINUOUS_IMPROVEMENT) {
                Assert.areEqual('EUROPE & LAC', project.Region__c);
                Assert.areEqual('WEST EUR', project.Hub__c);
                Assert.areEqual('BELUX', project.Cluster__c);
                Assert.areEqual('AMEA;EUROPE & LAC', project.AddAdditionalRegionOrRegions__c);
                Assert.areEqual('NAPAC;RUSSIA;EAST EUR', project.AddAdditionalHubOrHubs__c);
                System.debug(project.AddAdditionalClusterOrClusters__c);
                Assert.areEqual('EAST ASIA;RUSSIA;EE DIST MARKETS', project.AddAdditionalClusterOrClusters__c);
            } else if (project.ProjectClassification__c == InnovatorConstants.MANDATORY) {
                Assert.areEqual('GTR-EUROPE & LAC', project.Region__c);
                Assert.areEqual('GTR-WEST EUR', project.Hub__c);
                Assert.areEqual('GTR-BELUX', project.Cluster__c);
                Assert.areEqual('GTR-AMEA;GTR-EUROPE & LAC', project.AddAdditionalRegionOrRegions__c);
                Assert.areEqual('GTR-NAPAC;GTR-RUSSIA;GTR-EAST EUR', project.AddAdditionalHubOrHubs__c);
                Assert.areEqual('GTR-EAST ASIA;GTR-RUSSIA;GTR-EE DIST MARKETS', project.AddAdditionalClusterOrClusters__c);
            } else if (project.ProjectClassification__c == InnovatorConstants.BUSINESS_ENABLER) {
                Assert.areEqual('AMEA', project.Region__c);
                Assert.areEqual('NAPAC', project.Hub__c);
                Assert.areEqual('EAST ASIA', project.Cluster__c);
                Assert.areEqual('AMEA;GTR-AMEA;EUROPE & LAC;GTR-EUROPE & LAC', project.AddAdditionalRegionOrRegions__c);
                Assert.areEqual('MEA;GTR-MEA;NORTH EUR;SOUTH EUR;WEST EUR;GTR-NORTH EUR;GTR-SOUTH EUR;GTR-WEST EUR', project.AddAdditionalHubOrHubs__c);
                Assert.areEqual('SEAT;CWAK;GTR-SEAT;GTR-CWAK;NORDICS;BELUX;NETHERLANDS;ALPS;GERMANY;UK AND IRELAND;GTR-NORDICS;GTR-BELUX;GTR-NETHERLANDS;GTR-ALPS;GTR-GERMANY;GTR-UK AND IRELAND;ITALY;FRANCE;GREECE DISTR;SPAIN;PORTUGAL;GTR-ITALY;GTR-FRANCE;GTR-GREECE DISTR;GTR-SPAIN;GTR-PORTUGAL', project.AddAdditionalClusterOrClusters__c);
            } else if (project.ProjectClassification__c == InnovatorConstants.BRAND_ENERGIZER) {
                Assert.areEqual('GTR-AMEA', project.Region__c);
                Assert.areEqual('GTR-NAPAC', project.Hub__c);
                Assert.areEqual('GTR-EAST ASIA', project.Cluster__c);
                Assert.areEqual('EUROPE & LAC;GTR-EUROPE & LAC;AMEA;GTR-AMEA', project.AddAdditionalRegionOrRegions__c);
                Assert.areEqual('EAST EUR;GTR-EAST EUR;MEA;GTR-MEA', project.AddAdditionalHubOrHubs__c);
                Assert.areEqual('POLAND;GTR-POLAND;SEAT;SOUTH AFRICA;GTR-SEAT;GTR-SOUTH AFRICA;EE DIST MARKETS;GTR-EE DIST MARKETS', project.AddAdditionalClusterOrClusters__c);
            }
        }
    }
}