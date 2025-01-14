// xiao_liu_ren.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'daoJia.dart';
import '../models/qigua_record.dart';
import '../models/global_records.dart';
import '../setting/record_page.dart';

class XiaoLiuRen extends StatefulWidget {
  const XiaoLiuRen({Key? key}) : super(key: key);

  @override
  _XiaoLiuRenState createState() => _XiaoLiuRenState();
}

class _XiaoLiuRenState extends State<XiaoLiuRen> {
  String selectedLiupai = '道家';        // 目前只有道家
  String selectedLeixing = '时间';      // 时间 / 数字
  String selectedTimeType = '月日时';    // '月日时' / '时刻分'
  List<String> numbers = ['', '', ''];  // 三组数字
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _qiGuaController = TextEditingController();

  void _gatherInformation() {
    String qiGuaShiXiang = _qiGuaController.text;
    String date = DateFormat.yMd('zh_CN').format(selectedDate);
    final localizations = MaterialLocalizations.of(context);
    String formattedTime =
    localizations.formatTimeOfDay(selectedTime, alwaysUse24HourFormat: true);

    // 如果是 "时间" 类型，就用 selectedTimeType；否则把三组数字拼一下
    String detail = (selectedLeixing == '时间')
        ? selectedTimeType
        : numbers.join(', ');

    // 把信息保存为一个 QiGuaRecord
    QiGuaRecord newRecord = QiGuaRecord(
      qiGuaShiXiang: qiGuaShiXiang,
      date: date,
      time: formattedTime,
      liupai: selectedLiupai,
      leixing: selectedLeixing,
      detail: detail,
    );

    // 保存到全局记录列表
    qiguaBox.add(newRecord);

    // 打印一下
    print("已存一条记录: $newRecord");

    // 然后根据流派来跳转 (这里示例只有"道家")
    if (selectedLiupai == '道家') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DaoJia(
            data: [
              qiGuaShiXiang,
              date,
              formattedTime,
              selectedLiupai,
              selectedLeixing,
              detail,
            ],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }

  // 构建页面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(243, 244, 248, 1),

        title: const Text(
          "小六壬",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        toolbarHeight: 60.0,

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RoundedRectangleContainer(
                selectedLiupai: selectedLiupai,
                selectedLeixing: selectedLeixing,
                selectedTimeType: selectedTimeType,
                numbers: numbers,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                onLiupaiChanged: (value) {
                  setState(() {
                    selectedLiupai = value;
                  });
                },
                onLeixingChanged: (value) {
                  setState(() {
                    selectedLeixing = value;
                  });
                },
                onTimeTypeChanged: (value) {
                  setState(() {
                    selectedTimeType = value;
                  });
                },
                onNumberChanged: (index, value) {
                  setState(() {
                    numbers[index] = value;
                  });
                },
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                onTimeChanged: (time) {
                  setState(() {
                    selectedTime = time;
                  });
                },
                qiGuaController: _qiGuaController,
                onSubmit: _gatherInformation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== 辅助组件 ==========

class RoundedRectangleContainer extends StatelessWidget {
  final String selectedLiupai;
  final String selectedLeixing;
  final String selectedTimeType;
  final List<String> numbers;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<String> onLiupaiChanged;
  final ValueChanged<String> onLeixingChanged;
  final ValueChanged<String> onTimeTypeChanged;
  final void Function(int, String) onNumberChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final TextEditingController qiGuaController;
  final VoidCallback onSubmit;

  const RoundedRectangleContainer({
    Key? key,
    required this.selectedLiupai,
    required this.selectedLeixing,
    required this.selectedTimeType,
    required this.numbers,
    required this.selectedDate,
    required this.selectedTime,
    required this.onLiupaiChanged,
    required this.onLeixingChanged,
    required this.onTimeTypeChanged,
    required this.onNumberChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.qiGuaController,
    required this.onSubmit,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(54, 102, 250, 1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(54, 102, 250, 1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 起卦事项
          Row(
            children: [
              const Text('起卦事项: ', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: qiGuaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: '起卦事项',
                    labelStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromRGBO(0, 125, 255, 1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 选择日期
          Row(
            children: [
              const Text('选择日期: ', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    hintText: DateFormat.yMd('zh_CN').format(selectedDate),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 选择时间
          Row(
            children: [
              const Text('选择时间: ', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: InputDecoration(
                    hintText: selectedTime.format(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(Icons.access_time),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 选择流派（示例只有“道家”）
          Row(
            children: [
              const Text('选择流派: ', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  spacing: 10.0,
                  children: ['道家'].map((value) {
                    return ChoiceChip(
                      label: Text(value),
                      selected: selectedLiupai == value,
                      onSelected: (bool selected) {
                        if (selected) {
                          onLiupaiChanged(value);
                        }
                      },
                      selectedColor: const Color.fromRGBO(0, 125, 255, 1),
                      labelStyle: TextStyle(
                        color: selectedLiupai == value ? Colors.white : Colors.black,
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 排盘类型：时间 / 数字
          Row(
            children: [
              const Text('排盘类型: ', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  spacing: 10.0,
                  children: ['时间', '数字'].map((value) {
                    return ChoiceChip(
                      label: Text(value),
                      selected: selectedLeixing == value,
                      onSelected: (bool selected) {
                        if (selected) {
                          onLeixingChanged(value);
                        }
                      },
                      selectedColor: const Color.fromRGBO(0, 125, 255, 1),
                      labelStyle: TextStyle(
                        color: selectedLeixing == value ? Colors.white : Colors.black,
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 如果选的是“时间”，再显示时间类型（“月日时”和“时刻分”）
          if (selectedLeixing == '时间')
            Row(
              children: [
                const Text('时间类型: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    spacing: 10.0,
                    children: ['月日时', '时刻分'].map((value) {
                      return ChoiceChip(
                        label: Text(value),
                        selected: selectedTimeType == value,
                        onSelected: (bool selected) {
                          if (selected) {
                            onTimeTypeChanged(value);
                          }
                        },
                        selectedColor: const Color.fromRGBO(0, 125, 255, 1),
                        labelStyle: TextStyle(
                          color: selectedTimeType == value ? Colors.white : Colors.black,
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          if (selectedLeixing == '时间') const SizedBox(height: 20),

          // 如果选的是“数字”，再显示输入数字的三个 TextField
          if (selectedLeixing == '数字')
            Row(
              children: [
                const Text('输入数字: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(0, 125, 255, 1),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              onNumberChanged(index, value);
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          if (selectedLeixing == '数字') const SizedBox(height: 20),

          // “起卦”按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 125, 255, 1),
                    minimumSize: Size(MediaQuery.of(context).size.width / 3, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: const Text(
                    "起卦",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 底部提示
          Row(
            children: const [
              Expanded(
                child: Text(
                  '日期时间将自动转换为农历',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
