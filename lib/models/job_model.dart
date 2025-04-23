class JobModel {
  final String jobId;
  final String title;
  final String location;
  final String description;
  final String company;  // Add the company field

  JobModel({
    required this.jobId,
    required this.title,
    required this.location,
    required this.description,
    required this.company,  // Initialize the company field
  });

  // Convert Firestore document data to JobModel
  factory JobModel.fromMap(Map<String, dynamic> data, String docId) {
    return JobModel(
      jobId: docId,
      title: data['title'] ?? 'No Title',
      location: data['location'] ?? 'Unknown',
      description: data['description'] ?? 'No Description',
      company: data['company'] ?? 'Unknown Company',  // Ensure company is fetched from Firestore
    );
  }

  // Convert JobModel to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'title': title,
      'location': location,
      'description': description,
      'company': company,  // Include company in the map
    };
  }
}
