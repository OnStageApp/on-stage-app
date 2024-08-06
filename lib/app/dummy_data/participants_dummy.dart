import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';

class StagersDummy {
  static List<StagerOverview> stagers = [
    // generate 10 stagers, stagers means participants in this app
    const StagerOverview(
      id: 'asdasd',
      firstName: 'Alexandru',
      lastName: 'Popescu',
      picture: 'assets/images/profile1.png',
      status: StagerStatusEnum.rejected,
    ),
    const StagerOverview(
      id: 'asdasd',
      firstName: 'Andrei',
      lastName: 'Ionescu',
      picture: 'assets/images/profile2.png',
      status: StagerStatusEnum.pending,
    ),
    const StagerOverview(
      id: 'asdasd',
      firstName: 'Mihai',
      lastName: 'Popa',
      picture: 'assets/images/profile3.png',
      status: StagerStatusEnum.accepted,
    ),
    const StagerOverview(
      id: 'asdasd',
      firstName: 'Ion',
      lastName: 'Georgescu',
      picture: 'assets/images/profile4.png',
      status: StagerStatusEnum.rejected,
    ),
    const StagerOverview(
      id: 'asdasd',
      firstName: 'Vasile',
      lastName: 'Ionescu',
      picture: 'assets/images/profile5.png',
      status: StagerStatusEnum.pending,
    ),
    const StagerOverview(
      id: 'asdasd',
      firstName: 'Gheorghe',
      lastName: 'Popescu',
      picture: 'assets/images/profile6.png',
      status: StagerStatusEnum.accepted,
    ),
    const StagerOverview(
      id: 'asdasd',
      firstName: 'Mihai',
      lastName: 'Popa',
      picture: 'assets/images/profile7.png',
      status: StagerStatusEnum.rejected,
    ),
  ];
}
