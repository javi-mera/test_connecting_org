import { LightningElement, api } from 'lwc';
import apexSearchUser from '@salesforce/apex/LookupUserController.searchUsersBySearchTerm';
import apexSearchAllUser from '@salesforce/apex/LookupUserController.searchAllUsersByIsActive';

export default class LookupToDelegate extends LightningElement {

    connectedCallback() {
    }

    @api
    setSelection(user) {
        const lookup = this.template.querySelector("c-lookup");
        lookup.setSelection(user);
    }

    @api
    getSelection() {
        const lookup = this.template.querySelector("c-lookup");
        return lookup.getSelection();
    }

    @api
    clearSelection() {
        const lookup = this.template.querySelector("c-lookup");
        lookup.handleClearSelection();
    }

    handleSearchUser(event) {
        const lookup =  this.template.querySelector('c-lookup');
        if (lookup.getSelection().length === 0) {
            apexSearchUser(event.detail)
                .then((results) => {
                    lookup.setSearchResults(results);
                }).catch((error) => {
                    console.log(error);
                });
        } else {
            lookup.unsetLoading();
        }
        
    }

    handleSearchAllUser() {
        const lookup =  this.template.querySelector('c-lookup');
        if (lookup.getSelection().length === 0) {
            apexSearchAllUser()
            .then((results) => {
                lookup.setListOfObjects(results);
            }).catch((error) => {
                console.log(error);
            });
        }
    }
}