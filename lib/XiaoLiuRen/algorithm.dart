import 'package:intl/intl.dart';
import 'package:lunar/lunar.dart';

// 定义五行属性枚举
enum WuXing { wood, fire, earth, metal, water }

// 定义每个属性的五行
Map<String, WuXing> wuXingMap = {
  '大安': WuXing.wood,
  '留连': WuXing.earth,
  '速喜': WuXing.fire,
  '赤口': WuXing.metal,
  '小吉': WuXing.water,
  '空亡': WuXing.earth,
};

// 定义时辰的五行和阴阳关系
Map<String, WuXing> lunarHourWuXingMap = {
  '子': WuXing.water,
  '丑': WuXing.earth,
  '寅': WuXing.wood,
  '卯': WuXing.wood,
  '辰': WuXing.earth,
  '巳': WuXing.fire,
  '午': WuXing.fire,
  '未': WuXing.earth,
  '申': WuXing.metal,
  '酉': WuXing.metal,
  '戌': WuXing.earth,
  '亥': WuXing.water,
};

Map<String, String> lunarHourYinYangMap = {
  '子': '阳',
  '丑': '阴',
  '寅': '阳',
  '卯': '阴',
  '辰': '阳',
  '巳': '阴',
  '午': '阳',
  '未': '阴',
  '申': '阳',
  '酉': '阴',
  '戌': '阳',
  '亥': '阴',
};

// 定义每个属性的阴阳关系
Map<String, String> yinYangMap = {
  '大安': '阳',
  '留连': '阴',
  '速喜': '阳',
  '赤口': '阳',
  '小吉': '阳',
  '空亡': '阳',
};



// 定义六神的阴爻阳爻关系
Map<String, String> yinYangYaoMap = {
  '大安': '阳爻',
  '留连': '阴爻',
  '速喜': '阳爻',
  '赤口': '阴爻',
  '小吉': '阳爻',
  '空亡': '阴爻',
};

// 定义八卦的阴爻阳爻关系
Map<String, List<String>> baGuaYinYangMap = {
  '乾': ['阳爻', '阳爻', '阳爻'],
  '兑': ['阴爻', '阳爻', '阳爻'],
  '离': ['阳爻', '阴爻', '阳爻'],
  '震': ['阴爻', '阴爻', '阳爻'],
  '巽': ['阳爻', '阳爻', '阴爻'],
  '坎': ['阴爻', '阳爻', '阴爻'],
  '艮': ['阳爻', '阴爻', '阴爻'],
  '坤': ['阴爻', '阴爻', '阴爻'],
};

// 定义八卦的五行属性
Map<String, WuXing> baGuaWuXingMap = {
  '乾': WuXing.metal,
  '兑': WuXing.metal,
  '离': WuXing.fire,
  '震': WuXing.wood,
  '巽': WuXing.wood,
  '坎': WuXing.water,
  '艮': WuXing.earth,
  '坤': WuXing.earth,
};


// 定义一个类来存储拆分后的数据
class SplitData {
  final String? id;
  final DateTime? date;
  final DateTime? time;
  final String? category;
  final String? type;
  final String? period;
  final int? lunarMonth;
  final int? lunarDay;
  final String? lunarHour;
  final int? lunarHourPosition;
  final int? lunarKe;
  final int? lunarMinutes;
  final int? num1;
  final int? num2;
  final int? num3;

  SplitData({
    required this.id,
    required this.date,
    required this.time,
    required this.category,
    required this.type,
    required this.period,
    this.lunarMonth,
    this.lunarDay,
    this.lunarHour,
    this.lunarHourPosition,
    this.lunarKe,
    this.lunarMinutes,
    this.num1,
    this.num2,
    this.num3,
  });
}

// 拆分和转换数据的函数
SplitData splitAndConvertData(List<String?> data) {
  print('splitAndConvertData: $data');

  // 拆分和转换数据
  String? id = data[0]?.isEmpty ?? true ? null : data[0];
  DateTime? date = data[1]?.isEmpty ?? true ? null : DateFormat('yyyy/MM/dd').parse(data[1]!);
  DateTime? time = data[2]?.isEmpty ?? true ? null : DateFormat('HH:mm').parse(data[2]!);
  String? category = data[3]?.isEmpty ?? true ? null : data[3];
  String? type = data[4]?.isEmpty ?? true ? null : data[4];
  String? period = data[5]?.isEmpty ?? true ? null : data[5];

  int? lunarMonth;
  int? lunarDay;
  String? lunarHour;
  int? lunarHourPosition;
  int? lunarKe;
  int? lunarMinutes;
  int? num1;
  int? num2;
  int? num3;

  if (data.length == 6) {
    // 处理时间类型
    if (date != null && time != null) {
      DateTime combinedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      Lunar lunar = Solar.fromDate(combinedDateTime).getLunar();
      lunarMonth = lunar.getMonth();
      lunarDay = lunar.getDay();
      lunarHour = lunar.getTimeZhi();

      // 计算时辰的顺序
      Map<String, int> hourPositionMap = {
        '子': 1,
        '丑': 2,
        '寅': 3,
        '卯': 4,
        '辰': 5,
        '巳': 6,
        '午': 7,
        '未': 8,
        '申': 9,
        '酉': 10,
        '戌': 11,
        '亥': 12,
      };
      lunarHourPosition = hourPositionMap[lunarHour];

      // 时辰的起始时间映射表
      Map<String, DateTime> startOfLunarHourMap = {
        '子': DateTime(date.year, date.month, date.day - 1, 23),
        '丑': DateTime(date.year, date.month, date.day, 1),
        '寅': DateTime(date.year, date.month, date.day, 3),
        '卯': DateTime(date.year, date.month, date.day, 5),
        '辰': DateTime(date.year, date.month, date.day, 7),
        '巳': DateTime(date.year, date.month, date.day, 9),
        '午': DateTime(date.year, date.month, date.day, 11),
        '未': DateTime(date.year, date.month, date.day, 13),
        '申': DateTime(date.year, date.month, date.day, 15),
        '酉': DateTime(date.year, date.month, date.day, 17),
        '戌': DateTime(date.year, date.month, date.day, 19),
        '亥': DateTime(date.year, date.month, date.day, 21),
      };

      DateTime startOfLunarHour = startOfLunarHourMap[lunarHour]!;
      Duration diff = combinedDateTime.difference(startOfLunarHour);

      // 计算刻
      lunarKe = (diff.inMinutes ~/ 15) % 8;

      // 计算分
      lunarMinutes = diff.inMinutes % 15;

      // 调整刻和分的值
      lunarKe = lunarKe == 0 ? 10 : lunarKe;
      lunarMinutes = lunarMinutes == 0 ? 10 : lunarMinutes;
    }
  }
  if (data.length == 6 && data[4] == '数字') {
    // 检查并拆分最后一项的数字
    List<String> numbers = [];
    if (data[5] != null) {
      numbers = data[5]!.split(',');
    }

    num1 = int.tryParse(numbers.length > 0 ? numbers[0].trim() : '0') ?? 0;
    num2 = int.tryParse(numbers.length > 1 ? numbers[1].trim() : '0') ?? 0;
    num3 = int.tryParse(numbers.length > 2 ? numbers[2].trim() : '0') ?? 0;

    // 将0变为10
    num1 = num1 == 0 ? 10 : num1;
    num2 = num2 == 0 ? 10 : num2;
    num3 = num3 == 0 ? 10 : num3;
  }

  // 返回封装好的数据
  SplitData result = SplitData(
    id: id,
    date: date,
    time: time,
    category: category,
    type: type,
    period: period,
    lunarMonth: lunarMonth,
    lunarDay: lunarDay,
    lunarHour: lunarHour,
    lunarHourPosition: lunarHourPosition,
    lunarKe: lunarKe,
    lunarMinutes: lunarMinutes,
    num1: num1,
    num2: num2,
    num3: num3,
  );

  print('splitAndConvertData result: $result');

  return result;
}

// 处理 "月日时" 的方法
Map<String, String> handleMonthDayHour(SplitData data) {
  print('handleMonthDayHour: $data');

  List<String> array = ["大安", "留连", "速喜", "赤口", "小吉", "空亡"];

  // 计算TianGong
  int monthIndex = (data.lunarMonth! - 1) % array.length;
  String tianGong = array[monthIndex];

  // 计算DiGong
  int dayIndex = (monthIndex + data.lunarDay! - 1) % array.length;
  String diGong = array[dayIndex];

  // 计算RenGong
  int hourIndex = (dayIndex + data.lunarHourPosition! - 1) % array.length;
  String renGong = array[hourIndex];

  // 返回结果
  return {
    'tianGong': tianGong,
    'diGong': diGong,
    'renGong': renGong,
  };
}

// 处理 "时刻分" 的方法
Map<String, String> handleTimeMinute(SplitData data) {
  print('handleTimeMinute: $data');

  List<String> array = ["大安", "留连", "速喜", "赤口", "小吉", "空亡"];

  // 计算TianGong
  int hourPositionIndex = (data.lunarHourPosition! - 1) % array.length;
  String tianGong = array[hourPositionIndex];

  // 计算DiGong
  int keIndex = (hourPositionIndex + data.lunarKe! - 1) % array.length;
  String diGong = array[keIndex];

  // 计算RenGong
  int minutesIndex = (keIndex + data.lunarMinutes! - 1) % array.length;
  String renGong = array[minutesIndex];

  // 返回结果
  return {
    'tianGong': tianGong,
    'diGong': diGong,
    'renGong': renGong,
  };
}

// 处理 "数字" 的方法
Map<String, String> handleNumbers(SplitData data) {
  print('handleNumbers: $data');

  List<String> array = ["大安", "留连", "速喜", "赤口", "小吉", "空亡"];

  // 计算TianGong
  int num1Index = (data.num1! - 1) % array.length;
  String tianGong = array[num1Index];

  // 计算DiGong
  int num2Index = (num1Index + data.num2! - 1) % array.length;
  String diGong = array[num2Index];

  // 计算RenGong
  int num3Index = (num2Index + data.num3! - 1) % array.length;
  String renGong = array[num3Index];

  // 返回结果
  return {
    'tianGong': tianGong,
    'diGong': diGong,
    'renGong': renGong,
  };
}

// 对计算结果进行进一步处理的方法
Map<String, String> furtherProcessResults(Map<String, String> results) {
  print('furtherProcessResults: $results');

  return {
    'tianGong': '${results['tianGong']}',
    'diGong': '${results['diGong']}',
    'renGong': '${results['renGong']}',
  };
}

// 判断两个五行属性之间的关系
int getRelation(WuXing tianGong, WuXing renGong) {
  if (tianGong == renGong) {
    return 3; // 比肩
  } else if ((tianGong == WuXing.wood && renGong == WuXing.fire) ||
      (tianGong == WuXing.fire && renGong == WuXing.earth) ||
      (tianGong == WuXing.earth && renGong == WuXing.metal) ||
      (tianGong == WuXing.metal && renGong == WuXing.water) ||
      (tianGong == WuXing.water && renGong == WuXing.wood)) {
    return 1; // 生
  } else if ((tianGong == WuXing.fire && renGong == WuXing.wood) ||
      (tianGong == WuXing.earth && renGong == WuXing.fire) ||
      (tianGong == WuXing.metal && renGong == WuXing.earth) ||
      (tianGong == WuXing.water && renGong == WuXing.metal) ||
      (tianGong == WuXing.wood && renGong == WuXing.water)) {
    return 2; // 被生
  } else if ((tianGong == WuXing.wood && renGong == WuXing.earth) ||
      (tianGong == WuXing.earth && renGong == WuXing.water) ||
      (tianGong == WuXing.water && renGong == WuXing.fire) ||
      (tianGong == WuXing.fire && renGong == WuXing.metal) ||
      (tianGong == WuXing.metal && renGong == WuXing.wood)) {
    return 4; // 克
  } else if ((tianGong == WuXing.earth && renGong == WuXing.wood) ||
      (tianGong == WuXing.water && renGong == WuXing.earth) ||
      (tianGong == WuXing.fire && renGong == WuXing.water) ||
      (tianGong == WuXing.metal && renGong == WuXing.fire) ||
      (tianGong == WuXing.wood && renGong == WuXing.metal)) {
    return 5; // 被克
  }
  return -1; // 未知关系
}

// 体用关系的判断方法
int getTiYongRelation(WuXing ti, String tiYinYang, WuXing yong, String yongYinYang) {
  if (ti == yong) {
    return tiYinYang == yongYinYang ? 5 : 6; // 比劫或比助
  } else if ((ti == WuXing.wood && yong == WuXing.fire) ||
      (ti == WuXing.fire && yong == WuXing.earth) ||
      (ti == WuXing.earth && yong == WuXing.metal) ||
      (ti == WuXing.metal && yong == WuXing.water) ||
      (ti == WuXing.water && yong == WuXing.wood)) {
    return 4; // 体生用-小凶
  } else if ((ti == WuXing.fire && yong == WuXing.wood) ||
      (ti == WuXing.earth && yong == WuXing.fire) ||
      (ti == WuXing.metal && yong == WuXing.earth) ||
      (ti == WuXing.water && yong == WuXing.metal) ||
      (ti == WuXing.wood && yong == WuXing.water)) {
    return 1; // 用生体-大吉
  } else if ((ti == WuXing.wood && yong == WuXing.earth) ||
      (ti == WuXing.earth && yong == WuXing.water) ||
      (ti == WuXing.water && yong == WuXing.fire) ||
      (ti == WuXing.fire && yong == WuXing.metal) ||
      (ti == WuXing.metal && yong == WuXing.wood)) {
    return 2; // 体克用-小吉
  } else if ((ti == WuXing.earth && yong == WuXing.wood) ||
      (ti == WuXing.water && yong == WuXing.earth) ||
      (ti == WuXing.fire && yong == WuXing.water) ||
      (ti == WuXing.metal && yong == WuXing.fire) ||
      (ti == WuXing.wood && yong == WuXing.metal)) {
    return 3; // 用克体-大凶
  }
  return -1; // 未知关系
}

// 处理关系的方法
Map<String, int> processRelations(Map<String, String> results, String lunarHour) {
  print('processRelations: results=$results, lunarHour=$lunarHour');

  WuXing tianGongWuXing = wuXingMap[results['tianGong']]!;
  WuXing diGongWuXing = wuXingMap[results['diGong']]!;
  WuXing renGongWuXing = wuXingMap[results['renGong']]!;
  WuXing lunarHourWuXing = lunarHourWuXingMap[lunarHour]!;

  String renGongYinYang = yinYangMap[results['renGong']]!;
  String lunarHourYinYang = lunarHourYinYangMap[lunarHour]!;

  int tianRenRelation = getRelation(tianGongWuXing, renGongWuXing);
  int diRenRelation = getRelation(diGongWuXing, renGongWuXing);
  int tianDiRelation = getRelation(tianGongWuXing, diGongWuXing);
  int tiYongRelation = getTiYongRelation(renGongWuXing, renGongYinYang, lunarHourWuXing, lunarHourYinYang);

  return {
    'tianRenRelation': tianRenRelation,
    'diRenRelation': diRenRelation,
    'tianDiRelation': tianDiRelation,
    'tiYongRelation': tiYongRelation,
  };
}

// 转太极逻辑处理
// 定义六亲关系的方法
Map<String, String> zhuanTaiJi(Map<String, String> results) {
  print('zhuanTaiJi: $results');

  List<String> array = ["大安", "留连", "速喜", "赤口", "小吉", "空亡"];

  String tianGong = results['tianGong']!;
  String diGong = results['diGong']!;
  String renGong = results['renGong']!;

  WuXing tianGongWuXing = wuXingMap[tianGong]!;
  WuXing diGongWuXing = wuXingMap[diGong]!;
  WuXing renGongWuXing = wuXingMap[renGong]!;

  // 定义获取生克结果的内部方法
  String getResult(String gong, int relation) {
    WuXing wuXing = wuXingMap[gong]!;
    String result = '';
    for (var key in wuXingMap.keys) {
      if (wuXingMap[key] == wuXing) continue;
      int rel = getRelation(wuXing, wuXingMap[key]!);
      if (rel == relation) {
        result = key;
        break;
      }
    }
    return result.isEmpty ? '留连' : result;
  }

  // 父母
  String fuMuTianGong = getResult(tianGong, 2); // 被生
  String fuMuDiGong = getResult(diGong, 2); // 被生
  String fuMuRenGong = getResult(renGong, 2); // 被生
  fuMuTianGong = fuMuTianGong == '土' ? '留连' : fuMuTianGong;
  fuMuDiGong = fuMuDiGong == '土' ? '留连' : fuMuDiGong;
  fuMuRenGong = fuMuRenGong == '土' ? '留连' : fuMuRenGong;

  // 妻财
  String qiCaiTianGong = getResult(tianGong, 4); // 克
  String qiCaiDiGong = getResult(diGong, 4); // 克
  String qiCaiRenGong = getResult(renGong, 4); // 克
  qiCaiTianGong = qiCaiTianGong == '土' ? '留连' : qiCaiTianGong;
  qiCaiDiGong = qiCaiDiGong == '土' ? '留连' : qiCaiDiGong;
  qiCaiRenGong = qiCaiRenGong == '土' ? '留连' : qiCaiRenGong;

  // 官鬼
  String guanGuiTianGong = getResult(tianGong, 5); // 被克
  String guanGuiDiGong = getResult(diGong, 5); // 被克
  String guanGuiRenGong = getResult(renGong, 5); // 被克
  guanGuiTianGong = guanGuiTianGong == '土' ? '留连' : guanGuiTianGong;
  guanGuiDiGong = guanGuiDiGong == '土' ? '留连' : guanGuiDiGong;
  guanGuiRenGong = guanGuiRenGong == '土' ? '留连' : guanGuiRenGong;

  // 兄弟
  String xiongDiTianGong = tianGong == '土' ? '留连' : tianGong;
  String xiongDiDiGong = diGong == '土' ? '留连' : diGong;
  String xiongDiRenGong = renGong == '土' ? '留连' : renGong;

  // 子孙
  String ziSunTianGong = getResult(tianGong, 1); // 生
  String ziSunDiGong = getResult(diGong, 1); // 生
  String ziSunRenGong = getResult(renGong, 1); // 生
  ziSunTianGong = ziSunTianGong == '土' ? '留连' : ziSunTianGong;
  ziSunDiGong = ziSunDiGong == '土' ? '留连' : ziSunDiGong;
  ziSunRenGong = ziSunRenGong == '土' ? '留连' : ziSunRenGong;

  // 返回六亲结果
  return {
    '父母': '$fuMuTianGong, $fuMuDiGong, $fuMuRenGong',
    '妻财': '$qiCaiTianGong, $qiCaiDiGong, $qiCaiRenGong',
    '官鬼': '$guanGuiTianGong, $guanGuiDiGong, $guanGuiRenGong',
    '兄弟': '$xiongDiTianGong, $xiongDiDiGong, $xiongDiRenGong',
    '子孙': '$ziSunTianGong, $ziSunDiGong, $ziSunRenGong',
  };
}



//三宫具象法
Map<String, List<String>> threeGongConcretization(String tianGong, String diGong, String renGong) {
  // 获取阴阳爻
  String getYao(String gong) {
    return yinYangYaoMap[gong]!;
  }

  // 获取八卦
  String getBaGua(List<String> yaoList) {
    for (var entry in baGuaYinYangMap.entries) {
      if (entry.value[0] == yaoList[0] && entry.value[1] == yaoList[1] && entry.value[2] == yaoList[2]) {
        return entry.key;
      }
    }
    throw Exception('无法找到匹配的八卦');
  }

  // 转换为天盘爻，地盘爻，人盘爻
  String tianPanYao = getBaGua([getYao(renGong), getYao(tianGong), getYao(diGong)]);
  String diPanYao = getBaGua([getYao(tianGong), getYao(diGong), getYao(renGong)]);
  String renPanYao = getBaGua([getYao(tianGong), getYao(renGong), getYao(diGong)]);

  // 获取五行属性
  WuXing getWuXing(String gong) {
    return wuXingMap[gong]!;
  }

  // 转换为五行关系
  WuXing tianGongWuXing = getWuXing(tianGong);
  WuXing diGongWuXing = getWuXing(diGong);
  WuXing renGongWuXing = getWuXing(renGong);
  WuXing tianPanYaoWuXing = baGuaWuXingMap[tianPanYao]!;
  WuXing diPanYaoWuXing = baGuaWuXingMap[diPanYao]!;
  WuXing renPanYaoWuXing = baGuaWuXingMap[renPanYao]!;

  // 获取生克结果
  String getResult(String gong, int relation) {
    WuXing wuXing = wuXingMap[gong]!;
    for (var entry in wuXingMap.entries) {
      if (getRelation(wuXing, entry.value) == relation) {
        return entry.key;
      }
    }
    return '留连';
  }

  // 计算天盘
  int tianGongRelation = getRelation(tianGongWuXing, tianPanYaoWuXing);
  List<String> tianPan = [
    tianGongRelation == 0 ? tianGong : getResult(tianGong, tianGongRelation),
    tianGongRelation == 0 ? diGong : getResult(diGong, tianGongRelation),
    tianGongRelation == 0 ? renGong : getResult(renGong, tianGongRelation),
  ];

  // 计算地盘
  int diGongRelation = getRelation(diGongWuXing, diPanYaoWuXing);
  List<String> diPan = [
    diGongRelation == 0 ? tianGong : getResult(tianGong, diGongRelation),
    diGongRelation == 0 ? diGong : getResult(diGong, diGongRelation),
    diGongRelation == 0 ? renGong : getResult(renGong, diGongRelation),
  ];

  // 计算人盘
  int renGongRelation = getRelation(renGongWuXing, renPanYaoWuXing);
  List<String> renPan = [
    renGongRelation == 0 ? tianGong : getResult(tianGong, renGongRelation),
    renGongRelation == 0 ? diGong : getResult(diGong, renGongRelation),
    renGongRelation == 0 ? renGong : getResult(renGong, renGongRelation),
  ];

  // 处理土的特殊规则
  tianPan = tianPan.map((item) => item == '土' ? '留连' : item).toList();
  diPan = diPan.map((item) => item == '土' ? '留连' : item).toList();
  renPan = renPan.map((item) => item == '土' ? '留连' : item).toList();

  // 返回结果
  return {
    'tianPan': tianPan,
    'diPan': diPan,
    'renPan': renPan,
  };
}



//八卦具象法
String baGuaConcretization(String tianGong, String diGong, String renGong) {
  // 获取阴阳爻
  String getYao(String gong) {
    return yinYangYaoMap[gong]!;
  }

  // 获取八卦
  String getBaGua(List<String> yaoList) {
    for (var entry in baGuaYinYangMap.entries) {
      if (entry.value[0] == yaoList[0] && entry.value[1] == yaoList[1] && entry.value[2] == yaoList[2]) {
        return entry.key;
      }
    }
    throw Exception('无法找到匹配的八卦');
  }

  // 转化天宫、地宫、人宫为爻
  List<String> yaoList = [getYao(tianGong), getYao(diGong), getYao(renGong)];

  // 获取对应的八卦
  String baGua = getBaGua(yaoList);

  return baGua;
}






// 根据最后一项选择处理方法
Map<String, dynamic> processData(List<String?> data) {
  print('processData: $data');

  SplitData splitData = splitAndConvertData(data);
  Map<String, String> results;

  if (data.length == 6 && data.last == '月日时') {
    results = handleMonthDayHour(splitData);
  } else if (data.length == 6 && data.last == '时刻分') {
    results = handleTimeMinute(splitData);
  } else if (data.length == 6 && data[4] == '数字') {
    results = handleNumbers(splitData);
  } else {
    throw ArgumentError('未知的period类型');
  }


  // 对计算结果进行进一步处理
  Map<String, String> processedResults = furtherProcessResults(results);

  // 计算生克关系
  Map<String, int> relations = processRelations(results, splitData.lunarHour!);

  return {
    'processedResults': processedResults,
    'relations': relations,
  };
}
