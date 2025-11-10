// APIMongo/server.js
import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';

import { connectDB } from './config/MongoDB.js';

import FormsRoutes from './routes/FormRoutes.js'; 

dotenv.config();
const app = express();
app.use(express.json());
app.use(cors()); 

  // Usar as rotas
app.use('/db/forms', FormsRoutes);

connectDB();

app.listen(process.env.PORT, () => {
  console.log(`Servidor rodando em http://localhost:${process.env.PORT}`);
});