import {LightningElement, api} from 'lwc';

export default class CustomHelpText extends LightningElement {
    @api helptext;
    @api showHelpText = false;
    @api specialStyle;
    @api projectNameInput = false;

    styleClasses = 'stickyPopup';
    popupStyles = 'slds-popover slds-popover_tooltip tooltip-styles slds-nubbin_bottom';

    connectedCallback() {
        if (this.specialStyle) {
            this.styleClasses = 'stickyPopupSpecial';
        }
        if (this.projectNameInput) {
            this.popupStyles = 'slds-popover slds-popover_tooltip tooltip-styles tooltip-styles-special slds-nubbin_left';
            this.styleClasses = 'stickyPopupNameInput';
        }
    }

    handleOnClick() {
        this.dispatchEvent(
            new CustomEvent(
                'hidehelptext',
                {
                    detail : false
                }
            )
        );
        this.showHelpText = true;
    }

    @api
    handleClose() {
        this.showHelpText = false;
    }
}