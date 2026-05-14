({
    enqueueAvalaraCommit : function(component, receiptNumber) {
        console.log('[Avalara] Enqueuing commit for receipt:', receiptNumber);
        var action = component.get("c.enqueueAvalaraCommit");
        action.setParams({ receiptNumber : receiptNumber });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                console.log('[Avalara] Commit enqueued successfully');
            } else {
                var errors = response.getError();
                console.error('[Avalara] Failed to enqueue commit:', errors);
            }
        });
        $A.enqueueAction(action);
    }
})