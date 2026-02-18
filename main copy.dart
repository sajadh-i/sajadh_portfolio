import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sajadh I - Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
        primaryColor: const Color(0xFF00D9FF),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({Key? key}) : super(key: key);

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pulseController;
  bool _showNavbar = false;

  final String emailUrl = 'mailto:sajadhi791@gmail.com';
  final String phoneUrl = 'tel:+917994766865';
  final String linkedInUrl = 'https://www.linkedin.com/in/sajadh-i';
  final String githubUrl = 'https://github.com/sajadh-i';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      final show = _scrollController.offset > 100;
      if (show != _showNavbar) {
        setState(() => _showNavbar = show);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  void _scrollToProjects() {
    _scrollController.animateTo(
      1200,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToContact() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              const Color(0xFF00D9FF).withOpacity(0.08),
              const Color(0xFF0F0F23),
              const Color(0xFFFF6B9D).withOpacity(0.05),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                AnimatedSection(delay: 0, child: _buildHeroSection()),
                const SizedBox(height: 80),
                AnimatedSection(delay: 200, child: _buildAboutSection()),
                const SizedBox(height: 80),
                AnimatedSection(delay: 100, child: _buildSkillsSection()),
                const SizedBox(height: 80),
                AnimatedSection(delay: 150, child: _buildProjectsSection()),
                const SizedBox(height: 80),
                AnimatedSection(delay: 100, child: _buildExperienceSection()),
                const SizedBox(height: 80),
                AnimatedSection(delay: 100, child: _buildEducationSection()),
                const SizedBox(height: 80),
                AnimatedSection(delay: 100, child: _buildContactSection()),
                const SizedBox(height: 40),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _showNavbar ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        child: FloatingActionButton(
          onPressed: () => _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          ),
          backgroundColor: const Color(0xFF00D9FF),
          child: const Icon(Icons.arrow_upward, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 700;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80),
          child: isMobile
              ? Column(
                  children: [
                    _buildAnimatedProfileImage(),
                    const SizedBox(height: 40),
                    _buildHeroContent(isMobile),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildHeroContent(isMobile)),
                    const SizedBox(width: 60),
                    _buildAnimatedProfileImage(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildAnimatedProfileImage() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.05),
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF00D9FF), Color(0xFFFF6B9D)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF00D9FF,
                  ).withOpacity(0.3 + _pulseController.value * 0.2),
                  blurRadius: 30 + (_pulseController.value * 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0F0F23),
              ),
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/image/portfolio_image1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroContent(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Text(
                  'Hello, I\'m',
                  style: GoogleFonts.spaceMono(
                    fontSize: isMobile ? 18 : 22,
                    color: const Color(0xFF00D9FF),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00D9FF), Color(0xFFFF6B9D)],
                ).createShader(bounds),
                child: Text(
                  'Sajadh I',
                  style: GoogleFonts.orbitron(
                    fontSize: isMobile ? 48 : 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        TypewriterText(
          text: 'Flutter Developer',
          style: GoogleFonts.firaCode(
            fontSize: isMobile ? 24 : 36,
            color: const Color(0xFFB4B4D4),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Text(
                'Passionate Flutter Developer crafting beautiful, responsive mobile applications with clean architecture.',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 16 : 18,
                  color: const Color(0xFF8B8B9E),
                  height: 1.7,
                ),
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            HoverButton(
              text: 'View Projects',
              isPrimary: true,
              onPressed: _scrollToProjects,
            ),
            HoverButton(
              text: 'Contact Me',
              isPrimary: false,
              onPressed: _scrollToContact,
            ),
            HoverButton(
              text: 'Download Resume',
              isPrimary: true,
              icon: Icons.download,
              onPressed: () {
                _launchURL("assets/pdf/sajadh_flutter_1.pdf");
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 15,
          children: [
            HoverSocialIcon(
              icon: Icons.code,
              url: githubUrl,
              onTap: _launchURL,
            ),
            HoverSocialIcon(
              icon: Icons.link,
              url: linkedInUrl,
              onTap: _launchURL,
            ),
            HoverSocialIcon(
              icon: Icons.email,
              url: emailUrl,
              onTap: _launchURL,
            ),
            HoverSocialIcon(
              icon: Icons.phone,
              url: phoneUrl,
              onTap: _launchURL,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      'About Me',
      Text(
        'Passionate Flutter Developer with hands-on experience building responsive, user-friendly mobile applications. '
        'Skilled in Dart, REST API integration, state management (Provider/Bloc/GetX), and clean architecture. '
        'Strong problem-solving ability with a focus on performance, UI/UX, and writing maintainable code.',
        style: GoogleFonts.inter(
          fontSize: 18,
          color: const Color(0xFFB4B4D4),
          height: 1.8,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSkillsSection() {
    final skills = [
      'Dart',
      'Flutter',
      'Bloc',
      'Provider',
      'GetX',
      'Riverpod',
      'REST API',
      'Firebase',
      'Sqflite',
      'Hive',
      'Git',
      'Responsive Design',
    ];

    return _buildSection(
      'Skills',
      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: skills.asMap().entries.map((entry) {
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 400 + (entry.key * 50)),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: HoverSkillChip(skill: entry.value),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProjectsSection() {
    final projects = [
      {
        'title': 'Fusion Festa',
        'year': '2025',
        'desc':
            '''• Developed a full-featured mobile app allow users to explore traditional cultural events and book tickets
• Implemented clean UI screens, event listings, AI chat assistant and booking flows using Flutter & Firebase
• Integrated state management and optimized app performance for smooth navigation and real-time event
updates''',
        'tech': [
          'Flutter',
          'Cloudinary',
          'Firebase',
          'MVVM',
          'Payment Integration',
          'AI Chat',
        ],
        'color': const Color(0xFF00D9FF),
        'github': 'https://github.com/sajadh-i/fusion_festa.git',
        'pdf': 'assets/pdf/FusionFesta.pdf',
      },
      {
        'title': 'Hotstar Clone',
        'year': '2025',
        'desc':
            '''• Built a fully functional Hotstar clone with UI/UX similar to the original platform
• Implemented video player with controls, subtitles, and adaptive streaming
• Integrated animations and responsive design for seamless user experience across devices''',
        'tech': ['Flutter', 'Animations', 'Clone', 'Video Player'],
        'color': const Color(0xFFFF6B9D),
        'github': 'https://github.com/sajadh-i/jio_hotstar.git',
        'pdf': 'assets/pdf/hotstar.pdf',
      },
      {
        'title': 'Expense Tracker',
        'year': '2025',
        'desc':
            '''• Created a complete personal finance tracking app with local data storage using SQLite
• Implemented CRUD operations for adding, and deleting expenses
• Added features like monthly summaries, charts, and user-friendly UI for offline expense management''',
        'tech': ['Flutter', 'SQLite', 'FL Chart'],
        'color': const Color(0xFF9D4EDD),
        'github': 'https://github.com/sajadh-i/expense_tracker.git',
        'pdf': 'assets/pdf/Expenso.pdf',
      },
    ];

    return _buildSection(
      'Projects',
      Column(
        children: projects.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 600 + (entry.key * 200)),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: HoverProjectCard(
                      title: entry.value['title'] as String,
                      year: entry.value['year'] as String,
                      description: entry.value['desc'] as String,
                      tech: entry.value['tech'] as List<String>,
                      color: entry.value['color'] as Color,
                      githubUrl: entry.value['github'] as String,
                      projectPdf: entry.value['pdf'] as String,
                      onLaunch: _launchURL,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return _buildSection(
      'Experience',
      HoverCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flutter Developer Intern',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00D9FF),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Luminar Technolab',
              style: GoogleFonts.inter(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'June 2025 - January 2026 | Kochi, Kerala',
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                color: const Color(0xFF8B8B9E),
              ),
            ),
            const SizedBox(height: 20),
            ...[
              'Developed multiple Flutter applications using Dart, REST APIs, and state management',
              'Worked on debugging, API handling, responsive layouts, and SQLite integration',
              'Collaborated in structured training environment flutter',
            ].map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF00D9FF), Color(0xFFFF6B9D)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        r,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFFB4B4D4),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    final education = [
      {
        'degree': 'Bachelor of Computer Science',
        'institution': 'College of Applied Science, Chelakkara',
        'period': '2022 - 2025',
      },
      {
        'degree': 'Plus Two',
        'institution': 'ASMM Higher Secondary School',
        'period': '2021 - 2022',
      },
      {
        'degree': 'SSLC',
        'institution': 'ASMM Higher Secondary School',
        'period': '2019 - 2020',
      },
    ];

    return _buildSection(
      'Education',
      Column(
        children: education.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 500 + (entry.key * 150)),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-30 * (1 - value), 0),
                    child: HoverEducationCard(
                      degree: entry.value['degree']!,
                      institution: entry.value['institution']!,
                      period: entry.value['period']!,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactSection() {
    return _buildSection(
      'Contact',
      Column(
        children: [
          Text(
            'I\'m open to new opportunities and collaborations. Feel free to reach out!',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: const Color(0xFFB4B4D4),
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              HoverContactCard(
                icon: Icons.email_rounded,
                label: 'Email',
                value: 'sajadhi791@gmail.com',
                url: emailUrl,
                onTap: _launchURL,
              ),
              HoverContactCard(
                icon: Icons.phone_rounded,
                label: 'Phone',
                value: '+91 7994766865',
                url: phoneUrl,
                onTap: _launchURL,
              ),
              HoverContactCard(
                icon: Icons.location_on_rounded,
                label: 'Location',
                value: 'Palakkad, Kerala',
                url: '',
                onTap: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 40),
          HoverButton(
            text: 'LinkedIn Profile',
            isPrimary: true,
            icon: Icons.link,
            onPressed: () => _launchURL(linkedInUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            '© 2025 Sajadh I',
            style: GoogleFonts.spaceMono(
              color: const Color(0xFF8B8B9E),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Built with Flutter & ❤️',
            style: GoogleFonts.inter(
              color: const Color(0xFF8B8B9E),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00D9FF), Color(0xFFFF6B9D)],
          ).createShader(bounds),
          child: Text(
            title,
            style: GoogleFonts.orbitron(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00D9FF), Color(0xFFFF6B9D)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 40),
        child,
      ],
    );
  }
}

// Animated Widgets

class AnimatedSection extends StatefulWidget {
  final Widget child;
  final int delay;

  const AnimatedSection({Key? key, required this.child, this.delay = 0})
    : super(key: key);

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const TypewriterText({Key? key, required this.text, required this.style})
    : super(key: key);

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _characterCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterCount,
      builder: (context, child) {
        return Text(
          widget.text.substring(0, _characterCount.value),
          style: widget.style,
        );
      },
    );
  }
}

class HoverButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  final IconData? icon;

  const HoverButton({
    Key? key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? const LinearGradient(
                    colors: [Color(0xFF00D9FF), Color(0xFFFF6B9D)],
                  )
                : null,
            color: widget.isPrimary ? null : Colors.transparent,
            border: Border.all(
              color: widget.isPrimary
                  ? Colors.transparent
                  : const Color(0xFF00D9FF),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: _isHovered && widget.isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withOpacity(0.4),
                      blurRadius: 20,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.isPrimary
                      ? Colors.black
                      : const Color(0xFF00D9FF),
                  size: 20,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                widget.text,
                style: GoogleFonts.spaceMono(
                  color: widget.isPrimary
                      ? Colors.black
                      : const Color(0xFF00D9FF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HoverSocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final Function(String) onTap;

  const HoverSocialIcon({
    Key? key,
    required this.icon,
    required this.url,
    required this.onTap,
  }) : super(key: key);

  @override
  State<HoverSocialIcon> createState() => _HoverSocialIconState();
}

class _HoverSocialIconState extends State<HoverSocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF00D9FF).withOpacity(0.1)
                : const Color(0xFF1A1A2E),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFF00D9FF)
                  : const Color(0xFF00D9FF).withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(widget.icon, color: const Color(0xFF00D9FF), size: 24),
        ),
      ),
    );
  }
}

class HoverSkillChip extends StatefulWidget {
  final String skill;

  const HoverSkillChip({Key? key, required this.skill}) : super(key: key);

  @override
  State<HoverSkillChip> createState() => _HoverSkillChipState();
}

class _HoverSkillChipState extends State<HoverSkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered
              ? const Color(0xFF00D9FF).withOpacity(0.1)
              : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF00D9FF)
                : const Color(0xFF00D9FF).withOpacity(0.3),
          ),
        ),
        child: Text(
          widget.skill,
          style: GoogleFonts.spaceMono(
            fontSize: 14,
            color: const Color(0xFF00D9FF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class HoverProjectCard extends StatefulWidget {
  final String title, year, description, githubUrl;
  final List<String> tech;
  final Color color;
  final Function(String) onLaunch;
  final String projectPdf;

  const HoverProjectCard({
    Key? key,
    required this.title,
    required this.year,
    required this.description,
    required this.tech,
    required this.color,
    required this.githubUrl,
    required this.onLaunch,
    required this.projectPdf,
  }) : super(key: key);

  @override
  State<HoverProjectCard> createState() => _HoverProjectCardState();
}

class _HoverProjectCardState extends State<HoverProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? widget.color : widget.color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.2),
                    blurRadius: 20,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => widget.onLaunch(widget.githubUrl),
                  child: Row(
                    children: [
                      Icon(Icons.code, color: widget.color, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'View on GitHub',
                        style: GoogleFonts.spaceMono(
                          fontSize: 14,
                          color: widget.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 25),

                /// 🔥 DOWNLOAD PDF BUTTON
                InkWell(
                  onTap: () => widget.onLaunch(widget.projectPdf),
                  child: Row(
                    children: [
                      Icon(Icons.download, color: widget.color, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Download Screenshots',
                        style: GoogleFonts.spaceMono(
                          fontSize: 14,
                          color: widget.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: Text(
            //         widget.title,
            //         style: GoogleFonts.orbitron(
            //           fontSize: 26,
            //           fontWeight: FontWeight.bold,
            //           color: widget.color,
            //         ),
            //       ),
            //     ),
            //     Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 15,
            //         vertical: 8,
            //       ),
            //       decoration: BoxDecoration(
            //         color: widget.color.withOpacity(0.2),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: Text(
            //         widget.year,
            //         style: GoogleFonts.spaceMono(
            //           fontSize: 14,
            //           color: widget.color,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 15),
            Text(
              widget.description,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFFB4B4D4),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.tech
                  .map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0F23),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: widget.color.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        t,
                        style: GoogleFonts.firaCode(
                          fontSize: 12,
                          color: widget.color,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => widget.onLaunch(widget.githubUrl),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.code, color: widget.color, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'View on GitHub',
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_forward, color: widget.color, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget child;

  const HoverCard({Key? key, required this.child}) : super(key: key);

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF00D9FF)
                : const Color(0xFF00D9FF).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF00D9FF).withOpacity(0.15),
                    blurRadius: 20,
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}

class HoverEducationCard extends StatefulWidget {
  final String degree, institution, period;

  const HoverEducationCard({
    Key? key,
    required this.degree,
    required this.institution,
    required this.period,
  }) : super(key: key);

  @override
  State<HoverEducationCard> createState() => _HoverEducationCardState();
}

class _HoverEducationCardState extends State<HoverEducationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF00D9FF)
                : const Color(0xFF00D9FF).withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D9FF), Color(0xFFFF6B9D)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.school, color: Colors.black, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.degree,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.institution,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFFB4B4D4),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.period,
                    style: GoogleFonts.spaceMono(
                      fontSize: 13,
                      color: const Color(0xFF00D9FF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoverContactCard extends StatefulWidget {
  final IconData icon;
  final String label, value, url;
  final Function(String) onTap;

  const HoverContactCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.onTap,
  }) : super(key: key);

  @override
  State<HoverContactCard> createState() => _HoverContactCardState();
}

class _HoverContactCardState extends State<HoverContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.url.isNotEmpty
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.url.isNotEmpty ? () => widget.onTap(widget.url) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _isHovered && widget.url.isNotEmpty
                  ? const Color(0xFF00D9FF)
                  : const Color(0xFF00D9FF).withOpacity(0.3),
              width: 2,
            ),
            boxShadow: _isHovered && widget.url.isNotEmpty
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withOpacity(0.2),
                      blurRadius: 15,
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D9FF), Color(0xFFFF6B9D)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: Colors.black, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  color: const Color(0xFF8B8B9E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
