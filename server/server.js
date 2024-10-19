const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/innerbhakti');

const programSchema = new mongoose.Schema({
  name: String,
  image: String,
  tracks: [{ name: String, duration: String, audioUrl: String }],
});

const Program = mongoose.model('Program', programSchema);

// Fetch all programs
app.get('/programs', async (req, res) => {
  const programs = await Program.find();
  res.json(programs);
});

// Fetch program details
app.get('/programs/:id', async (req, res) => {
  const program = await Program.findById(req.params.id);
  res.json(program);
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
