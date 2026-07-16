import serial
import serial.tools.list_ports
import csv
import time
from datetime import datetime  # Importante: adicionar esta biblioteca

BAUD_RATE = 19200

def capturar(nome_arquivo_csv=None):

    porta = 'COM3'
    if porta is None:
        print("Nenhuma porta serial encontrada.")
        return
    print(f"Tentando conectar na porta fixa: {porta} a {BAUD_RATE} bps...")
    
    try:
        ser = serial.Serial(porta, BAUD_RATE, timeout=2)
        time.sleep(2)
        ser.reset_input_buffer()
        print("Conectado.")
    except Exception as e:
        print(f"Erro ao abrir a {porta}: {e}")
        return

    dados = []
    try:
        print("Gerando log de alarmes.")
        while True:
            linha = ser.readline().decode('utf-8', errors='ignore').strip()
            if not linha: continue
            if "," in linha:
                partes = linha.split(',')
                
                try:
                    data_hora_obj = datetime.strptime(partes[0].strip(), "%d/%m/%y %H:%M:%S")
                    partes[0] = data_hora_obj.strftime("%d/%m/%y %H:%M:%S")
                except ValueError:
                    pass

                dados.append(partes)
                
    except KeyboardInterrupt:
        print("\nInterrompido pelo usuário. Salvando log de alarmes...")
    
    ser.close()
    
    if dados:
        with open(f'{nome_arquivo_csv}', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(["TIMESTAMP", "STATE"])
            
            for linha in dados:
                writer.writerow(linha)
        
        print(f"Arquivo salvo como: {nome_arquivo_csv}")

if __name__ == "__main__":
    capturar(nome_arquivo_csv="registro_monitoramento.csv")