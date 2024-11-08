// ignore_for_file: cascade_invocations

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    this.color = Colors.white,
    this.size = 14,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _LogoPainter(color: color),
        size: Size(7 * size, 2 * size),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty("color", color))
      ..add(DoubleProperty("size", size));
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path_0 = Path()
      ..moveTo(size.width * 0.6732086, size.height * 0.4446980)
      ..lineTo(size.width * 0.6732086, size.height * 0.2935840)
      ..lineTo(size.width * 0.6527143, size.height * 0.2935840)
      ..lineTo(size.width * 0.6527143, size.height * 0.1904750)
      ..lineTo(size.width * 0.6635657, size.height * 0.1904750)
      ..cubicTo(
        size.width * 0.6724057,
        size.height * 0.1904750,
        size.width * 0.6768257,
        size.height * 0.1751440,
        size.width * 0.6768257,
        size.height * 0.1424710,
      )
      ..lineTo(size.width * 0.6768257, size.height * 0.06895690)
      ..lineTo(size.width * 0.7057600, size.height * 0.06895690)
      ..lineTo(size.width * 0.7057600, size.height * 0.1904750)
      ..lineTo(size.width * 0.7322829, size.height * 0.1904750)
      ..lineTo(size.width * 0.7322829, size.height * 0.2935840)
      ..lineTo(size.width * 0.7057600, size.height * 0.2935840)
      ..lineTo(size.width * 0.7057600, size.height * 0.4283610)
      ..cubicTo(
        size.width * 0.7057600,
        size.height * 0.4463310,
        size.width * 0.7071257,
        size.height * 0.4604900,
        size.width * 0.7098600,
        size.height * 0.4708360,
      )
      ..cubicTo(
        size.width * 0.7127514,
        size.height * 0.4806380,
        size.width * 0.7166114,
        size.height * 0.4855390,
        size.width * 0.7214314,
        size.height * 0.4855390,
      )
      ..cubicTo(
        size.width * 0.7248086,
        size.height * 0.4855390,
        size.width * 0.7279429,
        size.height * 0.4841780,
        size.width * 0.7308371,
        size.height * 0.4814550,
      )
      ..cubicTo(
        size.width * 0.7318000,
        size.height * 0.4809100,
        size.width * 0.7330857,
        size.height * 0.4795490,
        size.width * 0.7346943,
        size.height * 0.4773710,
      )
      ..lineTo(size.width * 0.7346943, size.height * 0.5794740)
      ..cubicTo(
        size.width * 0.7340514,
        size.height * 0.5805630,
        size.width * 0.7330057,
        size.height * 0.5819250,
        size.width * 0.7315600,
        size.height * 0.5835580,
      )
      ..cubicTo(
        size.width * 0.7301143,
        size.height * 0.5846470,
        size.width * 0.7290686,
        size.height * 0.5854640,
        size.width * 0.7284257,
        size.height * 0.5860090,
      )
      ..cubicTo(
        size.width * 0.7239229,
        size.height * 0.5898210,
        size.width * 0.7187800,
        size.height * 0.5917270,
        size.width * 0.7129943,
        size.height * 0.5917270,
      )
      ..cubicTo(
        size.width * 0.7007771,
        size.height * 0.5917270,
        size.width * 0.6910514,
        size.height * 0.5789300,
        size.width * 0.6838171,
        size.height * 0.5533360,
      )
      ..cubicTo(
        size.width * 0.6767457,
        size.height * 0.5277420,
        size.width * 0.6732086,
        size.height * 0.4915290,
        size.width * 0.6732086,
        size.height * 0.4446980,
      )
      ..close();

    final Paint paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawPath(path_0, paint0Fill);

    final Path path_1 = Path();
    path_1.moveTo(size.width * 0.6270000, size.height * 0.5730580);
    path_1.cubicTo(
      size.width * 0.6233029,
      size.height * 0.5605330,
      size.width * 0.6214543,
      size.height * 0.5450140,
      size.width * 0.6214543,
      size.height * 0.5264990,
    );
    path_1.cubicTo(
      size.width * 0.6214543,
      size.height * 0.5079840,
      size.width * 0.6233029,
      size.height * 0.4924640,
      size.width * 0.6270000,
      size.height * 0.4799400,
    );
    path_1.cubicTo(
      size.width * 0.6306971,
      size.height * 0.4674150,
      size.width * 0.6352771,
      size.height * 0.4611530,
      size.width * 0.6407429,
      size.height * 0.4611530,
    );
    path_1.cubicTo(
      size.width * 0.6462086,
      size.height * 0.4611530,
      size.width * 0.6507886,
      size.height * 0.4674150,
      size.width * 0.6544857,
      size.height * 0.4799400,
    );
    path_1.cubicTo(
      size.width * 0.6581829,
      size.height * 0.4924640,
      size.width * 0.6600314,
      size.height * 0.5079840,
      size.width * 0.6600314,
      size.height * 0.5264990,
    );
    path_1.cubicTo(
      size.width * 0.6600314,
      size.height * 0.5450140,
      size.width * 0.6581829,
      size.height * 0.5605330,
      size.width * 0.6544857,
      size.height * 0.5730580,
    );
    path_1.cubicTo(
      size.width * 0.6507886,
      size.height * 0.5855830,
      size.width * 0.6462086,
      size.height * 0.5918450,
      size.width * 0.6407429,
      size.height * 0.5918450,
    );
    path_1.cubicTo(
      size.width * 0.6352771,
      size.height * 0.5918450,
      size.width * 0.6306971,
      size.height * 0.5855830,
      size.width * 0.6270000,
      size.height * 0.5730580,
    );
    path_1.close();

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);

    final Path path_2 = Path();
    path_2.moveTo(size.width * 0.4224400, size.height * 0.5835590);
    path_2.lineTo(size.width * 0.4224400, size.height * 0.1833140);
    path_2.lineTo(size.width * 0.4549914, size.height * 0.1833140);
    path_2.lineTo(size.width * 0.4549914, size.height * 0.2404920);
    path_2.lineTo(size.width * 0.4561971, size.height * 0.2404920);
    path_2.cubicTo(
      size.width * 0.4584486,
      size.height * 0.2279670,
      size.width * 0.4610200,
      size.height * 0.2170760,
      size.width * 0.4639114,
      size.height * 0.2078190,
    );
    path_2.cubicTo(
      size.width * 0.4713057,
      size.height * 0.1860370,
      size.width * 0.4795857,
      size.height * 0.1751460,
      size.width * 0.4887486,
      size.height * 0.1751460,
    );
    path_2.cubicTo(
      size.width * 0.4991971,
      size.height * 0.1751460,
      size.width * 0.5081971,
      size.height * 0.1868540,
      size.width * 0.5157543,
      size.height * 0.2102690,
    );
    path_2.cubicTo(
      size.width * 0.5189686,
      size.height * 0.2200710,
      size.width * 0.5216200,
      size.height * 0.2315070,
      size.width * 0.5237086,
      size.height * 0.2445760,
    );
    path_2.lineTo(size.width * 0.5249143, size.height * 0.2445760);
    path_2.cubicTo(
      size.width * 0.5274886,
      size.height * 0.2320510,
      size.width * 0.5307829,
      size.height * 0.2206160,
      size.width * 0.5348000,
      size.height * 0.2102690,
    );
    path_2.cubicTo(
      size.width * 0.5436429,
      size.height * 0.1868540,
      size.width * 0.5532057,
      size.height * 0.1751460,
      size.width * 0.5634943,
      size.height * 0.1751460,
    );
    path_2.cubicTo(
      size.width * 0.5753886,
      size.height * 0.1751460,
      size.width * 0.5851943,
      size.height * 0.1898490,
      size.width * 0.5929114,
      size.height * 0.2192540,
    );
    path_2.cubicTo(
      size.width * 0.6006257,
      size.height * 0.2481160,
      size.width * 0.6044857,
      size.height * 0.2865070,
      size.width * 0.6044857,
      size.height * 0.3344270,
    );
    path_2.lineTo(size.width * 0.6044857, size.height * 0.5835590);
    path_2.lineTo(size.width * 0.5719343, size.height * 0.5835590);
    path_2.lineTo(size.width * 0.5719343, size.height * 0.3507640);
    path_2.cubicTo(
      size.width * 0.5719343,
      size.height * 0.3044770,
      size.width * 0.5655029,
      size.height * 0.2813330,
      size.width * 0.5526429,
      size.height * 0.2813330,
    );
    path_2.cubicTo(
      size.width * 0.5458914,
      size.height * 0.2813330,
      size.width * 0.5403457,
      size.height * 0.2889570,
      size.width * 0.5360057,
      size.height * 0.3042040,
    );
    path_2.cubicTo(
      size.width * 0.5318286,
      size.height * 0.3189070,
      size.width * 0.5297371,
      size.height * 0.3385110,
      size.width * 0.5297371,
      size.height * 0.3630160,
    );
    path_2.lineTo(size.width * 0.5297371, size.height * 0.5835590);
    path_2.lineTo(size.width * 0.4971857, size.height * 0.5835590);
    path_2.lineTo(size.width * 0.4971857, size.height * 0.3507640);
    path_2.cubicTo(
      size.width * 0.4971857,
      size.height * 0.3044770,
      size.width * 0.4907571,
      size.height * 0.2813330,
      size.width * 0.4778971,
      size.height * 0.2813330,
    );
    path_2.cubicTo(
      size.width * 0.4711457,
      size.height * 0.2813330,
      size.width * 0.4656000,
      size.height * 0.2889570,
      size.width * 0.4612600,
      size.height * 0.3042040,
    );
    path_2.cubicTo(
      size.width * 0.4570800,
      size.height * 0.3189070,
      size.width * 0.4549914,
      size.height * 0.3385110,
      size.width * 0.4549914,
      size.height * 0.3630160,
    );
    path_2.lineTo(size.width * 0.4549914, size.height * 0.5835590);
    path_2.lineTo(size.width * 0.4224400, size.height * 0.5835590);
    path_2.close();

    final Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = color;
    canvas.drawPath(path_2, paint2Fill);

    final Path path_3 = Path();
    path_3.moveTo(size.width * 0.3238457, size.height * 0.4596930);
    path_3.cubicTo(
      size.width * 0.3296314,
      size.height * 0.4798420,
      size.width * 0.3367857,
      size.height * 0.4899160,
      size.width * 0.3453029,
      size.height * 0.4899160,
    );
    path_3.cubicTo(
      size.width * 0.3538229,
      size.height * 0.4899160,
      size.width * 0.3609771,
      size.height * 0.4798420,
      size.width * 0.3667629,
      size.height * 0.4596930,
    );
    path_3.cubicTo(
      size.width * 0.3725514,
      size.height * 0.4395450,
      size.width * 0.3754429,
      size.height * 0.4142230,
      size.width * 0.3754429,
      size.height * 0.3837280,
    );
    path_3.cubicTo(
      size.width * 0.3754429,
      size.height * 0.3532330,
      size.width * 0.3725514,
      size.height * 0.3279120,
      size.width * 0.3667629,
      size.height * 0.3077630,
    );
    path_3.cubicTo(
      size.width * 0.3609771,
      size.height * 0.2876150,
      size.width * 0.3538229,
      size.height * 0.2775410,
      size.width * 0.3453029,
      size.height * 0.2775410,
    );
    path_3.cubicTo(
      size.width * 0.3367857,
      size.height * 0.2775410,
      size.width * 0.3296314,
      size.height * 0.2876150,
      size.width * 0.3238457,
      size.height * 0.3077630,
    );
    path_3.cubicTo(
      size.width * 0.3180571,
      size.height * 0.3279120,
      size.width * 0.3151629,
      size.height * 0.3532330,
      size.width * 0.3151629,
      size.height * 0.3837280,
    );
    path_3.cubicTo(
      size.width * 0.3151629,
      size.height * 0.4142230,
      size.width * 0.3180571,
      size.height * 0.4395450,
      size.width * 0.3238457,
      size.height * 0.4596930,
    );
    path_3.close();
    path_3.moveTo(size.width * 0.3009371, size.height * 0.5307570);
    path_3.cubicTo(
      size.width * 0.2887229,
      size.height * 0.4899160,
      size.width * 0.2826134,
      size.height * 0.4409060,
      size.width * 0.2826134,
      size.height * 0.3837280,
    );
    path_3.cubicTo(
      size.width * 0.2826134,
      size.height * 0.3265500,
      size.width * 0.2887229,
      size.height * 0.2775410,
      size.width * 0.3009371,
      size.height * 0.2366990,
    );
    path_3.cubicTo(
      size.width * 0.3131543,
      size.height * 0.1958580,
      size.width * 0.3279429,
      size.height * 0.1754370,
      size.width * 0.3453029,
      size.height * 0.1754370,
    );
    path_3.cubicTo(
      size.width * 0.3626657,
      size.height * 0.1754370,
      size.width * 0.3774543,
      size.height * 0.1958580,
      size.width * 0.3896686,
      size.height * 0.2366990,
    );
    path_3.cubicTo(
      size.width * 0.4018857,
      size.height * 0.2775410,
      size.width * 0.4079943,
      size.height * 0.3265500,
      size.width * 0.4079943,
      size.height * 0.3837280,
    );
    path_3.cubicTo(
      size.width * 0.4079943,
      size.height * 0.4409060,
      size.width * 0.4018857,
      size.height * 0.4899160,
      size.width * 0.3896686,
      size.height * 0.5307570,
    );
    path_3.cubicTo(
      size.width * 0.3774543,
      size.height * 0.5715980,
      size.width * 0.3626657,
      size.height * 0.5920190,
      size.width * 0.3453029,
      size.height * 0.5920190,
    );
    path_3.cubicTo(
      size.width * 0.3279429,
      size.height * 0.5920190,
      size.width * 0.3131543,
      size.height * 0.5715980,
      size.width * 0.3009371,
      size.height * 0.5307570,
    );
    path_3.close();

    final Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = color;
    canvas.drawPath(path_3, paint3Fill);

    final Path path_4 = Path();
    path_4.moveTo(size.width * 0.2345246, size.height * 0.5843080);
    path_4.lineTo(size.width * 0.2345246, size.height * 0.01252880);
    path_4.lineTo(size.width * 0.2670757, size.height * 0.01252880);
    path_4.lineTo(size.width * 0.2670757, size.height * 0.5843080);
    path_4.lineTo(size.width * 0.2345246, size.height * 0.5843080);
    path_4.close();

    final Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = color;
    canvas.drawPath(path_4, paint4Fill);

    final Path path_5 = Path();
    path_5.moveTo(size.width * 0.1810897, size.height * 0.5838510);
    path_5.lineTo(size.width * 0.1810897, size.height * 0.5348410);
    path_5.lineTo(size.width * 0.1798840, size.height * 0.5348410);
    path_5.cubicTo(
      size.width * 0.1769909,
      size.height * 0.5468210,
      size.width * 0.1740169,
      size.height * 0.5563510,
      size.width * 0.1709629,
      size.height * 0.5634300,
    );
    path_5.cubicTo(
      size.width * 0.1638900,
      size.height * 0.5824890,
      size.width * 0.1552097,
      size.height * 0.5920190,
      size.width * 0.1449220,
      size.height * 0.5920190,
    );
    path_5.cubicTo(
      size.width * 0.1341520,
      size.height * 0.5920190,
      size.width * 0.1253914,
      size.height * 0.5814000,
      size.width * 0.1186403,
      size.height * 0.5601630,
    );
    path_5.cubicTo(
      size.width * 0.1120497,
      size.height * 0.5383810,
      size.width * 0.1087543,
      size.height * 0.5108810,
      size.width * 0.1087543,
      size.height * 0.4776630,
    );
    path_5.cubicTo(
      size.width * 0.1087543,
      size.height * 0.4449900,
      size.width * 0.1118086,
      size.height * 0.4172180,
      size.width * 0.1179169,
      size.height * 0.3943470,
    );
    path_5.cubicTo(
      size.width * 0.1241860,
      size.height * 0.3709310,
      size.width * 0.1327857,
      size.height * 0.3559560,
      size.width * 0.1437166,
      size.height * 0.3494210,
    );
    path_5.lineTo(size.width * 0.1810897, size.height * 0.3265500);
    path_5.cubicTo(
      size.width * 0.1804469,
      size.height * 0.3113030,
      size.width * 0.1783571,
      size.height * 0.2987780,
      size.width * 0.1748206,
      size.height * 0.2889760,
    );
    path_5.cubicTo(
      size.width * 0.1712843,
      size.height * 0.2786300,
      size.width * 0.1665423,
      size.height * 0.2734560,
      size.width * 0.1605946,
      size.height * 0.2734560,
    );
    path_5.cubicTo(
      size.width * 0.1532003,
      size.height * 0.2734560,
      size.width * 0.1466903,
      size.height * 0.2810800,
      size.width * 0.1410643,
      size.height * 0.2963280,
    );
    path_5.cubicTo(
      size.width * 0.1381709,
      size.height * 0.3034070,
      size.width * 0.1358400,
      size.height * 0.3107580,
      size.width * 0.1340717,
      size.height * 0.3183820,
    );
    path_5.lineTo(size.width * 0.1147823, size.height * 0.2530360);
    path_5.cubicTo(
      size.width * 0.1183189,
      size.height * 0.2383330,
      size.width * 0.1224177,
      size.height * 0.2255360,
      size.width * 0.1270794,
      size.height * 0.2146450,
    );
    path_5.cubicTo(
      size.width * 0.1383314,
      size.height * 0.1885060,
      size.width * 0.1503071,
      size.height * 0.1754370,
      size.width * 0.1630060,
      size.height * 0.1754370,
    );
    path_5.cubicTo(
      size.width * 0.1777946,
      size.height * 0.1754370,
      size.width * 0.1899306,
      size.height * 0.1906850,
      size.width * 0.1994146,
      size.height * 0.2211790,
    );
    path_5.cubicTo(
      size.width * 0.2088986,
      size.height * 0.2516740,
      size.width * 0.2136406,
      size.height * 0.2895210,
      size.width * 0.2136406,
      size.height * 0.3347180,
    );
    path_5.lineTo(size.width * 0.2136406, size.height * 0.5838510);
    path_5.lineTo(size.width * 0.1810897, size.height * 0.5838510);
    path_5.close();
    path_5.moveTo(size.width * 0.1810897, size.height * 0.4123170);
    path_5.lineTo(size.width * 0.1810897, size.height * 0.4041490);
    path_5.lineTo(size.width * 0.1545669, size.height * 0.4204850);
    path_5.cubicTo(
      size.width * 0.1457257,
      size.height * 0.4264750,
      size.width * 0.1413051,
      size.height * 0.4400890,
      size.width * 0.1413051,
      size.height * 0.4613270,
    );
    path_5.cubicTo(
      size.width * 0.1413051,
      size.height * 0.4885540,
      size.width * 0.1461277,
      size.height * 0.5021680,
      size.width * 0.1557723,
      size.height * 0.5021680,
    );
    path_5.cubicTo(
      size.width * 0.1630060,
      size.height * 0.5021680,
      size.width * 0.1690337,
      size.height * 0.4937280,
      size.width * 0.1738563,
      size.height * 0.4768460,
    );
    path_5.cubicTo(
      size.width * 0.1786786,
      size.height * 0.4599650,
      size.width * 0.1810897,
      size.height * 0.4384560,
      size.width * 0.1810897,
      size.height * 0.4123170,
    );
    path_5.close();

    final Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = color;
    canvas.drawPath(path_5, paint5Fill);

    final Path path_6 = Path();
    path_6.moveTo(0, size.height * 0.5182130);
    path_6.lineTo(size.width * 0.01928943, size.height * 0.4487830);
    path_6.cubicTo(
      size.width * 0.02137911,
      size.height * 0.4569510,
      size.width * 0.02419214,
      size.height * 0.4645750,
      size.width * 0.02772854,
      size.height * 0.4716540,
    );
    path_6.cubicTo(
      size.width * 0.03431914,
      size.height * 0.4863570,
      size.width * 0.04195457,
      size.height * 0.4937080,
      size.width * 0.05063486,
      size.height * 0.4937080,
    );
    path_6.cubicTo(
      size.width * 0.06027943,
      size.height * 0.4937080,
      size.width * 0.06510171,
      size.height * 0.4841790,
      size.width * 0.06510171,
      size.height * 0.4651190,
    );
    path_6.cubicTo(
      size.width * 0.06510171,
      size.height * 0.4558620,
      size.width * 0.06196743,
      size.height * 0.4468770,
      size.width * 0.05569829,
      size.height * 0.4381640,
    );
    path_6.cubicTo(
      size.width * 0.04942914,
      size.height * 0.4294510,
      size.width * 0.04251714,
      size.height * 0.4212830,
      size.width * 0.03496200,
      size.height * 0.4136590,
    );
    path_6.cubicTo(
      size.width * 0.02740706,
      size.height * 0.4060360,
      size.width * 0.02049503,
      size.height * 0.3921500,
      size.width * 0.01422594,
      size.height * 0.3720010,
    );
    path_6.cubicTo(
      size.width * 0.007956886,
      size.height * 0.3518530,
      size.width * 0.004822343,
      size.height * 0.3270760,
      size.width * 0.004822343,
      size.height * 0.2976700,
    );
    path_6.cubicTo(
      size.width * 0.004822343,
      size.height * 0.2633630,
      size.width * 0.009001743,
      size.height * 0.2345020,
      size.width * 0.01736049,
      size.height * 0.2110860,
    );
    path_6.cubicTo(
      size.width * 0.02587997,
      size.height * 0.1871260,
      size.width * 0.03737314,
      size.height * 0.1751460,
      size.width * 0.05184029,
      size.height * 0.1751460,
    );
    path_6.cubicTo(
      size.width * 0.06437857,
      size.height * 0.1751460,
      size.width * 0.07579143,
      size.height * 0.1854920,
      size.width * 0.08607914,
      size.height * 0.2061850,
    );
    path_6.cubicTo(
      size.width * 0.09025857,
      size.height * 0.2143530,
      size.width * 0.09411629,
      size.height * 0.2244280,
      size.width * 0.09765286,
      size.height * 0.2364080,
    );
    path_6.lineTo(size.width * 0.07836343, size.height * 0.3058380);
    path_6.cubicTo(
      size.width * 0.07627371,
      size.height * 0.2998480,
      size.width * 0.07394286,
      size.height * 0.2944030,
      size.width * 0.07137086,
      size.height * 0.2895020,
    );
    path_6.cubicTo(
      size.width * 0.06574486,
      size.height * 0.2786110,
      size.width * 0.05923457,
      size.height * 0.2731650,
      size.width * 0.05184029,
      size.height * 0.2731650,
    );
    path_6.cubicTo(
      size.width * 0.04782171,
      size.height * 0.2731650,
      size.width * 0.04476743,
      size.height * 0.2756160,
      size.width * 0.04267800,
      size.height * 0.2805160,
    );
    path_6.cubicTo(
      size.width * 0.04074886,
      size.height * 0.2854170,
      size.width * 0.03978457,
      size.height * 0.2911350,
      size.width * 0.03978457,
      size.height * 0.2976700,
    );
    path_6.cubicTo(
      size.width * 0.03978457,
      size.height * 0.3069270,
      size.width * 0.04291886,
      size.height * 0.3159120,
      size.width * 0.04918800,
      size.height * 0.3246250,
    );
    path_6.cubicTo(
      size.width * 0.05545714,
      size.height * 0.3333380,
      size.width * 0.06236914,
      size.height * 0.3415060,
      size.width * 0.06992429,
      size.height * 0.3491300,
    );
    path_6.cubicTo(
      size.width * 0.07747914,
      size.height * 0.3567540,
      size.width * 0.08439114,
      size.height * 0.3706400,
      size.width * 0.09066029,
      size.height * 0.3907880,
    );
    path_6.cubicTo(
      size.width * 0.09692943,
      size.height * 0.4109370,
      size.width * 0.1000640,
      size.height * 0.4357140,
      size.width * 0.1000640,
      size.height * 0.4651190,
    );
    path_6.cubicTo(
      size.width * 0.1000640,
      size.height * 0.5010600,
      size.width * 0.09572371,
      size.height * 0.5312830,
      size.width * 0.08704343,
      size.height * 0.5557870,
    );
    path_6.cubicTo(
      size.width * 0.07836343,
      size.height * 0.5797480,
      size.width * 0.06622714,
      size.height * 0.5917280,
      size.width * 0.05063486,
      size.height * 0.5917280,
    );
    path_6.cubicTo(
      size.width * 0.03681057,
      size.height * 0.5917280,
      size.width * 0.02427254,
      size.height * 0.5794750,
      size.width * 0.01302037,
      size.height * 0.5549700,
    );
    path_6.cubicTo(
      size.width * 0.008037257,
      size.height * 0.5446240,
      size.width * 0.003697143,
      size.height * 0.5323720,
      0,
      size.height * 0.5182130,
    );
    path_6.close();

    final Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = color;
    canvas.drawPath(path_6, paint6Fill);

    final Path path_7 = Path();
    path_7.moveTo(size.width * 0.7353000, size.height * 0.1904770);
    path_7.lineTo(size.width * 0.7791086, size.height * 0.5835610);
    path_7.lineTo(size.width * 0.8152771, size.height * 0.5835610);
    path_7.lineTo(size.width * 0.8590857, size.height * 0.1904770);
    path_7.lineTo(size.width * 0.8241971, size.height * 0.1904770);
    path_7.lineTo(size.width * 0.7976743, size.height * 0.4528690);
    path_7.lineTo(size.width * 0.7967114, size.height * 0.4528690);
    path_7.lineTo(size.width * 0.7701886, size.height * 0.1904770);
    path_7.lineTo(size.width * 0.7353000, size.height * 0.1904770);
    path_7.close();

    final Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = color;
    canvas.drawPath(path_7, paint7Fill);

    final Path path_8 = Path();
    path_8.moveTo(size.width * 0.9914857, size.height * 0.008916940);
    path_8.cubicTo(
      size.width * 0.9861571,
      size.height * -0.002135750,
      size.width * 0.9796543,
      size.height * -0.002962820,
      size.width * 0.9740914,
      size.height * 0.006711420,
    );
    path_8.lineTo(size.width * 0.8924086, size.height * 0.1486420);
    path_8.cubicTo(
      size.width * 0.8853857,
      size.height * 0.1608480,
      size.width * 0.8810200,
      size.height * 0.1850330,
      size.width * 0.8810200,
      size.height * 0.2117500,
    );
    path_8.lineTo(size.width * 0.8810200, size.height * 0.5759630);
    path_8.lineTo(size.width * 0.8778543, size.height * 0.5815520);
    path_8.cubicTo(
      size.width * 0.8693829,
      size.height * 0.5964890,
      size.width * 0.8641171,
      size.height * 0.6258380,
      size.width * 0.8641171,
      size.height * 0.6581940,
    );
    path_8.lineTo(size.width * 0.8641171, size.height * 0.9256390);
    path_8.cubicTo(
      size.width * 0.8641171,
      size.height * 0.9518040,
      size.width * 0.8680600,
      size.height * 0.9755390,
      size.width * 0.8746657,
      size.height * 0.9891230,
    );
    path_8.cubicTo(
      size.width * 0.8781800,
      size.height * 0.9963660,
      size.width * 0.8821029,
      size.height,
      size.width * 0.8860371,
      size.height,
    );
    path_8.cubicTo(
      size.width * 0.8894914,
      size.height,
      size.width * 0.8929543,
      size.height * 0.9971930,
      size.width * 0.8961571,
      size.height * 0.9915540,
    );
    path_8.lineTo(size.width * 0.9633057, size.height * 0.8733580);
    path_8.cubicTo(
      size.width * 0.9723829,
      size.height * 0.8573930,
      size.width * 0.9780200,
      size.height * 0.8259390,
      size.width * 0.9780200,
      size.height * 0.7912770,
    );
    path_8.lineTo(size.width * 0.9780200, size.height * 0.4862630);
    path_8.cubicTo(
      size.width * 0.9808686,
      size.height * 0.4813260,
      size.width * 0.9836286,
      size.height * 0.4765390,
      size.width * 0.9862543,
      size.height * 0.4719520,
    );
    path_8.cubicTo(
      size.width * 0.9947314,
      size.height * 0.4571650,
      size.width,
      size.height * 0.4278420,
      size.width,
      size.height * 0.3954350,
    );
    path_8.lineTo(size.width, size.height * 0.06032070);
    path_8.cubicTo(
      size.width,
      size.height * 0.03916770,
      size.width * 0.9968200,
      size.height * 0.01994460,
      size.width * 0.9914857,
      size.height * 0.008916940,
    );
    path_8.close();
    path_8.moveTo(size.width * 0.9662057, size.height * 0.7912770);
    path_8.cubicTo(
      size.width * 0.9662057,
      size.height * 0.8109260,
      size.width * 0.9630086,
      size.height * 0.8287960,
      size.width * 0.9578514,
      size.height * 0.8378440,
    );
    path_8.lineTo(size.width * 0.8907057, size.height * 0.9560400);
    path_8.cubicTo(
      size.width * 0.8875029,
      size.height * 0.9616790,
      size.width * 0.8838857,
      size.height * 0.9612780,
      size.width * 0.8808000,
      size.height * 0.9549120,
    );
    path_8.cubicTo(
      size.width * 0.8777057,
      size.height * 0.9485710,
      size.width * 0.8759314,
      size.height * 0.9378940,
      size.width * 0.8759314,
      size.height * 0.9256390,
    );
    path_8.lineTo(size.width * 0.8759314, size.height * 0.6581940);
    path_8.cubicTo(
      size.width * 0.8759314,
      size.height * 0.6439080,
      size.width * 0.8778486,
      size.height * 0.6307000,
      size.width * 0.8810571,
      size.height * 0.6220030,
    );
    path_8.cubicTo(
      size.width * 0.8817543,
      size.height * 0.6201230,
      size.width * 0.8825000,
      size.height * 0.6184690,
      size.width * 0.8833086,
      size.height * 0.6170410,
    );
    path_8.lineTo(size.width * 0.9536714, size.height * 0.4930550);
    path_8.lineTo(size.width * 0.9639200, size.height * 0.4752350);
    path_8.cubicTo(
      size.width * 0.9640457,
      size.height * 0.4750100,
      size.width * 0.9641629,
      size.height * 0.4747840,
      size.width * 0.9642800,
      size.height * 0.4745340,
    );
    path_8.lineTo(size.width * 0.9655400, size.height * 0.4723780);
    path_8.cubicTo(
      size.width * 0.9656143,
      size.height * 0.4722780,
      size.width * 0.9656800,
      size.height * 0.4721780,
      size.width * 0.9657457,
      size.height * 0.4720520,
    );
    path_8.lineTo(size.width * 0.9662057, size.height * 0.4712500);
    path_8.lineTo(size.width * 0.9662057, size.height * 0.7912770);
    path_8.close();
    path_8.moveTo(size.width * 0.9881857, size.height * 0.3954350);
    path_8.cubicTo(
      size.width * 0.9881857,
      size.height * 0.4127790,
      size.width * 0.9853743,
      size.height * 0.4284930,
      size.width * 0.9808457,
      size.height * 0.4363880,
    );
    path_8.cubicTo(
      size.width * 0.9799200,
      size.height * 0.4380170,
      size.width * 0.9789743,
      size.height * 0.4396460,
      size.width * 0.9780200,
      size.height * 0.4413250,
    );
    path_8.cubicTo(
      size.width * 0.9780714,
      size.height * 0.4412500,
      size.width * 0.9780200,
      size.height * 0.4391950,
      size.width * 0.9780200,
      size.height * 0.4389940,
    );
    path_8.cubicTo(
      size.width * 0.9780200,
      size.height * 0.4374410,
      size.width * 0.9780057,
      size.height * 0.4358870,
      size.width * 0.9780057,
      size.height * 0.4343330,
    );
    path_8.cubicTo(
      size.width * 0.9780057,
      size.height * 0.4295960,
      size.width * 0.9782857,
      size.height * 0.4249340,
      size.width * 0.9783000,
      size.height * 0.4201720,
    );
    path_8.cubicTo(
      size.width * 0.9783229,
      size.height * 0.4117260,
      size.width * 0.9777543,
      size.height * 0.4032800,
      size.width * 0.9765629,
      size.height * 0.3958610,
    );
    path_8.cubicTo(
      size.width * 0.9754829,
      size.height * 0.3891450,
      size.width * 0.9739429,
      size.height * 0.3833050,
      size.width * 0.9721000,
      size.height * 0.3788690,
    );
    path_8.lineTo(size.width * 0.9605457, size.height * 0.3511740);
    path_8.cubicTo(
      size.width * 0.9604714,
      size.height * 0.3509740,
      size.width * 0.9604057,
      size.height * 0.3507990,
      size.width * 0.9603314,
      size.height * 0.3506480,
    );
    path_8.lineTo(size.width * 0.9069314, size.height * 0.2236300);
    path_8.lineTo(size.width * 0.9068714, size.height * 0.2234800);
    path_8.cubicTo(
      size.width * 0.9031343,
      size.height * 0.2133040,
      size.width * 0.9008057,
      size.height * 0.2037800,
      size.width * 0.9012486,
      size.height * 0.1927530,
    );
    path_8.cubicTo(
      size.width * 0.9017143,
      size.height * 0.1810730,
      size.width * 0.9031857,
      size.height * 0.1754090,
      size.width * 0.9065371,
      size.height * 0.1690680,
    );
    path_8.lineTo(size.width * 0.9794857, size.height * 0.04232560);
    path_8.cubicTo(
      size.width * 0.9804543,
      size.height * 0.04062140,
      size.width * 0.9813800,
      size.height * 0.04001990,
      size.width * 0.9821914,
      size.height * 0.04001990,
    );
    path_8.cubicTo(
      size.width * 0.9836429,
      size.height * 0.04001990,
      size.width * 0.9847829,
      size.height * 0.04192460,
      size.width * 0.9853286,
      size.height * 0.04305250,
    );
    path_8.cubicTo(
      size.width * 0.9861886,
      size.height * 0.04483190,
      size.width * 0.9881857,
      size.height * 0.05007000,
      size.width * 0.9881857,
      size.height * 0.06032070,
    );
    path_8.lineTo(size.width * 0.9881857, size.height * 0.3954350);
    path_8.close();

    final Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = color;
    canvas.drawPath(path_8, paint8Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
