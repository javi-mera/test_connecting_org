import { LightningElement, api } from 'lwc';

export default class MarginBlock extends LightningElement {
 
    @api
    marginValue;

    get marginBlockStyle() {
        return `margin-top: ${this.marginValue}px;`;
    }

}