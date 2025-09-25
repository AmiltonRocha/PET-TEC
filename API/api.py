from fastapi import FastAPI
from pydantic import BaseModel
import mysql.connector
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Liberar CORS para Flutter web/desktop
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permite todas as origens
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modelo de dados
class Paciente(BaseModel):
    nome: str
    cpf: str
    data_nascimento: str
    idade: int
    sexo: str
    telefone: str
    quarto_leito: str
    queixa_principal: str
    observacoes: str
    tipo_avc: str

# Endpoint para receber dados
@app.post("/pacientes")
def cadastrar_paciente(paciente: Paciente):
    print("Recebido na API:", paciente.dict())  # Debug para ver o que chegou
    try:
        # Conexão com o MySQL
        conn = mysql.connector.connect(
            host="localhost",
            user="root",      # seu usuário MySQL
            password="123456789",      # sua senha MySQL
            database="hospital"  # banco de dados
        )
        cursor = conn.cursor()

        # Inserção no banco
        sql = """INSERT INTO paciente
                 (nome, cpf, data_nascimento, sexo, telefone, quarto_leito, queixa_principal, observacoes, tipo_avc)
                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        valores = (
            paciente.nome,
            paciente.cpf,
            paciente.data_nascimento,
            paciente.sexo,
            paciente.telefone,
            paciente.quarto_leito,
            paciente.queixa_principal,
            paciente.observacoes,
            paciente.tipo_avc
        )

        cursor.execute(sql, valores)
        conn.commit()
        cursor.close()
        conn.close()

        print("Paciente inserido com sucesso no banco!")  # Debug
        return {"status": "sucesso", "mensagem": "Paciente cadastrado"}
    except Exception as e:
        print("Erro ao inserir no banco:", e)
        return {"status": "erro", "mensagem": str(e)}
