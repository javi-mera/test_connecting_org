/* eslint-disable @lwc/lwc/no-api-reassignments */
/* eslint-disable no-alert */
import { api, LightningElement, wire } from 'lwc';
import apexSearchUser from '@salesforce/apex/LookupUserController.searchUsers';
import apexSearchAllUser from '@salesforce/apex/LookupUserController.searchAllUsers';
import transformUser from '@salesforce/apex/LookupUserController.transformPLUser';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import userNameFld from '@salesforce/schema/User.Name';
import userLastNameFld from '@salesforce/schema/User.LastName';
import userProfileName from '@salesforce/schema/User.Profile.Name';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';

export default class LookupToUser extends LightningElement {

    initialSelectionUsers = [];
    userId = Id;
    error;

    @api user;
    @api currentUserId;
    @api currentUserName;
    @api currentUserLastName;
    @api recordId;
    @api selectedUser;

    @wire(MessageContext)
    messageContext;

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
    }

    @wire(getRecord, { recordId: '$currentUserId', fields: [ userNameFld, userLastNameFld, userProfileName ]})
    userDetails({error, data}) {
        if (data) {
            if (this.user !== undefined) {
                transformUser({id: this.user})
                .then((results) => {
                    this.setInitialSelectionUsers(results);
                }).catch((responseError) => {
                    alert(JSON.stringify(responseError));
                });
            } else if (this.currentUserId !== undefined) {
                if (data.fields.Profile.displayValue === 'Project Leader' || data.fields.Profile.displayValue === 'Super User') {
                    transformUser({id: this.currentUserId})
                    .then((results) => {
                        this.setInitialSelectionUsers(results);
                    }).catch((responseError) => {
                        alert(JSON.stringify(responseError));
                    });
                } 
            } else {
                this.initialSelectionUsers= [...this.initialSelectionUsers,
                    {
                        id: this.userId,
                        sObjectType: 'User',
                        icon: 'standard:user',
                        title:  data.fields.Name.value,
                        subtitle:  data.fields.LastName.value
                    }
                ];
            }
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }

    setInitialSelectionUsers(results) {
        for (const result of results) {
            this.initialSelectionUsers.push(result);
            this.initialSelectionUsers = [...this.initialSelectionUsers];
        }
    }

    connectedCallback(){
        this.subscribeToMessageChannel();
        console.log('User: ', this.currentUserId)
        if (this.currentUserId !== null && this.currentUserId !== undefined) {
            this.initialSelectionUsers = [
                {
                    id: this.currentUserId,
                    sObjectType: 'User',
                    icon: 'standard:user',
                    title:  `${this.currentUserName} ${this.currentUserLastName}`,
                    subtitle:  this.currentUserLastName
                }
            ];
        }
        console.log('User: ', JSON.stringify(this.initialSelectionUsers));
        this.recordId = this.currentUserId;
    }

    handleSearchUser(event) {
        let lookup =  this.template.querySelector('c-lookup');
        if (lookup.getSelection().length === 0) {
            apexSearchUser(event.detail)
            .then((results) => {
                lookup.setSearchResults(results);
            }).catch((error) => {
                console.log(error);
            });
        } else {
            lookup.unsetLoading();
            alert('You can only select one Project Leader');
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

    @api 
    validate() {
        const lookup =  this.template.querySelector('c-lookup');
        const selection = lookup.getSelection();
        this.selectedUser = selection;
        if (selection !== undefined) { 
            this.selectedUser = selection;
            if (selection.length > 0) {
                this.user = selection[0].id;
            }    
        } 
    }
}