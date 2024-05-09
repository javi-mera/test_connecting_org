import { api, LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';

import apexSearchCategories from '@salesforce/apex/LookupProductHierarchyController.searchCategories';
import apexSearchAllCategories from '@salesforce/apex/LookupProductHierarchyController.searchAllCategories';
import apexSearchBrands from '@salesforce/apex/LookupProductHierarchyController.searchBrands';
import apexSearchAllBrands from '@salesforce/apex/LookupProductHierarchyController.searchAllBrands';
import apexSearchSubBrands from '@salesforce/apex/LookupProductHierarchyController.searchSubBrands';
import apexSearchAllSubBrands from '@salesforce/apex/LookupProductHierarchyController.searchAllSubBrands';
import apexSearchFlavours from '@salesforce/apex/LookupProductHierarchyController.searchFlavours';
import apexSearchAllFlavours from '@salesforce/apex/LookupProductHierarchyController.searchAllFlavours';
import apexSearchSizes from '@salesforce/apex/LookupProductHierarchyController.searchSizes';
import apexSearchAllSizes from '@salesforce/apex/LookupProductHierarchyController.searchAllSizes';

const ERROR_MESSAGE = 'An error occured while searching';
const LABEL_CATEGORY = 'Category';

export default class GenerationProductHierarchy extends LightningElement {
    @wire(CurrentPageReference) 
    pageRef;
    @api 
    isDisabled;
    isMultiEntry = true;
    @api initialSelectionCategory=[];
    @api initialSelectionBrand = [];
    @api initialSelectionSubBrand=[];
    @api initialSelectionFlavour=[];
    @api initialSelectionSize=[];
    @api productHierarchyRecords=[];
    @api ProductHierarchiesValues=[];
    @api showSizesAndFlavours;
    @api projectType;

    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        subscribe(this.messageContext, MESSAGE_CHANNEL, () => {
            this.template.querySelectorAll('c-lookup').forEach((currentElement, index) => {
                currentElement.getCustomHelpText();
            })
        })
    }

    @api
    handlePublishEvent() {
        publish(this.messageContext, MESSAGE_CHANNEL, null);
    }

    handleSearchCategory(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === "Category") {
                searchElement=lookup;
            }
        }
        apexSearchCategories(event.detail)
        .then((results) => {
            searchElement.setSearchResults(results);
        }).catch((error) => {
            alert(ERROR_MESSAGE);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });

    }
    handleSearchAllCategories(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === "Category") {
                searchElement=lookup;
            }
        }

        apexSearchAllCategories()
        .then((results) => {
            const allSelected = searchElement.getSelection();
            let newValue = false;
            for (const selected of allSelected) {
                if (selected.value === 'New') {
                    newValue = true;
                }
            }
            const finalResults = [];
            if (!newValue) {
                finalResults.push({
                    id: 'New',
                    sObjectType: 'ProductHierarchy__c',
                    icon: 'standard:product',
                    title: 'New',
                    subtitle: 'New',
                    value: 'New'
                });
            }
            for (const result of results) {
                finalResults.push(result);
            }
            searchElement.setListOfObjects(finalResults);
        }).catch((error) => {
            alert(ERROR_MESSAGE);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleSearchBrand(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        let searchCategory;
        for (const lookup of lookups) {
            if (lookup.label === "Category") {
                searchCategory = lookup;
            }
            if (lookup.label === "Brand") {
                searchElement = lookup;
            }
        }
        const searches = searchCategory.getSelection();
        apexSearchBrands({
            searchTerm: event.detail.searchTerm,
            selectedIds: event.detail.selectedIds,
            selectedCategories: searches.map((element) => element.value),
            label: event.detail.label
        })
        .then((results) => {
            searchElement.setSearchResults(results);
        }).catch((error) => {
            alert(ERROR_MESSAGE);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleSearchAllBrands(event) {
        let lookups =  this.template.querySelectorAll('c-lookup');
        let searchElement;
        let searchCategory;
        for (const lookup of lookups) {
            if (lookup.label === "Category") {
                searchCategory=lookup;
            }
            if (lookup.label === "Brand") {
                searchElement=lookup;
            }
        }
        const searches = searchCategory.getSelection();
        if (searches.length > 0) {
            searchElement.setShowModal();
            apexSearchAllBrands({
                selectedCategories: searches.map((element) => element.value)
            })
            .then((results) => {
                const allSelected = searchElement.getSelection();
                let newValue = false;
                for (const selected of allSelected) {
                    if (selected.value === 'New') {
                        newValue = true;
                    }
                }
                const finalResults = [];
                if (!newValue) {
                    finalResults.push({
                        id: 'New',
                        sObjectType: 'ProductHierarchy__c',
                        icon: 'standard:product',
                        title: 'New',
                        subtitle: 'New',
                        value: 'New'
                    });
                }
                if (results != undefined && results.length > 0) {
                    for (const result of results) {
                        finalResults.push(result);
                    }
                } 
                if (finalResults.length > 0) {
                    searchElement.setListOfObjects(finalResults);
                } else {
                    searchElement.hideModal();
                }
            }).catch((error) => {
                alert(ERROR_MESSAGE);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });
        }
    }

    handleSearchSubBrand(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        let searchCategory;
        let searchBrand;
        for (const lookup of lookups) {
            if (lookup.label === "Category") {
                searchCategory = lookup;
            }
            if (lookup.label === "Brand") {
                searchBrand = lookup;
            }
            if (lookup.label === "Sub Brand") {
                searchElement = lookup;
            }
        }
        const searches = searchCategory.getSelection();
        const searchesBrands = searchBrand.getSelection();
        apexSearchSubBrands({
            searchTerm: event.detail.searchTerm,
            selectedIds: event.detail.selectedIds,
            selectedCategories: searches.map((element) => element.value),
            selectedBrands: searchesBrands.map((element) => element.value),
            label: event.detail.label
        })
        .then((results) => {
            searchElement.setSearchResults(results);
        }).catch((error) => {
            alert(ERROR_MESSAGE);
            document.querySelectorAll("c-lookup").forEach(e => e.remove());
        });
    }

    handleSearchAllSubBrands(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        let searchCategory;
        let searchBrand;
        for (const lookup of lookups) {
            if (lookup.label === "Category") {
                searchCategory = lookup;
            }
            if (lookup.label === "Brand") {
                searchBrand = lookup;
            }
            if (lookup.label === "Sub Brand") {
                searchElement = lookup;
            }
        }

        const searches = searchCategory.getSelection();
        const searchesBrands = searchBrand.getSelection();

        if (searches.length > 0 && searchesBrands.length > 0) {
            apexSearchAllSubBrands({
                selectedCategories: searches.map((element) => element.value),
                selectedBrands: searchesBrands.map((element) => element.value)
            })
            .then((results) => {
                const allSelected = searchElement.getSelection();
                let newValue = false;
                for (const selected of allSelected) {
                    if (selected.value === 'New') {
                        newValue = true;
                    }
                }
                let finalResults = [];
                if (!newValue) {
                    finalResults.push({
                        id: 'New',
                        sObjectType: 'ProductHierarchy__c',
                        icon: 'standard:product',
                        title: 'New',
                        subtitle: 'New',
                        value: 'New'
                    });
                }
                if (results != undefined && results.length > 0) {
                    for (const result of results) {
                        finalResults.push(result);
                    }
                } 
                if (finalResults.length > 0) {
                    searchElement.setListOfObjects(finalResults);
                } else {
                    searchElement.hideModal();
                }
            }).catch((error) => {
                alert(ERROR_MESSAGE);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });
        }

        
    }
    handleSearchFlavour(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        let searchCategory;
        let searchBrand;
        let searchSubBrand;
        for (const lookup of lookups) {
            if (lookup.label === "Category") {
                searchCategory = lookup;
            }
            if (lookup.label === "Brand") {
                searchBrand = lookup;
            }
            if (lookup.label === "Sub Brand") {
                searchSubBrand = lookup;
            }
            if (lookup.label === "Flavour") {
                searchElement = lookup;
            }
        }

        const searches = searchCategory.getSelection();
        const searchesBrands = searchBrand.getSelection();
        const searchesSubBrands = searchSubBrand.getSelection();

        if (searchesBrands.length > 0 && searchesSubBrands.length > 0 && searches.length > 0) {
            apexSearchFlavours({
                searchTerm: event.detail.searchTerm,
                selectedIds: event.detail.selectedIds,
                selectedCategories: searches.map((element) => element.value),
                selectedBrands: searchesBrands.map((element) => element.value),
                selectedSubBrands: searchesSubBrands.map((element) => element.value),
                label: event.detail.label
            })
            .then((results) => {
                searchElement.setSearchResults(results);
            }).catch((error) => {
                alert(ERROR_MESSAGE);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });
        }
    }

    handleSearchAllFlavours(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        let searchCategory;
        let searchBrand;
        let searchSubBrand;
        for (const lookup of lookups) {
            if(lookup.label === "Category") {
                searchCategory = lookup;
            }
            if(lookup.label === "Brand") {
                searchBrand = lookup;
            }
            if(lookup.label === "Sub Brand") {
                searchSubBrand = lookup;
            }
            if(lookup.label === "Flavour") {
                searchElement = lookup;
            }
        }

        let searches = searchCategory.getSelection();
        let searchesBrands = searchBrand.getSelection();
        let searchesSubBrands = searchSubBrand.getSelection();

        if (searchesBrands.length > 0 && searchesSubBrands.length > 0 && searches.length > 0) {
            apexSearchAllFlavours({
                selectedCategories: searches.map((element) => element.value),
                selectedBrands: searchesBrands.map((element) => element.value),
                selectedSubBrands: searchesSubBrands.map((element) => element.value)
            })
            .then((results) => {
                const allSelected = searchElement.getSelection();
                let newValue = false;
                for (const selected of allSelected) {
                    if (selected.value === 'New') {
                        newValue = true;
                    }
                }
                const finalResults = [];
                if (!newValue) {
                    finalResults.push({
                        id: 'New',
                        sObjectType: 'ProductHierarchy__c',
                        icon: 'standard:product',
                        title: 'New',
                        subtitle: 'New',
                        value: 'New'
                    });
                }
                if (results != undefined && results.length > 0) {
                    for (const result of results) {
                        finalResults.push(result);
                    }
                } 
                if (finalResults.length > 0) {
                    searchElement.setListOfObjects(finalResults);
                } else {
                    searchElement.hideModal();
                }
            }).catch((error) => {
                alert(ERROR_MESSAGE);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });
        }
    }

    handleSearchSize(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        let searchCategory;
        let searchBrand;
        let searchSubBrand;
        let searchFlavour;
        for (const lookup of lookups) {
            if (lookup.label == "Category") {
                searchCategory = lookup;
            }
            if (lookup.label === "Brand") {
                searchBrand = lookup;
            }
            if (lookup.label === "Sub Brand") {
                searchSubBrand = lookup;
            }
            if (lookup.label === "Flavour") {
                searchFlavour = lookup;
            }
            if (lookup.label === "Size") {
                searchElement = lookup;
            }
        }

        const searches = searchCategory.getSelection();
        const searchesBrands = searchBrand.getSelection();
        const searchesSubBrands = searchSubBrand.getSelection();
        const searchesFlavour = searchFlavour.getSelection();

        if (searchesBrands.length > 0 && searchesSubBrands.length > 0 && searches.length > 0 && searchesFlavour.length > 0) {
            apexSearchSizes({
                searchTerm: event.detail.searchTerm,
                selectedIds: event.detail.selectedIds,
                selectedCategories: searches.map((element) => element.value),
                selectedBrands: searchesBrands.map((element) => element.value),
                selectedSubBrands: searchesSubBrands.map((element) => element.value),
                selectedFlavours: searchesFlavour.map((element) => element.value),
                label: event.detail.label
            })
            .then((results) => {
                searchElement.setSearchResults(results);
            }).catch((error) => {
                alert(ERROR_MESSAGE);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });
        }        
        
    }


    handleSearchAllSizes(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchElement;
        let searchCategory;
        let searchBrand;
        let searchSubBrand;
        let searchFlavour;
        for (const lookup of lookups) {
            if (lookup.label == "Category") {
                searchCategory = lookup;
            }
            if (lookup.label === "Brand") {
                searchBrand = lookup;
            }
            if (lookup.label === "Sub Brand") {
                searchSubBrand = lookup;
            }
            if (lookup.label === "Flavour") {
                searchFlavour = lookup;
            }
            if (lookup.label === "Size") {
                searchElement = lookup;
            }
        }

        const searches = searchCategory.getSelection();
        const searchesBrands = searchBrand.getSelection();
        const searchesSubBrands = searchSubBrand.getSelection();
        const searchesFlavour = searchFlavour.getSelection();

        if (searchesBrands.length > 0 && searchesSubBrands.length > 0 && searches.length > 0 && searchesFlavour.length > 0) {
            apexSearchAllSizes({
                selectedCategories: searches.map((element) => element.value),
                selectedBrands: searchesBrands.map((element) => element.value),
                selectedSubBrands: searchesSubBrands.map((element) => element.value),
                selectedFlavours: searchesFlavour.map((element) => element.value)
            })
            .then((results) => {
                const allSelected = searchElement.getSelection();
                let newValue = false;
                for (const selected of allSelected) {
                    if (selected.value === 'New') {
                        newValue = true;
                    }
                }
                const finalResults = [];
                if (!newValue) {
                    finalResults.push({
                        id: 'New',
                        sObjectType: 'ProductHierarchy__c',
                        icon: 'standard:product',
                        title: 'New',
                        subtitle: 'New',
                        value: 'New'
                    });
                }
                if (results != undefined && results.length > 0) {
                    for (const result of results) {
                        finalResults.push(result);
                    }
                } 
                if (finalResults.length > 0) {
                    searchElement.setListOfObjects(finalResults);
                } else {
                    searchElement.hideModal();
                }
            }).catch((error) => {
                alert(ERROR_MESSAGE);
                document.querySelectorAll("c-lookup").forEach(e => e.remove());
            });
        }    
    }

    handleSelectionChange() {
        this.checkForErrors();
    }

    handleClear() {
        this.errorsSendTo = [];
    }

    notifyUser(title, message, variant) {
        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);
    }

    handleCategoryRemoved(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchBrand;
        let searchSubBrand;
        let searchFlavour;
        let searchSize;
        for (const lookup of lookups) {
            if (lookup.label === "Brand") {
                searchBrand = lookup;
            }
            if (lookup.label === "Sub Brand") {
                searchSubBrand = lookup;
            }
            if (this.showSizesAndFlavours) {
                if (lookup.label === "Flavour") {
                    searchFlavour = lookup;
                }
                if (lookup.label === "Size") {
                    searchSize = lookup;
                }
            }
        }
        searchBrand.handleClearSelection();
        searchSubBrand.handleClearSelection();
        if (this.showSizesAndFlavours) {
            searchSize.handleClearSelection();
            searchFlavour.handleClearSelection();
        }
    }

    handleBrandRemoved(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchSubBrand;
        let searchFlavour;
        let searchSize;
        for (const lookup of lookups) {
            if (lookup.label === "Sub Brand") {
                searchSubBrand = lookup;
            }
            if (this.showSizesAndFlavours) {
                if (lookup.label === "Flavour") {
                    searchFlavour = lookup;
                }
                if (lookup.label === "Size") {
                    searchSize = lookup;
                }
            }
        }
        searchSubBrand.handleClearSelection();
        if (this.showSizesAndFlavours) {
            searchSize.handleClearSelection();
            searchFlavour.handleClearSelection();
        }
    }

    handleRemoveSubBrand(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchFlavour;
        let searchSize;
        for (const lookup of lookups) {
            if (this.showSizesAndFlavours) {
                if (lookup.label === "Flavour") {
                    searchFlavour = lookup;
                }
                if (lookup.label === "Size") {
                    searchSize = lookup;
                }
            }
        }
        if (this.showSizesAndFlavours) {
            searchSize.handleClearSelection();
            searchFlavour.handleClearSelection();
        }
    }

    handleRemoveFlavour(event) {
        const lookups = this.template.querySelectorAll('c-lookup');
        let searchSize;
        for (const lookup of lookups) {
            if (this.showSizesAndFlavours) {
                if (lookup.label == "Size") {
                    searchSize = lookup;
                }
            }
        }
        if (this.showSizesAndFlavours) {
            searchSize.handleClearSelection();
        }
    }

    checkForErrors() {
        this.errorsSendTo = [];
        const lookups = this.template.querySelectorAll('c-lookup');
        const selection = [];
        let errorFound = false;
        for(const lookup of lookups){
            let currentSelection = lookup.getSelection();
            // Enforcing required field
            if (currentSelection.length === 0) {
                let label = lookup.label;
                if(label === LABEL_CATEGORY){
                    this.errorsSendTo.push({ message: 'Please make a selection in the '+lookup.label+' receiver(s) field.' });
                    errorFound = true;
                }
            } else {
                selection.push(currentSelection);
            }
        }
        if(!errorFound){
            this.handleClear();
        }
    }

    @api
    validate() {
        this.productHierarchyRecords=[];
        const lookups = this.template.querySelectorAll('c-lookup');
        this.ProductHierarchiesValues=[];

        this.initialSelectionCategory = [];
        this.iinitialSelectionBrand = [];
        this.iinitialSelectionSubBrand=[];
        this.iinitialSelectionFlavour=[];
        this.iinitialSelectionSize=[];

        for (const lookup of lookups) {
            if (lookup.label === "Sub Brand") {
                this.initialSelectionSubBrand = lookup.getSelection();
            }
            if (lookup.label === "Category") {
                this.initialSelectionCategory = lookup.getSelection();
            }
            if (lookup.label === "Brand") {
                this.initialSelectionBrand = lookup.getSelection();
            }

            if (this.showSizesAndFlavours) {
                if (lookup.label === "Flavour") {
                    this.initialSelectionFlavour = lookup.getSelection();
                }
                if (lookup.label === "Size") {
                    this.initialSelectionSize = lookup.getSelection();
                }
            }
        }
    }

    disableStuff() {
        let searchElement;
        for (const lookup of lookups) {
            if (lookup.label === "Brand") {
                searchElement = lookup;
                searchElement.setDisabled();
            }
        }
    }

}