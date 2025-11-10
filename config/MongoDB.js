//server/config/db.js

const MONGO_URI='mongodb+srv://AdmPET:g3isthebest@cluster0.ntpwyyz.mongodb.net/Pet_Saude?appName=Cluster0'

import mongoose from 'mongoose';
import dotenv from 'dotenv';
dotenv.config();

export const connectDB = async () => {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('Conectado ao MongoDB');
  } catch (err) {
    console.error('Erro ao conectar no MongoDB:', err);
  }
};
