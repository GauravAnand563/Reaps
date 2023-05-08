import 'package:flutter/material.dart';
import 'package:reaps/services.dart';

import 'constants.dart';

class GraphPage extends StatefulWidget {
  GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'Visualization',
            style: kh2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Some title here', style: kh2,),
            SizedBox(height: 20,),
            Text('Visualization here')
          ],
        ),
      ),
    );
  }

  // Widget _buildGraph(String title, )
}
