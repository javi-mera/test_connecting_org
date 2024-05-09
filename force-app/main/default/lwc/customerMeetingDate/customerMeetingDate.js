import {LightningElement, api, wire} from 'lwc';
import INFO_TEXT_LABEL from '@salesforce/label/c.Customer_Meeting_Date_Text';
import PRESENTATION_LINK_LABEL from '@salesforce/label/c.Customer_Meeting_Presentation_Link';
import {publish, MessageContext, subscribe} from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/helpTextChannel__c';

const eventIcon = 'utility:event';

const PRESENTATION_LINK = PRESENTATION_LINK_LABEL;
const CUSTOMER_MEETING_DATE_TABLE_DATA = [
    {
        label: 'NAM',
        text: 'April year PRIOR to the innovation launch.',
        icon: eventIcon,
    },
    {
        label: 'WEUR',
        text: 'April year PRIOR to the innovation launch.',
        icon: eventIcon,
    },
    {
        label: 'AMEA',
        text: 'Please click on link below for specific customer timings.',
        disabled: true
    },
    {
        label: 'EEURA',
        text: 'Up to 8 months before the planned on shelf date.',
        disabled: true
    },
    {
        label: 'LAC',
        text: 'Product registration (needed for listing) can take up to 12 months in some markets.\nClick link below for information, including registration documentation and sample requirements.',
        disabled: true
    },
    {
        label: 'GTR',
        text: 'Global GTR / Regional GTR launch: Up to 9 months prior to innovation launch.\nMarket specific GTR launch: Click link below for specific customer timings.',
        disabled: true
    }
];

export default class CustomerMeetingDate extends LightningElement {

    @api shelfDate;
    @api customerMeetingDate;
    @api isPM;
    @api readOnlyShelfDate;
    @api projectClassification;
    infotext = INFO_TEXT_LABEL;

    @wire(MessageContext)
    messageContext;

    customerPresentationLink = PRESENTATION_LINK;
    _minimumDate = this.getMinimumDate();
    _showCustomerPresentationWindow = false;
    _customerPresentationColumns = [
        { label: 'Region', fieldName: 'label', editable: false, sortable: false, wrapText: false, hideDefaultActions: true },
        { label: `Date of Region's First Customer Meeting for Innovations`, fieldName: 'text', editable: false, sortable: false, wrapText: true, hideDefaultActions: true, fixedWidth: 550 },
        { type: 'button-icon', typeAttributes: { iconName: { fieldName: 'icon' }, disabled: { fieldName: 'disabled' }, name: 'setDate', value: 'setDate', variant: 'bare', title: 'Set Customer Meeting Date' },  editable: false, sortable: false, wrapText: false, hideDefaultActions: true }
    ];
    _customerPresentationData = [];

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.setCustomerPresentationDate(true);
    }

    subscribeToMessageChannel() {
        subscribe(this.messageContext, MESSAGE_CHANNEL, () => {
            this.template.querySelectorAll('c-custom-help-text').forEach((currentElement, index) => {
                currentElement.handleClose();
            })
        });
    }

    @api
    handleHideHelpText() {
        publish(this.messageContext, MESSAGE_CHANNEL, null);
    }

    getMinimumDate() {
        const date = new Date();
        date.setDate(-1);
        return date.toISOString();
    }

    getCustomerMeetingDate(month) {
        const currentDate = new Date();
        let priorDate;
        priorDate = currentDate;
        priorDate.setDate(1);
        priorDate.setMonth(month - 1);
        return priorDate.toISOString();
    }

    callRowAction(event) {
        this.customerMeetingDate = event.detail.row.date;
        const customerMeetingDateInput = this.template.querySelector(`lightning-input[data-name='customer-meeting-date']`);
        customerMeetingDateInput.value = new Date(event.detail.row.date).toISOString().substring(0,10);
        customerMeetingDateInput.reportValidity();
    }

    onDateValueChange(event) {
        this[event.currentTarget.dataset.key] = event.currentTarget.value;
        if (event.currentTarget.dataset.key === 'shelfDate') {
            this.setCustomerPresentationDate(true);
        }
    }

    setCustomerPresentationDate(isEnabled) {
        if (isEnabled) {
            this._customerPresentationData = CUSTOMER_MEETING_DATE_TABLE_DATA;
            this._customerPresentationData[0].date = this.getCustomerMeetingDate(4);
            this._customerPresentationData[1].date = this.getCustomerMeetingDate(4);
        }
    }

    get showEstimatedCustomerDate() {
        return this.projectClassification !== 'Continuous Improvement' && this.projectClassification !== 'Mandatory';
    }

}