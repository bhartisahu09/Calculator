import 'package:flutter/material.dart';
import 'calculator_widget.dart';
import 'age_calculator_widget.dart';
import 'bmi_calculator_widget.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(162, 181, 252, 1)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const CalculatorWidget(),
    const AgeCalculatorWidget(),
    const BMICalculatorWidget(),
  ];

  static final List<String> _titles = [
    'Calculator',
    'Age Calculator',
    'BMI Calculator',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor =  Colors.grey[100];
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: appBarColor,
        centerTitle: true,
        elevation: 0,
      ),
     body: Container(
      color: Colors.white,
      child: SafeArea(
        child: _pages[_selectedIndex],
      ),
    ),
     
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: _AnimatedBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class _AnimatedBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const _AnimatedBottomNavBar({required this.selectedIndex, required this.onItemTapped});

  static const _icons = [
    Icons.calculate_outlined,
    Icons.cake_outlined,
    Icons.monitor_weight_outlined,
  ];
  static const _labels = [
    'Calculator',
    'Age',
    'BMI',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: _BubbleNavBarInner(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
        colorScheme: colorScheme,
      ),
    );
  }
}

class _BubbleNavBarInner extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final ColorScheme colorScheme;
  const _BubbleNavBarInner({required this.selectedIndex, required this.onItemTapped, required this.colorScheme});

  @override
  State<_BubbleNavBarInner> createState() => _BubbleNavBarInnerState();
}

class _BubbleNavBarInnerState extends State<_BubbleNavBarInner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bubbleAnim;
  int _prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _bubbleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void didUpdateWidget(covariant _BubbleNavBarInner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _prevIndex = oldWidget.selectedIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const icons = _AnimatedBottomNavBar._icons;
    const labels = _AnimatedBottomNavBar._labels;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = width / icons.length;
        return Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _bubbleAnim,
              builder: (context, child) {
                final begin = _prevIndex * itemWidth + itemWidth / 2;
                final end = widget.selectedIndex * itemWidth + itemWidth / 2;
                final x = lerpDouble(begin, end, _bubbleAnim.value)!;
                final bubbleSize = lerpDouble(36, 48, _bubbleAnim.value)!;
                return Positioned(
                  left: x - bubbleSize / 2,
                  top: 8,
                  child: SizedBox(
                    width: bubbleSize,
                    height: bubbleSize,
                  ),
                );              
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(icons.length, (i) {
                final isSelected = i == widget.selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onItemTapped(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.25 : 1.0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                            child: Icon(
                              icons[i],
                              color: isSelected
                                  ? widget.colorScheme.primary
                                  : widget.colorScheme.onSurface.withOpacity(0.6),
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 350),
                            style: TextStyle(
                              color: isSelected
                                  ? widget.colorScheme.primary
                                  : widget.colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: isSelected ? 14 : 13,
                            ),
                            child: Text(labels[i]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
