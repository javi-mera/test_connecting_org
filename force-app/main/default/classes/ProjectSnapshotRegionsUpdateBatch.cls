/**
 * @author - Darya Rykhlik
 * @date - 25 Apr 2024
 * @description - The Batch class to update Project Snapshots Geography fields
 */

public class ProjectSnapshotRegionsUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {
    /**
         * Method to collect records to be passed to the execute method
         * @param batchableContext - The parameter type of a batch job method
         * @return - List of records to be processed with a SOQL query
         */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(
            'SELECT Region__c, Hub__c, Cluster__c, LeadMarket__c, AddAdditionalRegionOrRegions__c, AddAdditionalHubOrHubs__c, AddAdditionalClusterOrClusters__c, AddAdditionalMarketOrMarkets__c ' +
                'FROM Project_Snapshot__c'
        );
    }

    /**
     * Method to process each “batch” of data passed to the method
     * @param batchableContext - The parameter type of a batch job method
     * @param projects - List of Project__c records
     */
    public void execute(Database.BatchableContext batchableContext, List<Project_Snapshot__c> projects) {
        List<String> eeuraCountries = new List<String> {
            'Albania',
            'Bosnia-Herz.',
            'Bulgaria',
            'Czech Republic',
            'Estonia',
            'Croatia',
            'Hungary',
            'Lithuania',
            'Latvia',
            'Montenegro',
            'Macedonia',
            'Poland',
            'Romania',
            'Serbia',
            'Slovenia',
            'Slovakia',
            'Georgia',
            'Kazakhstan',
            'Moldova',
            'Mongolia',
            'Ukraine',
            'Uzbekistan',
            'Kirgisistan',
            'Turkmenistan'
        };

        List<String> gtrEeuraCountries = new List<String> {
            'GTR-Albania',
            'GTR-Bosnia-Herz.',
            'GTR-Bulgaria',
            'GTR-Czech Republic',
            'GTR-Estonia',
            'GTR-Croatia',
            'GTR-Hungary',
            'GTR-Lithuania',
            'GTR-Latvia',
            'GTR-Montenegro',
            'GTR-Macedonia',
            'GTR-Poland',
            'GTR-Romania',
            'GTR-Serbia',
            'GTR-Slovenia',
            'GTR-Slovakia',
            'GTR-Georgia',
            'GTR-Kazakhstan',
            'GTR-Moldova',
            'GTR-Mongolia',
            'GTR-Ukraine',
            'GTR-Uzbekistan',
            'GTR-Kirgisistan',
            'GTR-Turkmenistan'
        };

        List<String> southEurCountries = new List<String> {
            'Italy',
            'Andorra',
            'Cyprus',
            'Spain',
            'Greece',
            'Malta',
            'Portugal'
        };
        List<String> gtrSouthEurCountries = new List<String> {
            'GTR-Italy',
            'GTR-Andorra',
            'GTR-Cyprus',
            'GTR-Spain',
            'GTR-Greece',
            'GTR-Malta',
            'GTR-Portugal'
        };

        List<String> westEurCountries = new List<String> {
            'Belgium',
            'Luxembourg',
            'Netherlands',
            'France',
            'Martinique'
        };

        List<String> gtrWestEurCountries = new List<String> {
            'GTR-Belgium',
            'GTR-Luxembourg',
            'GTR-Netherlands',
            'GTR-France',
            'GTR-Martinique'
        };

        List<String> northEurCountries = new List<String> {
            'Denmark',
            'Finland',
            'Iceland',
            'Norway',
            'Sweden',
            'Austria',
            'Switzerland',
            'Germany',
            'United Kingdom',
            'Ireland'
        };

        List<String> gtrNorthEurCountries = new List<String> {
            'GTR-Denmark',
            'GTR-Finland',
            'GTR-Iceland',
            'GTR-Norway',
            'GTR-Sweden',
            'GTR-Austria',
            'GTR-Switzerland',
            'GTR-Germany',
            'GTR-United Kingdom',
            'GTR-Ireland'
        };

        List<String> nordicsCountries = new List<String>{
            'Denmark',
            'Finland',
            'Iceland',
            'Norway',
            'Sweden'
        };
        List<String> gtrNordicsCountries = new List<String>{
            'GTR-Denmark',
            'GTR-Finland',
            'GTR-Iceland',
            'GTR-Norway',
            'GTR-Sweden'
        };

        List<String> eeDistMarkets = new List<String>{
            'Albania',
            'Bosnia-Herz.',
            'Bulgaria',
            'Czech Republic',
            'Estonia',
            'Croatia',
            'Hungary',
            'Lithuania',
            'Latvia',
            'Montenegro',
            'Macedonia',
            'Romania',
            'Serbia',
            'Slovenia',
            'Slovakia',
            'Kirgisistan',
            'Turkmenistan'
        };

        List<String> gtrEeDistMarkets = new List<String>{
            'GTR-Albania',
            'GTR-Bosnia-Herz.',
            'GTR-Bulgaria',
            'GTR-Czech Republic',
            'GTR-Estonia',
            'GTR-Croatia',
            'GTR-Hungary',
            'GTR-Lithuania',
            'GTR-Latvia',
            'GTR-Montenegro',
            'GTR-Macedonia',
            'GTR-Romania',
            'GTR-Serbia',
            'GTR-Slovenia',
            'GTR-Slovakia',
            'GTR-Kirgisistan',
            'GTR-Turkmenistan'
        };

        List<String> seatCountries = new List<String>{
            'Burundi',
            'Djibouti',
            'Eritrea',
            'Ethiopia',
            'Madagascar',
            'Mauritius',
            'Namibia',
            'Rwanda',
            'Seychelles',
            'South Sudan',
            'Tanzania',
            'Uganda',
            'Zimbabwe'
        };

        List<String> gtrSeatCountries = new List<String>{
            'GTR-Burundi',
            'GTR-Djibouti',
            'GTR-Eritrea',
            'GTR-Ethiopia',
            'GTR-Madagascar',
            'GTR-Mauritius',
            'GTR-Namibia',
            'GTR-Rwanda',
            'GTR-Seychelles',
            'GTR-South Sudan',
            'GTR-Tanzania',
            'GTR-Uganda',
            'GTR-Zimbabwe'
        };

        List<String> greeceDistr = new List<String>{
            'Andorra',
            'Cyprus',
            'Greece',
            'Malta'
        };

        List<String> gtrGreeceDistr = new List<String>{
            'GTR-Andorra',
            'GTR-Cyprus',
            'GTR-Greece',
            'GTR-Malta'
        };

        List<String> cwakCountries = new List<String>{
            'Burkina Faso',
            'Benin',
            'Cote d Ivoire',
            'Cameroon',
            'Gabon',
            'Ghana',
            'Guinea',
            'Equatorial Guin',
            'Liberia',
            'Sierra Leone',
            'Senegal',
            'Togo'
        };

        List<String> gtrCwakCountries = new List<String>{
            'GTR-Burkina Faso',
            'GTR-Benin',
            'GTR-Cote d Ivoire',
            'GTR-Cameroon',
            'GTR-Gabon',
            'GTR-Ghana',
            'GTR-Guinea',
            'GTR-Equatorial Guin',
            'GTR-Liberia',
            'GTR-Sierra Leone',
            'GTR-Senegal',
            'GTR-Togo'
        };

        List<String> southAmerica = new List<String>{
            'Argentina',
            'Bolivia',
            'Chile',
            'Ecuador',
            'Peru'
        };

        List<String> gtrSouthAmerica = new List<String>{
            'GTR-Argentina',
            'GTR-Bolivia',
            'GTR-Chile',
            'GTR-Ecuador',
            'GTR-Peru'
        };

        if (!projects.isEmpty()) {
            List<Project_Snapshot__c> projectsToUpdate = new List<Project_Snapshot__c>();
            for (Project_Snapshot__c project : projects) {
                List<String> additionalHubs = new List<String>();
                if (String.isNotBlank(project.AddAdditionalHubOrHubs__c)) {
                    additionalHubs = project.AddAdditionalHubOrHubs__c.split(';');
                }
                List<String> additionalMarkets = new List<String>();
                if (String.isNotBlank(project.AddAdditionalMarketOrMarkets__c)) {
                    additionalMarkets = project.AddAdditionalMarketOrMarkets__c.split(';');
                }
                //Lead Regions
                if (project.Region__c == 'ASIA, MIDDLE EAST & AFRICA') {
                    project.Region__c = 'AMEA';
                } else if (project.Region__c == 'GTR-ASIA, MIDDLE EAST & AFRICA') {
                    project.Region__c = 'GTR-AMEA';
                } else if (project.Region__c == 'LATIN AMERICA' || project.Region__c == 'WEUR') {
                    project.Region__c = 'EUROPE & LAC';
                } else if (project.Region__c == 'GTR-LATIN AMERICA' || project.Region__c == 'GTR-WEUR') {
                    project.Region__c = 'GTR-EUROPE & LAC';
                } else if (project.Region__c == 'EEURA') {
                    if (project.Hub__c == 'EAST ASIA') {
                        project.Region__c = 'AMEA';
                    } else if (project.Hub__c == 'EEUR' && (project.LeadMarket__c == 'Russian Fed.' || project.LeadMarket__c == 'Belarus')) {
                        project.Region__c = 'AMEA';
                    } else if (eeuraCountries.contains(project.LeadMarket__c)) {
                        project.Region__c = 'EUROPE & LAC';
                    }
                } else if (project.Region__c == 'GTR-EEURA') {
                    if (project.Hub__c == 'GTR-EAST ASIA') {
                        project.Region__c = 'GTR-AMEA';
                    } else if (project.Hub__c == 'GTR-EEUR' && (project.LeadMarket__c == 'GTR-Russian Fed.' || project.LeadMarket__c == 'GTR-Belarus')) {
                        project.Region__c = 'GTR-AMEA';
                    } else if (gtrEeuraCountries.contains(project.LeadMarket__c)) {
                        project.Region__c = 'GTR-EUROPE & LAC';
                    }
                }

                //Additional Regions
                if (String.isNotBlank(project.AddAdditionalRegionOrRegions__c)) {
                    Set<String> newAdditionalRegions = new Set<String>();
                    for (String additionalRegion : project.AddAdditionalRegionOrRegions__c.split(';')) {
                        if (additionalRegion == 'ASIA, MIDDLE EAST & AFRICA') {
                            newAdditionalRegions.add('AMEA');
                        } else if (additionalRegion == 'GTR-ASIA, MIDDLE EAST & AFRICA') {
                            newAdditionalRegions.add('GTR-AMEA');
                        } else if (additionalRegion == 'LATIN AMERICA' || additionalRegion == 'WEUR') {
                            newAdditionalRegions.add('EUROPE & LAC');
                        } else if (additionalRegion == 'GTR-LATIN AMERICA' || additionalRegion == 'GTR-WEUR') {
                            newAdditionalRegions.add('GTR-EUROPE & LAC');
                        } else if (additionalRegion == 'NORTH AMERICA') {
                            newAdditionalRegions.add('NORTH AMERICA');
                        } else if (additionalRegion == 'GTR-NORTH AMERICA') {
                            newAdditionalRegions.add('GTR-NORTH AMERICA');
                        } else if (additionalRegion == 'EEURA') {
                            if (additionalHubs.contains('EAST ASIA')) {
                                newAdditionalRegions.add('AMEA');
                            }
                            if (additionalHubs.contains('EEUR') && (additionalMarkets.contains('Russian Fed.') || additionalMarkets.contains('Belarus'))) {
                                newAdditionalRegions.add('AMEA');
                            }
                            for (String market : additionalMarkets) {
                                if (eeuraCountries.contains(market)) {
                                    newAdditionalRegions.add('EUROPE & LAC');
                                }
                            }
                        } else if (additionalRegion == 'GTR-EEURA') {
                            if (additionalHubs.contains('GTR-EAST ASIA')) {
                                newAdditionalRegions.add('GTR-AMEA');
                            }
                            if (additionalHubs.contains('GTR-EEUR') && (additionalMarkets.contains('GTR-Russian Fed.') || additionalMarkets.contains('GTR-Belarus'))) {
                                newAdditionalRegions.add('GTR-AMEA');
                            }
                            for (String market : additionalMarkets) {
                                if (gtrEeuraCountries.contains(market)) {
                                    newAdditionalRegions.add('GTR-EUROPE & LAC');
                                }
                            }
                        }
                    }
                    if (!newAdditionalRegions.isEmpty()) {
                        project.AddAdditionalRegionOrRegions__c = String.join(newAdditionalRegions, ';');
                    }
                }

                // Lead Hubs
                if (project.Hub__c == 'ASIA') {
                    project.Hub__c = 'INDIA & SEA CLUSTER';
                } else if (project.Hub__c == 'GTR-ASIA') {
                    project.Hub__c = 'GTR-INDIA & SEA CLUSTER';
                } else if (project.Hub__c == 'EAST ASIA' || project.Hub__c == 'OCEANIA') {
                    project.Hub__c = 'NAPAC';
                } else if (project.Hub__c == 'GTR-EAST ASIA' || project.Hub__c == 'GTR-OCEANIA') {
                    project.Hub__c = 'GTR-NAPAC';
                } else if (project.Hub__c == 'EEUR') {
                    if (project.LeadMarket__c == 'Russian Fed.' || project.LeadMarket__c == 'Belarus') {
                        project.Hub__c = 'RUSSIA';
                    } else if (eeuraCountries.contains(project.LeadMarket__c)) {
                        project.Hub__c = 'EAST EUR';
                    }
                } else if (project.Hub__c == 'GTR-EEUR') {
                    if (project.LeadMarket__c == 'GTR-Russian Fed.' || project.LeadMarket__c == 'GTR-Belarus') {
                        project.Hub__c = 'GTR-RUSSIA';
                    } else if (gtrEeuraCountries.contains(project.LeadMarket__c)) {
                        project.Hub__c = 'GTR-EAST EUR';
                    }
                } else if (project.Hub__c == 'WEUR') {
                    if (southEurCountries.contains(project.LeadMarket__c)) {
                        project.Hub__c = 'SOUTH EUR';
                    } else if (westEurCountries.contains(project.LeadMarket__c)) {
                        project.Hub__c = 'WEST EUR';
                    } else if (northEurCountries.contains(project.LeadMarket__c)) {
                        project.Hub__c = 'NORTH EUR';
                    }
                } else if (project.Hub__c == 'GTR-WEUR') {
                    if (gtrSouthEurCountries.contains(project.LeadMarket__c)) {
                        project.Hub__c = 'GTR-SOUTH EUR';
                    } else if (gtrWestEurCountries.contains(project.LeadMarket__c)) {
                        project.Hub__c = 'GTR-WEST EUR';
                    } else if (gtrNorthEurCountries.contains(project.LeadMarket__c)) {
                        project.Hub__c = 'GTR-NORTH EUR';
                    }
                }

                // Additional Hubs
                if (!additionalHubs.isEmpty()) {
                    Set<String> newAdditionalHubs = new Set<String>();
                    for (String additionalHub : additionalHubs) {
                        if (additionalHub == 'ASIA') {
                            newAdditionalHubs.add('INDIA & SEA CLUSTER');
                        } else if (additionalHub == 'GTR-ASIA') {
                            newAdditionalHubs.add('GTR-INDIA & SEA CLUSTER');
                        } else if (additionalHub == 'EAST ASIA' || additionalHub == 'OCEANIA') {
                            newAdditionalHubs.add('NAPAC');
                        } else if (additionalHub == 'GTR-EAST ASIA' || additionalHub == 'GTR-OCEANIA') {
                            newAdditionalHubs.add('GTR-NAPAC');
                        } else if (additionalHub == 'LAC') {
                            newAdditionalHubs.add('LAC');
                        } else if (additionalHub == 'GTR-LAC') {
                            newAdditionalHubs.add('GTR-LAC');
                        } else if (additionalHub == 'MEA') {
                            newAdditionalHubs.add('MEA');
                        } else if (additionalHub == 'GTR-MEA') {
                            newAdditionalHubs.add('GTR-MEA');
                        } else if (additionalHub == 'NAM') {
                            newAdditionalHubs.add('NAM');
                        } else if (additionalHub == 'GTR-NAM') {
                            newAdditionalHubs.add('GTR-NAM');
                        } else if (additionalHub == 'EEUR') {
                            if (additionalMarkets.contains('Russian Fed.') || additionalMarkets.contains('Belarus')) {
                                newAdditionalHubs.add('RUSSIA');
                            }
                            for (String market : additionalMarkets) {
                                if (eeuraCountries.contains(market)) {
                                    newAdditionalHubs.add('EAST EUR');
                                }
                            }
                        } else if (additionalHub == 'GTR-EEUR') {
                            if (additionalMarkets.contains('GTR-Russian Fed.') || additionalMarkets.contains('GTR-Belarus')) {
                                newAdditionalHubs.add('GTR-RUSSIA');
                            }
                            for (String market : additionalMarkets) {
                                if (gtrEeuraCountries.contains(market)) {
                                    newAdditionalHubs.add('GTR-EAST EUR');
                                }
                            }
                        } else if (additionalHub == 'WEUR') {
                            for (String market : additionalMarkets) {
                                if (southEurCountries.contains(market)) {
                                    newAdditionalHubs.add('SOUTH EUR');
                                }
                                if (westEurCountries.contains(market)) {
                                    newAdditionalHubs.add('WEST EUR');
                                }
                                if (northEurCountries.contains(market)) {
                                    newAdditionalHubs.add('NORTH EUR');
                                }
                            }
                        } else if (additionalHub == 'GTR-WEUR') {
                            for (String market : additionalMarkets) {
                                if (gtrSouthEurCountries.contains(market)) {
                                    newAdditionalHubs.add('GTR-SOUTH EUR');
                                }
                                if (gtrWestEurCountries.contains(market)) {
                                    newAdditionalHubs.add('GTR-WEST EUR');
                                }
                                if (gtrNorthEurCountries.contains(market)) {
                                    newAdditionalHubs.add('GTR-NORTH EUR');
                                }
                            }
                        }
                    }
                    if (!newAdditionalHubs.isEmpty()) {
                        project.AddAdditionalHubOrHubs__c = String.join(newAdditionalHubs, ';');
                    }
                }

                // Lead Clusters
                if (project.Cluster__c == 'BENELUX & NORDICS') {
                    if (project.LeadMarket__c == 'Belgium' || project.LeadMarket__c == 'Luxembourg') {
                        project.Cluster__c = 'BELUX';
                    } else if (project.LeadMarket__c == 'Netherlands') {
                        project.Cluster__c = 'NETHERLANDS';
                    } else if (nordicsCountries.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'NORDICS';
                    }
                } else if (project.Cluster__c == 'GTR-BENELUX & NORDICS') {
                    if (project.LeadMarket__c == 'GTR-Belgium' || project.LeadMarket__c == 'GTR-Luxembourg') {
                        project.Cluster__c = 'GTR-BELUX';
                    } else if (project.LeadMarket__c == 'GTR-Netherlands') {
                        project.Cluster__c = 'GTR-NETHERLANDS';
                    } else if (gtrNordicsCountries.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'GTR-NORDICS';
                    }
                } else if (project.Cluster__c == 'BUP') {
                    project.Cluster__c = 'SOUTH AMERICA';
                } else if (project.Cluster__c == 'GTR-BUP') {
                    project.Cluster__c = 'GTR-SOUTH AMERICA';
                } else if (project.Cluster__c == 'CACEM') {
                    project.Cluster__c = 'CARICAM';
                } else if (project.Cluster__c == 'GTR-CACEM') {
                    project.Cluster__c = 'GTR-CARICAM';
                } else if (project.Cluster__c == 'CEEBB') {
                    if (project.LeadMarket__c == 'Poland') {
                        project.Cluster__c = 'POLAND';
                    } else if (eeDistMarkets.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'EE DIST MARKETS';
                    }
                } else if (project.Cluster__c == 'GTR-CEEBB') {
                    if (project.LeadMarket__c == 'GTR-Poland') {
                        project.Cluster__c = 'GTR-POLAND';
                    } else if (gtrEeDistMarkets.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'GTR-EE DIST MARKETS';
                    }
                } else if (project.Cluster__c == 'CHINA CLUSTER' || project.Cluster__c == 'JAPAN & KOREA') {
                    project.Cluster__c = 'EAST ASIA';
                } else if (project.Cluster__c == 'GTR-CHINA CLUSTER' || project.Cluster__c == 'GTR-JAPAN & KOREA') {
                    project.Cluster__c = 'GTR-EAST ASIA';
                } else if (project.Cluster__c == 'EAST AFRICA') {
                    if (project.LeadMarket__c == 'Dem. Rep. Congo' || project.LeadMarket__c == 'Rep.of Congo' || project.LeadMarket__c == 'Kenya') {
                        project.Cluster__c = 'CWAK';
                    } else if (seatCountries.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'SEAT';
                    }
                } else if (project.Cluster__c == 'GTR-EAST AFRICA') {
                    if (project.LeadMarket__c == 'GTR-Dem. Rep. Congo' || project.LeadMarket__c == 'GTR-Rep.of Congo' || project.LeadMarket__c == 'GTR-Kenya') {
                        project.Cluster__c = 'GTR-CWAK';
                    } else if (gtrSeatCountries.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'GTR-SEAT';
                    }
                } else if (project.Cluster__c == 'FIT') {
                    if (project.LeadMarket__c == 'Italy') {
                        project.Cluster__c = 'ITALY';
                    } else if (project.LeadMarket__c == 'France' || project.LeadMarket__c == 'Martinique') {
                        project.Cluster__c = 'FRANCE';
                    }
                } else if (project.Cluster__c == 'GTR-FIT') {
                    if (project.LeadMarket__c == 'GTR-Italy') {
                        project.Cluster__c = 'GTR-ITALY';
                    } else if (project.LeadMarket__c == 'GTR-France' || project.LeadMarket__c == 'GTR-Martinique') {
                        project.Cluster__c = 'GTR-FRANCE';
                    }
                } else if (project.Cluster__c == 'GERMANY & ALPS') {
                    if (project.LeadMarket__c == 'Germany') {
                        project.Cluster__c = 'GERMANY';
                    } else if (project.LeadMarket__c == 'Austria' || project.LeadMarket__c == 'Switzerland') {
                        project.Cluster__c = 'ALPS';
                    }
                } else if (project.Cluster__c == 'GTR-GERMANY & ALPS') {
                    if (project.LeadMarket__c == 'GTR-Germany') {
                        project.Cluster__c = 'GTR-GERMANY';
                    } else if (project.LeadMarket__c == 'GTR-Austria' || project.LeadMarket__c == 'GTR-Switzerland') {
                        project.Cluster__c = 'GTR-ALPS';
                    }
                } else if (project.Cluster__c == 'IBERIA & GREECE') {
                    if (project.LeadMarket__c == 'Spain') {
                        project.Cluster__c = 'SPAIN';
                    } else if (project.LeadMarket__c == 'Portugal') {
                        project.Cluster__c = 'PORTUGAL';
                    } else if (greeceDistr.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'GREECE DISTR';
                    }
                } else if (project.Cluster__c == 'GTR-IBERIA & GREECE') {
                    if (project.LeadMarket__c == 'GTR-Spain') {
                        project.Cluster__c = 'GTR-SPAIN';
                    } else if (project.LeadMarket__c == 'GTR-Portugal') {
                        project.Cluster__c = 'GTR-PORTUGAL';
                    } else if (gtrGreeceDistr.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'GTR-GREECE DISTR';
                    }
                } else if (project.Cluster__c == 'SOUTH AFRICA') {
                    if (project.LeadMarket__c == 'Mozambique') {
                        project.Cluster__c = 'SEAT';
                    } else if (project.LeadMarket__c == 'South Africa') {
                        project.Cluster__c = 'SOUTH AFRICA';
                    }
                } else if (project.Cluster__c == 'GTR-SOUTH AFRICA') {
                    if (project.LeadMarket__c == 'GTR-Mozambique') {
                        project.Cluster__c = 'GTR-SEAT';
                    } else if (project.LeadMarket__c == 'GTR-South Africa') {
                        project.Cluster__c = 'GTR-SOUTH AFRICA';
                    }
                } else if (project.Cluster__c == 'UA, KZ & CIS') {
                    if (project.LeadMarket__c == 'Belarus') {
                        project.Cluster__c = 'RUSSIA';
                    } else if (project.LeadMarket__c == 'Ukraine') {
                        project.Cluster__c = 'UKRAINE';
                    } else if (project.LeadMarket__c == 'Kazakhstan' || project.LeadMarket__c == 'Uzbekistan') {
                        project.Cluster__c = 'CENTRAL ASIA';
                    } else if (eeDistMarkets.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'EE DIST MARKETS';
                    }
                } else if (project.Cluster__c == 'GTR-UA, KZ & CIS') {
                    if (project.LeadMarket__c == 'GTR-Belarus') {
                        project.Cluster__c = 'GTR-RUSSIA';
                    } else if (project.LeadMarket__c == 'GTR-Ukraine') {
                        project.Cluster__c = 'GTR-UKRAINE';
                    } else if (project.LeadMarket__c == 'GTR-Kazakhstan' || project.LeadMarket__c == 'GTR-Uzbekistan') {
                        project.Cluster__c = 'GTR-CENTRAL ASIA';
                    } else if (gtrEeDistMarkets.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'GTR-EE DIST MARKETS';
                    }
                } else if (project.Cluster__c == 'WEST AFRICA') {
                    if (project.LeadMarket__c == 'Nigeria') {
                        project.Cluster__c = 'NIGERIA';
                    } else if (project.LeadMarket__c == 'Angola' || project.LeadMarket__c == 'CAR') {
                        project.Cluster__c = 'SEAT';
                    } else if (cwakCountries.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'CWAK';
                    }
                } else if (project.Cluster__c == 'GTR-WEST AFRICA') {
                    if (project.LeadMarket__c == 'GTR-Nigeria') {
                        project.Cluster__c = 'GTR-NIGERIA';
                    } else if (project.LeadMarket__c == 'GTR-Angola' || project.LeadMarket__c == 'GTR-CAR') {
                        project.Cluster__c = 'GTR-SEAT';
                    } else if (gtrCwakCountries.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'GTR-CWAK';
                    }
                } else if (project.Cluster__c == 'WESTLAC') {
                    if (project.LeadMarket__c == 'Colombia' || project.LeadMarket__c == 'Venezuela') {
                        project.Cluster__c = 'CARICAM';
                    } else if (southAmerica.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'SOUTH AMERICA';
                    }
                } else if (project.Cluster__c == 'GTR-WESTLAC') {
                    if (project.LeadMarket__c == 'GTR-Colombia' || project.LeadMarket__c == 'GTR-Venezuela') {
                        project.Cluster__c = 'GTR-CARICAM';
                    } else if (gtrSouthAmerica.contains(project.LeadMarket__c)) {
                        project.Cluster__c = 'GTR-SOUTH AMERICA';
                    }
                }


                //Additional Clusters
                if (String.isNotBlank(project.AddAdditionalClusterOrClusters__c)) {
                    Set<String> newAdditionalClusters = new Set<String>();
                    for (String additionalCluster : project.AddAdditionalClusterOrClusters__c.split(';')) {
                        for (String market : additionalMarkets) {
                            if (additionalCluster == 'BENELUX & NORDICS') {
                                if (market == 'Belgium' || market == 'Luxembourg') {
                                    newAdditionalClusters.add('BELUX');
                                }
                                if (market == 'Netherlands') {
                                    newAdditionalClusters.add('NETHERLANDS');
                                }
                                if (nordicsCountries.contains(market)){
                                    newAdditionalClusters.add('NORDICS');
                                }
                            } else if (additionalCluster == 'GTR-BENELUX & NORDICS') {
                                if (market == 'GTR-Belgium' || market == 'GTR-Luxembourg') {
                                    newAdditionalClusters.add('GTR-BELUX');
                                }
                                if (market == 'GTR-Netherlands') {
                                    newAdditionalClusters.add('GTR-NETHERLANDS');
                                }
                                if (gtrNordicsCountries.contains(market)) {
                                    newAdditionalClusters.add('GTR-NORDICS');
                                }
                            } else if (additionalCluster == 'CEEBB') {
                                if (market == 'Poland') {
                                    newAdditionalClusters.add('POLAND');
                                }
                                if (eeDistMarkets.contains(market)) {
                                    newAdditionalClusters.add('EE DIST MARKETS');
                                }
                            } else if (additionalCluster == 'GTR-CEEBB') {
                                if (market == 'GTR-Poland') {
                                    newAdditionalClusters.add('GTR-POLAND');
                                }
                                if (gtrEeDistMarkets.contains(market)){
                                    newAdditionalClusters.add('GTR-EE DIST MARKETS');
                                }
                            } else if (additionalCluster == 'EAST AFRICA') {
                                if (market == 'Dem. Rep. Congo' || market == 'Rep.of Congo' || market == 'Kenya') {
                                    newAdditionalClusters.add('CWAK');
                                }
                                if (seatCountries.contains(market)) {
                                    newAdditionalClusters.add('SEAT');
                                }
                            } else if (additionalCluster == 'GTR-EAST AFRICA') {
                                if (market == 'GTR-Dem. Rep. Congo' || market == 'GTR-Rep.of Congo' || market == 'GTR-Kenya') {
                                    newAdditionalClusters.add('GTR-CWAK');
                                }
                                if (gtrSeatCountries.contains(market)) {
                                    newAdditionalClusters.add('GTR-SEAT');
                                }
                            } else if (additionalCluster == 'FIT') {
                                if (market == 'Italy') {
                                    newAdditionalClusters.add('ITALY');
                                }
                                if (market == 'France' || market == 'Martinique') {
                                    newAdditionalClusters.add('FRANCE');
                                }
                            } else if (additionalCluster == 'GTR-FIT') {
                                if (market == 'GTR-Italy') {
                                    newAdditionalClusters.add('GTR-ITALY');
                                }
                                if (market == 'GTR-France' || market == 'GTR-Martinique') {
                                    newAdditionalClusters.add('GTR-FRANCE');
                                }
                            } else if (additionalCluster == 'GERMANY & ALPS') {
                                if (market == 'Germany') {
                                    newAdditionalClusters.add('GERMANY');
                                }
                                if (market == 'Austria' || market == 'Switzerland') {
                                    newAdditionalClusters.add('ALPS');
                                }
                            } else if (additionalCluster == 'GTR-GERMANY & ALPS') {
                                if (market == 'GTR-Germany') {
                                    newAdditionalClusters.add('GTR-GERMANY');
                                }
                                if (market == 'GTR-Austria' || market == 'GTR-Switzerland') {
                                    newAdditionalClusters.add('GTR-ALPS');
                                }
                            } else if (additionalCluster == 'IBERIA & GREECE') {
                                if (market == 'Spain') {
                                    newAdditionalClusters.add('SPAIN');
                                }
                                if (market == 'Portugal') {
                                    newAdditionalClusters.add('PORTUGAL');
                                }
                                if (greeceDistr.contains(market) ) {
                                    newAdditionalClusters.add('GREECE DISTR');
                                }
                            } else if (additionalCluster == 'GTR-IBERIA & GREECE') {
                                if (market == 'GTR-Spain') {
                                    newAdditionalClusters.add('GTR-SPAIN');
                                }
                                if (market == 'GTR-Portugal') {
                                    newAdditionalClusters.add('GTR-PORTUGAL');
                                }
                                if (gtrGreeceDistr.contains(market) ) {
                                    newAdditionalClusters.add('GTR-GREECE DISTR');
                                }
                            } else if (additionalCluster == 'SOUTH AFRICA') {
                                if (market == 'Mozambique') {
                                    newAdditionalClusters.add('SEAT');
                                }
                                if (market == 'South Africa') {
                                    newAdditionalClusters.add('SOUTH AFRICA');
                                }
                            } else if (additionalCluster == 'GTR-SOUTH AFRICA') {
                                if (market == 'GTR-Mozambique') {
                                    newAdditionalClusters.add('GTR-SEAT');
                                }
                                if (market == 'GTR-South Africa') {
                                    newAdditionalClusters.add('GTR-SOUTH AFRICA');
                                }
                            } else if (additionalCluster == 'UA, KZ & CIS') {
                                if (market == 'Belarus') {
                                    newAdditionalClusters.add('RUSSIA');
                                }
                                if (market == 'Ukraine') {
                                    newAdditionalClusters.add('UKRAINE');
                                }
                                if (market == 'Kazakhstan' || market == 'Uzbekistan') {
                                    newAdditionalClusters.add('CENTRAL ASIA');
                                }
                                if (market == 'Georgia' || market == 'Moldova' || market == 'Mongolia') {
                                    newAdditionalClusters.add('EE DIST MARKETS');
                                }
                            } else if (additionalCluster == 'GTR-UA, KZ & CIS') {
                                if (market == 'GTR-Belarus') {
                                    newAdditionalClusters.add('GTR-RUSSIA');
                                }
                                if (market == 'GTR-Ukraine') {
                                    newAdditionalClusters.add('GTR-UKRAINE');
                                }
                                if (market == 'GTR-Kazakhstan' || market == 'GTR-Uzbekistan') {
                                    newAdditionalClusters.add('GTR-CENTRAL ASIA');
                                }
                                if (market == 'GTR-Georgia' || market == 'GTR-Moldova' || market == 'GTR-Mongolia') {
                                    newAdditionalClusters.add('GTR-EE DIST MARKETS');
                                }
                            } else if (additionalCluster == 'WEST AFRICA') {
                                if (market == 'Nigeria') {
                                    newAdditionalClusters.add('NIGERIA');
                                }
                                if (market == 'Angola' || market == 'CAR') {
                                    newAdditionalClusters.add('SEAT');
                                }
                                if (cwakCountries.contains(market)) {
                                    newAdditionalClusters.add('CWAK');
                                }
                            } else if (additionalCluster == 'GTR-WEST AFRICA') {
                                if (market == 'GTR-Nigeria') {
                                    newAdditionalClusters.add('GTR-NIGERIA');
                                }
                                if (market == 'GTR-Angola' || market == 'GTR-CAR') {
                                    newAdditionalClusters.add('GTR-SEAT');
                                }
                                if (gtrCwakCountries.contains(market)) {
                                    newAdditionalClusters.add('GTR-CWAK');
                                }
                            } else if (additionalCluster == 'WESTLAC') {
                                if (market == 'Colombia' || market == 'Venezuela') {
                                    newAdditionalClusters.add('CARICAM');
                                }
                                if (southAmerica.contains(market)) {
                                    newAdditionalClusters.add('SOUTH AMERICA');
                                }
                            } else if (additionalCluster == 'GTR-WESTLAC') {
                                if (market == 'GTR-Colombia' || market == 'GTR-Venezuela') {
                                    newAdditionalClusters.add('GTR-CARICAM');
                                }
                                if (gtrSouthAmerica.contains(market)) {
                                    newAdditionalClusters.add('GTR-SOUTH AMERICA');
                                }
                            }
                        }

                        if (additionalCluster == 'BUP') {
                            newAdditionalClusters.add('SOUTH AMERICA');
                        } else if (additionalCluster == 'GTR-BUP') {
                            newAdditionalClusters.add('GTR-SOUTH AMERICA');
                        } else if (additionalCluster == 'CACEM') {
                            newAdditionalClusters.add('CARICAM');
                        } else if (additionalCluster == 'GTR-CACEM') {
                            newAdditionalClusters.add('GTR-CARICAM');
                        } else if (additionalCluster == 'CHINA CLUSTER' || additionalCluster == 'JAPAN & KOREA') {
                            newAdditionalClusters.add('EAST ASIA');
                        } else if (additionalCluster == 'GTR-CHINA CLUSTER' || additionalCluster == 'GTR-JAPAN & KOREA') {
                            newAdditionalClusters.add('GTR-EAST ASIA');
                        } else if (additionalCluster == 'ANZ') {
                            newAdditionalClusters.add('ANZ');
                        } else if (additionalCluster == 'GTR-ANZ') {
                            newAdditionalClusters.add('GTR-ANZ');
                        } else if (additionalCluster == 'CANADA') {
                            newAdditionalClusters.add('CANADA');
                        } else if (additionalCluster == 'GTR-CANADA') {
                            newAdditionalClusters.add('GTR-CANADA');
                        } else if (additionalCluster == 'GULF') {
                            newAdditionalClusters.add('GULF');
                        } else if (additionalCluster == 'GTR-GULF') {
                            newAdditionalClusters.add('GTR-GULF');
                        } else if (additionalCluster == 'INDIA CLUSTER') {
                            newAdditionalClusters.add('INDIA CLUSTER');
                        } else if (additionalCluster == 'GTR-INDIA CLUSTER') {
                            newAdditionalClusters.add('GTR-INDIA CLUSTER');
                        } else if (additionalCluster == 'ISRAEL') {
                            newAdditionalClusters.add('ISRAEL');
                        } else if (additionalCluster == 'GTR-ISRAEL') {
                            newAdditionalClusters.add('GTR-ISRAEL');
                        } else if (additionalCluster == 'LEVANT') {
                            newAdditionalClusters.add('LEVANT');
                        } else if (additionalCluster == 'GTR-LEVANT') {
                            newAdditionalClusters.add('GTR-LEVANT');
                        } else if (additionalCluster == 'MEXICO') {
                            newAdditionalClusters.add('MEXICO');
                        } else if (additionalCluster == 'GTR-MEXICO') {
                            newAdditionalClusters.add('GTR-MEXICO');
                        } else if (additionalCluster == 'NORTH AFRICA') {
                            newAdditionalClusters.add('NORTH AFRICA');
                        } else if (additionalCluster == 'GTR-NORTH AFRICA') {
                            newAdditionalClusters.add('GTR-NORTH AFRICA');
                        } else if (additionalCluster == 'RUSSIA') {
                            newAdditionalClusters.add('RUSSIA');
                        } else if (additionalCluster == 'GTR-RUSSIA') {
                            newAdditionalClusters.add('GTR-RUSSIA');
                        } else if (additionalCluster == 'SOUTH EAST ASIA') {
                            newAdditionalClusters.add('SOUTH EAST ASIA');
                        } else if (additionalCluster == 'GTR-SOUTH EAST ASIA') {
                            newAdditionalClusters.add('GTR-SOUTH EAST ASIA');
                        } else if (additionalCluster == 'UK AND IRELAND') {
                            newAdditionalClusters.add('UK AND IRELAND');
                        } else if (additionalCluster == 'GTR-UK AND IRELAND') {
                            newAdditionalClusters.add('GTR-UK AND IRELAND');
                        } else if (additionalCluster == 'UNITED STATES') {
                            newAdditionalClusters.add('UNITED STATES');
                        } else if (additionalCluster == 'GTR-UNITED STATES') {
                            newAdditionalClusters.add('GTR-UNITED STATES');
                        }
                    }
                    if (!newAdditionalClusters.isEmpty()) {
                        project.AddAdditionalClusterOrClusters__c = String.join(newAdditionalClusters, ';');
                    }
                }

                //Countries
                if (project.LeadMarket__c == 'Trinidad,Tobago') {
                    project.LeadMarket__c = 'Trinidad Tobago';
                } else if (project.LeadMarket__c == 'GTR-Trinidad,Tobago') {
                    project.LeadMarket__c = 'GTR-Trinidad Tobago';
                }
                //Additional Countries

                if (additionalMarkets.contains('Trinidad,Tobago') || additionalMarkets.contains('GTR-Trinidad,Tobago')) {
                    Set<String> newAdditionalMarkets = new Set<String>();
                    for (String market : additionalMarkets) {
                        if (market == 'Trinidad,Tobago') {
                            newAdditionalMarkets.add('Trinidad Tobago');
                        } else if (market == 'GTR-Trinidad,Tobago') {
                            newAdditionalMarkets.add('GTR-Trinidad Tobago');
                        } else {
                            newAdditionalMarkets.add(market);
                        }
                    }
                    if (!newAdditionalMarkets.isEmpty()) {
                        project.AddAdditionalMarketOrMarkets__c = String.join(newAdditionalMarkets, ';');
                    }
                }

                projectsToUpdate.add(project);
            }
            if (!projectsToUpdate.isEmpty()) {
                update projectsToUpdate;
            }
        }
    }
    /**
     * Method to execute post-processing operations
     * @param batchableContext - The parameter type of a batch job method
     */
    public void finish(Database.BatchableContext batchableContext) { }
}