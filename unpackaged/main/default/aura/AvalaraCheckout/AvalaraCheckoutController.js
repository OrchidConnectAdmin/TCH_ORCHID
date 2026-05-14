({
    doInit : function(component, event, helper) {
        console.log('[Avalara] === SparkPlug doInit START ===');

        var compEvent = $A.get('e.FDService:SparkPlugLoadedEvent');
        compEvent.setParams({extensionPoint : component.get('v.extensionPoint')});
        compEvent.fire();

        var data = component.get('v.data');
        console.log('[Avalara] encryptedSalesOrderId:', data.salesOrder);

        helper.loadCheckoutInfo(component, data.salesOrder);
    },

    handleContinue : function(component, event, helper) {
        component.set('v.step', 'processing');
        component.set('v.errorMessage', '');

        var data = component.get('v.data');
        helper.syncAddressAndCalculate(component, data.salesOrder);
    },

    handleEdit : function(component) {
        component.set('v.step', 'editing');
        component.set('v.errorMessage', '');
    },

    handleBackToReview : function(component) {
        component.set('v.step', 'review');
        component.set('v.errorMessage', '');
    },

    handleSaveAddress : function(component, event, helper) {
        component.set('v.isSaving', true);

        var data = component.get('v.data');
        var action = component.get('c.updateEntityAddress');
        action.setParams({
            encryptedSalesOrderId : data.salesOrder,
            entityId : component.get('v.entityId'),
            entityType : component.get('v.entityType'),
            saveForFuture : component.get('v.saveForFuture'),
            street : component.get('v.street'),
            city : component.get('v.city'),
            state : component.get('v.state'),
            postalCode : component.get('v.postalCode'),
            country : component.get('v.country')
        });

        action.setCallback(this, function(response) {
            component.set('v.isSaving', false);

            if (response.getState() === 'SUCCESS') {
                console.log('[Avalara] Address saved, calculating tax...');
                component.set('v.step', 'processing');
                component.set('v.errorMessage', '');
                helper.runCalculateTax(component, data.salesOrder);
            } else {
                var errors = response.getError();
                var message = (errors && errors[0] && errors[0].message) ? errors[0].message : 'Failed to save address.';
                console.error('[Avalara] Address save error:', message);
                component.set('v.errorMessage', message);
            }
        });
        $A.enqueueAction(action);
    }
})