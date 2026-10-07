import 'package:flutter/material.dart';

import '../theme.dart';

/// Avatar de usuario: iniciales sobre gradiente cálido, como la web
/// (gradientes wine/sepia/amber/olive) con anillo claro.
class UserAvatar extends StatelessWidget {
  final String username;
  final String? avatar;
  final double size;
  const UserAvatar({
    super.key,
    required this.username,
    this.avatar,
    this.size = 40,
  });

  /// Gradientes de la web (AVATAR_GRADIENTS) aproximados a sRGB.
  static const _grads = [
    [Color(0xFF9E4B45), Color(0xFFA97C52)],
    [Color(0xFF9E4B45), Color(0xFF7E3440)],
    [Color(0xFFE0A34E), Color(0xFF9C6B3A)],
    [Color(0xFF9A9A54), Color(0xFFA97C52)],
    [Color(0xFF9E4B45), Color(0xFF7E3440)],
    [Color(0xFFC99862), Color(0xFFA97C52)],
  ];

  @override
  Widget build(BuildContext context) {
    var hash = 0;
    for (final c in username.codeUnits) {
      hash += c;
    }
    final grad = _grads[hash % _grads.length];
    final initials = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: grad,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: DevColors.white15, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.34,
        ),
      ),
    );
  }
}