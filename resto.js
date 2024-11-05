const express = require('express');
const mongoose = require('mongoose');
const Invoice =require('./models/invoice.js')
const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');
const Employee =require ('./models/employee.js')
const MenuItem =require('./models/MenuItem.js')
const Order = require('./models/order.js')
const Users =require('./models/users.js')
const SalesReport =require('./models/salesReport.js')
const Table =require('./models/table.js');


const app =express()
app.use(express.json());

app.get('/',(req,res) => {
    res.send("hello from node api")
});

app.post('/api/employee', async (req,res) =>{
   try {
   const employee = await Employee.create(req.body);
   res.status(200).json(employee)
    
   } catch (error) {
    res.status(500).json ({message:error.message});
    
   }

});
app.get('/api/employee/new', async (req,res) =>{
    try {
    const employee = await Employee.find({});
    res.status(200).json(employee);
     
    } catch (error) {
     res.status(500).json ({message:error.message});
     
    }
 
 });
app.get('/api/employee/new/id', async (req,res) =>{
    try {
   const{ id }=req.params;
   const employee = await Employee.findById(id);
   res.status(200).json(employee);
     
    } catch (error) {
     res.status(500).json ({message:error.message});
     
    }
 
 });
 const generateInvoicePDF = (invoice) => {
    const doc = new PDFDocument();
    const filePath = path.join(__dirname, '../invoices', `${invoice._id}.pdf`);

    doc.pipe(fs.createWriteStream(filePath));

    doc.fontSize(25).text('Facture', { align: 'center' });
    doc.text(`ID de la commande: ${invoice.orderId}`);
    doc.text(`Nom du client: ${invoice.clientName}`);
    doc.text(`Montant total: ${invoice.totalAmount}`);
    doc.text(`Statut du paiement: ${invoice.paymentStatus}`);
    doc.text(`Méthode de paiement: ${invoice.paymentMethod}`);
    doc.text(`Date: ${new Date(invoice.createdAt).toLocaleDateString()}`);

    doc.end();
};
app.post('/api/invoice', async (req, res) => {
  try {
      const { orderId, clientName, totalAmount, paymentStatus, paymentMethod } = req.body;

      const invoice = await Invoice.create({
          orderId,
          clientName,
          totalAmount,
          paymentStatus,
          paymentMethod
      });

      // Generate PDF
      generateInvoicePDF(invoice);

      res.status(201).json(invoice);
  } catch (error) {
      console.error("Error details:", error); // Log the error for debugging
      res.status(500).json({ message: 'Error creating invoice', error: error.message });
  }
});




app.get('/api/invoices', async (req, res) => {
    try {
        const invoices = await Invoice.find({});
        res.status(200).json(invoices);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});



app.post('/api/MenuItem',async (req,res) =>{
    try {
        const menuItem=await MenuItem.create(req.body);
        res.status(200).json(menuItem)
    } catch (error){
        res.status(500).json({message:error.message});
    }
});
app.get('/api/MenuItems', async (req,res) =>{
    try {
    const menuItem = await MenuItem.find({});
    res.status(200).json(menuItem);
     
    } catch (error) {
     res.status(500).json ({message:error.message});
     
    }
});
app.post('/api/order',async (req,res) => {
    try {
        const order=await Order.create(req.body);
        res.status(200).json(order)
    } catch (error){
        res.status(500).json({message:error.message});
    }
});
app.get('/api/orders', async (req, res) => {
    try {
        const order = await Order.find({});
        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Get an order by ID
app.get('/api/orders/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const order = await Order.findById(id);
        if (!order) {
            return res.status(404).json({ message: "Order not found" });
        }
        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


// Route pour créer ou mettre à jour un rapport de vente
app.post('/api/salesReport', async (req, res) => {
  let { totalSales, itemsSold } = req.body;

  // Validation to avoid NaN in totalSales
  totalSales = isNaN(totalSales) ? 0 : totalSales;
  try {
    const salesReport = new SalesReport({ totalSales, itemsSold });
    await salesReport.save();
    res.status(201).json(salesReport);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});
  // try {
    // const totalSales = itemsSold.reduce((acc, item) => acc + (item.price * item.quantity), 0)

    // const report = await SalesReport.findOne({ totalItemsSold});
    
    // if (report) {
    //   // Si un rapport existe pour cette date, mettez-le à jour
    //   report.totalSales += totalSales;
    //   itemsSold.forEach(soldItem => {
    //     const existingItem = report.itemsSold.find(i => i.item.equals(soldItem.item));
    //     if (existingItem) {
    //       existingItem.quantity += soldItem.quantity; // Mettez à jour la quantité vendue
    //     } else {
    //       report.itemsSold.push({ item: soldItem.item, quantity: soldItem.quantity });
    //     }
    //   });
    //   await report.save();
    // } else {
    //   // Créez un nouveau rapport
    //   const newReport = new SalesReport({
    //     date,
    //     totalSales,
    //     itemsSold,
    //   });
    //   await newReport.save();

  //   }

  //   res.status(201).json({ message: 'Sales report created/updated successfully' });
  // } catch (error) {
  //   res.status(500).json({ message: 'Error creating/updating sales report', error });
  // }

// });

// Route pour récupérer les rapports de vente sur une période
app.get('/api/salesReports', async (req, res) => {
  const { startDate, endDate } = req.query;
  try {
    const salesReports = await SalesReport.find().populate('itemsSold.item');
    res.json(salesReports);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
//   try {
//     const reports = await SalesReport.find({
//       date: {
//         $gte: new Date(startDate),
//         $lte: new Date(endDate)
//       }
//     }).populate('itemsSold.item'); // Récupérez les informations des articles

//     res.json(reports);
//   } catch (error) {
//     res.status(500).json({ message: 'Error retrieving sales reports', error });
//   }
// });

// Route pour récupérer un résumé des ventes
app.get('/summary', async (req, res) => {
  const { startDate, endDate } = req.query;

  try {
    const reports = await SalesReport.find({
      date: {
        $gte: new Date(startDate),
        $lte: new Date(endDate)
      }
    });

    const totalSales = reports.reduce((acc, report) => acc + report.totalSales, 0);
    const totalItemsSold = reports.reduce((acc, report) => {
      return acc + report.itemsSold.reduce((itemAcc, item) => itemAcc + item.quantity, 0);
    }, 0);

    res.json({
      totalSales,
      totalItemsSold,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving sales summary', error });
  }
});



    
    app.post('/api/table',async (req,res) => {
            try {
                const table=await Table.create(req.body);
                res.status(200).json(table)
            } catch (error){
                res.status(500).json({message:error.message});
            }
    });
    app.get('/api/tables', async (req, res) => {
        try {
            const table = await Table.find({});
            res.status(200).json(table);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    });
    app.post('/api/user',async (req,res) => {
        try {
            const users=await Users.create(req.body);
            res.status(200).json(users)
        } catch (error){
    res.status(500).json({message:error.message});
          }
        });
        app.get('/api/users', async (req, res) => {
            try {
                const users = await Users.find({});
                res.status(200).json(users);
            } catch (error) {
                res.status(500).json({ message: error.message });
            }
        });
        
        // Get a user by ID
        app.get('/api/users/:id', async (req, res) => {
            try {
                const { id } = req.params;
                const user = await Users.findById(id);
                if (!user) {
                    return res.status(404).json({ message: "User not found" });
                }
                res.status(200).json(user);
            } catch (error) {
                res.status(500).json({ message: error.message });
            }
        });




mongoose.connect("mongodb+srv://edenrugomana:1234@cluster0.7vcnh.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
.then(() => {
    console.log("connected to database!");
    app.listen(3000,() =>
    {
        console.log('server is running port 3000');
    });
})
.catch(() => {
    console.log("connection failed!");
})