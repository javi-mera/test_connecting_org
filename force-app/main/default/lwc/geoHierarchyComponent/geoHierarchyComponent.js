import {LightningElement, api, wire} from 'lwc';
import {publish, subscribe, MessageContext} from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';
import {constants} from 'c/utils';

import apexSearchMarkets from '@salesforce/apex/LookupGeoHierarchyController.searchMarkets';
import apexSearchAllMarkets from '@salesforce/apex/LookupGeoHierarchyController.searchAllMarkets';
import apexSearchAllAdditionalMarkets from '@salesforce/apex/LookupGeoHierarchyController.searchAdditionalGeoHierarchyByMarkets';
import apexSearchGeoHierarchyByMarket from '@salesforce/apex/LookupGeoHierarchyController.searchGeoHierarchyByMarket';
import apexSearchDistributionChannels from '@salesforce/apex/LookupGeoHierarchyController.searchDistributionChannels';
import apexSearchAllDistributionChannels from '@salesforce/apex/LookupGeoHierarchyController.searchAllDistributionChannels';
import apexSearchTradeType from '@salesforce/apex/LookupGeoHierarchyController.searchTradeTypes';
import apexSearchAllTradeTypes from '@salesforce/apex/LookupGeoHierarchyController.searchAllTradeTypes';
import apexSearchBrandHome from '@salesforce/apex/LookupGeoHierarchyController.searchBrandHomes';
import apexSearchAllBrandHomes from '@salesforce/apex/LookupGeoHierarchyController.searchAllBrandHomes';
import calculateBMC from '@salesforce/apex/BMCMatrixService.calculateBMC';

export default class GeoHierarchyComponent extends LightningElement {
    label = {
        constants
    };

    @api projectId;
    @api initialLeadMarket;
    @api initialLeadRegion;
    @api initialLeadHub;
    @api initialLeadCluster;
    @api initialDistributionChannel;
    @api initialTradeType;
    @api initialBrandHome;
    @api initialAdditionalMarkets;
    @api initialAdditionalRegions;
    @api initialAdditionalHubs;
    @api initialAdditionalClusters;

    @api selectedLeadMarket;
    @api selectedLeadRegion;
    @api selectedLeadHub;
    @api selectedLeadCluster;
    @api selectedDistributionChannel;
    @api selectedTradeType;
    @api selectedBrandHome;
    @api selectedAdditionalMarkets;
    @api selectedAdditionalRegions;
    @api selectedAdditionalHubs;
    @api selectedAdditionalClusters;

    @api isAdmin = false;
    @api bmcClassification = '';
    @api marketClassification = '';
    @api projectPriorityJustification = "";
    @api leadRegionAlignedToProject;
    @api currentPhase;
    @api projectClassification;
    @api projectClassificationSubtype;
    @api noChangesNeededForPromotionalPack;
    @api isSameMarketPromoPack;

    showPromotionalPackBlock = false;
    isBrandHome = false;
    isLoaded = false;

    isLeadGeoDisabled = false;
    isAdditionalGeoDisabled = false;
    isInputDisabled = true;

    _bmcOptions = Object.freeze([
        {label: 'Air', value: 'Air'},
        {label: 'Sand', value: 'Sand'},
        {label: 'Pebble', value: 'Pebble'},
        {label: 'Stone', value: 'Stone'},
        {label: 'Boulder', value: 'Boulder'},
        {label: 'New to World', value: 'New to World'}
    ]);

    _marketOptions = Object.freeze([
        {label: 'Global Footprint', value: 'Global Footprint'},
        {label: 'Established', value: 'Established'},
        {label: 'Future Star 1', value: 'Future Star 1'},
        {label: 'Future Star 2', value: 'Future Star 2'},
        {label: 'Future Star 3', value: 'Future Star 3'},
        {label: 'Hotspot', value: 'Hotspot'},
        {label: 'Must Win', value: 'Must Win'},
        {label: 'New to World', value: 'New to World'}
    ]);

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.showPromotionalPackBlock = this.projectClassification === constants.CONST_PROMOTIONAL_PACK_NAME && this.projectClassificationSubtype === constants.CONST_REPEATING_PROMOTIONAL_PACK_NAME && !this.isSameMarketPromoPack;

        this.selectedLeadMarket = this.initialLeadMarket;
        this.selectedLeadRegion = this.initialLeadRegion;
        this.selectedLeadHub = this.initialLeadHub;
        this.selectedLeadCluster = this.initialLeadCluster;
        this.selectedDistributionChannel = this.initialDistributionChannel;
        this.selectedTradeType = this.initialTradeType;
        this.selectedBrandHome = this.initialBrandHome;
        this.selectedAdditionalMarkets = this.initialAdditionalMarkets;
        this.selectedAdditionalRegions = this.initialAdditionalRegions;
        this.selectedAdditionalHubs = this.initialAdditionalHubs;
        this.selectedAdditionalClusters = this.initialAdditionalClusters;

        this.initialLeadMarket = this.transformGeoValues(this.initialLeadMarket);
        this.initialLeadRegion = this.transformGeoValues(this.initialLeadRegion);
        this.initialLeadHub = this.transformGeoValues(this.initialLeadHub);
        this.initialLeadCluster = this.transformGeoValues(this.initialLeadCluster);
        this.initialDistributionChannel = this.getGeoHierarchyValuesList(this.initialDistributionChannel);
        this.initialTradeType = this.getGeoHierarchyValuesList(this.initialTradeType);
        this.initialBrandHome = this.getGeoHierarchyValuesList(this.initialBrandHome);
        this.initialAdditionalMarkets = this.getGeoHierarchyValuesList(this.initialAdditionalMarkets);
        this.initialAdditionalRegions = this.getGeoHierarchyValuesList(this.initialAdditionalRegions);
        this.initialAdditionalHubs = this.getGeoHierarchyValuesList(this.initialAdditionalHubs);
        this.initialAdditionalClusters = this.getGeoHierarchyValuesList(this.initialAdditionalClusters);

        if (this.isEmpty(this.selectedLeadMarket)) {
            this.isLeadGeoDisabled = true;
        }
        if (this.isEmpty(this.selectedAdditionalMarkets)) {
            this.isInputDisabled = false;
            this.isAdditionalGeoDisabled = true;
        }
    }

    renderedCallback() {
        if (!this.isLoaded) {
            this.checkBrandHome();
            this.isLoaded = true;
        }
    }

    checkBrandHome() {
        const tradeTypeLookup = this.template.querySelector('c-lookup[data-field="Trade Type"]');
        const tradeTypeSelection = tradeTypeLookup.getSelection().map((selection) => selection.title);
        this.isBrandHome = tradeTypeSelection.includes(constants.BRAND_HOME_LABEL);
    }

    getGeoHierarchyValuesList(stringValue) {
        let list = [];
        if (!this.isEmpty(stringValue)) {
            stringValue = stringValue.toString();
            let removedLastCharString = stringValue.slice(-1) === ';' ? stringValue.slice(0, -1) : stringValue;
            let valuesList = removedLastCharString.split(';');
            for (const value of valuesList) {
                list.push(this.transformGeoValues(value));
            }
        }
        return list;
    }

    isEmpty(value) {
        return value === undefined || value === null || value === '';
    }

    transformGeoValues(value) {
        let result = [];
        if (!this.isEmpty(value)) {
            result = {
                icon: constants.GEO_HIERARCHY_ICON,
                id: value,
                sObjectType: constants.GEO_HIERARCHY_OBJECT,
                subtitle: value,
                title: value,
                value: value
            };
        }
        return result;
    }

    subscribeToMessageChannel() {
        subscribe(this.messageContext, MESSAGE_CHANNEL, () => {
            this.template.querySelectorAll('c-lookup').forEach((currentElement) => {
                currentElement.getCustomHelpText();
            })
        })
    }

    @api
    handlePublishEvent() {
        publish(this.messageContext, MESSAGE_CHANNEL, null);
        this.template.querySelectorAll('c-custom-help-text').forEach((currentElement) => {
            currentElement.handleClose();
        })
    }

    setListOfObject(results, searchElement) {
        if (results !== undefined && results.length > 0) {
            searchElement.setListOfObjects(results);
        } else {
            searchElement.hideModal();
        }
    }

    handleSearchLeadMarket(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.LEAD_MARKET_LABEL) {
                searchElement = lookup;
            }
        }
        if (searchElement.getSelection().length < 1) {
            apexSearchMarkets({
                searchTerm: event.detail.searchTerm,
                selectedIds: event.detail.selectedIds
            })
                .then((results) => {
                    searchElement.setSearchResults(results);
                }).catch((error) => {
                alert(error);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });
        }
    }

    handleSearchAllMarkets(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.LEAD_MARKET_LABEL) {
                searchElement = lookup;
            }
        }
        if (searchElement.getSelection().length < 1) {
            apexSearchAllMarkets({
                selectedIds: event.detail.selectedIds
            })
                .then((results) => {
                    this.setListOfObject(results, searchElement);
                }).catch((error) => {
                alert(error);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });
        }
    }

    handleLeadMarketChange(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        const leadMarket = event.detail.selectedIds[0];
        apexSearchGeoHierarchyByMarket({
            searchTerm: leadMarket
        })
            .then((results) => {
                const leadRegion = results[0].id;
                const leadHub = results[0].title;
                const leadCluster = results[0].subtitle;
                const distributionChannel = results[0].value;
                let leadRegionLookup;
                let leadHubLookup;
                let leadClusterLookup;
                let distributionChannelLookup;
                for (const lookup of lookups) {
                    if (lookup.label === constants.LEAD_REGION_LABEL) {
                        leadRegionLookup = lookup;
                    }
                    if (lookup.label === constants.LEAD_HUB_LABEL) {
                        leadHubLookup = lookup;
                    }
                    if (lookup.label === constants.LEAD_CLUSTER_LABEL) {
                        leadClusterLookup = lookup;
                    }
                    if (lookup.label === constants.DISTRIBUTION_CHANNELS_LABEL) {
                        distributionChannelLookup = lookup;
                    }
                }

                leadRegionLookup.selection = this.transformGeoValues(leadRegion);
                leadHubLookup.selection = this.transformGeoValues(leadHub);
                leadClusterLookup.selection = this.transformGeoValues(leadCluster);
                distributionChannelLookup.selection = this.transformGeoValues(distributionChannel);
                this.selectedLeadMarket = leadMarket;
                this.selectedLeadRegion = leadRegion;
                this.selectedLeadHub = leadHub;
                this.selectedLeadCluster = leadCluster;
                this.selectedDistributionChannel = distributionChannel;

                this.isLeadGeoDisabled = false;
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });

        this.setBMCFromCalculation();
    }

    handleLeadMarketRemoval() {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchRegion;
        let searchHub;
        let searchCluster;
        let searchMarket;
        let distributionChannel;
        for (const lookup of lookups) {
            if (lookup.label === constants.LEAD_MARKET_LABEL) {
                searchMarket = lookup;
            }
            if (lookup.label === constants.LEAD_REGION_LABEL) {
                searchRegion = lookup;
            }
            if (lookup.label === constants.LEAD_HUB_LABEL) {
                searchHub = lookup;
            }
            if (lookup.label === constants.LEAD_CLUSTER_LABEL) {
                searchCluster = lookup;
            }
            if (lookup.label === constants.DISTRIBUTION_CHANNELS_LABEL) {
                distributionChannel = lookup;
            }
        }

        searchMarket.handleClearSelection();
        searchRegion.handleClearSelection();
        searchHub.handleClearSelection();
        searchCluster.handleClearSelection();
        distributionChannel.handleClearSelection();

        this.selectedLeadMarket = '';
        this.selectedLeadRegion = '';
        this.selectedLeadHub = '';
        this.selectedLeadCluster = '';
        this.selectedDistributionChannel = '';

        this.isLeadGeoDisabled = true;

        this.setBMCFromCalculation();
    }

    handleSearchDistributionChannel(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.DISTRIBUTION_CHANNELS_LABEL) {
                searchElement = lookup;
            }
        }
        apexSearchDistributionChannels(event.detail)
            .then((results) => {
                searchElement.setSearchResults(results);
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleSearchAllDistributionChannel(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.DISTRIBUTION_CHANNELS_LABEL) {
                searchElement = lookup;
            }
        }

        apexSearchAllDistributionChannels(event.detail)
            .then((results) => {
                if (results.length > 0) {
                    searchElement.setListOfObjects(results);
                } else {
                    searchElement.hideModal();
                }
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleDistributionChannelChange(event) {
        let newChannels = '';
        for (let channel of event.detail.selectedIds) {
            newChannels += channel + ';';
        }
        this.selectedDistributionChannel = newChannels;
    }

    handleSearchTradeType(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.TRADE_TYPE_LABEL) {
                searchElement = lookup;
            }
        }

        apexSearchTradeType(event.detail)
            .then((results) => {
                searchElement.setSearchResults(results);
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleSearchAllTradeTypes(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.TRADE_TYPE_LABEL)
                searchElement = lookup;
        }

        apexSearchAllTradeTypes(event.detail)
            .then((results) => {
                if (results.length > 0) {
                    searchElement.setListOfObjects(results);
                } else {
                    searchElement.hideModal();
                }
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleTradeTypeChange(event) {
        let newTradeTypes = '';
        for (let tradeType of event.detail.selectedIds) {
            newTradeTypes += tradeType + ';';
        }
        this.selectedTradeType = newTradeTypes;
        this.isBrandHome = this.selectedTradeType.includes(constants.BRAND_HOME_LABEL);
    }

    handleSearchBrandHome(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.BRAND_HOME_LABEL) {
                searchElement = lookup;
            }
        }

        apexSearchBrandHome(event.detail)
            .then((results) => {
                searchElement.setSearchResults(results);
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleSearchAllBrandHomes(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.BRAND_HOME_LABEL)
                searchElement = lookup;
        }

        apexSearchAllBrandHomes(event.detail)
            .then((results) => {
                if (results.length > 0) {
                    searchElement.setListOfObjects(results);
                } else {
                    searchElement.hideModal();
                }
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleBrandHomeChange(event) {
        let newBrandHomes = '';
        for (let brandHome of event.detail.selectedIds) {
            newBrandHomes += brandHome + ';';
        }
        this.selectedBrandHome = newBrandHomes;
    }

    get showProjectPriorityJustification() {
        return this.bmcClassification === 'Pebble' || this.bmcClassification === 'Sand' || this.bmcClassification === 'Air';
    }

    get disableBMC() {
        return !this.isAdmin;
    }

    handleClassificationChange(event) {
        this[event.currentTarget.dataset.field] = event.detail.value;
    }

    handleProjectPriorityJustificationChange(event) {
        this.projectPriorityJustification = event.detail.value;
    }

    get marketClassificationFormula() {
        return this.marketClassification !== '' ? this.marketClassification : 'N/A';
    }

    get disableLeadRegionAlignedToProject() {
        if (this.projectClassification === constants.CONST_CI_NAME || this.projectClassification === constants.CONST_MANDATORY_NAME || this.projectClassification === constants.CONST_PROMOTIONAL_PACK_NAME) {
            return false;
        }
        return this.currentPhase === '1' || this.currentPhase === '2' || this.currentPhase === '3';
    }

    handleLeadRegionAlignedToProjectValueChange() {
        this.leadRegionAlignedToProject = !this.leadRegionAlignedToProject;
    }

    handleNoChangesNeededForPromotionalPackChange() {
        this.noChangesNeededForPromotionalPack = !this.noChangesNeededForPromotionalPack;
    }

    handleSearchAdditionalMarket(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.ADDITIONAL_MARKET_LABEL) {
                searchElement = lookup;
            }
        }

        apexSearchMarkets({
            searchTerm: event.detail.searchTerm,
            selectedIds: event.detail.selectedIds
        })
            .then((results) => {
                searchElement.setSearchResults(results);
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleSearchAllAdditionalMarkets(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === constants.ADDITIONAL_MARKET_LABEL) {
                searchElement = lookup;
            }
        }

        apexSearchAllMarkets({
            selectedIds: event.detail.selectedIds
        })
            .then((results) => {
                this.setListOfObject(results, searchElement);
            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });

    }

    handleAdditionalMarketChange(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        const additionalMarkets = event.detail.selectedIds;
        apexSearchAllAdditionalMarkets({
            selectedMarkets: additionalMarkets,
        })
            .then((results) => {
                let additionalRegionsList = [];
                let additionalHubsList = [];
                let additionalClustersList = [];

                let additionalRegionLookup;
                let additionalHubLookup;
                let additionalClusterLookup;
                for (const lookup of lookups) {
                    if (lookup.label === constants.ADDITIONAL_REGION_LABEL) {
                        additionalRegionLookup = lookup;
                    }
                    if (lookup.label === constants.ADDITIONAL_HUB_LABEL) {
                        additionalHubLookup = lookup;
                    }
                    if (lookup.label === constants.ADDITIONAL_CLUSTER_LABEL) {
                        additionalClusterLookup = lookup;
                    }
                }

                for (let region of additionalRegionLookup.selection) {
                    additionalRegionsList.push(region.value);
                }

                for (let hub of additionalHubLookup.selection) {
                    additionalHubsList.push(hub.value);
                }

                for (let cluster of additionalClusterLookup.selection) {
                    additionalClustersList.push(cluster.value);
                }

                if (this.isEmpty(this.selectedAdditionalMarkets)) {
                    additionalRegionLookup.selection = [];
                    additionalHubLookup.selection = [];
                    additionalClusterLookup.selection = [];
                }
                for (let record of results) {
                    if (!additionalRegionsList.includes(record.id)) {
                        additionalRegionsList.push(record.id);
                        additionalRegionLookup.selection = [...additionalRegionLookup.selection, this.transformGeoValues(record.id)];
                    }

                    if (!additionalHubsList.includes(record.title)) {
                        additionalHubsList.push(record.title);
                        additionalHubLookup.selection = [...additionalHubLookup.selection, this.transformGeoValues(record.title)];
                    }

                    if (!additionalClustersList.includes(record.value)) {
                        additionalClustersList.push(record.value);
                        additionalClusterLookup.selection = [...additionalClusterLookup.selection, this.transformGeoValues(record.value)];
                    }
                }


                this.selectedAdditionalMarkets = additionalMarkets.join(';');
                this.selectedAdditionalRegions = additionalRegionsList.join(';');
                this.selectedAdditionalHubs = additionalHubsList.join(';');
                this.selectedAdditionalClusters = additionalClustersList.join(';');

                this.isInputDisabled = true;
                this.isAdditionalGeoDisabled = false;

            }).catch((error) => {
            alert(error);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });

        this.setBMCFromCalculation();
    }

    handleAdditionalMarketRemoval() {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchMarket;
        let searchRegion;
        let searchHub;
        let searchCluster;
        for (const lookup of lookups) {
            if (lookup.label === constants.ADDITIONAL_MARKET_LABEL) {
                searchMarket = lookup;
            }
            if (lookup.label === constants.ADDITIONAL_REGION_LABEL) {
                searchRegion = lookup;
            }
            if (lookup.label === constants.ADDITIONAL_HUB_LABEL) {
                searchHub = lookup;
            }
            if (lookup.label === constants.ADDITIONAL_CLUSTER_LABEL) {
                searchCluster = lookup;
            }
        }

        let additionalMarkets = [];
        if (this.isEmpty(searchMarket.selection[0])) {
            searchMarket.handleClearSelection();
            searchRegion.handleClearSelection();
            searchHub.handleClearSelection();
            searchCluster.handleClearSelection();

            this.selectedAdditionalMarkets = '';
            this.selectedAdditionalRegions = '';
            this.selectedAdditionalHubs = '';
            this.selectedAdditionalClusters = '';

            this.isInputDisabled = false;
            this.isAdditionalGeoDisabled = true;
        } else {
            for (let market of searchMarket.selection) {
                additionalMarkets.push(market.value);
            }

            apexSearchAllAdditionalMarkets({
                selectedMarkets: additionalMarkets,

            })
                .then((results) => {
                    let additionalRegionsList = [];
                    let additionalHubsList = [];
                    let additionalClustersList = [];

                    searchRegion.handleClearSelection();
                    searchHub.handleClearSelection();
                    searchCluster.handleClearSelection();

                    for (let record of results) {
                        if (!additionalRegionsList.includes(record.id)) {
                            additionalRegionsList.push(record.id);
                            searchRegion.selection = [...searchRegion.selection, this.transformGeoValues(record.id)];
                        }

                        if (!additionalHubsList.includes(record.title)) {
                            additionalHubsList.push(record.title);
                            searchHub.selection = [...searchHub.selection, this.transformGeoValues(record.title)];
                        }

                        if (!additionalClustersList.includes(record.value)) {
                            additionalClustersList.push(record.value);
                            searchCluster.selection = [...searchCluster.selection, this.transformGeoValues(record.value)];
                        }
                    }

                    this.selectedAdditionalMarkets = additionalMarkets.join(';');
                    this.selectedAdditionalRegions = additionalRegionsList.join(';');
                    this.selectedAdditionalHubs = additionalHubsList.join(';');
                    this.selectedAdditionalClusters = additionalClustersList.join(';');

                    this.isInputDisabled = true;
                    this.isAdditionalGeoDisabled = false;

                }).catch((error) => {
                alert(error);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });

        }

        this.setBMCFromCalculation();
    }

    setBMCFromCalculation() {
        const leadLookup = this.template.querySelectorAll('c-lookup[data-field="Lead Market"]')[0].getSelection().map((selection) => selection.id);
        const additionalLookup = this.template.querySelectorAll('c-lookup[data-field="Additional Market"]')[0].getSelection().map((selection) => selection.id);

        calculateBMC({
            recordId: this.projectId,
            leadMarket: leadLookup[0],
            additionalMarkets: additionalLookup.join(';')
        }).then((response) => {
            if (response == null) {
                return;
            }
            this.bmcClassification = response.BMC;
            this.marketClassification = response.Market;
        })
    }
}