import 'package:flutter/material.dart';
import 'package:flat_match/widgets/other_info_item.dart';


class PersonInfo extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PersonInfo({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final String fullName = '${userData["name"]} ${userData["surname"]}';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50, // Adjust the radius as needed
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: NetworkImage(userData["image"]),
                          ),
                        ),
                        Text(
                          fullName,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            OtherInfoItem(
                              icon: Icons.cake,
                              value: userData["age"].toString(),
                            ),
                            OtherInfoItem(
                              icon: Icons.transgender,
                              value: userData["gender"],
                            ),
                            OtherInfoItem(
                              icon: Icons.pets,
                              value: userData["petPreference"],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            userData["description"],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  )
                )
              )
            )
          )
        );
      }
    );
  }
}