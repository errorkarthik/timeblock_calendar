import 'package:flutter/material.dart';
import '../presentation/weekly_calendar_view/weekly_calendar_view.dart';
import '../presentation/create_time_block/create_time_block.dart';
import '../presentation/daily_calendar_view/daily_calendar_view.dart';
import '../presentation/edit_time_block/edit_time_block.dart';
import '../presentation/welcome_screen/welcome_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String welcomeScreen = '/welcome-screen';
  static const String weeklyCalendarView = '/weekly-calendar-view';
  static const String createTimeBlock = '/create-time-block';
  static const String dailyCalendarView = '/daily-calendar-view';
  static const String editTimeBlock = '/edit-time-block';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const WelcomeScreen(),
    welcomeScreen: (context) => const WelcomeScreen(),
    weeklyCalendarView: (context) => const WeeklyCalendarView(),
    createTimeBlock: (context) => const CreateTimeBlock(),
    dailyCalendarView: (context) => const DailyCalendarView(),
    editTimeBlock: (context) => const EditTimeBlock(),
    // TODO: Add your other routes here
  };
}
