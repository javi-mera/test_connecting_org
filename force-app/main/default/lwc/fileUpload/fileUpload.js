import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import LIGHTNING_STATIC_RESOURCE_PATH from '@salesforce/resourceUrl/FileUploadStyles';
import deleteFile from '@salesforce/apex/FileUploadController.deleteFile';
const ACTIONS = [
    { label: 'Delete', name: 'delete' },
];

export default class FileUpload extends LightningElement {
    @api recordId;
    @api files = [];
    columns = [
        { 
            label: 'File Name',
            fieldName: 'name' },
        {
            type: 'action',
            typeAttributes: { rowActions: ACTIONS },
        },
    ];
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        for (let file of uploadedFiles) {
            this.files = [...this.files, file];
        }
    }
    // invoke the loaders in connectedCallback() to ensure that
    // the page loads and renders the container before the map is created
    connectedCallback() {
        loadStyle(this, LIGHTNING_STATIC_RESOURCE_PATH + '/global-header_css.css').then(() => {});
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'delete') {
            this.deleteRow(row);
        }
    }
    
    deleteRow(row) {
        let fileList = this.files;
        deleteFile({docId : row.documentId})
        .then(result => {
            this.showNotification('File name delete successfully', 'success');
            //removing the element from the list
            this.files = [];
            fileList.forEach((element) => {
                if (element.documentId !== row.documentId) {
                    this.files.push(element);
                }
            });
        }).catch(error => {
            this.showNotification(JSON.stringify(error), 'error');
        }); 
    }

    showNotification(message, variant) {
        const evt = new ShowToastEvent({
            title: '',
            message: message,
            variant: variant,
            mode: 'dismissible'
        });
        this.dispatchEvent(evt);
    }
}