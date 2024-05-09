import { LightningElement, api } from 'lwc';

export default class FinancialThresholds extends LightningElement {
    @api recordId;
    @api willBeAchieved;
    @api willNotBeAchievedComment = '';
    _options = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No' , value: 'No'  }
    ];
    value = 'Yes';
    
    connectedCallback() {
        this.willBeAchieved = true;
    }

    npvChanged(event) {
        this.willBeAchieved = event.detail.value === 'Yes';
        this.willNotBeAchievedComment = this.willBeAchieved ? '' : this.willNotBeAchievedComment;
    }

    commentChanged(event) {
        this.willNotBeAchievedComment = event.detail.value;
    }

    get options() {
        return this._options;
    }

    get npvNotAchieved() {
        return !this.willBeAchieved;
    }

}