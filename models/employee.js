const { default: mongoose } = require("mongoose");

const employeeSchema = new mongoose.Schema({
    name: { type: String, required: true },
    position: { type: String, enum: ['waiter', 'chef', 'manager'], required: true },
    hireDate: { type: Date, default: Date.now },
    performanceRating: { type: Number, default: 5 }, // Note de performance sur 10
  }, { timestamps: true });
  
  module.exports = mongoose.model('Employee', employeeSchema);
  