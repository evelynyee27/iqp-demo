import 'package:flutter_application_1/comparsion_chatbox.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/regular_chatbox.dart';
import 'package:go_router/go_router.dart';
import 'chatbox_by_criteria.dart';
import 'categories.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    GoRoute(
      path: '/chatboxbycriteria',
      builder: (context, state) => const ChatboxByCriteria(),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const Categories(ranking: [],),
    ),
    GoRoute(
      path: '/comparsionchatbox',
      builder: (context, state) => const ComparsionChatbox(listOfSchool: [], isTchart: false,),
    ),
    GoRoute(
      path: '/regularchatbox',
      builder: (context, state) => const RegularChatbox(schoolName: ""),
    ),
  ],
);
