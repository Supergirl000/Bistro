const { default: mongoose } = require("mongoose");
const tableSchema = new mongoose.Schema({
    number: { type: Number, required: true, unique: true },
    capacity: { type: Number, required: true }, // Nombre de personnes que la table peut accueillir
    status: { type: String, enum: ['available', 'occupied'], default: 'available' },
  }, { timestamps: true });
  
  module.exports = mongoose.model('Table', tableSchema);
  