const { default: mongoose } = require("mongoose");
const menuItemSchema = new mongoose.Schema({
    name: { type: String, required: true },
    description: { type: String },
    price: { type: Number, required: true },
    category: { type: String, required: true }, // Par exemple : Boissons, Entrées, Plats principaux
    image: { type: String }, // URL de l'image du plat
  }, { timestamps: true });
  
  module.exports = mongoose.model('MenuItem', menuItemSchema);
  