import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/qigua_record.dart';
import '../XiaoLiuRen/daoJia.dart';
import '../models/global_records.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late final Box<QiGuaRecord> box;

  @override
  void initState() {
    super.initState();
    // 在 main.dart 已经 openBox，这里只获取已打开的 box
    box = qiguaBox;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 设置背景颜色
      backgroundColor: const Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        // AppBar 同样使用浅灰背景
        backgroundColor: const Color.fromRGBO(243, 244, 248, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () {
            Navigator.pop(context); // 返回上一个页面
          },
        ),
        centerTitle: true,
        toolbarHeight: 60.0, // 与 Setting 中一致
        title: const Text(
          "起卦记录",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Alimama", // 若无此字体，可换成其他
          ),
        ),
        elevation: 0, // 让 AppBar 更加扁平
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<QiGuaRecord> box, _) {
          // 获取记录列表并逆序
          final records = box.values.toList().reversed.toList();

          if (records.isEmpty) {
            return const Center(
              child: Text("暂无记录", style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    if (record.liupai == '道家') {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => DaoJia(
                            data: [
                              record.qiGuaShiXiang,
                              record.date,
                              record.time,
                              record.liupai,
                              record.leixing,
                              record.detail,
                            ],
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                  },
                  onLongPress: () {
                    _showDeleteDialog(context, record);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.history,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "起卦事项：${record.qiGuaShiXiang}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4.0),
                                  Text(record.date),
                                  const SizedBox(width: 10.0),
                                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4.0),
                                  Text(record.time),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  const Icon(Icons.change_circle_outlined, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4.0),
                                  Text("方式：${record.leixing}"),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  const Icon(Icons.auto_fix_high, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4.0),
                                  Text("流派：${record.liupai}"),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4.0),
                                  if (record.leixing == '时间')
                                    Text("时间类型：${record.detail}")
                                  else
                                    Text("数字：${record.detail}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },

      ),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(BuildContext context, QiGuaRecord record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("删除记录"),
        content: const Text("确定要删除这条起卦记录吗？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              // 调用 record.delete() 删除这条记录
              record.delete();
              Navigator.pop(ctx);
            },
            child: const Text("删除", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
