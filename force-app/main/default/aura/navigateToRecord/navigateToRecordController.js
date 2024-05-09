({
   invoke : function(component, event, helper) {
      const record = component.get("v.recordId");
      const redirect = $A.get("e.force:navigateToSObject");
      redirect.setParams({
         "recordId": record
      });
      redirect.fire();
   }
})