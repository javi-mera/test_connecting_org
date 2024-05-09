import {LightningElement, api} from 'lwc';

export default class CustomDataType extends LightningElement {

    @api customDate;

    newDate;

    connectedCallback() {
            console.log('in custom type a')
            console.log('customDate: ', this.customDate)
        this.newDate = this.customDate;
    }

    // fireCustomTypeA() {
    //     console.log('in custom type a')
    //     console.log('customDate: ', this.customDate)
    //     // this.customDate = new Date();
    //     // let newCustomValueA = this.customValue + 1;
    //
    //     // const event = new CustomEvent('customdate', {
    //     //     composed: true,
    //     //     bubbles: true,
    //     //     cancelable: true,
    //     //     detail: {
    //     //         newCustomDate: this.customDate
    //     //     },
    //     // });
    //     //
    //     // this.dispatchEvent(event);
    // }

}