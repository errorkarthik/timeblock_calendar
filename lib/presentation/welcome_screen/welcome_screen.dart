import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/value_proposition_widget.dart';
import './widgets/welcome_content_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToCalendar() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.dailyCalendarView, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDarkMode
                        ? [
                            const Color(0xFF0F172A),
                            const Color(0xFF1E293B),
                          ]
                        : [
                            const Color(0xFFF8FAFC),
                            const Color(0xFFE2E8F0),
                          ])),
            child: SafeArea(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(children: [
                      SizedBox(height: 8.h),

                      // App Logo
                      AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                                opacity: _fadeAnimation.value,
                                child: Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: theme.primaryColor
                                                  .withAlpha(77),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10)),
                                        ]),
                                    child: CustomImageWidget(
                                        imageUrl: 'assets/images/app_logo.png',
                                        width: 20.w, 
                                        height: 20.w)));
                          }),

                      SizedBox(height: 4.h),

                      // Welcome Content
                      Expanded(
                          child: SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: const WelcomeContentWidget()))),

                      // Value Propositions
                      SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(children: [
                                ValuePropositionWidget(
                                    icon: Icons.calendar_view_day_rounded,
                                    title: 'Visual Time Blocking',
                                    description:
                                        'See your schedule at a glance with intuitive visual blocks',
                                    delay: 200),
                                SizedBox(height: 2.h),
                                ValuePropositionWidget(
                                    icon: Icons.smart_toy_rounded,
                                    title: 'Smart Scheduling',
                                    description:
                                        'AI-powered suggestions for optimal time management',
                                    delay: 400),
                                SizedBox(height: 2.h),
                                ValuePropositionWidget(
                                    icon: Icons.sync_rounded,
                                    title: 'Cross-Device Sync',
                                    description:
                                        'Access your calendar anywhere, anytime',
                                    delay: 600),
                              ]))),

                      SizedBox(height: 4.h),

                      // Get Started Button
                      SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                            color: theme.primaryColor
                                                .withAlpha(77),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8)),
                                      ]),
                                  child: ElevatedButton(
                                      onPressed: _navigateToCalendar,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: theme.primaryColor,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          padding: EdgeInsets.zero),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Get Started',
                                                style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white)),
                                            SizedBox(width: 2.w),
                                            const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.white,
                                                size: 20),
                                          ]))))),

                      SizedBox(height: 2.h),

                      // Learn More Link
                      SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to feature overview or onboarding
                                    HapticFeedback.lightImpact();
                                  },
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 1.h)),
                                  child: Text('Learn More',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: theme.primaryColor))))),

                      SizedBox(height: 2.h),
                    ])))));
  }
}