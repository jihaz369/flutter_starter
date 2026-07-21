import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const HoloRadioApp());
}

// ==================== THEME ====================
class HoloTheme {
  static const Color bg = Color(0xFF05070A);
  static const Color panelBg = Color(0xA60A1428);
  static const Color cyan = Color(0xFF00F0FF);
  static const Color cyanDim = Color(0x4D00F0FF);
  static const Color blue = Color(0xFF0066FF);
  static const Color blueDim = Color(0x330066FF);
  static const Color green = Color(0xFF00FF88);
  static const Color red = Color(0xFF3366FF);
  static const Color yellow = Color(0xFFFFCC00);
  static const Color grid = Color(0x0F00F0FF);
  static const Color glass = Color(0x660F1E3C);
  static const Color border = Color(0x4000F0FF);
  static const Color fontMono = Color(0xFF00F0FF);
}

// ==================== APP ====================
class HoloRadioApp extends StatelessWidget {
  const HoloRadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HoloRadio',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: HoloTheme.bg,
        colorScheme: const ColorScheme.dark(
          primary: HoloTheme.cyan,
          secondary: HoloTheme.blue,
          surface: HoloTheme.panelBg,
        ),
      ),
      home: const HoloRadioHome(),
    );
  }
}

// ==================== HOME ====================
class HoloRadioHome extends StatefulWidget {
  const HoloRadioHome({super.key});

  @override
  State<HoloRadioHome> createState() => _HoloRadioHomeState();
}

class _HoloRadioHomeState extends State<HoloRadioHome>
    with SingleTickerProviderStateMixin {
  int _currentTab = 0;
  late AnimationController _radarController;

  final List<String> _tabs = ['SENDER', 'RECEIVER', 'SETTINGS', 'ANALYZER'];

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Grid
          const BackgroundGrid(),
          // Radar Sweep
          RadarSweep(controller: _radarController),
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 20),
                    // Tabs
                    _buildTabs(),
                    const SizedBox(height: 25),
                    // Screen Content
                    _buildScreen(),
                    const SizedBox(height: 20),
                    // Footer
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: HoloTheme.border),
        ),
      ),
      child: Column(
        children: [
          Text(
            '◈ HOLO RADIO ◈',
            style: TextStyle(
              fontSize: 28,
              letterSpacing: 4,
              color: HoloTheme.cyan,
              fontFamily: 'Courier',
              shadows: [
                Shadow(
                  color: HoloTheme.cyan.withOpacity(0.5),
                  blurRadius: 20,
                ),
                Shadow(
                  color: HoloTheme.blue.withOpacity(0.3),
                  blurRadius: 40,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'DIGITAL MODEM SYSTEM // OFFLINE CAPABLE',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 6,
              color: HoloTheme.cyan.withOpacity(0.5),
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final isActive = _currentTab == index;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () => setState(() => _currentTab = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? HoloTheme.cyan.withOpacity(0.2)
                    : HoloTheme.glass,
                border: Border.all(
                  color: isActive ? HoloTheme.cyan : HoloTheme.border,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: HoloTheme.cyan.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: HoloTheme.cyan,
                  fontFamily: 'Courier',
                  fontSize: 13,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScreen() {
    switch (_currentTab) {
      case 0:
        return const SenderScreen();
      case 1:
        return const ReceiverScreen();
      case 2:
        return const SettingsScreen();
      case 3:
        return const AnalyzerScreen();
      default:
        return const SenderScreen();
    }
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: HoloTheme.border),
        ),
      ),
      child: Text(
        'HOLO RADIO v1.0 // OFFLINE DIGITAL MODEM // NO EXTERNAL DEPENDENCIES',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: HoloTheme.cyan.withOpacity(0.5),
          letterSpacing: 2,
          fontFamily: 'Courier',
        ),
      ),
    );
  }
}

// ==================== BACKGROUND GRID ====================
class BackgroundGrid extends StatelessWidget {
  const BackgroundGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: GridPainter(),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HoloTheme.grid
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== RADAR SWEEP ====================
class RadarSweep extends StatelessWidget {
  final AnimationController controller;

  const RadarSweep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Opacity(
            opacity: 0.15,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: HoloTheme.cyanDim),
              ),
              child: Transform.rotate(
                angle: controller.value * 2 * math.pi,
                child: CustomPaint(
                  painter: RadarSweepPainter(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RadarSweepPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          HoloTheme.cyanDim,
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width / 2, size.height / 2));

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== PANEL WIDGET ====================
class HoloPanel extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const HoloPanel({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: HoloTheme.panelBg,
        border: Border.all(color: HoloTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            // Scanline animation
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _Scanline(),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Panel Title
                  Row(
                    children: [
                      const Text(
                        '◆',
                        style: TextStyle(
                          color: HoloTheme.cyan,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: HoloTheme.cyan,
                          fontSize: 12,
                          letterSpacing: 3,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...children,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Scanline extends StatefulWidget {
  @override
  State<_Scanline> createState() => _ScanlineState();
}

class _ScanlineState extends State<_Scanline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: math.sin(_controller.value * math.pi) * 0.5 + 0.5,
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, HoloTheme.cyan, Colors.transparent],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==================== CUSTOM WIDGETS ====================
class HoloButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDanger;

  const HoloButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = HoloTheme.border;
    Color bgColor = HoloTheme.glass;
    Color textColor = HoloTheme.cyan;

    if (isPrimary) {
      borderColor = HoloTheme.cyan;
      bgColor = HoloTheme.cyan.withOpacity(0.15);
    } else if (isDanger) {
      borderColor = HoloTheme.red;
      textColor = HoloTheme.red;
      bgColor = HoloTheme.red.withOpacity(0.1);
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Courier',
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class HoloTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final int? maxLines;
  final bool obscureText;
  final TextEditingController? controller;
  final bool enabled;

  const HoloTextField({
    super.key,
    this.label,
    this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              color: HoloTheme.cyan.withOpacity(0.5),
              fontFamily: 'Courier',
            ),
          ),
        if (label != null) const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border.all(color: HoloTheme.border),
            borderRadius: BorderRadius.circular(2),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            obscureText: obscureText,
            enabled: enabled,
            style: const TextStyle(
              color: HoloTheme.cyan,
              fontFamily: 'Courier',
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: HoloTheme.cyan.withOpacity(0.3),
                fontFamily: 'Courier',
              ),
              contentPadding: const EdgeInsets.all(12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class HoloDisplayBox extends StatelessWidget {
  final String text;
  final double? minHeight;

  const HoloDisplayBox({
    super.key,
    required this.text,
    this.minHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight ?? 80),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: HoloTheme.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: HoloTheme.green,
          fontFamily: 'Courier',
          fontSize: 12,
          height: 1.6,
        ),
      ),
    );
  }
}

class HoloToggle extends StatefulWidget {
  final String label;
  final ValueChanged<bool>? onChanged;
  final bool initialValue;

  const HoloToggle({
    super.key,
    required this.label,
    this.onChanged,
    this.initialValue = false,
  });

  @override
  State<HoloToggle> createState() => _HoloToggleState();
}

class _HoloToggleState extends State<HoloToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _value = !_value);
        widget.onChanged?.call(_value);
      },
      child: Row(
        children: [
          Container(
            width: 44,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              border: Border.all(color: HoloTheme.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _value ? HoloTheme.green : HoloTheme.cyanDim,
                  shape: BoxShape.circle,
                  boxShadow: _value
                      ? [BoxShadow(color: HoloTheme.green, blurRadius: 10)]
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              color: _value ? HoloTheme.green : HoloTheme.cyan.withOpacity(0.5),
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }
}

class HoloSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double>? onChanged;

  const HoloSlider({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: HoloTheme.cyan.withOpacity(0.5),
            fontFamily: 'Courier',
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: HoloTheme.cyan,
            inactiveTrackColor: Colors.black.withOpacity(0.4),
            thumbColor: HoloTheme.cyan,
            overlayColor: HoloTheme.cyan.withOpacity(0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class HoloMeter extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double? height;

  const HoloMeter({
    super.key,
    required this.value,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border.all(color: HoloTheme.border),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [HoloTheme.green, HoloTheme.cyan, HoloTheme.blue],
            ),
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== SENDER SCREEN ====================
class SenderScreen extends StatefulWidget {
  const SenderScreen({super.key});

  @override
  State<SenderScreen> createState() => _SenderScreenState();
}

class _SenderScreenState extends State<SenderScreen> {
  String _txText = 'Hello, HoloRadio! This is a test transmission.';
  String _txBinary = 'Awaiting encoding...';
  bool _encryptionOn = false;
  double _volume = 80;
  double _noise = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Text Input + Binary Output
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HoloPanel(
                title: 'Text Input',
                children: [
                  HoloTextField(
                    maxLines: 5,
                    controller: TextEditingController(text: _txText),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      HoloButton(label: 'ENCODE', onPressed: _encodeText),
                      HoloButton(label: 'CLEAR', onPressed: _clearTx),
                      HoloButton(label: 'SAMPLE', onPressed: _loadSample),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: HoloPanel(
                title: 'Binary Output',
                children: [
                  HoloDisplayBox(text: _txBinary),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      HoloButton(label: 'COPY BINARY'),
                      HoloButton(label: 'EXPORT BIN'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // Row 2: Frame Builder + Packet Monitor
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HoloPanel(
                title: 'Frame Builder',
                children: [
                  const HoloDisplayBox(text: 'No frames generated'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      HoloButton(label: 'BUILD FRAMES'),
                      HoloButton(label: 'EXPORT FRAMES'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: HoloPanel(
                title: 'Packet Monitor',
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView(
                      shrinkWrap: true,
                      children: const [
                        _PacketItem(label: 'No packets'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Security Layer
        HoloPanel(
          title: 'Security Layer',
          children: [
            Row(
              children: [
                Expanded(
                  child: HoloToggle(
                    label: 'ENCRYPTION OFF',
                    onChanged: (v) => setState(() => _encryptionOn = v),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: HoloTextField(
                    label: 'Passphrase',
                    hint: 'Enter key...',
                    obscureText: true,
                    enabled: _encryptionOn,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Status',
                        style: TextStyle(
                          fontSize: 11,
                          color: HoloTheme.cyan.withOpacity(0.5),
                          fontFamily: 'Courier',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          border: Border.all(color: HoloTheme.border),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'No key loaded',
                          style: TextStyle(
                            color: HoloTheme.cyan.withOpacity(0.5),
                            fontFamily: 'Courier',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: HoloButton(
                    label: '⬇ DOWNLOAD ENCRYPTED (.ENC)',
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Transmission Controls
        HoloPanel(
          title: 'Transmission Controls',
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDropdown('Modulation', [
                    'Binary FSK',
                    '4-FSK',
                    '8-FSK',
                    'BPSK',
                    'QPSK',
                    'OOK',
                    'MSK',
                    'GMSK',
                  ]),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildDropdown('Sample Rate', [
                    '8000 Hz',
                    '16000 Hz',
                    '22050 Hz',
                    '44100 Hz',
                    '48000 Hz',
                  ]),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: HoloTextField(
                    label: 'Center Freq (Hz)',
                    controller: TextEditingController(text: '1500'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: HoloTextField(
                    label: 'Symbol Rate',
                    controller: TextEditingController(text: '300'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HoloTextField(
                    label: 'Frame Size (bytes)',
                    controller: TextEditingController(text: '32'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: HoloSlider(
                    label: 'Volume',
                    value: _volume / 100,
                    onChanged: (v) => setState(() => _volume = v * 100),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: HoloSlider(
                    label: 'Noise Level',
                    value: _noise / 100,
                    onChanged: (v) => setState(() => _noise = v * 100),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (_) {},
                            fillColor: WidgetStateProperty.all(HoloTheme.cyan),
                          ),
                          const Text(
                            'CRC-16',
                            style: TextStyle(
                              color: HoloTheme.cyan,
                              fontFamily: 'Courier',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (_) {},
                            fillColor: WidgetStateProperty.all(HoloTheme.cyan),
                          ),
                          const Text(
                            'FEC',
                            style: TextStyle(
                              color: HoloTheme.cyan,
                              fontFamily: 'Courier',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              children: [
                HoloButton(label: '▶ TRANSMIT AUDIO', isPrimary: true),
                HoloButton(label: '⬇ GENERATE WAV', isPrimary: true),
                HoloButton(label: 'CONSTELLATION'),
              ],
            ),
          ],
        ),

        // Visualizations
        Row(
          children: [
            Expanded(
              child: HoloPanel(
                title: 'Spectrum Analyzer',
                children: [
                  Container(
                    height: 150,
                    color: Colors.black.withOpacity(0.6),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: SpectrumPainter(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: HoloPanel(
                title: 'Waterfall Display',
                children: [
                  Container(
                    height: 150,
                    color: Colors.black.withOpacity(0.6),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: WaterfallPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: HoloPanel(
                title: 'Oscilloscope',
                children: [
                  Container(
                    height: 150,
                    color: Colors.black.withOpacity(0.6),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: OscilloscopePainter(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: HoloPanel(
                title: 'Bit Stream',
                children: [
                  Container(
                    height: 150,
                    color: Colors.black.withOpacity(0.6),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: BitStreamPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // System Log
        HoloPanel(
          title: 'System Log',
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 150),
              child: ListView(
                shrinkWrap: true,
                children: const [
                  _LogEntry(time: '13:45:01', msg: 'HoloRadio initialized'),
                  _LogEntry(time: '13:45:01', msg: 'System ready • Offline capable'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: HoloTheme.cyan.withOpacity(0.5),
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border.all(color: HoloTheme.border),
            borderRadius: BorderRadius.circular(2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.first,
              isExpanded: true,
              dropdownColor: HoloTheme.bg,
              style: const TextStyle(
                color: HoloTheme.cyan,
                fontFamily: 'Courier',
                fontSize: 13,
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }

  void _encodeText() {
    setState(() {
      _txBinary = '01001000 01100101 01101100 01101100 01101111 ...';
    });
  }

  void _clearTx() {
    setState(() {
      _txText = '';
      _txBinary = 'Awaiting encoding...';
    });
  }

  void _loadSample() {
    setState(() {
      _txText = 'HoloRadio Test Message #42. Signal check. Over.';
    });
  }
}

// ==================== RECEIVER SCREEN ====================
class ReceiverScreen extends StatelessWidget {
  const ReceiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HoloPanel(
                title: 'Signal Input',
                children: [
                  Wrap(
                    spacing: 10,
                    children: [
                      HoloButton(label: '🎤 START MIC', isPrimary: true),
                      HoloButton(label: '📁 LOAD WAV'),
                      HoloButton(label: '🔓 DECODE', isPrimary: true),
                      HoloButton(label: '⬇ DOWNLOAD WAV'),
                      HoloButton(label: '📋 COPY BINARY'),
                      HoloButton(label: '⏹ STOP', isDanger: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'BUFFER:',
                        style: TextStyle(
                          fontSize: 12,
                          color: HoloTheme.cyan.withOpacity(0.5),
                          fontFamily: 'Courier',
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: HoloMeter(value: 0.0, height: 12),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '0.0s',
                        style: TextStyle(
                          fontSize: 12,
                          color: HoloTheme.cyan.withOpacity(0.5),
                          fontFamily: 'Courier',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatusDot(label: 'SYNC', active: false),
                      const SizedBox(width: 15),
                      _StatusDot(label: 'CRC', active: false),
                      const SizedBox(width: 15),
                      _StatusDot(label: 'RECEIVING', active: false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: HoloPanel(
                title: 'Decoded Text',
                children: [
                  const HoloDisplayBox(text: 'Awaiting decode...'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      HoloButton(label: 'COPY TEXT'),
                      HoloButton(label: 'SAVE TXT'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // Decryption Layer
        HoloPanel(
          title: 'Decryption Layer',
          children: [
            Row(
              children: [
                Expanded(
                  child: HoloToggle(label: 'DECRYPTION OFF'),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: HoloTextField(
                    label: 'Passphrase',
                    hint: 'Enter key...',
                    obscureText: true,
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Decryption Status',
                        style: TextStyle(
                          fontSize: 11,
                          color: HoloTheme.cyan.withOpacity(0.5),
                          fontFamily: 'Courier',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          border: Border.all(color: HoloTheme.border),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'No decryption active',
                          style: TextStyle(
                            color: HoloTheme.cyan.withOpacity(0.5),
                            fontFamily: 'Courier',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: HoloButton(
                    label: '🔓 DECRYPT BUFFER',
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: HoloPanel(
                title: 'Binary Input',
                children: [
                  const HoloDisplayBox(text: 'No data received'),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: HoloPanel(
                title: 'Packet Log',
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView(
                      shrinkWrap: true,
                      children: const [
                        _PacketItem(label: 'No packets'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: HoloPanel(
                title: 'Signal Scope',
                children: [
                  Container(
                    height: 150,
                    color: Colors.black.withOpacity(0.6),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: OscilloscopePainter(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: HoloPanel(
                title: 'Constellation',
                children: [
                  Container(
                    height: 150,
                    color: Colors.black.withOpacity(0.6),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: ConstellationPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        HoloPanel(
          title: 'Receiver Log',
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 150),
              child: ListView(
                shrinkWrap: true,
                children: const [
                  _LogEntry(time: '13:45:01', msg: 'Receiver ready'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ==================== SETTINGS SCREEN ====================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HoloPanel(
          title: 'System Configuration',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 200,
                  child: _buildDropdown('Audio Output Device', ['Default']),
                ),
                SizedBox(
                  width: 200,
                  child: HoloSlider(label: 'Input Gain (dB)', value: 0.5),
                ),
                SizedBox(
                  width: 200,
                  child: _buildDropdown('AGC', ['Fast', 'Slow', 'Off']),
                ),
                SizedBox(
                  width: 200,
                  child: HoloTextField(
                    label: 'Squelch (dB)',
                    controller: TextEditingController(text: '-40'),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: HoloTextField(
                    label: 'Preamble Length',
                    controller: TextEditingController(text: '64'),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: HoloTextField(
                    label: 'Postamble Length',
                    controller: TextEditingController(text: '32'),
                  ),
                ),
              ],
            ),
          ],
        ),
        HoloPanel(
          title: 'Encryption Defaults',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 200,
                  child: _buildDropdown('Algorithm', [
                    'AES-GCM-256',
                    'ChaCha20-Poly1305',
                  ]),
                ),
                SizedBox(
                  width: 200,
                  child: _buildDropdown('Key Derivation', [
                    'PBKDF2 (100k iter)',
                    'Argon2id (sim)',
                  ]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: HoloTheme.cyan.withOpacity(0.5),
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border.all(color: HoloTheme.border),
            borderRadius: BorderRadius.circular(2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.first,
              isExpanded: true,
              dropdownColor: HoloTheme.bg,
              style: const TextStyle(
                color: HoloTheme.cyan,
                fontFamily: 'Courier',
                fontSize: 13,
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== ANALYZER SCREEN ====================
class AnalyzerScreen extends StatelessWidget {
  const AnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: HoloPanel(
                title: 'Frequency Domain',
                children: [
                  Container(
                    height: 200,
                    color: Colors.black.withOpacity(0.6),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: SpectrumPainter(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: HoloPanel(
                title: 'Spectrogram',
                children: [
                  Container(
                    height: 200,
                    color: Colors.black.withOpacity(0.6),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: WaterfallPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        HoloPanel(
          title: 'Statistics',
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'SNR', value: '-- dB'),
                _StatItem(label: 'BER', value: '--'),
                _StatItem(label: 'FER', value: '--'),
                _StatItem(label: 'Lock', value: 'UNLOCKED'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ==================== HELPER WIDGETS ====================
class _PacketItem extends StatelessWidget {
  final String label;
  final bool isOk;

  const _PacketItem({
    required this.label,
    this.isOk = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: HoloTheme.cyan.withOpacity(0.1),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isOk ? HoloTheme.green : HoloTheme.red,
          fontFamily: 'Courier',
          fontSize: 12,
        ),
      ),
    );
  }
}

class _LogEntry extends StatelessWidget {
  final String time;
  final String msg;

  const _LogEntry({
    required this.time,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: HoloTheme.cyan.withOpacity(0.05),
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 12,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '[$time] ',
              style: const TextStyle(color: HoloTheme.cyan),
            ),
            TextSpan(
              text: msg,
              style: TextStyle(color: HoloTheme.cyan.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final String label;
  final bool active;

  const _StatusDot({
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? HoloTheme.green : HoloTheme.cyanDim,
            boxShadow: active
                ? [BoxShadow(color: HoloTheme.green, blurRadius: 8)]
                : [BoxShadow(color: HoloTheme.cyanDim, blurRadius: 5)],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: HoloTheme.cyan,
            fontFamily: 'Courier',
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: $value',
      style: const TextStyle(
        color: HoloTheme.cyan,
        fontFamily: 'Courier',
        fontSize: 13,
      ),
    );
  }
}

// ==================== CUSTOM PAINTERS ====================
class SpectrumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HoloTheme.cyan
      ..strokeWidth = 1;

    final random = math.Random(42);
    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x < size.width; x += 2) {
      final y = size.height - (random.nextDouble() * size.height * 0.6);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaterfallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint();

    for (double x = 0; x < size.width; x += 2) {
      final val = random.nextDouble();
      paint.color = HoloTheme.cyan.withOpacity(val * 0.3);
      final barH = val * size.height;
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - barH, 2, barH),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter) => false;
}

class OscilloscopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HoloTheme.green
      ..strokeWidth = 1;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (double x = 0; x < size.width; x++) {
      final y = size.height / 2 +
          math.sin(x * 0.05) * size.height / 3;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BitStreamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = HoloTheme.cyan;

    for (int i = 0; i < size.width / 4; i++) {
      final bit = i % 3 == 0 ? 1 : 0;
      final x = i * 4.0;
      final y = bit == 1 ? 2.0 : size.height / 2 + 2;
      canvas.drawRect(
        Rect.fromLTWH(x, y, 2, size.height / 2 - 4),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConstellationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Grid
    final gridPaint = Paint()
      ..color = HoloTheme.cyan.withOpacity(0.3)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      gridPaint,
    );

    // Points
    final points = [
      [1.0, 1.0],
      [1.0, -1.0],
      [-1.0, 1.0],
      [-1.0, -1.0],
    ];

    final pointPaint = Paint()..color = HoloTheme.green;

    for (final p in points) {
      canvas.drawCircle(
        Offset(
          size.width / 2 + p[0] * 40,
          size.height / 2 - p[1] * 40,
        ),
        6,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
