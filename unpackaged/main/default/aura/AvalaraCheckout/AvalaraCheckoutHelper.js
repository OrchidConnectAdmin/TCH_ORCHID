({
    loadCheckoutInfo : function(component, encryptedSalesOrderId) {
        var action = component.get('c.getCheckoutInfo');
        action.setParams({ encryptedSalesOrderId : encryptedSalesOrderId });

        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var info = response.getReturnValue();

                if (!info.taxableItems || info.taxableItems.length === 0) {
                    console.log('[Avalara] No taxable items, skipping tax review');
                    this.fireCompleteEvent(component);
                    return;
                }

                component.set('v.taxableItems', info.taxableItems);
                component.set('v.entityId', info.entityId);
                component.set('v.entityType', info.entityType);
                component.set('v.street', info.street);
                component.set('v.city', info.city);
                component.set('v.state', info.state);
                component.set('v.postalCode', info.postalCode);
                component.set('v.country', info.country);
                component.set('v.step', 'review');
                console.log('[Avalara] Checkout info loaded, showing review');
            } else {
                var errors = response.getError();
                var message = (errors && errors[0] && errors[0].message) ? errors[0].message : 'Unknown error';
                console.error('[Avalara] Failed to load checkout info:', message, JSON.stringify(errors));
                this.fireCompleteEvent(component);
            }
        });
        $A.enqueueAction(action);
    },

    syncAddressAndCalculate : function(component, encryptedSalesOrderId) {
        var action = component.get('c.updateEntityAddress');
        action.setParams({
            encryptedSalesOrderId : encryptedSalesOrderId,
            entityId : component.get('v.entityId'),
            entityType : component.get('v.entityType'),
            saveForFuture : false,
            street : component.get('v.street'),
            city : component.get('v.city'),
            state : component.get('v.state'),
            postalCode : component.get('v.postalCode'),
            country : component.get('v.country')
        });

        var self = this;
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                console.log('[Avalara] Address synced to SO, calculating tax...');
                self.runCalculateTax(component, encryptedSalesOrderId);
            } else {
                var errors = response.getError();
                var message = (errors && errors[0] && errors[0].message) ? errors[0].message : 'Failed to sync address.';
                console.error('[Avalara] Address sync error:', message);
                component.set('v.step', 'editing');
                component.set('v.errorMessage', message);
            }
        });
        $A.enqueueAction(action);
    },

    runCalculateTax : function(component, encryptedSalesOrderId) {
        var action = component.get('c.calculateTax');
        action.setParams({ encryptedSalesOrderId : encryptedSalesOrderId });
        console.log('[Avalara] Calling calculateTax...');

        var self = this;
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                console.log('[Avalara] Tax calculation completed');
                self.fireCompleteEvent(component);
            } else {
                var errors = response.getError();
                var message = (errors && errors[0] && errors[0].message) ? errors[0].message : 'Tax calculation failed.';
                var isAddressError = message.toLowerCase().indexOf('address') > -1;
                console.error('[Avalara] Tax calculation error:', message);

                if (isAddressError) {
                    component.set('v.step', 'editing');
                    component.set('v.errorMessage', message);
                } else {
                    console.log('[Avalara] Non-address error, proceeding');
                    self.fireCompleteEvent(component);
                }
            }
        });
        $A.enqueueAction(action);
    },

    fireCompleteEvent : function(component) {
        var completeEvent = $A.get('e.FDService:SparkPlugCompleteEvent');
        completeEvent.setParams({extensionPoint : component.get('v.extensionPoint')});
        completeEvent.fire();
        console.log('[Avalara] SparkPlugCompleteEvent fired');
    }
})