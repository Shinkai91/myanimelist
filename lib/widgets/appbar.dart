import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DateTime currentTime;

  const CustomAppBar({super.key, required this.currentTime});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 40, 53, 147),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(
          'https://store-images.s-microsoft.com/image/apps.14964.9007199266506523.65c06eb1-33a4-438a-855a-7726d60ec911.21ac20c8-cdd3-447c-94d5-d8cf1eb08650?h=210',
          fit: BoxFit.contain,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${currentTime.day}/${currentTime.month}/${currentTime.year}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}:${currentTime.second.toString().padLeft(2, '0')}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}