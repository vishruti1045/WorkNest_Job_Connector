import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job_model.dart';

class DataController extends GetxController {
  var savedJobs = <JobModel>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch the saved jobs for the current user
  Future<List<JobModel>> fetchSavedJobs() async {  // Renamed to fetchSavedJobs
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('savedJobs')
            .get();

        // Check if any documents were found, and if so, map them to JobModel
        if (snapshot.docs.isNotEmpty) {
          savedJobs.value = snapshot.docs
              .map((doc) => JobModel.fromMap(doc.data(), doc.id))
              .toList();
          return savedJobs;  // Return the list of saved jobs
        } else {
          // If no jobs are found, return an empty list
          savedJobs.clear();
          return [];
        }
      }
    } catch (e) {
      print("Error fetching saved jobs: $e");
    }
    return [];  // Return empty list on error
  }

  // Save a job to the current user's saved jobs
  Future<void> saveJob(JobModel job) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Check if the job already exists in the saved jobs collection
        final savedJobsQuery = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('savedJobs')
            .where('jobId', isEqualTo: job.jobId)  // Assuming 'jobId' is unique
            .get();

        if (savedJobsQuery.docs.isEmpty) {
          // If job doesn't already exist, add it
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('savedJobs')
              .add(job.toMap());
        } else {
          print("Job is already saved!");
        }
      }
    } catch (e) {
      print("Error saving job: $e");
    }
  }
}
