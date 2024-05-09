({
    init : function (component) {  
        var recordId = component.get("v.recordId");    
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        var objectName = component.get("v.sObjectName");

        if(objectName=="Account"){
            flow.startFlow("Create_an_Account");
        }else{
            // In that component, start your flow. Reference the flow's API Name.
            if(recordId){
                var inputVariables = [
                    {
                    name : "ProjectId",
                    type : "String",
                    value: recordId
                    }
                ];
                //if it has Id we start the edition
                flow.startFlow("Project_Edit",inputVariables);
            }else{
                flow.startFlow("Project_Creation");
            }
        }
       
    }
})