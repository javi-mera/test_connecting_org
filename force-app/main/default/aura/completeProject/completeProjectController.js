({
    init : function (component, event) {
        const flow = component.find("flowData");
        const inputVariables = [
            {
                name : "recordId",
                type : "String",
                value: component.get("v.recordId")
            }
        ];
        flow.startFlow("Project_Complete", inputVariables);
    }
})