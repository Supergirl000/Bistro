const { default: mongoose } = require("mongoose");
const orderSchema = new mongoose.Schema({
    tableNumber: { type: Number, required: true },
    items: [
      {
        menuItem: { type: mongoose.Schema.Types.ObjectId, ref: 'MenuItem', required: true },
        quantity: { type: Number, default: 1 },
        price: { type: Number, required: true } // Prix calculé en fonction de la quantité
      }
    ],
    status: { type: String, enum: ['pending', 'completed'], default: 'pending' }, // Statut de la commande
    totalAmount: { type: Number, required: true }, // Total de la commande
    waiter: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // Serveur qui a pris la commande
  }, { timestamps: true });
  
  module.exports = mongoose.model('Order', orderSchema);
  