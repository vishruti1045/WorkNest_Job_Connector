import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/data_controller.dart';
import '../models/job_model.dart';
import '../routes/named_routes.dart';

class JobListScreen extends StatelessWidget {
  final DataController dataController = Get.put(DataController());

  JobListScreen({super.key});

  Future<List<JobModel>> fetchJobs() async {
  final snapshot = await FirebaseFirestore.instance.collection('jobs').get();
  return snapshot.docs
      .map((doc) => JobModel.fromMap(doc.data(), doc.id))
      .toList();
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<JobModel>>(
      future: fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching jobs.'));
        }

        final jobs = snapshot.data ?? [];

        if (jobs.isEmpty) {
          return const Center(child: Text('No jobs available.'));
        }

        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text(job.title),
                subtitle: Text(job.company),
                trailing: IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {
                    dataController.saveJob(job);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Job saved successfully!")),
                    );
                  },
                ),
                onTap: () {
                  Get.toNamed(NamedRoutes.fullPageJob, arguments: job);
                },
              ),
            );
          },
        );
      },
    );
  }
}
