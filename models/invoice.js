const mongoose = require('mongoose');

const InvoiceSchema = new mongoose.Schema({
    clientName: { type: String, required: true },
    items: [{
        description: String,
        quantity: Number,
        price: Number,
        total: Number
    }],
    totalAmount: { type: Number, required: true },
    paymentStatus: { type: String, enum: ['Paid', 'Pending', 'Cancelled'], default: 'Pending' },
    paymentMethod: { type: String, enum: ['Cash', 'Card', 'Online'], default: 'Cash' },
    createdAt: { type: Date, default: Date.now }
});

// Create the model
const Invoice = mongoose.model('Invoice', InvoiceSchema);

// Export the model
module.exports = Invoice;
