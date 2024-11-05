const mongoose = require('mongoose');
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, enum: ['admin', 'manager', 'waiter'], default: 'manager' }, // Gestion des rôles
  isVerified: { type: Boolean, default: false }, // Email vérifié
}, { timestamps: true });

module.exports = mongoose.model('Users', userSchema);
