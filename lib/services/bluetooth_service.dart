import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  BluetoothConnection? connection;
  bool isConnected = false;
  Stream<Uint8List>? dataStream;

  Future<bool> requestPermissions() async {
    // Solicita múltiplas permissões
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();

    // Verifica se todas as permissões foram concedidas
    bool allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
      }
    });

    return allGranted;
  }

  Future<bool> connectToESP32() async {
    try {
      // Solicita permissões
      bool permissionsGranted = await requestPermissions();
      if (!permissionsGranted) {
        throw Exception('Permissões não concedidas');
      }

      // Verifica se o Bluetooth está ligado
      bool? isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
      if (isEnabled != true) {
        await FlutterBluetoothSerial.instance.requestEnable();
      }

      // Busca dispositivos pareados
      List<BluetoothDevice> devices =
          await FlutterBluetoothSerial.instance.getBondedDevices();

      // Procura pela ESP32
      BluetoothDevice? esp32Device;
      try {
        esp32Device = devices.firstWhere(
          (device) => device.name == "ESP32_LED_Control",
        );
      } catch (e) {
        throw Exception('ESP32 não encontrada entre os dispositivos pareados');
      }

      // Tenta conectar à ESP32
      print('Tentando conectar a: ${esp32Device.name}');
      connection = await BluetoothConnection.toAddress(esp32Device.address);
      isConnected = connection?.isConnected ?? false;

      if (isConnected) {
        print('Conectado com sucesso a ${esp32Device.name}');
        dataStream = connection!.input;
        _startListening();
      } else {
        throw Exception('Falha ao estabelecer conexão com a ESP32');
      }

      return isConnected;
    
      return false;
    } catch (e) {
      print('Erro ao conectar: $e');
      isConnected = false;
      rethrow; // Re-lança a exceção para ser tratada no UI
    }
  }

  void _startListening() {
    dataStream?.listen(
      (Uint8List data) {
        print('Dados recebidos: ${String.fromCharCodes(data)}');
      },
      onError: (error) {
        print('Erro ao receber dados: $error');
        isConnected = false;
      },
      onDone: () {
        print('Conexão finalizada');
        isConnected = false;
      },
    );
  }

  Future<void> disconnect() async {
    try {
      await connection?.close();
      connection = null;
      isConnected = false;
      print('Desconectado com sucesso');
    } catch (e) {
      print('Erro ao desconectar: $e');
    }
  }

  Future<bool> sendCommand(String command) async {
    if (!isConnected || connection == null) {
      print('Tentativa de enviar comando sem conexão');
      return false;
    }

    try {
      connection!.output.add(Uint8List.fromList(command.codeUnits));
      await connection!.output.allSent;
      print('Comando $command enviado com sucesso');
      return true;
    } catch (e) {
      print('Erro ao enviar comando: $e');
      return false;
    }
  }
}
