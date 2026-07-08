import serial
import serial.tools.list_ports
import csv
import time

BAUD_RATE = 9600 

def encontrar_porta():
    portas = serial.tools.list_ports.comports()
    for p in portas:
        if "USB" in p.description or "COM" in p.device:
            return p.device
    return None

def capturar(nome_arquivo_csv=None):

    porta = encontrar_porta()
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
        print("Gerando log de alarmes. Pressione Ctrl+C para interromper e salvar o arquivo CSV.")
        while True:
            linha = ser.readline().decode('utf-8', errors='ignore').strip()
            if not linha: continue
            print(f"ATmega16 -> {linha}")
            
            # printf("%02d:%02d:%02d,Alarme_1,Ativado\n", hora, min, seg);
            if "," in linha and "Hora" not in linha:
                partes = linha.split(',')
                dados.append(partes)
                
    except KeyboardInterrupt:
        print("\nInterrompido pelo usuário. Salvando log de alarmes...")
    
    ser.close()
    
    if dados:
        with open(f'{nome_arquivo_csv}', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(["Hora", "Alarme", "Status"])
            
            for linha in dados:
                writer.writerow(linha)
        
        print(f"Arquivo salvo como: {nome_arquivo_csv}")

if __name__ == "__main__":
    capturar(nome_arquivo_csv="registro_monitoramento.csv")