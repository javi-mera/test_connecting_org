import { api, wire, LightningElement } from 'lwc';
import searchProjects from '@salesforce/apex/LookupToProjectController.searchProjects';
import searchProjectBySearchTerm from '@salesforce/apex/LookupToProjectController.searchProjectBySearchTerm';
import {getRecord} from "lightning/uiRecordApi";
import PROJECT_NAME from '@salesforce/schema/Project__c.Name';
import { constants } from 'c/utils';
import { publish, subscribe, MessageContext } from "lightning/messageService";
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';

const PROJECT_ICON_NAME = 'custom:custom56';
const ORIGINAL_PROJECT_LABEL = 'Original Project';

export default class LookupToProject extends LightningElement {

    @api initialSelectionProjects = [];
    @api selectedProject;
    @api currentParentProjectId;
    @api currentProjectId;          // Project Id from the flow
    @api currentProjectClassification;

    originalProjectHelpText;
    originalProjectLabel;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.originalProjectHelpText = this.currentProjectClassification === constants.CONST_GEO_EXTENSION_NAME ? constants.CONST_GEO_PARENT_PROJECT_LABEL : constants.CONST_PROMOTIONAL_PACK_PARENT_PROJECT_LABEL;
        this.originalProjectLabel = this.currentProjectClassification === constants.CONST_GEO_EXTENSION_NAME ? '* ' + ORIGINAL_PROJECT_LABEL : ORIGINAL_PROJECT_LABEL;
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

    @api validate() {
        let lookup = this.template.querySelector("c-lookup");
        let selection = lookup.getSelection();
        this.initialSelectionProjects = [];
        if (selection.length > 0) {
            this.initialSelectionProjects = selection;
            this.selectedProject = selection[0].id;
        }
    }

    @wire(getRecord, { recordId: '$currentParentProjectId', fields: [ PROJECT_NAME ]})
    projectDetails({error, data}) {
        if (data) {
            this.initialSelectionProjects= [...this.initialSelectionProjects,
                {
                    id: this.currentParentProjectId,
                    sObjectType: 'Project__c',
                    icon: PROJECT_ICON_NAME,
                    title: data.fields.Name.value,
                    subtitle: data.fields.Name.value
                }
            ];
        } else if (error) {
            console.log(error);
        }
    }

    handleSearchProject(event) {
        let lookup = this.template.querySelector("c-lookup");
        if (lookup.getSelection().length === 0) {
            searchProjectBySearchTerm({
                currentProjectId: this.currentProjectId,
                searchTerm: event.detail.searchTerm,
                projectClassification: this.currentProjectClassification
            })
                .then((results) => {
                    lookup.setSearchResults(results);
                })
                .catch((error) => {
                    console.error(error);
                });
        } else {
            lookup.unsetLoading();
            // eslint-disable-next-line no-alert
            alert("You can only select one Parent Project");
        }
    }

    handleSearchAllProjects() {
        let lookup = this.template.querySelector("c-lookup");
        if (lookup.getSelection().length === 0) {
            searchProjects({
                currentProjectId: this.currentProjectId,
                projectClassification: this.currentProjectClassification
            })
                .then((results) => {
                    lookup.setListOfObjects(results);
                })
                .catch((error) => {
                    console.error(error);
                });
        }
    }
}