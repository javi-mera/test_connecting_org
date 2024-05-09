import { api, LightningElement, wire, track } from 'lwc';
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import GEO_HIERARCHY_COMPONENT_STYLESHEET from '@salesforce/resourceUrl/geoHierarchyComponentStyles';
import {loadStyle} from "lightning/platformResourceLoader";
import {constants} from 'c/utils';

const MINIMAL_SEARCH_TERM_LENGTH = 2; // Min number of chars required to search
const SEARCH_DELAY = 300; // Wait 300 ms after user stops typing then, perform search

const SEARCH_DISABLED_LABELS = [
    constants.LEAD_REGION_LABEL,
    constants.LEAD_HUB_LABEL,
    constants.LEAD_CLUSTER_LABEL,
    constants.ADDITIONAL_REGION_LABEL,
    constants.ADDITIONAL_HUB_LABEL,
    constants.ADDITIONAL_CLUSTER_LABEL
];
const LABEL_TO_NAME = {
    'Category': 'category',
    'Brand': 'brand',
    'Sub Brand': 'subbrand',
    'Flavour': 'flavour',
    'Size': 'size',
    [constants.LEAD_REGION_LABEL]: 'region',
    [constants.LEAD_HUB_LABEL]: 'hub',
    [constants.LEAD_MARKET_LABEL]: 'leadmarket',
    'Secondary Markets': 'secondarymarket',
    [constants.DISTRIBUTION_CHANNELS_LABEL]: 'distributionchannel',
    [constants.LEAD_CLUSTER_LABEL]: 'cluster',
    [constants.TRADE_TYPE_LABEL]: 'tradetype',
    [constants.BRAND_HOME_LABEL]: 'brandhome',
    '* Project Leader': 'users',
    'User for Reassignment': 'users',
    'Pending Approver': 'users',
    'Functions': 'function',
    [constants.ADDITIONAL_REGION_LABEL]: 'additionalregions',
    [constants.ADDITIONAL_HUB_LABEL]: 'additionalhubs',
    [constants.ADDITIONAL_CLUSTER_LABEL]: 'additionalclusters',
    [constants.ADDITIONAL_MARKET_LABEL]: 'additionalmarkets',
    '* Project Manager': 'projectmanager',
    'Project Manager': 'projectmanager',
    'Original Project': 'project',
    '* Original Project': 'project'
};
const LABEL_TO_PLURAL_NAME = {
    'Category': 'categories',
    'Brand': 'brands',
    'Sub Brand': 'subbrands',
    'Flavour': 'flavours',
    'Size': 'sizes',
    [constants.LEAD_REGION_LABEL]: 'regions',
    [constants.LEAD_HUB_LABEL]: 'hubs',
    [constants.LEAD_MARKET_LABEL]: 'leadmarkets',
    'Secondary Markets': 'secondarymarkets',
    [constants.DISTRIBUTION_CHANNELS_LABEL]: 'distributionchannels',
    [constants.LEAD_CLUSTER_LABEL]: 'clusters',
    [constants.TRADE_TYPE_LABEL]: 'tradetype',
    [constants.BRAND_HOME_LABEL]: 'brandhome',
    '* Project Leader': 'users',
    'User for Reassignment': 'users',
    'Pending Approver': 'users',
    'Functions': 'functions',
    [constants.ADDITIONAL_REGION_LABEL]: 'additionalregions',
    [constants.ADDITIONAL_HUB_LABEL]: 'additionalhubs',
    [constants.ADDITIONAL_CLUSTER_LABEL]: 'additionalclusters',
    [constants.ADDITIONAL_MARKET_LABEL]: 'additionalmarkets',
    '* Project Manager': 'projectmanagers',
    'Project Manager': 'projectmanagers',
    'Original Project': 'projects',
    '* Original Project': 'projects'
};
const NOT_MULTI_ENTRY_TYPES = [
    'Pending Approver',
    'User for Reassignment',
    constants.LEAD_REGION_LABEL,
    constants.LEAD_HUB_LABEL,
    constants.LEAD_MARKET_LABEL,
    constants.LEAD_CLUSTER_LABEL,
    '* Project Leader',
    '* Project Manager',
    'Project Manager',
    'Original Project',
    '* Original Project'
];

export default class Lookup extends LightningElement {
    @api label;
    @api required;
    @api placeholder = '';
    isMultiEntry = true;
    @api errors = [];
    @api scrollAfterNItems;
    @api customKey;
    @api isDisabled;
    @api isCancelButtonDisabled = false;
    @api isInputDisabled = false;
    @api infotext;
    @api specialStyle = false;

    @wire(CurrentPageReference) 
    pageRef;

    searchTerm = '';
    searchResults = [];
    hasFocus = false;
    loading = false;
    isDirty = false;
    showModal = false;

    cleanSearchTerm;
    blurTimeout;
    searchThrottlingTimeout;
    curSelection = [];
    list = [];

    @api isOriginalProject;
    originalProjectPopup = false;
    @track originalProjectId;
    @track originalProjectIcon;
    @track originalProjectName;
    @track originalProjectNumber;
    @track originalProjectDescription;
    showHelpText = false;

    renderedCallback() {
        loadStyle(this, GEO_HIERARCHY_COMPONENT_STYLESHEET).then(() => {
            console.log('Loaded Successfully')
        }).catch(error => {
            console.error('Error in loading the colors:', error)
        })
    }

    @api
    getCustomHelpText() {
        this.template.querySelectorAll('c-custom-help-text').forEach((currentElement) => {
            currentElement.handleClose();
        })
    }

    @api
    handleHideHelpText() {
        this.dispatchEvent(
            new CustomEvent(
                'getlookup',
                {
                    detail : false
                }
            )
        );
    }

    handleHover(event) {
        if (this.isOriginalProject) {
            this.originalProjectPopup = true;
            this.originalProjectId = event.currentTarget.dataset.id;
            this.originalProjectIcon = event.currentTarget.dataset.icon;
            this.originalProjectName = event.currentTarget.dataset.name;
            this.originalProjectNumber = event.currentTarget.dataset.subtitle;
            this.originalProjectDescription = event.currentTarget.dataset.description;
        }
    }

    handleMouseOut() {
        if (this.isOriginalProject) {
            this.originalProjectPopup = false;
        }
    }

    connectedCallback() {
        if (this.infotext) {
            this.showHelpText = true;
        }
        if (NOT_MULTI_ENTRY_TYPES.includes(this.label)) {
            this.isMultiEntry = false;
        }
    }

    // EXPOSED FUNCTIONS
    @api
    set selection(initialSelection) {
        this.curSelection = Array.isArray(initialSelection) ? initialSelection : [initialSelection];
        this.isDirty = false;
    }
    get selection() {
        return this.curSelection;
    }

    @api
    setSelection(user) {
        this.curSelection = Array.isArray(user) ? user : [user];
        this.isDirty = false;
    }

    @api
    setDisabled() {
        this.isDisabled = true;
    }

    @api 
    setUndisabled() {
        this.isDisabled = false;
    }

    @api
    unsetMultyEntry() {
        this.isMultiEntry = false;
    }

    @api
    unsetLoading() {
        this.loading = false;
    }
    
    @api
    setSearchResults(results) {
        // Reset the spinner
        this.loading = false;
        // Clone results before modifying them to avoid Locker restriction
        const resultsLocal = JSON.parse(JSON.stringify(results));
        // Format results
        this.searchResults = resultsLocal.map((result) => {
            // Clone and complete search result if icon is missing
            if (this.searchTerm.length > 0) {
                const regex = new RegExp(`(${this.searchTerm})`, 'gi');
                result.titleFormatted = result.title
                    ? result.title.replace(regex, '<strong>$1</strong>')
                    : result.title;
                result.subtitleFormatted = result.subtitle
                    ? result.subtitle.replace(regex, '<strong>$1</strong>')
                    : result.subtitle;
            }
            if (typeof result.icon === 'undefined') {
                const { id, sObjectType, title, subtitle, value } = result;
                return {
                    id,
                    sObjectType,
                    icon: 'standard:default',
                    title,
                    subtitle,
                    value
                };
            }
            return result;
        });
    }
    @api
    setListOfObjects(results) {
        // Reset the spinner
        this.loading = false;
        // Clone results before modifying them to avoid Locker restriction
        const resultsLocal = JSON.parse(JSON.stringify(results));
        // Format results
        this.list = resultsLocal.map((result) => {
            // Clone and complete search result if icon is missing
            if (typeof result.icon === 'undefined') {
                const { id, sObjectType, title, subtitle, value } = result;
                return {
                    id,
                    sObjectType,
                    icon: 'standard:default',
                    title,
                    subtitle,
                    value
                };
            }
            return result;
        });
        this.showModal = true;
    }
    @api
    getSelection() {
        return this.curSelection;
    }

    @api
    getkey() {
        return this.customKey;
    }

    // INTERNAL FUNCTIONS

    updateSearchTerm(newSearchTerm) {
        this.searchTerm = newSearchTerm;
        // Compare clean new search term with current one and abort if identical
        const newCleanSearchTerm = newSearchTerm.trim().replace(/\*/g, '').toLowerCase();
        if (this.cleanSearchTerm === newCleanSearchTerm) {
            return;
        }
        // Save clean search term
        this.cleanSearchTerm = newCleanSearchTerm;
        // Ignore search terms that are too small
        if (newCleanSearchTerm.length < MINIMAL_SEARCH_TERM_LENGTH) {
            this.searchResults = [];
            return;
        }
        // Apply search throttling (prevents search if user is still typing)
        if (this.searchThrottlingTimeout) {
            clearTimeout(this.searchThrottlingTimeout);
        }
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.searchThrottlingTimeout = setTimeout(() => {
            // Send search event if search term is long enougth
            if (this.cleanSearchTerm.length >= MINIMAL_SEARCH_TERM_LENGTH) {
                // Display spinner until results are returned
                this.loading = true;
                const name = `search${LABEL_TO_NAME[this.label]}`;
                const evt = new CustomEvent(name, 
                    {
                        detail: {
                            searchTerm: this.cleanSearchTerm,
                            selectedIds: this.curSelection.map((element) => element.id),
                            label: this.label
                        }
                    }
                );
                this.dispatchEvent(evt);
            }
            this.searchThrottlingTimeout = null;
        }, SEARCH_DELAY);
    }

    isSelectionAllowed() {
        return this.isMultiEntry ? true : !this.hasSelection();
    }

    hasResults() {
        return this.searchResults.length > 0;
    }

    hasSelection() {
        return this.curSelection.length > 0;
    }

    // EVENT HANDLING
    handleInput(event) {
        // Prevent action if selection is not allowed
        if (!this.isSelectionAllowed()) {
            return;
        }
        this.updateSearchTerm(event.target.value);
    }

    handleResultClick(event) {
        if (this.isOriginalProject) {
            this.originalProjectPopup = false;
        }
        const recordId = event.currentTarget.dataset.recordid;

        // Save selection
        let selectedItem = this.searchResults.filter((result) => result.id === recordId);
        if (selectedItem.length === 0) {
            return;
        }
        selectedItem = selectedItem[0];
        const newSelection = [...this.curSelection];
        newSelection.push(selectedItem);
        let mapSelection = newSelection.map(({titleFormatted, subtitleFormatted, ...rest}) => {
            return rest;
        });
        this.curSelection = mapSelection;
        this.isDirty = true;

        // Reset search
        this.searchTerm = '';
        this.searchResults = [];

        if (this.label === constants.LEAD_MARKET_LABEL || this.label === constants.ADDITIONAL_MARKET_LABEL || this.label === constants.DISTRIBUTION_CHANNELS_LABEL ||
        this.label === constants.TRADE_TYPE_LABEL || this.label === constants.BRAND_HOME_LABEL) {
            const name = 'selectionchange';
            this.dispatchEvent(new CustomEvent(name,
                {
                    detail: {
                        searchTerm: this.cleanSearchTerm,
                        selectedIds: this.curSelection.map((element) => element.id),
                        label: this.label
                    }
                }
            ));
        }

        // Notify parent components that selection has changed
        //Use pubsub
        //fireEvent(this.pageRef, 'selectionchange', null);
        
    }

    handleComboboxClick() {
        // Hide combobox immediatly
        if (this.blurTimeout) {
            window.clearTimeout(this.blurTimeout);
            if (this.label === "Pending Approver") {
                this.dispatchEvent(new CustomEvent('selectionchange',
                {
                    detail: {
                        searchTerm: this.cleanSearchTerm,
                        selectedIds: this.curSelection.map((element) => element.id),
                        label: this.label
                    }
                }
            ));
            }
        }
        this.hasFocus = false;
    }

    handleFocus() {
        // Prevent action if selection is not allowed
        if (!this.isSelectionAllowed()) {
            return;
        }
        this.hasFocus = true;
    }

    handleBlur() {
        // Prevent action if selection is not allowed
        if (!this.isSelectionAllowed()) {
            return;
        }
        // Delay hiding combobox so that we can capture selected result
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.blurTimeout = window.setTimeout(() => {
            this.hasFocus = false;
            this.blurTimeout = null;
            fireEvent(this.pageRef, 'selectionchange', null);
        }, 300);
    }

    handleRemoveSelectedItem(event) {
        if (!SEARCH_DISABLED_LABELS.includes(this.label)) {
            const recordId = event.currentTarget.name;
            this.curSelection = this.curSelection.filter((item) => item.id !== recordId);
            this.isDirty = true;
            // Notify parent components that selection has changed
            let name;
            if (this.label === "* Project Manager" || this.label === "Project Manager" || this.label === "* Project Leader" ||
                this.label === constants.LEAD_MARKET_LABEL || this.label === "Original Project" || this.label === "* Original Project" || this.label === "User for Reassignment" || this.label === "Pending Approver") {
                this.handleClearSelection();
                if (this.label === constants.LEAD_MARKET_LABEL || this.label === "Pending Approver") {
                    name = `remove${LABEL_TO_NAME[this.label]}`;
                    this.dispatchEvent(new CustomEvent(name,
                        {
                            detail: {
                                searchTerm: this.cleanSearchTerm,
                                selectedIds: this.curSelection.map((element) => element.id),
                                label: this.label
                            }
                        }
                    ));
                }
            } else {
                name = `remove${LABEL_TO_NAME[this.label]}`;
                this.dispatchEvent(new CustomEvent(name,
                    {
                        detail: {
                            searchTerm: this.cleanSearchTerm,
                            selectedIds: this.curSelection.map((element) => element.id),
                            label: this.label
                        }
                    }
                ));
            }
        }
    }

    @api handleClearSelection() {
        this.curSelection = [];
        this.isDirty = true;
        // Notify parent components that selection has changed
        fireEvent(this.pageRef, 'selectionchange', null);
    }

    @api setShowModal() {
        this.loading = true;
        this.showModal = true;
    }

    handleIconClick(){
        const name = `searchall${LABEL_TO_PLURAL_NAME[this.label]}`;
        if (this.label === "Category") {
            this.loading = true;
            this.showModal = true;
        }

        if ([constants.DISTRIBUTION_CHANNELS_LABEL, constants.TRADE_TYPE_LABEL, 'Original Project', '* Original Project'].includes(this.label)) {
            this.setShowModal();
        }

        this.dispatchEvent(new CustomEvent(name, 
            {
                detail: {
                    selectedIds: this.curSelection.map((element) => element.id),
                    label: this.label
                }
            }
        ));
    }
    handleSaveSelection(event){
        const selectedItems = event.detail.selectedItems;
        for(const selectedItem of selectedItems){
            const newSelection = [...this.curSelection];
            newSelection.push(selectedItem);
            this.curSelection = newSelection;
            this.isDirty = true;
            // Reset search
            this.searchTerm = '';
            this.searchResults = [];
        }

        // Notify parent components that selection has changed
        //Use pubsub
        fireEvent(this.pageRef, 'selectionchange', null);
        this.dispatchEvent(new CustomEvent('selectionchange',
            {
                detail: {
                    searchTerm: this.cleanSearchTerm,
                    selectedIds: this.curSelection.map((element) => element.id),
                    label: this.label
                }
            }
        ));
    }

    @api hideModal(){
        this.showModal = false;
        this.loading = false;
    }

    // STYLE EXPRESSIONS

    get getContainerClass() {
        let css = 'slds-combobox_container slds-has-inline-listbox slds-grid slds-wrap ';
        if (this.hasFocus && this.hasResults()) {
            css += 'slds-has-input-focus ';
        }
        if (this.errors.length > 0) {
            css += 'has-custom-error';
        }
        return css;
    }

    get getDropdownClass() {
        let css = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click ';
        if (this.hasFocus && this.cleanSearchTerm && this.cleanSearchTerm.length >= MINIMAL_SEARCH_TERM_LENGTH) {
            css += 'slds-is-open';
        }
        return css;
    }

    get getInputClass() {
        let css = 'slds-input slds-combobox__input has-custom-height ';
        if (this.errors.length > 0 || (this.isDirty && this.required && !this.hasSelection())) {
            css += 'has-custom-error ';
        }
        if (!this.isMultiEntry) {
            css += 'slds-combobox__input-value ' + (this.hasSelection() ? 'has-custom-border' : '');
        }
        return css;
    }

    get getComboboxClass() {
        let css = 'slds-combobox__form-element slds-input-has-icon ';
        if (this.isMultiEntry) {
            css += 'slds-input-has-icon_right';
        } else {
            css += this.hasSelection() ? 'slds-input-has-icon_left-right' : 'slds-input-has-icon_right';
        }
        return css;
    }
    get getSearchIconClass() {
        let css = 'slds-input__icon slds-input__icon_right ';

        if (SEARCH_DISABLED_LABELS.includes(this.label)) {
            css += 'slds-hide';
        } else {
            if (!this.isMultiEntry) {
                css += this.hasSelection() ? 'slds-hide' : '';
            }
        }
        return css;
    }
    get getPopUpIconClass() {
        let css = 'slds-input__icon slds-input__icon_right slds-float_right ';

        if (SEARCH_DISABLED_LABELS.includes(this.label)) {
            css += 'slds-hide';
        } else {
            if (!this.isMultiEntry) {
                css += this.hasSelection() ? 'slds-hide' : '';
            }
        }
        return css;
    }

    get getClearSelectionButtonClass() {
        let css = 'slds-button slds-button_icon slds-input__icon slds-input__icon_right ';
        if (SEARCH_DISABLED_LABELS.includes(this.label)) {
            css += 'slds-hide';
        } else {
            css += this.hasSelection() ? '' : 'slds-hide';
        }
        return css;
    }

    get getSelectIconName() {
        return this.hasSelection() ? this.curSelection[0].icon : 'standard:default';
    }

    get getSelectIconClass() {
        return 'slds-combobox__input-entity-icon ' + (this.hasSelection() ? '' : 'slds-hide');
    }

    get getInputValue() {
        if (this.isMultiEntry) {
            return this.searchTerm;
        }
        return this.hasSelection() ? this.curSelection[0].title : this.searchTerm;
    }

    get getInputTitle() {
        if (this.isMultiEntry) {
            return '';
        }
        return this.hasSelection() ? this.curSelection[0].title : '';
    }

    get getListboxClass() {
        return (
            'slds-listbox slds-listbox_vertical slds-dropdown slds-dropdown_fluid ' +
            (this.scrollAfterNItems ? 'slds-dropdown_length-with-icon-' + this.scrollAfterNItems : '')
        );
    }

    get isInputReadonly() {
        if (this.isMultiEntry) {
            return false;
        }
        return this.hasSelection();
    }

    get isExpanded() {
        return this.hasResults();
    }
}