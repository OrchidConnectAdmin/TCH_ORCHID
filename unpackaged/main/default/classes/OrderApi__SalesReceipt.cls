/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SalesReceipt {
    global Id customer_id;
    global List<OrderApi.SalesReceipt.LineItem> line_items;
    global SalesReceipt(Id customer_id) {

    }
global class LineItem {
    global Decimal amount;
    global Id invoice_id;
    global Id item_id;
    global Boolean price_override;
    global Integer quantity;
    global LineItem(Id item_id, Integer quantity) {

    }
    global LineItem(Id invoice_id, Decimal invoice_payment_amount) {

    }
    global LineItem(Id item_id, Integer quantity, Boolean price_override, Decimal sale_price) {

    }
}
}
