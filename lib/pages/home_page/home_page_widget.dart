import 'package:alnitak/services/bluetooth_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:battery_plus/battery_plus.dart'; // Import do pacote para o velocímetro
import '/services/bluetooth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'home_page_model.dart';
import 'dart:async';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class YourModel {
  bool? switchValue2;
  String? extraMessage; // Adicione esta linha

  YourModel({
    this.switchValue2,
    this.extraMessage, // Adicione esta linha
  });
}

class _HomePageWidgetState extends State<HomePageWidget>
    with SingleTickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  double _speed = 0.0;
  double _batteryLevel = 0.0;
  late AnimationController _animationController;
  late StreamSubscription<BatteryState> _batterySubscription;
  final BluetoothService _bluetoothService = BluetoothService();

  void _updateSpeed(double newSpeed) {
    setState(() {
      _speed = newSpeed;
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: false);
    _listenBatteryLevel();
    // Removemos o _connectToESP32() pois agora a conexão será feita pelo switch
  }

  void _listenBatteryLevel() async {
    final battery = Battery();
    _batterySubscription =
        battery.onBatteryStateChanged.listen((BatteryState state) async {
      final level = await battery.batteryLevel;
      setState(() {
        _batteryLevel = level / 100;
      });
    });
  }

  Future<bool> _sendCommand(String command) async {
    if (_bluetoothService.isConnected) {
      try {
        final sent = await _bluetoothService.sendCommand(command);
        if (!sent && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao enviar comando. Verifique a conexão.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return sent;
      } catch (e) {
        print('Erro ao enviar comando: $e');
        return false;
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bluetooth não está conectado'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _batterySubscription.cancel();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            actions: const [],
            centerTitle: false,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 250, // Defina a largura desejada
                        height: 250, // Defina a altura desejada
                        child: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.0, end: _speed),
                          duration: const Duration(seconds: 1),
                          builder: (BuildContext context, double value,
                              Widget? child) {
                            return Center(
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 150,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: 50,
                                        color: Colors.blue,
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                      GaugeRange(
                                        startValue: 50,
                                        endValue: 100,
                                        color: Colors.blue,
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                      GaugeRange(
                                        startValue: 100,
                                        endValue: 150,
                                        color: Colors.blue,
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                    ],
                                    pointers: <GaugePointer>[
                                      NeedlePointer(
                                        value:
                                            _speed, // Posição do marcador vermelho
                                        lengthUnit: GaugeSizeUnit.factor,
                                        needleLength: 0.7,
                                        needleColor: Colors.red,
                                        knobStyle: const KnobStyle(
                                          knobRadius: 0.1,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 40),
                                            Text(
                                              value.toStringAsFixed(2),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    10), // Espaçamento entre o texto e a imagem
                                            Image.asset(
                                              'assets/images/lumios_energy.png', // Substitua pelo caminho da sua imagem
                                              width:
                                                  50, // Ajuste o tamanho conforme necessário
                                              height: 30,
                                            ),
                                          ],
                                        ),
                                        angle: 90,
                                        positionFactor: 0.5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Slider(
                        value: _speed,
                        min: 0,
                        max: 150,
                        onChanged: (double newValue) {
                          _updateSpeed(newValue);
                        },
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            height: 50, // Aumentei a altura para 50
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 182, 202, 220),
                                  width: 2.0),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: SizedBox(
                                    width: MediaQuery.sizeOf(context).width *
                                        0.9 *
                                        _batteryLevel,
                                    height: 50,
                                    child: Lottie.asset(
                                      'assets/jsons/mx7ev5vBg9.json', // Substitua pelo caminho da sua animação Lottie
                                      fit: BoxFit.cover,
                                      animate: true,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${(_batteryLevel * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(
                                0.0,
                                2.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/anchor_(1).png',
                                      width: 30.0,
                                      height: 35.0,
                                      fit: BoxFit.cover,
                                      alignment: const Alignment(0.0, 0.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  28.0, 0.0, 28.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'vcqi6g9r' /* Âncora */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'ei36on5v' /* 30 M */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: const Color(0xFF379FCB),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(
                                0.0,
                                2.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'tfjkq7qs' /* Motor */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'huvsvnas' /* 30.0 ºC */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: const Color(0xFF379FCB),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    28.0, 0.0, 28.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'icupkutz' /* Tensão */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'lkvqo04q' /* 48.0 V */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color: const Color(0xFF379FCB),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            '4z6klaj3' /* Control */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'wrarzam8' /* 48.0 ºC */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color: const Color(0xFF379FCB),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(
                                0.0,
                                2.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _model.extraMessage ??
                                  FFLocalizations.of(context).getText(
                                    'y840d2q7' /* MENSAGEM EXTRA */,
                                  ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).error,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _sendCommand('1').then((success) {
                                if (!success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Falha ao enviar comando. Verifique a conexão Bluetooth.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.29,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 2.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'BOTÃO 1',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: const Color(0xFF289900),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _sendCommand('2').then((success) {
                                if (!success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Falha ao enviar comando. Verifique a conexão Bluetooth.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.29,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 2.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'BOTÃO 2',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: const Color.fromARGB(
                                            255, 218, 214, 14),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _sendCommand('3').then((success) {
                                if (!success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Falha ao enviar comando. Verifique a conexão Bluetooth.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.29,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 2.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'BOTÃO 3',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: const Color.fromARGB(
                                            255, 239, 5, 5),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ].divide(const SizedBox(height: 8.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
