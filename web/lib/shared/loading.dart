import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'folding_cube.dart';

class FoldingCubeLoading extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final double size;
  const FoldingCubeLoading({
    Key? key,
    this.backgroundColor = Colors.white,
    this.color = const Color(0xff7367F0),
    this.size = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: FoldingCube(
          color: color,
          size: size,
        ),
      ),
    );
  }
}

class WaveLoading extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final double size;
  const WaveLoading({
    Key? key,
    this.backgroundColor = Colors.white,
    this.color = const Color(0xff7367F0),
    this.size = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SpinKitWave(
          color: color,
          size: size,
        ),
      ),
    );
  }
}
