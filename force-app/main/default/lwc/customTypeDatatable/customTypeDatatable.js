import LightningDatatable from "lightning/datatable";
import dateTemplate from "./dateTemplate.html";
import dateTemplateEditable from "./dateTemplateEditable.html";

export default class CustomTypeDatatable extends LightningDatatable {
    static customTypes = {
        customDateTemplate: {
            template: dateTemplate,
            editTemplate: dateTemplateEditable,
            standardCellLayout: true,
            typeAttributes: ["customDate", "displayDate"],
        }
    };
}