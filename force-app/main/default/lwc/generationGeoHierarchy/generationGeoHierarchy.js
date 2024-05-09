//DEPRECATED COMPONENT
import { api, LightningElement, wire } from 'lwc';
// import { CurrentPageReference } from 'lightning/navigation';
// import { publish, subscribe, MessageContext } from 'lightning/messageService';
// import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';
// import {getRecord} from "lightning/uiRecordApi";
// import SAME_MARKET_PROMOTIONAL_PACK from '@salesforce/schema/Project__c.IsSameMarketPromotionalPack__c';
//
// import LEAD_REGION_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Region_Help_Text';
// import LEAD_HUB_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Hub_Help_Text';
// import LEAD_CLUSTER_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Cluster_Help_Text';
// import LEAD_MARKET_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Market_Help_Text';
// import LEAD_REGION_ALIGNED_HELP_TEXT_LABEL from '@salesforce/label/c.Lead_Region_Aligned_To_Project_Help_Text';
// import NO_CHANGES_NEEDED_FOR_PROMOTIONAL_PACK_LABEL from '@salesforce/label/c.No_Changes_Needed_for_Promotional_Pack_Label';
// import NO_CHANGES_NEEDED_FOR_PROMOTIONAL_PACK_HELP_TEXT_LABEL from '@salesforce/label/c.No_Changes_Needed_for_Promotional_Pack_Help_Text';
//
// import apexSearchRegions from '@salesforce/apex/LookupGeoHierarchyController.searchRegions';
// import apexSearchAllRegions from '@salesforce/apex/LookupGeoHierarchyController.searchAllRegions';
// import apexSearchHubs from '@salesforce/apex/LookupGeoHierarchyController.searchHubs';
// import apexSearchAllHubs from '@salesforce/apex/LookupGeoHierarchyController.searchAllHubs';
// import apexSearchClusters from '@salesforce/apex/LookupGeoHierarchyController.searchClusters';
// import apexSearchAllClusters from '@salesforce/apex/LookupGeoHierarchyController.searchAllClusters';
// import apexSearchDistributionChannels from '@salesforce/apex/LookupGeoHierarchyController.searchDistributionChannels';
// import apexSearchAllDistributionChannels from '@salesforce/apex/LookupGeoHierarchyController.searchAllDistributionChannels';
// import apexSearchTradeType from '@salesforce/apex/LookupGeoHierarchyController.searchTradeTypes';
// import apexSearchAllTradeTypes from '@salesforce/apex/LookupGeoHierarchyController.searchAllTradeTypes';
// import apexSearchBrandHome from '@salesforce/apex/LookupGeoHierarchyController.searchBrandHomes';
// import apexSearchAllBrandHomes from '@salesforce/apex/LookupGeoHierarchyController.searchAllBrandHomes';
// import apexSearchMarkets from '@salesforce/apex/LookupGeoHierarchyController.searchMarkets';
// import apexSearchAllMarkets from '@salesforce/apex/LookupGeoHierarchyController.searchAllMarkets';
// import apexSearchGeoHierarchyByMarket from '@salesforce/apex/LookupGeoHierarchyController.searchGeoHierarchyByMarket';
// import calculateBMC from '@salesforce/apex/BMCMatrixService.calculateBMC';
// import searchBrandHomes from '@salesforce/apex/LookupGeoHierarchyController.searchBrandHomes';
//
// const ADDITIONAL_REGION_LABEL = 'Additional Region(s) to launch this fiscal year';
// const ADDITIONAL_HUB_LABEL = 'Additional Hub(s) to launch this fiscal year';
// const ADDITIONAL_CLUSTER_LABEL = 'Additional Cluster(s) to launch this fiscal year';
// const ADDITIONAL_MARKET_LABEL = 'Additional Market(s) to launch this fiscal year';
//
// const CI = "Continuous Improvement";
// const MANDATORY = "Mandatory";
// const PROMOTIONAL_PACK = "Promotional Pack";
// const PROMOTIONAL_PACK_REPEAT_SUBTYPE = "Repeat of Previous or Existing Promotional Pack";
// const PROJECT_PRIORITY_JUSTIFICATION = 'Please clarify why this project is required if it is not for a Priority BMC';

export default class GenerationGeoHierarchy extends LightningElement {
    @api
    isDisabled = false;
    // @wire(CurrentPageReference)
    // pageRef;

    @api projectId;
    @api initialSelectionHub = [];
    @api initialSelectionSecondaryMarket = [];
    @api initialSelectionDistributionChannel = [];
    @api initialSelectionLeadRegion = [];
    @api initialSelectionTradeType = [];
    @api initialSelectionBrandHome = [];
    @api initialSelectionCluster = [];
    @api initialSelectionCity = [];
    @api initialSelectionMarket = [];
    @api initialSelectionAdditionalRegion = [];
    @api initialSelectionAdditionalHub = [];
    @api initialSelectionAdditionalCluster = [];
    @api initialSelectionAdditionalMarket = [];
    @api isPM = false;
    @api isAdmin = false;
    @api disableLeadMarket;
    @api isBMC = false; //Deprecated
    @api bmcClassification = '';
    @api marketClassification = '';
    @api bmcCalculated = false;
    @api projectPriorityJustification = "";
    @api areChangesNeededForPromotionalPack; // Deprecated

    @api selectedRegions=[];
    @api selectedDistributionChannels=[];
    @api selectionTradeType=[];
    @api selectionBrandHome = [];
    @api tradeType="";
    @api selectionClusters=[];
    @api selectionCity=[];
    @api selectionHubs=[];
    @api selectionMarket=[];
    @api showAdditional;
    @api selectionAdditionalRegions=[];
    @api selectionAdditionalHubs=[];
    @api selectionAdditionalClusters=[];
    @api selectionAdditionalMarkets=[];

    @api currentPhase;
    @api projectClassification;
    @api leadRegionAlignedToProject;

    @api noChangesNeededForPromotionalPack;

    // showPromotionalPackBlock = false;
    // isBrandHome = false;
    // isLoaded = false;
    //
    // _bmcOptions = Object.freeze([
    //     {label: 'Air', value: 'Air'},
    //     {label: 'Sand', value: 'Sand'},
    //     {label: 'Pebble', value: 'Pebble'},
    //     {label: 'Stone', value: 'Stone'},
    //     {label: 'Boulder', value: 'Boulder'},
    //     {label: 'New to World', value: 'New to World'}
    // ]);
    //
    // _marketOptions = Object.freeze([
    //     {label: 'Global Footprint', value: 'Global Footprint'},
    //     {label: 'Established', value: 'Established'},
    //     {label: 'Future Star 1', value: 'Future Star 1'},
    //     {label: 'Future Star 2', value: 'Future Star 2'},
    //     {label: 'Future Star 3', value: 'Future Star 3'},
    //     {label: 'Hotspot', value: 'Hotspot'},
    //     {label: 'Must Win', value: 'Must Win'},
    //     {label: 'New to World', value: 'New to World'}
    // ]);
    //
    // @wire(MessageContext)
    // messageContext;
    //
    // leadRegionHelpText = LEAD_REGION_HELP_TEXT_LABEL;
    // leadHubHelpText = LEAD_HUB_HELP_TEXT_LABEL;
    // leadClusterHelpText = LEAD_CLUSTER_HELP_TEXT_LABEL;
    // leadMarketHelpText = LEAD_MARKET_HELP_TEXT_LABEL;
    // leadRegionAlignedHelpText = LEAD_REGION_ALIGNED_HELP_TEXT_LABEL;
    // noChangesNeededForPromotionalPackLabelText = NO_CHANGES_NEEDED_FOR_PROMOTIONAL_PACK_LABEL;
    // noChangesNeededForPromotionalPackHelpText = NO_CHANGES_NEEDED_FOR_PROMOTIONAL_PACK_HELP_TEXT_LABEL;
    //
    // addRegionsTest = [];
    // connectedCallback(){
    //     this.subscribeToMessageChannel();
    //     console.log('this.initialSelectionLeadRegion', JSON.stringify(this.initialSelectionLeadRegion))
    //     // console.log('tradeType ', this.tradeType);
    //     // this.initialSelectionMarket = [{ icon: 'standard:location', id: this.tradeType, sObjectType: 'GeoHierarchy__c', subtitle: this.tradeType, title: this.tradeType, value: this.tradeType }];
    //     let string = this.tradeType.slice(0, -1);
    //     let additionalRegions = string.split(';');
    //     console.log('additionalRegions ' + additionalRegions);
    //     for (const region of additionalRegions) {
    //         console.log(region);
    //         this.addRegionsTest.push({ icon: 'standard:location', id: region, sObjectType: 'GeoHierarchy__c', subtitle: region, title: region, value: region })
    //         // console.log(this.initialSelectionAdditionalRegion);
    //     }
    // }
    //
    // renderedCallback() {
    //     if (!this.isLoaded) {
    //         this.handleTradeTypeChange();
    //         this.isLoaded = true;
    //     }
    // }
    //
    // subscribeToMessageChannel() {
    //     subscribe(this.messageContext, MESSAGE_CHANNEL, () => {
    //         this.template.querySelectorAll('c-lookup').forEach((currentElement) => {
    //             currentElement.getCustomHelpText();
    //         })
    //     })
    // }
    //
    // @wire(getRecord, { recordId: '$projectId', fields: [ SAME_MARKET_PROMOTIONAL_PACK ]})
    // projectDetails({error, data}) {
    //     if (data) {
    //         if (this.projectClassification === PROMOTIONAL_PACK && data.fields.ProjectClassificationSubtype__c?.value === PROMOTIONAL_PACK_REPEAT_SUBTYPE && data.fields.IsSameMarketPromotionalPack__c?.value === false) {
    //             this.showPromotionalPackBlock = true;
    //         }
    //     } else if (error) {
    //         console.error(error);
    //     }
    // }
    //
    // @api
    // handlePublishEvent() {
    //     publish(this.messageContext, MESSAGE_CHANNEL, null);
    //     this.template.querySelectorAll('c-custom-help-text').forEach((currentElement) => {
    //         currentElement.handleClose();
    //     })
    // }
    //
    // handleSearchLeadRegion(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Region") {
    //             searchElement = lookup;
    //         }
    //     }
    //     if (searchElement.getSelection().length < 1) {
    //         apexSearchRegions({
    //             searchTerm: event.detail.searchTerm,
    //             selectedIds: event.detail.selectedIds
    //         })
    //         .then((results) => {
    //             searchElement.setSearchResults(results);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchAdditionalRegions(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_REGION_LABEL) {
    //             searchElement = lookup;
    //         }
    //     }
    //     apexSearchRegions({
    //         searchTerm: event.detail.searchTerm,
    //         selectedIds: event.detail.selectedIds
    //     })
    //     .then((results) => {
    //         searchElement.setSearchResults(results);
    //     }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    // }
    //
    // handleSearchAllRegions(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Lead Region") {
    //             searchElement = lookup;
    //         }
    //     }
    //     if (searchElement.getSelection().length < 1) {
    //         apexSearchAllRegions({
    //             selectedIds: event.detail.selectedIds
    //         })
    //         .then((results) => {
    //             this.setListOfObject(results, searchElement);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchAllAdditionalRegions(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_REGION_LABEL) {
    //             searchElement = lookup;
    //         }
    //     }
    //     apexSearchAllRegions({
    //         selectedIds: event.detail.selectedIds
    //     })
    //     .then((results) => {
    //         if (results.length > 0) {
    //             searchElement.setListOfObjects(results);
    //         } else {
    //             searchElement.hideModal();
    //         }
    //     }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    // }
    //
    // handleSearchHub(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Lead Region") {
    //             regionSelection=lookup;
    //         }
    //         if(lookup.label === "Lead Hub") {
    //             searchElement=lookup;
    //         }
    //     }
    //
    //     if (regionSelection.getSelection().length > 0 && searchElement.getSelection().length < 1) {
    //         const searches = regionSelection.getSelection();
    //         apexSearchHubs({
    //             searchTerm: event.detail.searchTerm,
    //             selectedIds: event.detail.selectedIds,
    //             selectedRegions: searches.map((element) => element.value)
    //         }).then((results) => {
    //             searchElement.setSearchResults(results);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    // handleSearchAdditionalHub(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if(lookup.label === ADDITIONAL_HUB_LABEL) {
    //             searchElement=lookup;
    //         }
    //         if(lookup.label === ADDITIONAL_REGION_LABEL) {
    //             regionSelection=lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 ) {
    //         let searches = regionSelection.getSelection();
    //         apexSearchHubs({
    //             searchTerm: event.detail.searchTerm,
    //             selectedIds: event.detail.selectedIds,
    //             selectedRegions: searches.map((element) => element.value)
    //         }).then((results) => {
    //             searchElement.setSearchResults(results);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchAllHubs(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Lead Hub") {
    //             searchElement = lookup;
    //         }
    //         if(lookup.label === "Lead Region") {
    //             regionSelection = lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 && searchElement.getSelection().length < 1) {
    //         const searches = regionSelection.getSelection();
    //         apexSearchAllHubs({
    //             selectedIds: event.detail.selectedIds,
    //             selectedRegions: searches.map((element) => element.value)
    //         }).then((results) => {
    //             this.setListOfObject(results, searchElement);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchAllAdditionalHubs(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_HUB_LABEL) {
    //             searchElement=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_REGION_LABEL) {
    //             regionSelection=lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 ) {
    //         const searches = regionSelection.getSelection();
    //         apexSearchAllHubs({
    //             selectedIds: event.detail.selectedIds,
    //             selectedRegions: searches.map((element) => element.value)
    //         })
    //         .then((results) => {
    //             this.setListOfObject(results, searchElement);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchCluster(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let hubsSelection;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Hub") {
    //             hubsSelection=lookup;
    //         }
    //         if (lookup.label === "Lead Cluster") {
    //             searchElement=lookup;
    //         }
    //         if (lookup.label === "Lead Region") {
    //             regionSelection=lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 && hubsSelection.getSelection().length > 0 && searchElement.getSelection().length < 1) {
    //         let searches = hubsSelection.getSelection();
    //         let searchesRegion = regionSelection.getSelection();
    //         apexSearchClusters({
    //             searchTerm: event.detail.searchTerm,
    //             selectedIds: event.detail.selectedIds,
    //             selectedHubs: searches.map((element) => element.value),
    //             selectedRegions: searchesRegion.map((element) => element.value)
    //         })
    //         .then((results) => {
    //             searchElement.setSearchResults(results);
    //
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchAdditionalCluster(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let hubsSelection;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_HUB_LABEL) {
    //             hubsSelection=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_CLUSTER_LABEL) {
    //             searchElement=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_REGION_LABEL) {
    //             regionSelection=lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 && hubsSelection.getSelection().length > 0 ) {
    //         let searches = hubsSelection.getSelection();
    //         let searchesRegion = regionSelection.getSelection();
    //         apexSearchClusters({
    //             searchTerm: event.detail.searchTerm,
    //             selectedIds: event.detail.selectedIds,
    //             selectedHubs: searches.map((element) => element.value),
    //             selectedRegions: searchesRegion.map((element) => element.value)
    //         })
    //         .then((results) => {
    //             searchElement.setSearchResults(results);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchAllClusters(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let hubsSelection;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Hub") {
    //             hubsSelection=lookup;
    //         }
    //         if (lookup.label === "Lead Cluster") {
    //             searchElement=lookup;
    //         }
    //         if (lookup.label === "Lead Region") {
    //             regionSelection=lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 && hubsSelection.getSelection().length > 0 && searchElement.getSelection().length < 1) {
    //         let searches = hubsSelection.getSelection();
    //         let searchesRegion = regionSelection.getSelection();
    //         apexSearchAllClusters({
    //             selectedIds: event.detail.selectedIds,
    //             selectedHubs: searches.map((element) => element.value),
    //             selectedRegions: searchesRegion.map((element) => element.value)
    //         })
    //         .then((results) => {
    //             searchElement.setListOfObjects(results);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchAllAdditionalClusters(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let hubsSelection;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_HUB_LABEL) {
    //             hubsSelection=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_CLUSTER_LABEL) {
    //             searchElement=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_REGION_LABEL) {
    //             regionSelection=lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 && hubsSelection.getSelection().length > 0 ) {
    //         let searches = hubsSelection.getSelection();
    //         let searchesRegion = regionSelection.getSelection();
    //         apexSearchAllClusters({
    //             selectedIds: event.detail.selectedIds,
    //             selectedHubs: searches.map((element) => element.value),
    //             selectedRegions: searchesRegion.map((element) => element.value)
    //         })
    //         .then((results) => {
    //             this.setListOfObject(results, searchElement);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchLeadMarket(event) { //todo 1
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Market") {
    //             searchElement = lookup;
    //         }
    //     }
    //     if (searchElement.getSelection().length < 1) {
    //         apexSearchMarkets({
    //             searchTerm: event.detail.searchTerm,
    //             selectedIds: event.detail.selectedIds
    //         })
    //             .then((results) => {
    //                 searchElement.setSearchResults(results);
    //             }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    //
    //     // const lookups = this.template.querySelectorAll('c-lookup');
    //     // let searchElement;
    //     // let clusterSelection;
    //     // let hubsSelection;
    //     // let regionSelection;
    //     // for (const lookup of lookups) {
    //     //     if (lookup.label === "Lead Hub") {
    //     //         hubsSelection=lookup;
    //     //     }
    //     //     if (lookup.label === "Lead Cluster") {
    //     //         clusterSelection=lookup;
    //     //     }
    //     //     if (lookup.label === "Lead Market") {
    //     //         searchElement=lookup;
    //     //     }
    //     //     if (lookup.label === "Lead Region") {
    //     //         regionSelection=lookup;
    //     //     }
    //     // }
    //     // if (regionSelection.getSelection().length > 0 && hubsSelection.getSelection().length > 0 && clusterSelection.getSelection().length > 0 && searchElement.getSelection().length < 1) {
    //     //     let searchesHub = hubsSelection.getSelection();
    //     //     let searchesCluster = clusterSelection.getSelection();
    //     //     let searchesRegion = regionSelection.getSelection();
    //     //     apexSearchMarkets({
    //     //         searchTerm: event.detail.searchTerm,
    //     //         selectedIds: event.detail.selectedIds,
    //     //         valuesHubs: searchesHub.map((element) => element.value),
    //     //         valuesClusters : searchesCluster.map((element) => element.value),
    //     //         selectedRegions: searchesRegion.map((element) => element.value)
    //     //     })
    //     //     .then((results) => {
    //     //         searchElement.setSearchResults(results);
    //     //     }).catch((error) => {
    //     //         alert(error);
    //     //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     //     });
    //     // }
    // }
    //
    // handleSearchAdditionalMarket(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     let clusterSelection;
    //     let hubsSelection;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_HUB_LABEL) {
    //             hubsSelection=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_CLUSTER_LABEL) {
    //             clusterSelection=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_MARKET_LABEL) {
    //             searchElement=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_REGION_LABEL) {
    //             regionSelection=lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 && hubsSelection.getSelection().length > 0 && clusterSelection.getSelection().length > 0 ) {
    //         let searchesHub = hubsSelection.getSelection();
    //         let searchesCluster = clusterSelection.getSelection();
    //         let searchesRegion = regionSelection.getSelection();
    //         apexSearchMarkets({
    //             searchTerm: event.detail.searchTerm,
    //             selectedIds: event.detail.selectedIds,
    //             valuesHubs: searchesHub.map((element) => element.value),
    //             valuesClusters : searchesCluster.map((element) => element.value),
    //             selectedRegions: searchesRegion.map((element) => element.value)
    //         })
    //         .then((results) => {
    //             searchElement.setSearchResults(results);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchAllMarkets(event) { //todo 2
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Lead Market") {
    //             searchElement = lookup;
    //         }
    //     }
    //     if (searchElement.getSelection().length < 1) {
    //         apexSearchAllMarkets({
    //             selectedIds: event.detail.selectedIds
    //         })
    //             .then((results) => {
    //                 this.setListOfObject(results, searchElement);
    //             }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    //     // const lookups = this.template.querySelectorAll('c-lookup');
    //     // let searchElement;
    //     // let clusterSelection;
    //     // let hubsSelection;
    //     // let regionSelection;
    //     // for (const lookup of lookups) {
    //     //     if(lookup.label === "Lead Hub") {
    //     //         hubsSelection=lookup;
    //     //     }
    //     //     if(lookup.label === "Lead Cluster") {
    //     //         clusterSelection=lookup;
    //     //     }
    //     //     if(lookup.label === "Lead Market") {
    //     //         searchElement=lookup;
    //     //     }
    //     //     if(lookup.label === "Lead Region") {
    //     //         regionSelection=lookup;
    //     //     }
    //     // }
    //     // if (regionSelection.getSelection().length > 0 && hubsSelection.getSelection().length > 0 && clusterSelection.getSelection().length > 0 && searchElement.getSelection().length < 1) {
    //     //     let searchesHub = hubsSelection.getSelection();
    //     //     let searchesCluster = clusterSelection.getSelection();
    //     //     let searchesRegion = regionSelection.getSelection();
    //     //     apexSearchAllMarkets({
    //     //         selectedIds: event.detail.selectedIds,
    //     //         valuesHubs: searchesHub.map((element) => element.value),
    //     //         valuesClusters : searchesCluster.map((element) => element.value),
    //     //         selectedRegions: searchesRegion.map((element) => element.value)
    //     //     })
    //     //     .then((results) => {
    //     //         this.setListOfObject(results, searchElement);
    //     //     }).catch((error) => {
    //     //         alert(error);
    //     //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     //     });
    //     // }
    // }
    //
    // handleSearchAllAdditionalMarkets(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let clusterSelection;
    //     let hubsSelection;
    //     let searchElement;
    //     let regionSelection;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_HUB_LABEL) {
    //             hubsSelection = lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_CLUSTER_LABEL) {
    //             clusterSelection = lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_MARKET_LABEL) {
    //             searchElement=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_REGION_LABEL) {
    //             regionSelection = lookup;
    //         }
    //     }
    //     if (regionSelection.getSelection().length > 0 && hubsSelection.getSelection().length > 0 && clusterSelection.getSelection().length > 0 ) {
    //         let searchesHub = hubsSelection.getSelection();
    //         let searchesCluster = clusterSelection.getSelection();
    //         let searchesRegion = regionSelection.getSelection();
    //         apexSearchAllMarkets({
    //             selectedIds: event.detail.selectedIds,
    //             valuesHubs: searchesHub.map((element) => element.value),
    //             valuesClusters : searchesCluster.map((element) => element.value),
    //             selectedRegions: searchesRegion.map((element) => element.value)
    //         })
    //         .then((results) => {
    //             this.setListOfObject(results, searchElement);
    //         }).catch((error) => {
    //             alert(error);
    //             document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //         });
    //     }
    // }
    //
    // handleSearchDistributionChannel(event) {
    //     const lookups =  this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Distribution Channel(s)") {
    //             searchElement=lookup;
    //         }
    //     }
    //     apexSearchDistributionChannels(event.detail)
    //     .then((results) => {
    //         searchElement.setSearchResults(results);
    //     }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    //
    // }
    //
    // handleSearchAllDistributionChannel(event) {
    //     const lookups =  this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Distribution Channel(s)") {
    //             searchElement=lookup;
    //         }
    //     }
    //
    //     apexSearchAllDistributionChannels(event.detail)
    //     .then((results) => {
    //         if (results.length > 0) {
    //             searchElement.setListOfObjects(results);
    //         } else {
    //             searchElement.hideModal();
    //         }
    //     }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    //
    // }
    //
    // handleSearchBrandHome(event) {
    //     const lookups =  this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Brand Home") {
    //             searchElement=lookup;
    //         }
    //     }
    //
    //     apexSearchBrandHome(event.detail)
    //     .then((results) => {
    //         searchElement.setSearchResults(results);
    //     }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    // }
    //
    // handleSearchAllBrandHomes(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Brand Home")
    //             searchElement=lookup;
    //     }
    //
    //     apexSearchAllBrandHomes(event.detail)
    //     .then((results) => {
    //         if (results.length > 0) {
    //             searchElement.setListOfObjects(results);
    //         } else {
    //             searchElement.hideModal();
    //         }
    //     }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    // }
    //
    // handleSearchTradeType(event) {
    //     const lookups =  this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Trade Type(s)") {
    //             searchElement=lookup;
    //         }
    //     }
    //
    //     apexSearchTradeType(event.detail)
    //     .then((results) => {
    //         searchElement.setSearchResults(results);
    //     }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    // }
    //
    // handleSearchAllTradeTypes(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElement;
    //     for (const lookup of lookups) {
    //         if(lookup.label === "Trade Type(s)")
    //             searchElement=lookup;
    //     }
    //
    //     apexSearchAllTradeTypes(event.detail)
    //     .then((results) => {
    //         if (results.length > 0) {
    //             searchElement.setListOfObjects(results);
    //         } else {
    //             searchElement.hideModal();
    //         }
    //     }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    // }
    //
    // handleRemoveRegions(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchRegion;
    //     let searchHub;
    //     let searchCluster;
    //     let searchMarket;
    //     let distributionChannel;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Region") {
    //             searchRegion=lookup;
    //         }
    //         if (lookup.label === "Lead Hub") {
    //             searchHub=lookup;
    //         }
    //         if (lookup.label === "Lead Cluster") {
    //             searchCluster=lookup;
    //         }
    //         if (this.showAdditional) {
    //             if(lookup.label === "Lead Market") {
    //                 searchMarket=lookup;
    //             }
    //         }
    //         if (lookup.label === 'Distribution Channel(s)') {
    //             distributionChannel = lookup;
    //         }
    //     }
    //     searchRegion.handleClearSelection();
    //     searchHub.handleClearSelection();
    //     searchCluster.handleClearSelection();
    //     distributionChannel.handleClearSelection();
    //     if (this.showAdditional) {
    //         searchMarket.handleClearSelection();
    //     }
    //     this.setBMCFromCalculation();
    // }
    //
    //
    // handleRemoveHubs(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchCluster;
    //     let searchMarket;
    //     let searchHub;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Hub") {
    //             searchHub=lookup;
    //         }
    //         if (lookup.label === "Lead Cluster") {
    //             searchCluster=lookup;
    //         }
    //         if (this.showAdditional) {
    //             if(lookup.label === "Lead Market") {
    //                 searchMarket=lookup;
    //             }
    //         }
    //
    //     }
    //     searchHub.handleClearSelection();
    //     searchCluster.handleClearSelection();
    //
    //     if (this.showAdditional) {
    //         searchMarket.handleClearSelection();
    //     }
    //     this.setBMCFromCalculation();
    //
    // }
    // handleRemoveAdditionalRegions(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchCluster;
    //     let searchMarket;
    //     let searchHub;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_HUB_LABEL) {
    //             searchHub=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_CLUSTER_LABEL) {
    //             searchCluster=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_MARKET_LABEL) {
    //             searchMarket=lookup;
    //         }
    //     }
    //     searchHub.handleClearSelection();
    //     searchCluster.handleClearSelection();
    //     searchMarket.handleClearSelection();
    //     this.setBMCFromCalculation();
    // }
    //
    // handleRemoveAdditionalHubs(event) {
    //     const lookups =  this.template.querySelectorAll('c-lookup');
    //     let searchCluster;
    //     let searchMarket;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_CLUSTER_LABEL) {
    //             searchCluster=lookup;
    //         }
    //         if (lookup.label === ADDITIONAL_MARKET_LABEL) {
    //             searchMarket=lookup;
    //         }
    //     }
    //     searchCluster.handleClearSelection();
    //     searchMarket.handleClearSelection();
    //     this.setBMCFromCalculation();
    // }
    //
    // handleRemoveLeadCluster(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchMarket;
    //     let searchCluster;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Cluster") {
    //             searchCluster=lookup;
    //         }
    //         if (lookup.label === "Lead Market") {
    //             searchMarket=lookup;
    //         }
    //     }
    //     searchCluster.handleClearSelection();
    //     if (this.showAdditional) {
    //         searchMarket.handleClearSelection();
    //     }
    //     this.setBMCFromCalculation();
    // }
    //
    // handleRemoveAdditionalCluster(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchMarket;
    //     for (const lookup of lookups) {
    //         if (lookup.label === ADDITIONAL_MARKET_LABEL) {
    //             searchMarket=lookup;
    //         }
    //     }
    //     searchMarket.handleClearSelection();
    //     this.setBMCFromCalculation();
    // }
    //
    // handleLeadRegionChange(event) {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let distributionChannel;
    //     for (const lookup of lookups) {
    //         if (lookup.label === 'Distribution Channel(s)') {
    //             distributionChannel = lookup;
    //             break;
    //         }
    //     }
    //     let hasGTR = false;
    //     for (const id of event.detail.selectedIds) {
    //         if (id.includes('GTR')) {
    //             hasGTR = true;
    //             break;
    //         }
    //     }
    //     const distributionChannels = distributionChannel.selection;
    //     const hasGTRDistributionChannel = distributionChannels.filter((channel) => channel.id === 'Travel Retail').length === 1
    //     const hasDomesticDistributionChannel = distributionChannels.filter((channel) => channel.id === 'Domestic').length === 1
    //     if (hasGTR && !hasGTRDistributionChannel) {
    //         distributionChannel.selection = [...distributionChannel.selection, { icon: 'standard:location', id: 'Travel Retail', sObjectType: 'GeoHierarchy__c', subtitle: 'Travel Retail', title: 'Travel Retail', value: 'Travel Retail' }];
    //     } else if (!hasGTR && !hasDomesticDistributionChannel) {
    //         distributionChannel.selection = [...distributionChannel.selection, { icon: 'standard:location', id: 'Domestic', sObjectType: 'GeoHierarchy__c', subtitle: 'Domestic', title: 'Domestic', value: 'Domestic' }];
    //     }
    // }
    //
    // handleTradeTypeChange() {
    //     const tradeTypeLookup = this.template.querySelector('c-lookup[data-field="Trade Type"]');
    //     const tradeTypeSelection = tradeTypeLookup.getSelection().map((selection) => selection.title);
    //     this.isBrandHome = tradeTypeSelection.includes('Brand Home');
    // }
    //
    // @api
    // validate() {
    //     this.selectedRegions = [];
    //     this.selectedDistributionChannels = [];
    //     this.selectionTradeType = [];
    //     this.selectionBrandHome = [];
    //     this.tradeType = "";
    //     this.selectionClusters = [];
    //     this.selectionHubs = [];
    //     this.selectionMarket = [];
    //
    //     let lookups = this.template.querySelectorAll('c-lookup');
    //     let searchElementMarket;
    //     let searchElementChannels;
    //     let searchElementTradeType;
    //     let searchElementBrandHome;
    //     let searchElementRegion;
    //     let searchElementHubs;
    //     let searchElementCluster;
    //     let searchElementAdditionalRegion;
    //     let searchElementAdditionalHubs;
    //     let searchElementAdditionalCluster;
    //     let searchElementAdditionalMarket;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Market") {
    //             searchElementMarket=lookup;
    //         }
    //         if (lookup.label === "Distribution Channel(s)") {
    //             searchElementChannels = lookup;
    //         }
    //         if (lookup.label === "Trade Type(s)") {
    //             searchElementTradeType = lookup;
    //         }
    //         if (lookup.label === "Lead Region") {
    //             searchElementRegion = lookup;
    //         }
    //         if (lookup.label === "Lead Hub") {
    //             searchElementHubs = lookup;
    //         }
    //         if (lookup.label === "Lead Cluster") {
    //             searchElementCluster = lookup;
    //         }
    //         if (this.isBrandHome) {
    //             if (lookup.label === "Brand Home") {
    //                 searchElementBrandHome = lookup;
    //             }
    //         }
    //
    //         if (this.showAdditional) {
    //             // if (lookup.label === "Lead Market") {
    //             //     searchElementMarket=lookup;
    //             // }
    //             if (lookup.label === ADDITIONAL_REGION_LABEL) {
    //                 searchElementAdditionalRegion=lookup;
    //             }
    //             if (lookup.label === ADDITIONAL_HUB_LABEL) {
    //                 searchElementAdditionalHubs=lookup;
    //             }
    //             if (lookup.label === ADDITIONAL_CLUSTER_LABEL) {
    //                 searchElementAdditionalCluster=lookup;
    //             }
    //             if (lookup.label === ADDITIONAL_MARKET_LABEL) {
    //                 searchElementAdditionalMarket=lookup;
    //             }
    //         }
    //     }
    //
    //     let allChannels = searchElementChannels.getSelection();
    //     this.initialSelectionDistributionChannel = allChannels;
    //     for (const channel of allChannels) {
    //         this.selectedDistributionChannels.push(channel.id);
    //     }
    //     let allTradeTypes = searchElementTradeType.getSelection();
    //     this.initialSelectionTradeType = allTradeTypes;
    //     for (const tradeType of allTradeTypes) {
    //         this.selectionTradeType.push(tradeType.id);
    //     }
    //
    //     if (this.isBrandHome) {
    //         let allBrandHomes = searchElementBrandHome.getSelection();
    //         this.initialSelectionBrandHome = allBrandHomes;
    //         for (const brandHome of allBrandHomes) {
    //             this.selectionBrandHome.push(brandHome.id);
    //         }
    //     }
    //
    //     let allClusters = searchElementCluster.getSelection();
    //     this.initialSelectionCluster = allClusters;
    //     for (const cluster of allClusters) {
    //         this.selectionClusters.push(cluster.id);
    //     }
    //     let allHubs = searchElementHubs.getSelection();
    //     this.initialSelectionHub = allHubs;
    //     for (const hub of allHubs) {
    //         this.selectionHubs.push(hub.id);
    //     }
    //     let allRegions = searchElementRegion.getSelection();
    //     this.initialSelectionLeadRegion = allRegions;
    //     for (const region of allRegions) {
    //         this.selectedRegions.push(region.id);
    //     }
    //
    //     let allMarkets;
    //     let allAdditionalClusters;
    //     let allAdditionalHubs;
    //     let allAdditional;
    //     let allAdditionalRegions;
    //
    //     allMarkets = searchElementMarket.getSelection();
    //     this.initialSelectionMarket = allMarkets;
    //     for (const market of allMarkets) {
    //         this.selectionMarket.push(market.id);
    //     }
    //
    //     if (this.showAdditional) {
    //         // allMarkets = searchElementMarket.getSelection();
    //         // if (allMarkets.length > 0 && allMarkets !== undefined) {
    //         //     this.initialSelectionMarket = allMarkets;
    //         //     for (const market of allMarkets) {
    //         //         this.selectionMarket.push(market.id);
    //         //     }
    //         // }
    //         allAdditionalClusters = searchElementAdditionalCluster.getSelection();
    //         this.initialSelectionAdditionalCluster = allAdditionalClusters;
    //         for (const additionalCluster of allAdditionalClusters) {
    //             this.selectionAdditionalClusters.push(additionalCluster.id);
    //         }
    //         allAdditionalHubs = searchElementAdditionalHubs.getSelection();
    //         this.initialSelectionAdditionalHub = allAdditionalHubs;
    //         for (const additionalHub of allAdditionalHubs) {
    //             this.selectionAdditionalHubs.push(additionalHub.id);
    //         }
    //         allAdditional = searchElementAdditionalMarket.getSelection();
    //         this.initialSelectionAdditionalMarket = allAdditional;
    //         for (const additional of allAdditional) {
    //             this.selectionAdditionalMarkets.push(additional.subtitle);
    //         }
    //         allAdditionalRegions = searchElementAdditionalRegion.getSelection();
    //         this.initialSelectionAdditionalRegion = allAdditionalRegions;
    //         for (const additionalRegion of allAdditionalRegions) {
    //             this.selectionAdditionalRegions.push(additionalRegion.id);
    //         }
    //     }
    //     return { isValid: true };
    // }
    //
    // get disableLeadRegionAlignedToProject() {
    //     if (this.projectClassification === CI || this.projectClassification === MANDATORY || this.projectClassification === PROMOTIONAL_PACK) {
    //         return false;
    //     }
    //     return this.currentPhase === '1' || this.currentPhase === '2' || this.currentPhase === '3';
    // }
    //
    // handleLeadRegionAlignedToProjectValue(event) {
    //     this.leadRegionAlignedToProject = !this.leadRegionAlignedToProject;
    // }
    //
    // handleNoChangesNeededForPromotionalPackChange(event) {
    //     this.noChangesNeededForPromotionalPack = !this.noChangesNeededForPromotionalPack;
    // }
    //
    // setListOfObject(results, searchElement) {
    //     if (results !== undefined && results.length > 0) {
    //         searchElement.setListOfObjects(results);
    //     } else {
    //         searchElement.hideModal();
    //     }
    // }
    //
    // get showBMC() {
    //     return ((!this.isAdmin && this.currentPhase !== '1') || (this.isAdmin && this.currentPhase !== '1')) && this.bmcCalculated;
    // }
    //
    // get disableBMC() {
    //     return !this.isAdmin;
    // }
    //
    // get bmcLabel() {
    //     return this.isBMC ? 'Yes' : 'No';
    // }
    //
    // handleClassificationChange(event) {
    //     this[event.currentTarget.dataset.field] = event.detail.value;
    // }
    //
    // // handleProjectPriorityJustificationChange(event) {
    // //     this.projectPriorityJustification = event.detail.value;
    // // }
    //
    // get projectPriorityJustificationLabel() {
    //     return this.currentPhase === '1' ? PROJECT_PRIORITY_JUSTIFICATION : `*${PROJECT_PRIORITY_JUSTIFICATION}`;
    // }
    //
    // get showProjectPriorityJustification() {
    //     return this.bmcClassification === 'Pebble' || this.bmcClassification === 'Sand' || this.bmcClassification === 'Air';
    // }
    //
    // get marketClassificationFormula() {
    //     return this.marketClassification !== '' ? this.marketClassification : 'N/A';
    // }
    //
    // handleLeadMarketChange(event) { //todo 3
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     // const market = this.template.querySelector('c-lookup[data-field="Lead Market"]')
    //     //search the Geo record by Country
    //     //apply all values
    //     console.log('event.detail.searchTerm: ', JSON.stringify(event.detail.selectedIds[0]))
    //     apexSearchGeoHierarchyByMarket({
    //         searchTerm: event.detail.selectedIds[0]
    //     })
    //         .then((results) => {
    //             const leadRegion = results[0].id;
    //             const leadHub = results[0].title;
    //             const leadCluster = results[0].subtitle;
    //             const distributionChannel = results[0].value;
    //             let leadRegionLookup;
    //             let leadHubLookup;
    //             let leadClusterLookup;
    //             let distributionChannelLookup;
    //             for (const lookup of lookups) {
    //                 if (lookup.label === "Lead Region") {
    //                     leadRegionLookup = lookup;
    //                 }
    //                 if (lookup.label === "Lead Hub") {
    //                     leadHubLookup = lookup;
    //                 }
    //                 if (lookup.label === "Lead Cluster") {
    //                     leadClusterLookup = lookup;
    //                 }
    //                 if (lookup.label === "Distribution Channel(s)") {
    //                     distributionChannelLookup = lookup;
    //                 }
    //             }
    //
    //             leadRegionLookup.selection = [...leadRegionLookup.selection, { icon: 'standard:location', id: leadRegion, sObjectType: 'GeoHierarchy__c', subtitle: leadRegion, title: leadRegion, value: leadRegion }];
    //             leadHubLookup.selection = [...leadHubLookup.selection, { icon: 'standard:location', id: leadHub, sObjectType: 'GeoHierarchy__c', subtitle: leadHub, title: leadHub, value: leadHub }];
    //             leadClusterLookup.selection = [...leadClusterLookup.selection, { icon: 'standard:location', id: leadCluster, sObjectType: 'GeoHierarchy__c', subtitle: leadCluster, title: leadCluster, value: leadCluster }];
    //             distributionChannelLookup.selection = [...distributionChannelLookup.selection, { icon: 'standard:location', id: distributionChannel, sObjectType: 'GeoHierarchy__c', subtitle: distributionChannel, title: distributionChannel, value: distributionChannel }];
    //         }).catch((error) => {
    //         alert(error);
    //         document.querySelectorAll("c-lookup").forEach(e => e.remove());
    //     });
    //
    //     this.setBMCFromCalculation();
    // }
    //
    // handleAdditionalMarketChange() {
    //     const lookups = this.template.querySelectorAll('c-lookup');
    //     let searchRegion;
    //     let searchHub;
    //     let searchCluster;
    //     let searchMarket;
    //     let distributionChannel;
    //     for (const lookup of lookups) {
    //         if (lookup.label === "Lead Region") {
    //             searchRegion=lookup;
    //         }
    //         if (lookup.label === "Lead Hub") {
    //             searchHub=lookup;
    //         }
    //         if (lookup.label === "Lead Cluster") {
    //             searchCluster=lookup;
    //         }
    //         // if (this.showAdditional) {
    //         //     if(lookup.label === "Lead Market") {
    //         //         searchMarket=lookup;
    //         //     }
    //         // }
    //         if (lookup.label === 'Distribution Channel(s)') {
    //             distributionChannel = lookup;
    //         }
    //     }
    //     searchRegion.handleClearSelection();
    //     searchHub.handleClearSelection();
    //     searchCluster.handleClearSelection();
    //     distributionChannel.handleClearSelection();
    //     // if (this.showAdditional) {
    //     //     searchMarket.handleClearSelection();
    //     // }
    //
    //     this.setBMCFromCalculation();
    // }
    //
    // setBMCFromCalculation() {
    //     const leadLookup = this.template.querySelectorAll('c-lookup[data-field="Lead Market"]')[0].getSelection().map((selection) => selection.subtitle);
    //     const additionalLookup = this.template.querySelectorAll('c-lookup[data-field="Additional Market"]')[0].getSelection().map((selection) => selection.subtitle);
    //     calculateBMC({ recordId: this.projectId, leadMarket: leadLookup[0], additionalMarkets: additionalLookup.join(';')}).then((response) => {
    //         if (response == null) {
    //             return;
    //         }
    //         this.bmcClassification = response.BMC;
    //         this.marketClassification = response.Market;
    //     })
    //
    // }

}