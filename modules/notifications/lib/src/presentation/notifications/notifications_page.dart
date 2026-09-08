import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';
import 'package:notifications/src/presentation/notifications/widgets/notification_item.dart';
import 'package:notifications/src/presentation/notifications_filter_sheet/args/notifications_filter_args.dart';

part 'mixin/notifications_mixin.dart';

class NotificationsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with NotificationsMixin {
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    bloc.add(const GetNotificationsEvent());
  }

  @override
  void dispose() {
    _disposeMixin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<NotificationsBloc, NotificationsState>(
    listener: _handleStates,
    child: Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notificationsTitle),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterSheet),
          IconButton(icon: const Icon(Icons.delete_sweep_outlined), onPressed: _confirmClearAll),
        ],
      ),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          buildWhen: (_, curr) => curr is NotificationListState,
          builder: (context, state) {
            if (state is NotificationsLoadingState) {
              return const Center(child: CustomCircularProgressIndicator());
            }

            final items = _filteredNotifications;

            if (items.isEmpty && state is! NotificationsPaginationLoadingState) {
              return Center(
                child: Text(
                  context.l10n.notificationsTitle,
                  style: context.textStyle.defaultW400x16.copyWith(color: context.color.textSecondary),
                ),
              );
            }

            return ListView.separated(
              controller: _scrollController,
              itemCount: items.length + (state is NotificationsPaginationLoadingState ? 1 : 0),
              separatorBuilder: (_, _) => Dimensions.kGap12,
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return const Padding(
                    padding: Dimensions.kPaddingVertical16,
                    child: Center(child: CustomCircularProgressIndicator()),
                  );
                }

                final item = items[index];
                return NotificationItem(
                  args: NotificationItemArgs(
                    id: item.id,
                    title: item.title,
                    message: item.message,
                    isRead: item.isRead,
                    onTap: () {
                      if (!item.isRead) {
                        bloc.add(MarkNotificationAsReadEvent(id: item.id));
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    ),
  );
}
