import 'package:flutter/material.dart';
import '../models/job_model.dart';

class JobsCard extends StatelessWidget {
  final JobModel dataModel;
  final Color color;

  const JobsCard({
    super.key,
    required this.dataModel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dataModel.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(dataModel.company, style: const TextStyle(color: Colors.white70)),  // Display the company name
        ],
      ),
    );
  }
}
