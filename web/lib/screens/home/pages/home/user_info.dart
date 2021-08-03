import 'package:flutter/material.dart';
import 'package:web/shared/loading.dart';
import 'package:web/screens/home/pages/home/home_page.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final HomePage widget;

  final double _imageHeight = 120;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: _imageHeight,
              width: _imageHeight * (338 / 418),
            ),
            const WaveLoading(size: 30),
            Image.network(
              widget.userData.picUrl,
              height: _imageHeight,
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(left: 20)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.userData.prefix} ${widget.userData.firstname} ${widget.userData.lastname}',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                'เลขประจำตัวนักเรียน: ${widget.userData.sid}',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              Text(
                'ชั้น: ${widget.userData.classroom}',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserInfoMobile extends StatelessWidget {
  const UserInfoMobile({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final HomePage widget;

  final double _imageHeight = 120;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: _imageHeight,
              width: _imageHeight * (338 / 418),
            ),
            const WaveLoading(size: 30),
            Image.network(
              widget.userData.picUrl,
              height: _imageHeight,
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(left: 20)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.userData.prefix} ${widget.userData.firstname} ${widget.userData.lastname}',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                'เลขประจำตัวนักเรียน: ${widget.userData.sid}',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              Text(
                'ชั้น: ${widget.userData.classroom}',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
