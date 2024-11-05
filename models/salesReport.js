const { default: mongoose } = require("mongoose");
const salesReportSchema = new mongoose.Schema({
  totalSales: {
    type: Number,
    required: true,
    default:0,
  },
   // Total des ventes pour la période donnée
    itemsSold: [
      {
        item: { type: mongoose.Schema.Types.ObjectId, ref: 'MenuItem', required: true },
        quantity: { type: Number, required: true }
        
      }
    ]
  }, { timestamps: true });
  
  module.exports = mongoose.model('SalesReport', salesReportSchema);
  