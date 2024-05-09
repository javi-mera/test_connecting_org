({
    init : function (component, event) {        
        var fields = event.getParam('fields');
        console.log(fields);

        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        var inputVariables = [
            {
               name : "recordId",
               type : "String",
               value: component.get("v.recordId")
            }
         ];
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("Submit_For_Approval_Flow", inputVariables);
    }
})