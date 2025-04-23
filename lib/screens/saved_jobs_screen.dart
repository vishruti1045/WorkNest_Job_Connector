import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/dimensions.dart';
import '../routes/named_routes.dart';
import '../controllers/data_controller.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/job_card.dart';
import '../widgets/color_styles.dart';
import '../themes/font_styles.dart';
import '../models/job_model.dart';

class SavedJobsScreen extends StatelessWidget {
  SavedJobsScreen({super.key});

  final DataController controller = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Jobs',
          style: TextStyle(
            color: ColorStyles.darkTitleColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorStyles.pureWhite,
      ),
      body: FutureBuilder<List<JobModel>>(
        future: controller.fetchSavedJobs(),  // Use the renamed method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomProgressIndicator();  // Show loading indicator while fetching
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching saved jobs!'),
            );
          }

          final savedJobs = snapshot.data ?? [];

          if (savedJobs.isEmpty) {
            return const Center(
              child: Text('No saved jobs!'),
            );
          }

          return ListView.builder(
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              final job = savedJobs[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    NamedRoutes.fullPageJob,
                    arguments: job,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: scaleHeight(10, context),
                    horizontal: scaleWidth(12, context),
                  ),
                  child: JobsCard(
                    dataModel: job,
                    color: index % 2 == 0
                        ? ColorStyles.c5386E4
                        : const Color(0xFF3A5C99),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
