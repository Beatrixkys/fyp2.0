import 'package:flutter/material.dart';

class NavigationButton extends StatefulWidget {
  final Widget widget;
  const NavigationButton({Key? key, required this.widget}) : super(key: key);

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: widget.widget,
    );
  }
}

class ButtonCenterText extends StatelessWidget {
  final String title;
  const ButtonCenterText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  final String title;
  final String route;

  const SmallButton({Key? key, required this.title, required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class ShortcutButton extends StatefulWidget {
  //final Function() onPressed;
  //final String tooltip;
  //final IconData icon;

  const ShortcutButton({
    Key? key,
    //required this.icon,
    //required this.tooltip,
    //required this.onPressed
  }) : super(key: key);

  @override
  State<ShortcutButton> createState() => _ShortcutButtonState();
}

class _ShortcutButtonState extends State<ShortcutButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;

  late AnimationController _animationController = AnimationController(
    vsync: this,
  );

  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: const Color.fromARGB(255, 195, 224, 248),
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return FloatingActionButton(
      heroTag: "b1",
      onPressed: () {
        Navigator.pushNamed(context, "/addfinance");
      },
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }

  Widget edit() {
    return FloatingActionButton(
      heroTag: "b2",
      onPressed: () {
        Navigator.pushNamed(context, "/managefinance");
      },
      tooltip: 'Edit',
      child: const Icon(Icons.edit),
    );
  }

  Widget goals() {
    return FloatingActionButton(
      heroTag: "b3",
      onPressed: () {
        Navigator.pushNamed(context, "/managegoals");
      },
      tooltip: 'Goal',
      child: const Icon(
        Icons.center_focus_weak_outlined,
      ),
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      heroTag: "b4",
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: edit(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: goals(),
        ),
        toggle(),
      ],
    );
  }
}
