import 'package:flutter/widgets.dart';

class RoundedAvatar extends StatelessWidget {
  const RoundedAvatar({
    Key key,
    this.source,
    this.size,
  }) : super(key: key);

  final size;
  final source;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(this.size / 2)),
        child: Image.network(
          this.source,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
