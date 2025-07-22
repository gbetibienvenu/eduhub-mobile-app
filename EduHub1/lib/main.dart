import 'package:flutter/material.dart';

void main() {
  runApp(EduHubApp());
}

class EduHubApp extends StatefulWidget {
  @override
  State<EduHubApp> createState() => _EduHubAppState();
}

class _EduHubAppState extends State<EduHubApp> {
  Locale _locale = Locale('en');

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en' ? Locale('sw') : Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      home: SplashScreen(onToggleLanguage: _toggleLanguage),
    );
  }
}

class SplashScreen extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  SplashScreen({required this.onToggleLanguage});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                OnboardingScreen(onToggleLanguage: onToggleLanguage)),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text('EduHub',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Learn. Grow. Thrive.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]))
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  OnboardingScreen({required this.onToggleLanguage});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Learn Anytime, Anywhere',
      'description':
          'Access micro-courses offline and study at your convenience.',
      'image': '📱'
    },
    {
      'title': 'Build Skills That Matter',
      'description': 'Develop literacy, digital skills, and soft skills.',
      'image': '🎯'
    },
    {
      'title': 'Stay Motivated & Connected',
      'description': 'Earn badges, join discussions, and take on challenges.',
      'image': '🏅'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(slide['image']!, style: TextStyle(fontSize: 80)),
                      SizedBox(height: 30),
                      Text(slide['title']!,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      Text(slide['description']!,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]))
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => HomeScreen(
                          onToggleLanguage: widget.onToggleLanguage)),
                );
              },
              child: Text('Get Started'),
            ),
          ),
          TextButton(
            onPressed: widget.onToggleLanguage,
            child: Text('Switch Language'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  HomeScreen({required this.onToggleLanguage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EduHub'),
        actions: [
          IconButton(onPressed: onToggleLanguage, icon: Icon(Icons.language))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Continue learning and unlock new skills.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTrackCard(context, Icons.menu_book, 'Literacy'),
                _buildTrackCard(context, Icons.computer, 'Digital Skills'),
                _buildTrackCard(context, Icons.groups, 'Soft Skills'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackCard(BuildContext context, IconData icon, String title) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CourseListScreen(trackTitle: title)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseListScreen extends StatelessWidget {
  final String trackTitle;
  CourseListScreen({required this.trackTitle});

// This is code i updated 
  // final List<String> mockCourses = [
  //   'Intro to Basics',
  //   'Everyday Vocabulary',
  //   'Filling Forms',
  //   'Simple Messages',
  // ];

// With this one below here 

List<String> getCoursesForTrack(String track) {
  switch (track) {
    case 'Literacy':
      return [
        'Intro to Reading',
        'Everyday Vocabulary',
        'Filling Forms',
        'Reading Signs',
        'Story Time',
        'Functional Writing',
      ];
    case 'Digital Skills':
      return [
        'Intro to Smartphones',
        'Using the Internet',
        'Social Media Basics',
        'Digital Payments',
        'Typing Practice',
        'Cybersecurity Essentials',
      ];
    case 'Soft Skills':
      return [
        'Communication',
        'Teamwork',
        'Time Management',
        'Problem Solving',
        'Leadership Basics',
        'Public Speaking',
      ];
    default:
      return ['General Course'];
  }
}



  @override
  Widget build(BuildContext context) {
    //This code has been added 
     final courses = getCoursesForTrack(trackTitle);

    return Scaffold(
      appBar: AppBar(title: Text(trackTitle)),
      body: ListView.separated(
        padding: EdgeInsets.all(16),

        // itemCount: mockCourses.length,

        // An added features
        itemCount: courses.length,

        separatorBuilder: (_, __) => SizedBox(height: 10),
        itemBuilder: (context, index) {

          // final title = mockCourses[index];

           // An added features
          final title = courses[index];


          return ListTile(
            tileColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: Icon(Icons.play_circle_fill, color: Colors.blue),
            title: Text(title),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LessonViewerScreen(title: title)));
            },
          );
        },
      ),
    );
  }
}


class LessonViewerScreen extends StatelessWidget {
  final String title;
  LessonViewerScreen({required this.title});

  @override
  
  Widget build(BuildContext context) {

    // Added features below here 
    
      final Map<String, String> lessonContent = {
    'Intro to Reading': 'Learn how to identify letters and pronounce words.',
    'Filling Forms': 'This lesson teaches how to fill out basic forms like name, address, phone.',
    'Typing Practice': 'Practice typing on a digital keyboard efficiently.',
    'Communication': 'Discover how to express your ideas clearly and listen actively.',
    'Reading Maps & Directions': 'Understand how to use and read maps for daily navigation.',
    'Digital Payments': 'Learn how to use mobile money apps and stay safe.',
    'Social Media Basics': 'Explore safe and useful ways to use Facebook, WhatsApp, and more.',
    'Public Speaking': 'Build confidence and learn how to talk in front of others.',
    'Empathy & Respect': 'Understand how to work well with others and show respect.',
    'Teamwork': 'Learn the importance of working together to solve problems.',
  };
    String content = lessonContent[title] ?? 'Content for "$title" is coming soon.';


// Old code still below here

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lesson Content:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            // Text('This is a short interactive lesson on "$title".',
                // style: TextStyle(fontSize: 16)),
            Text('This is a short interactive lesson on "$title".',
            style: TextStyle(fontSize: 16)),

            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Mark as Complete'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48)),
            )
          ],
        ),
      ),
    );
  }
}
