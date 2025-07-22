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
  bool _loggedIn = false; // Add this

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en' ? Locale('sw') : Locale('en');
    });
  }

  void _handleLoginSuccess() {
    setState(() {
      _loggedIn = true;
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
      home: _loggedIn
          ? SplashScreen(onToggleLanguage: _toggleLanguage)
          : LoginScreen(onLoginSuccess: _handleLoginSuccess),
    );
  }
}

// --- Add this LoginScreen widget ---
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  LoginScreen({required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  bool showPassword = false;

  // Simple in-memory user store for demo
  static final Map<String, String> _users = {
    'demo@eduhub.com': 'demo1234',
  };

  void _showCreateUserDialog() {
    String newEmail = '';
    String newPassword = '';
    final _createFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Account'),
        content: Form(
          key: _createFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Colors.blue),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : "Enter a valid email",
                onChanged: (value) => newEmail = value,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                ),
                obscureText: true,
                validator: (value) => value != null && value.length >= 4
                    ? null
                    : "Password too short",
                onChanged: (value) => newPassword = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_createFormKey.currentState!.validate()) {
                if (_users.containsKey(newEmail)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User already exists!')),
                  );
                } else {
                  setState(() {
                    _users[newEmail] = newPassword;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account created! Please log in.')),
                  );
                }
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);

      // Allow any email/password for testing
      setState(() => isLoading = false);
      widget.onLoginSuccess(); // Always proceed to SplashScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade300,
              Colors.orange.shade200
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              margin: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.blue[100],
                        child: Icon(Icons.school,
                            size: 48, color: Colors.blue[700]),
                      ),
                      SizedBox(height: 18),
                      Text(
                        "Welcome to EduHub",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Sign in to continue learning",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 28),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value != null && value.contains('@')
                                ? null
                                : "Enter a valid email",
                        onSaved: (value) => email = value ?? '',
                      ),
                      SizedBox(height: 18),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          filled: true,
                          fillColor: Colors.grey[100],
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue,
                            ),
                            onPressed: () =>
                                setState(() => showPassword = !showPassword),
                          ),
                        ),
                        obscureText: !showPassword,
                        validator: (value) => value != null && value.length >= 4
                            ? null
                            : "Password too short",
                        onSaved: (value) => password = value ?? '',
                      ),
                      SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: isLoading ? null : _login,
                          child: isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white))
                              : Text("Login", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Forgot password? Feature coming soon!")),
                              );
                            },
                            child: Text("Forgot password?",
                                style: TextStyle(color: Colors.blue[700])),
                          ),
                          SizedBox(width: 8),
                          Text('|', style: TextStyle(color: Colors.grey)),
                          TextButton(
                            onPressed: _showCreateUserDialog,
                            child: Text("Create account",
                                style: TextStyle(color: Colors.blue[700])),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      // BYPASS BUTTON FOR TESTING
                      ElevatedButton.icon(
                        icon: Icon(Icons.fast_forward, color: Colors.white),
                        label: Text("Bypass Login (Test)",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          widget.onLoginSuccess();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade300,
              Colors.orange.shade200
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated/rotating logo
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(seconds: 2),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * 3.1416,
                    child: child,
                  );
                },
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.school, size: 64, color: Colors.blue[700]),
                ),
              ),
              SizedBox(height: 30),
              // Emojis for EduTech appeal
              Text('🎓  📚  💡  🖥️  📱', style: TextStyle(fontSize: 38)),
              SizedBox(height: 30),
              Text(
                'EduHub',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Learn. Grow. Thrive.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple[700],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 30),
              LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Colors.white54,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ],
          ),
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

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  HomeScreen({required this.onToggleLanguage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> tracks = [
    {'icon': Icons.menu_book, 'title': 'Literacy', 'emoji': '📚'},
    {'icon': Icons.computer, 'title': 'Digital Skills', 'emoji': '💻'},
    {'icon': Icons.groups, 'title': 'Soft Skills', 'emoji': '🤝'},
  ];

  String? _selectedTrack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('EduHub'),
            SizedBox(width: 8),
            Text('🎓', style: TextStyle(fontSize: 26)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: widget.onToggleLanguage, icon: Icon(Icons.language)),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
            onSelected: (value) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$value tapped!')));
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade50,
              Colors.orange.shade50,
              Colors.blue.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User avatar and greeting
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.orange[100],
                      child: Text('👋', style: TextStyle(fontSize: 28)),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back!',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('Ready to learn something new today?',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700])),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 28),

                // Fun banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Text('🚀', style: TextStyle(fontSize: 32)),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Keep your streak! Complete a lesson today and earn a badge!',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple[900]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),

                // Dropdown menu for tracks
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text('🎯 Select a Learning Track'),
                      value: _selectedTrack,
                      isExpanded: true,
                      items: tracks.map((track) {
                        return DropdownMenuItem<String>(
                          value: track['title'],
                          child: Row(
                            children: [
                              Text(track['emoji'],
                                  style: TextStyle(fontSize: 22)),
                              SizedBox(width: 10),
                              Text(track['title']),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedTrack = value);
                        if (value != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseListScreen(trackTitle: value),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Track cards
                Text('Explore Tracks',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: tracks.map((track) {
                    return _buildTrackCard(
                      context,
                      track['icon'],
                      track['title'],
                      track['emoji'],
                    );
                  }).toList(),
                ),
                SizedBox(height: 30),

                // Go to Main Menu button
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.menu_book),
                    label: Text('Go to Main Menu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 239, 238, 241),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainMenuScreen(
                              onToggleLanguage: widget.onToggleLanguage),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                // Fun footer emojis
                Center(
                  child: Text(
                    '🎓  📚  💡  🖥️  📱  🏆  🤩',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackCard(
      BuildContext context, IconData icon, String title, String emoji) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseListScreen(trackTitle: title),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        color: Colors.white,
        child: Container(
          width: 110,
          height: 130,
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: TextStyle(fontSize: 32)),
              SizedBox(height: 10),
              Icon(icon, size: 32, color: Colors.deepPurple),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
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
      'Filling Forms':
          'This lesson teaches how to fill out basic forms like name, address, phone.',
      'Typing Practice': 'Practice typing on a digital keyboard efficiently.',
      'Communication':
          'Discover how to express your ideas clearly and listen actively.',
      'Reading Maps & Directions':
          'Understand how to use and read maps for daily navigation.',
      'Digital Payments': 'Learn how to use mobile money apps and stay safe.',
      'Social Media Basics':
          'Explore safe and useful ways to use Facebook, WhatsApp, and more.',
      'Public Speaking':
          'Build confidence and learn how to talk in front of others.',
      'Empathy & Respect':
          'Understand how to work well with others and show respect.',
      'Teamwork': 'Learn the importance of working together to solve problems.',
    };

    final String description = lessonContent[title] ??
        'This is a short interactive lesson on "$title".';

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
            Text(description, style: TextStyle(fontSize: 16)),
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

class MainMenuScreen extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  MainMenuScreen({required this.onToggleLanguage});

  final List<Map<String, dynamic>> menuItems = [
    {
      'emoji': '📚',
      'title': 'Literacy Courses',
      'subtitle': 'Read, write, and communicate',
      'icon': Icons.menu_book,
      'color': Colors.blue,
    },
    {
      'emoji': '💻',
      'title': 'Digital Skills',
      'subtitle': 'Smartphones, internet, and more',
      'icon': Icons.computer,
      'color': Colors.deepPurple,
    },
    {
      'emoji': '🤝',
      'title': 'Soft Skills',
      'subtitle': 'Teamwork, leadership, and more',
      'icon': Icons.groups,
      'color': Colors.orange,
    },
    {
      'emoji': '🏆',
      'title': 'Achievements',
      'subtitle': 'Badges & progress',
      'icon': Icons.emoji_events,
      'color': Colors.green,
    },
    {
      'emoji': '⚙️',
      'title': 'Settings',
      'subtitle': 'Language & preferences',
      'icon': Icons.settings,
      'color': Colors.grey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EduHub Main Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: onToggleLanguage,
            tooltip: 'Switch Language',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.orange.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 18),
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    '🚀 Welcome to EduHub!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your learning journey starts here.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            ...menuItems.map((item) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 6,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item['color'].withOpacity(0.15),
                      child: Text(
                        item['emoji'],
                        style: TextStyle(fontSize: 28),
                      ),
                      radius: 28,
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: item['color'],
                      ),
                    ),
                    subtitle: Text(item['subtitle']),
                    trailing: Icon(item['icon'], color: item['color']),
                    onTap: () {
                      // Navigation logic for each menu item
                      if (item['title'] == 'Literacy Courses') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CourseListScreen(trackTitle: 'Literacy'),
                          ),
                        );
                      } else if (item['title'] == 'Digital Skills') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CourseListScreen(trackTitle: 'Digital Skills'),
                          ),
                        );
                      } else if (item['title'] == 'Soft Skills') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CourseListScreen(trackTitle: 'Soft Skills'),
                          ),
                        );
                      } else if (item['title'] == 'Settings') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Settings coming soon!')),
                        );
                      } else if (item['title'] == 'Achievements') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Achievements coming soon!')),
                        );
                      }
                    },
                  ),
                )),
            SizedBox(height: 30),
            Center(
              child: Text(
                '🎓  📚  💡  🖥️  📱',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
