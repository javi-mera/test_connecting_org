import {LightningElement, api} from 'lwc';

export default class CompactLayoutOnHover extends LightningElement {
    @api recordId;
    @api iconName;
    @api recordName;
    @api recordNumber;
    @api recordDescription;
    @api isProject = false;
}