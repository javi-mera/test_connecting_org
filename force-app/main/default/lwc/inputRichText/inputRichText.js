import { api, LightningElement } from 'lwc';

export default class InputRichText extends LightningElement {
    @api inputText;
    @api decisionText;
    @api value = this.inputText;
    @api decisionValue = this.decisionText;
    @api showDecisionRequired;
    @api label = '';
    @api labelDecision = 'Decision Required';
    
    formats = ['font', 'size', 'bold', 'italic', 'underline',
        'strike', 'list', 'indent', 'align', 'link',
        'image', 'clean', 'table', 'header', 'color','background','code','code-block','script','blockquote','direction'];

    connectedCallback() {
        this.value = this.inputText;
        this.decisionValue = this.decisionText;

        this.showDecisionRequired = this.decisionValue ? true : false;
    }

    handleValueChange(event) {
        this.value = event.target.value;
        console.log(this.value);
    }
    handleDecisionValueChange(event) {
        this.decisionValue = event.target.decisionValue;
    }

    @api
    validate() {
        this.inputText = this.value;
        this.decisionText = this.decisionValue;
        if (this.inputText) { 
            return { isValid: true }; 
        } 
        else { 
            // If the component is invalid, return the isValid parameter 
            // as false and return an error message. 
            return { 
                isValid: false, 
                errorMessage: 'Please fill up a Task & Decision' 
            }; 
        }
    }
}