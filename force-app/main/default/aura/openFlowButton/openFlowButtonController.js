({
    init : function (component) {    
        const recordId = component.get("v.recordId");    
        const objectName = component.get("v.sObjectName");
        component.set("v.display",true);
        const flow = component.find("flowData");
        if (objectName === "Account") {
            flow.startFlow("Create_an_Account");
        } else {
            // In that component, start your flow. Reference the flow's API Name.
            if (recordId) {
                const inputVariables = [
                    {
                        name : "ProjectId",
                        type : "String",
                        value: recordId
                    }
                ];
                //if it has Id we start the edition
                flow.startFlow("Project_Edit",inputVariables);
            } else {
                flow.startFlow("Project_Creation");
            }
        }
    },
    handleCapture : function(component, message) {
        component.set("v.display",false);  
        const inputVariables = [
            {
                name : "ProjectId",
                type : "String",
                value: message.getParam('projectId')
            },
            {
                name : "SkipToPhase",
                type : "String",
                value: message.getParam('phase')
            }
        ];
        component.set("v.display",true); 
        const flow = component.find("flowData");  
        flow.startFlow("Project_Edit",inputVariables);
    }
})