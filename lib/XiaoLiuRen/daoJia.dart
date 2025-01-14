import 'package:flutter/material.dart';
import '../XiaoLiuRen/algorithm.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DaoJia extends StatefulWidget {
  final List<String> data;

  DaoJia({required this.data});

  @override
  _DaoJia createState() => _DaoJia();
}

class _DaoJia extends State<DaoJia> {
  SplitData? _splitData;
  Map<String, dynamic>? _results;
  Map<String, List<String>>? _threeGongResults;
  String? _baGuaResult;

  /// 用来记录当前显示哪个模块：0=转太极, 1=三宫象, 2=八卦具象
  int _selectedModule = 0;

  @override
  void initState() {
    super.initState();
    _splitData = splitAndConvertData(widget.data);
    try {
      _results = processData(widget.data);
      _threeGongResults = threeGongConcretization(
        _results!['processedResults']['tianGong'],
        _results!['processedResults']['diGong'],
        _results!['processedResults']['renGong'],
      );
      _baGuaResult = baGuaConcretization(
        _results!['processedResults']['tianGong'],
        _results!['processedResults']['diGong'],
        _results!['processedResults']['renGong'],
      ) + '卦';
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(243, 244, 248, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("道家小六壬", style: TextStyle(fontSize: 20, fontFamily: "Alimama")),
        centerTitle: true,
        toolbarHeight: 60.0,


      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              /// --- 1. 事项起卦 ---
              Matter(data: widget.data),

              SizedBox(height: 20),

              /// --- 2. 卦象 ---
              if (_results != null)
                GuaxiangContainer(
                  tiangong: _results!['processedResults']['tianGong'],
                  digong: _results!['processedResults']['diGong'],
                  rengong: _results!['processedResults']['renGong'],
                  lunarHour: (_splitData?.lunarHour ?? '未提供') + '时',
                ),

              SizedBox(height: 20),

              /// --- 3. 基本信息 ---
              if (_results != null)
                BasicInformation(relations: _results!['relations']),

              SizedBox(height: 20),

              /// =============== 新增的三个按钮 ===============
              /// 你可以根据需求放在任意位置，比如放在顶部、底部，都行
              // 用 Container 包裹，设置左右 margin
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // ====== “转换太极” 按钮 (原来的就保留不动) ======
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.rotate_right,
                          color: Colors.white,
                        ),
                        label: Text(
                          '转换太极',
                          style: TextStyle(
                            fontFamily: 'Alimama',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF007DFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedModule = 0;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    // ====== “三宫具象” 按钮，使用自定义 SVG ======
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          'assets/icons/tree-diagram.svg',
                          width: 20,
                          height: 20,
                          color: Colors.white, // 如果想让 SVG 也变成白色，可以这么设置
                        ),
                        label: Text(
                          '三宫具象',
                          style: TextStyle(
                            fontFamily: 'Alimama',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF2BB673),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedModule = 1;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    // ====== “八卦具象” 按钮，使用自定义 SVG ======
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          'assets/icons/bagua.svg',
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                        label: Text(
                          '八卦具象',
                          style: TextStyle(
                            fontFamily: 'Alimama',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFFF05A24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedModule = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),




              SizedBox(height: 20),

              /// =============== 根据选中的模块来展示对应的 Widget ===============
              if (_selectedModule == 0 && _results != null)
                TurningTaiJi(results: _results!['processedResults']),

              if (_selectedModule == 1 && _threeGongResults != null)
                ThreeGongConcretization(threeGongResults: _threeGongResults!),

              if (_selectedModule == 2 && _baGuaResult != null)
                BaGuaConcretization(baGuaResult: _baGuaResult!),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}




//起卦
class Matter extends StatelessWidget {
  final List<String> data;

  Matter({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // Increased radius for rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '起卦',
              style: TextStyle(
                fontSize: 24, // Larger font size
                fontFamily: 'Alimama', // Custom font
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildTitleWithRow('事项：', data[0] == "" ? "没写~" : data[0] ),
          SizedBox(height: 10),
          _buildTitleWithRow('信息：', data[1], data[2], data[4], data[5]),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildTitleWithRow(String title, String text, [String? text2, String? text3, String? text4]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Alimama',
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildRoundedBox(text, 12),
              if (text2 != null) _buildRoundedBox(text2, 12),
              if (text3 != null) _buildRoundedBox(text3, 12),
              if (text4 != null) _buildRoundedBox(text4, 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoundedBox(String text, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 125, 255, 1), // Customize color as needed
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "Alimama",
        ),
      ),
    );
  }
}












//卦象
class GuaxiangContainer extends StatelessWidget {
  final String tiangong;
  final String digong;
  final String rengong;
  final String lunarHour;

  GuaxiangContainer({
    required this.tiangong,
    required this.digong,
    required this.rengong,
    required this.lunarHour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            25), // Increased radius for rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '卦象',
            style: TextStyle(
              fontSize: 24, // Larger font size
              fontFamily: 'Alimama', // Custom font
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRoundedBox(context, tiangong, 20),
              // Increased size for rounded box
              _buildRoundedBox(context, digong, 20),
              // Increased size for rounded box
              _buildRoundedBox(context, rengong, 20),
              // Increased size for rounded box
              _buildRoundedBox(context, lunarHour, 20),
              // Increased size for rounded box
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedBox(BuildContext context, String text, double size) {
    return GestureDetector(
      onTap: () => _showDialog(context, text),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 125, 255, 1), // Customize color as needed
          borderRadius: BorderRadius.circular(
              15), // Increased radius for rounded corners
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: size,
            fontFamily: "Alimama",
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String text) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Cubic(0.33, 1, 0.68, 1),
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            height: 500,
            width: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: text == '子时' || text == '丑时' || text == '寅时' ||
                text == '卯时' || text == '辰时' || text == '巳时' ||
                text == '午时' || text == '未时' || text == '申时' ||
                text == '酉时' || text == '戌时' || text == '亥时'
                ? _buildZiShiContent(context, text)
                : _buildDefaultContent(context, text),
          ),
        );
      },
    );
  }

  Widget _buildDefaultContent(BuildContext context, String text) {
    void _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    }


    String jiXiong = '';
    String wuXing = '';
    String shenShou = '';
    String fangWei = '';
    String diZhiFangWeiMonth = '';
    String tianGanFangWeiMonth = '';
    String diZhiWuXing = '';
    String diZhiShunXu = '';
    String tianGanShunXu = '';
    String twelvePalaces = '';
    String sixDao = '';
    String rankingNum = '';
    String positionNum = '';
    String season = '';
    String weather = '';
    String disease = '';
    String meaning = '';


    switch (text) {
      case '大安':
        jiXiong = '大吉';
        wuXing = '木';
        shenShou = '青龙';
        fangWei = '东方';
        diZhiFangWeiMonth = '寅、卯、辰';
        tianGanFangWeiMonth = '甲、乙';
        diZhiWuXing = '寅、卯';
        diZhiShunXu = '寅、卯';
        tianGanShunXu = '甲、丁';
        twelvePalaces = '事业宫(外)，命宫(内)';
        sixDao = '人道，主宫天权，次宫天艺，位在修罗道';
        rankingNum = '1，7';
        positionNum = '4，5';
        season = '春季';
        weather = '可能天气晴朗但不确定';
        disease = '肝胆，四肢，神经系统，静脉';
        meaning =
        '大安在东方，可以结合“四象”之青龙，但是因为大安有“身未动”之特点、所以，应该是条“睡龙”，虽为大吉，但因“安”而生“逸”，有不思进取之意，特性为静，缺少主动性；另外，既然是正东方，所以为震卦，五行当然为木。';
        break;
      case '留连':
        jiXiong = '小凶';
        wuXing = '(四方)土';
        shenShou = '腾蛇';
        fangWei = '四角(主东南)';
        diZhiFangWeiMonth = '辰、巳';
        tianGanFangWeiMonth = '无天干';
        diZhiWuXing = '辰、戌、丑、未';
        diZhiShunXu = '辰、巳';
        tianGanShunXu = '丁、己';
        twelvePalaces = '田宅宫(外)，奴仆宫(内)';
        sixDao = '修罗道，主宫天奸，次宫天福，位在佛道';
        rankingNum = '2，8';
        positionNum = '7，8';
        season = '春夏';
        weather = '可能细雨连绵';
        disease = '肠胃，喉咙，隐疾，神经病，肿瘤，疑难杂症';
        meaning =
        '留连为四方土，原则上应在四个角，也就是其它五宫中间都应该有一留连宫，比如大安后留连、之后速喜、之后再留连、然后赤口、再留连、再小吉、再空亡、再留连，但是这样排的话，从概率上来说不符合自然规律，同时也不符合六神的排位原理（另外章节详述）。所以，我们只要明白，从理论上讲，留连位在四偏角就行了。那么当然，按卦的方位来讲，就应在巽、坤、乾、艮，在季节上讲，就是春夏秋冬之中的丑、辰、未、戍四月。由于四季土是正逢季节特性转移之时，所以有变化之象，所以要记住，留连是六神中唯一不完全确定性的宫位，特别是晚上测到留连，代表这件事虽为凶，但有一定的变数（另章节详述）；另外，由于四方土在四偏方，为“拐弯转角”之意，是为不通畅，所以，有“缓慢”、“停滞”，“拖延”、“暗昧”、“纠缠”、“暂留”之意。';
        break;
      case '速喜':
        jiXiong = '中吉';
        wuXing = '火';
        shenShou = '朱雀';
        fangWei = '南方';
        diZhiFangWeiMonth = '巳、午、未';
        tianGanFangWeiMonth = '丙、丁';
        diZhiWuXing = '巳、午';
        diZhiShunXu = '午、未';
        tianGanShunXu = '丙、辛';
        twelvePalaces = '感情宫(外)，夫妻宫(内)';
        sixDao = '佛道，主宫天贵，次宫天破，位在畜生道';
        rankingNum = '3，9';
        positionNum = '6，9';
        season = '长夏';
        weather = '可能晴朗出现彩虹';
        disease = '炎症，心脏，头脑，血液，上火，烫伤';
        meaning =
        '速喜在南方，当为离卦，五行自然为火，结合“四象”为朱雀，但因为速喜有“迅速”、“快速”之特点，所以其火为“迅猛”，但后劲不足，一烧即过。所以，速喜宫虽为好事，但不长久，如果测考试、谈判之类的短暂性事件的话，测到速喜宫就一定能过、能成，测其它也为吉，但不能拖延，时机过了就有可能会有变化。';
        break;
      case '赤口':
        jiXiong = '中凶';
        wuXing = '金';
        shenShou = '白虎';
        fangWei = '西方';
        diZhiFangWeiMonth = '申、酉、戍';
        tianGanFangWeiMonth = '庚、辛';
        diZhiWuXing = '申、酉';
        diZhiShunXu = '申、酉';
        tianGanShunXu = '庚、癸';
        twelvePalaces = '疾厄宫(外)，兄弟宫(内)';
        sixDao = '畜生道，主宫天刃，次宫天寿，位在仙道';
        rankingNum = '1，2';
        positionNum = '4，10';
        season = '秋季';
        weather = '可能有雷雨暴雹';
        disease = '皮肤病，肺部，大肠，外伤，流血，骨头';
        meaning =
        '赤口在西方，当为兑卦，五行就自然为金，结合“四象”论为白虎，因为赤口为凶，所以为伤人之虎。其有惊恐、凶险、口舌、官非、伤灾之意。赤口在三凶卦中虽为中凶，但有些事情比大凶空亡还凶，比如断出行，空亡也有未出行之意，而赤口多为车祸等意外事故；又如断生意，空亡可能指生意落空了，而赤口多却为破财和纠纷。';
        break;
      case '小吉':
        jiXiong = '小吉';
        wuXing = '水';
        shenShou = '玄武';
        fangWei = '北方';
        diZhiFangWeiMonth = '亥、子、丑';
        tianGanFangWeiMonth = '壬、癸';
        diZhiWuXing = '亥、子';
        diZhiShunXu = '戌、亥';
        tianGanShunXu = '壬、甲';
        twelvePalaces = '驿马宫(外)，子女宫(内)';
        sixDao = '仙道，主宫天文，次宫天驿，位在鬼道';
        rankingNum = '5，11';
        positionNum = '3，8';
        season = '冬季';
        weather = '可能有细雨';
        disease = '肾脏，膀胱，性病，浮肿，寒邪，生殖系统';
        meaning =
        '小吉在北方，当为坎卦，结合“四象”论为玄武，五行自然为水，但因小吉为“小”，此水应为溪流之水，虽为吉，但力量不大。从卦论，任何事均是往着好的方面在发展的，但是发展缓慢，且成效不大，还需自已加倍努力，才能有更大的收获或更好的发展。';
      case '空亡':
        jiXiong = '大凶';
        wuXing = '(中央)土';
        shenShou = '勾陈';
        fangWei = '中央';
        diZhiFangWeiMonth = '丑、寅';
        tianGanFangWeiMonth = '戊、已';
        diZhiWuXing = '无地支，天干为戊、己';
        diZhiShunXu = '子、丑';
        tianGanShunXu = '戊、乙';
        twelvePalaces = '福德宫(外)，父母宫(内)';
        sixDao = '鬼道，主宫天厄，次宫天孤，位在人道';
        rankingNum = '6，12';
        positionNum = '5，10';
        season = '冬春';
        weather = '可能天气阴沉难以预测';
        disease = '无病，大病，癌症，癔症，脾胃';
        meaning =
        '空亡在中央，九宫中入中宫，为勾陈土，其空亡之点为灵空太极点，不在四季中，与时间无关，仅空间为中。因为空亡为大凶，所以，凡所测之事，首先均要以凶论断，其次再看具体表现，比如论病，如赤口，多为手术之信息，而空亡卦，除病人已病入膏肓以不治论，另外，也表示没有病的意思，但没病为什么为凶呢？所以，论病测到空亡会有以下几种情况：\n1. 不治之症，多活不过10天，当然具体数字还得具体分析；\n2. 非器质性病变，病能好，但需要治疗一段时间才能好，多为五个月，当然具体时间还得具体分析，季节不同亦有不同；\n3. 为癔症，就是说不是神经病就是阴性病。';
        break;

    // Add more cases for other types
      default:
        jiXiong = '未知';
        wuXing = '未知';
        shenShou = '未知';
        fangWei = '未知';
        diZhiFangWeiMonth = '未知';
        tianGanFangWeiMonth = '未知';
        diZhiWuXing = '未知';
        diZhiShunXu = '未知';
        tianGanShunXu = '未知';
        twelvePalaces = '未知';
        sixDao = '未知';
        rankingNum = '未知';
        positionNum = '未知';
        season = '未知';
        weather = '未知';
        disease = '未知';
        meaning = '未知';
        break;
    }

    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Alimama',
            color: Color.fromRGBO(29, 29, 29, 1),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "吉凶:$jiXiong\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "五行:$wuXing\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "神兽:$shenShou\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "方位:$fangWei\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "地支(方位、月份归类):$diZhiFangWeiMonth\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "天干(方位、月份归类):$tianGanFangWeiMonth\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "地支(五行归类):$diZhiWuXing\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "地支(顺序归类):$diZhiShunXu\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "天干(顺序归类):$tianGanShunXu\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "十二宫:\n$twelvePalaces\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "六道:\n$sixDao\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "排位数:$rankingNum\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "方位数:$positionNum\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "季节:$season\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "天象:$weather\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "疾病:\n$disease\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "基本含义:\n$meaning\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: Text(
              "关闭",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(0, 125, 255, 1),
                fontFamily: 'Alimama',
                decoration: TextDecoration.none,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildZiShiContent(BuildContext context, String text) {
    void _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    }


    String range = '';
    String zodiacSign = '';
    String earthlyBranchesMeaning = '';


    switch (text) {
      case '子时':
        range = '23:00 ~ 01:00';
        zodiacSign = '鼠';
        earthlyBranchesMeaning =
        '孳也，草木种子，吸土中水分而出，为一阳萌生的开始。\n子癸一家但有区别，子水属于流动的水，运动的水，引申为江湖走江湖的。子水也代表玄学，技能，聪明，淫邪。于人体为肾，膀胱，泌尿，到年上主这人到处跑。';
        break;
      case '丑时':
        range = '01:00 ~ 03:00';
        zodiacSign = '牛';
        earthlyBranchesMeaning =
        '草木在土中发芽，屈曲着将要冒出地面。\n寒土，泥巴，湿土，沼泽，堤坝，阴中之阴不见阳光，是地下室，下水道，黑社会。为抽象，为军营，厂矿，煤矿。怎么用？看它干什么。根据天干之象配合使用。看十神天干为啥或带了什么象，比如丑土为财库，就可能为银行，是羊刃库就是军营了。丑土还主牢狱，黑社会，干的勾当为弄财。辛酉日主见丑为黑社会，但辛丑日柱不是，因为辛丑辛为清丑为浊，辛金为丑土中出来的，为浊中出清，有高贵之象。';
        break;
      case '寅时':
        range = '03:00 ~ 05:00';
        zodiacSign = '虎';
        earthlyBranchesMeaning =
        '演也，津也，寒土中屈曲的草木，迎着春阳从地面伸展。\n为树木，木林，死木为家具，活木为家具。引申为会所，楼宇，组织，因六壬中寅为功曹，故寅也引申为政府机关，文化场所，但是必须是以寅木为印才是政府机关的，如果寅木为财就是木材了。于人体为头，为手，为肢体，肝胆，毛发，经脉通于毛发，故也主神经。';
        break;
      case '卯时':
        range = '05:00 ~ 07:00';
        zodiacSign = '兔';
        earthlyBranchesMeaning =
        '茂也，日照东方，万物滋茂。\n花木类，弯曲的，绳索木工，兵器（带羊刃时），植物，木材建材，车船街道（因为卯木为太冲），到门户上又是印星则为车。为门窗，床，篱笆，机构，网络，肝胆，四肢，手指，腰，毛发。';
        break;
      case '辰时':
        range = '07:00 ~ 09:00';
        zodiacSign = '龙';
        earthlyBranchesMeaning =
        '震也，万物震起而长，阳气生发已经过半。\n湿土，泥巴，水土，水库，堤岸，池塘，水中田园，土产，牢狱（因辰为天罗地网），建筑，车辆机器，大机构，旧屋，辰为食神为中药，思想，网络，膀胱，肌肤，肩，胸。丙辰日主，本来为食神又是辰土，为思想。';
        break;
      case '巳时':
        range = '09:00 ~ 011:00';
        zodiacSign = '蛇';
        earthlyBranchesMeaning =
        '起也，万物盛长而起，阴气消尽，纯阳无阴。\n阴火，温暖，文化，文章，务虚。与丙火不一样，巳火是阴阳的聚合物，既阴又阳，变化莫测，如果柱中有巳火，这个人的性格可能有变色龙的倾向。还为色彩影像，网络，道路，闹市。于人体为眼目，三焦，咽，面，神经，心脏，小肠。';
        break;
      case '午时':
        range = '11:00 ~ 13:00';
        zodiacSign = '马';
        earthlyBranchesMeaning =
        '万物丰满长大，阳气充盛，阴气开始萌生。\n直来直去，特热，大火，阳光，火光，广告，文字，语言，机动，打杀，剧场。午火为热闹的地方，体现视觉冲击力的火。于人体为小肠，眼睛，舌，神经，血液，精力。';
        break;
      case '未时':
        range = '13:00 ~ 15:00';
        zodiacSign = '羊';
        earthlyBranchesMeaning =
        '味也，果实成熟而有滋味。\n为温土，田园，公园，庭院，林场。为休闲，陶冶，酒店，饰物。未也为房地产，酒店（木土之象为地产，建筑物）营造，化工，为食神时主医药。于人体为脾胃，脘腹，口腔，肌肤。';
        break;
      case '申时':
        range = '15:00 ~ 17:00';
        zodiacSign = '猴';
        earthlyBranchesMeaning =
        '身也，物体都已长成。\n与庚相似，刀，剑，戈，兵，司法，军队，公检法。矿物，车辆，金融，数学等。配十神含义。于人体为肺，大肠，脊，牙齿，气管。申金与火相配主武职。带上羊刃七杀羊刃伤官，也主武职。带伤官为检察院、纪委，带羊刃为公安、军队。';
        break;
      case '酉时':
        range = '17:00 ~ 19:00';
        zodiacSign = '鸡';
        earthlyBranchesMeaning =
        '酉，就也。万物到这时都收缩收敛。\n金石，加工好的，器皿，道路，酒店。传媒，信息，技术，玄学，技巧，阴中之阴。于人体为肺，肋，小肠，牙齿。';
        break;
      case '戌时':
        range = '19:00 ~ 21:00';
        zodiacSign = '狗';
        earthlyBranchesMeaning =
        '灭也，草木凋零，生气灭绝。\n燥土，窑冶，炉，枪，火药，牢狱，刑罚，甘霖，古墓，庙宇，市场，色情场所，化工。属于火库，枪弹库，还有戊土之象。如为伤官库、官库易为庙宇，为食神库为学校，也有编辑部的象，因为戌是火库，文明之象。影院，市场，互联网，热闹的地方。戌主数学，戌亥为乾宫，主数学。';
        break;
      case '亥时':
        range = '21:00 ~ 23:00';
        zodiacSign = '猪';
        earthlyBranchesMeaning =
        '劾也，阴气劾杀万物，到此已达极点。\n科技，运算，网络。亥水容易当会计，总和数字打交道。小孩考试考得好不好，要从命理上先分学科。戌亥为数学，丙丁火为语文，丙丁火到时上年上为外语，火为朱雀为说话文章之意，戌未为化学，酉金为物理申金有时也是。木火属文，金水属理，月令年为历史，代表祖国祖先，月令有用，喜欢传统文化。月令弄到时上者，能够古为今用也。';
        break;
    // Add more cases for other types
      default:
        break;
    }


    return Column(
      children: [
        Text(
          "$text",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Alimama',
            color: Color.fromRGBO(29, 29, 29, 1),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "范围:$range\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "生肖:$zodiacSign\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "含义:$earthlyBranchesMeaning\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Alibaba',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(29, 29, 29, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  // 将按钮包裹在 Center 小部件中以水平居中
                  // Center(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       _launchURL('https://www.yuque.com/xiumuzidiao-ksdwi/mgkguq'); // Replace with your URL
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Color.fromRGBO(0, 125, 255, 1), // 背景颜色蓝色
                  //       foregroundColor: Colors.white, // 文字颜色白色
                  //       textStyle: TextStyle(
                  //         fontFamily: 'Alimama', // 字体为 Alimama
                  //         fontSize: 16, // 字体大小，可以根据需要调整
                  //       ),
                  //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 按钮内边距，可以根据需要调整
                  //     ),
                  //     child: Text('更多小六壬内容'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: Text(
              "关闭",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(0, 125, 255, 1),
                fontFamily: 'Alimama',
                decoration: TextDecoration.none,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );

  }
}





//基本信息
class BasicInformation extends StatelessWidget {
  final Map<String, int> relations;

  BasicInformation({required this.relations});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // Increased radius for rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '基本信息',
            style: TextStyle(
              fontSize: 24, // Larger font size
              fontFamily: 'Alimama', // Custom font
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildRelationRow('天人关系', '天宫(', relations['tianRenRelation'], ')人宫'),
          SizedBox(height: 20),
          _buildRelationRow('地人关系', '地宫(', relations['diRenRelation'], ')人宫'),
          SizedBox(height: 20),
          _buildRelationRow('天地关系', '天宫(', relations['tianDiRelation'], ')地宫'),
          SizedBox(height: 20),
          _buildRelationRow('体用关系','', relations['tiYongRelation'],''),
        ],
      ),
    );
  }

  Widget _buildRelationRow(String label, String prefix, int? relation, String suffix) {
    String relationText = '$prefix ${_getRelationText(label, relation)} $suffix';
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontFamily: "Alimama"),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundedBox(relationText, 16),
            ],
          ),
        ),
      ],
    );
  }


  String _getRelationText(String label, int? relation) {
    switch (label) {
      case '天人关系':
      case '地人关系':
      case '天地关系':
        switch (relation) {
          case 1:
            return '生';
          case 2:
            return '被生';
          case 3:
            return '比肩';
          case 4:
            return '克';
          case 5:
            return '被克';
          default:
            return '未知关系';
        }
      case '体用关系':
        switch (relation) {
          case 1:
            return '用生体-大吉';
          case 2:
            return '体克用-小吉';
          case 3:
            return '用克体-大凶';
          case 4:
            return '体生用-小凶';
          case 5:
            return '比肩';
          case 6:
            return '比肩';
          default:
            return '未知关系';
        }
      default:
        return '未知关系';
    }
  }

  Widget _buildRoundedBox(String text, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 125, 255, 1), // Customize color as needed
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "Alimama",
        ),
      ),
    );
  }
}





// 转太极
class TurningTaiJi extends StatefulWidget {
  final Map<String, String> results;

  TurningTaiJi({required this.results});

  @override
  _TurningTaiJiState createState() => _TurningTaiJiState();
}

class _TurningTaiJiState extends State<TurningTaiJi> {
  Map<int, Map<int, String>> selectedTexts = {
    0: {0: '留连', 1: '留连', 2: '留连'},
    1: {0: '留连', 1: '留连', 2: '留连'},
    2: {0: '留连', 1: '留连', 2: '留连'},
    3: {0: '留连', 1: '留连', 2: '留连'},
    4: {0: '留连', 1: '留连', 2: '留连'},
  };

  @override
  void initState() {
    super.initState();
    _initializeResults();
  }

  void _initializeResults() {
    Map<String, String> liuQinResults = zhuanTaiJi(widget.results);
    List<String> labels = ['父母', '妻财', '官鬼', '兄弟', '子孙'];
    for (int i = 0; i < labels.length; i++) {
      List<String> parts = liuQinResults[labels[i]]!.split(', ');
      for (int j = 0; j < parts.length; j++) {
        selectedTexts[i]![j] = parts[j];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '转太极',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Alimama',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildRelationRow(0, '父母', selectedTexts[0]!.values.toList()),
          SizedBox(height: 20),
          _buildRelationRow(1, '妻财', selectedTexts[1]!.values.toList()),
          SizedBox(height: 20),
          _buildRelationRow(2, '官鬼', selectedTexts[2]!.values.toList()),
          SizedBox(height: 20),
          _buildRelationRow(3, '兄弟', selectedTexts[3]!.values.toList()),
          SizedBox(height: 20),
          _buildRelationRow(4, '子孙', selectedTexts[4]!.values.toList()),
        ],
      ),
    );
  }

  Widget _buildRelationRow(int rowIndex, String label, List<String> texts) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontFamily: "Alimama"),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: texts.asMap().entries.map((entry) {
            int index = entry.key;
            String text = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: _buildRoundedBox(rowIndex, index, text),
            );
          }).toList(),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildRoundedBox(int rowIndex, int index, String text) {
    return SizedBox(
      width: 70, // Set the fixed width
      height: 50, // Set the fixed height
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 125, 255, 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: text == '留连' || text == '空亡'
            ? DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedTexts[rowIndex]![index],
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            iconSize: 10,
            elevation: 16,
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Alimama"),
            dropdownColor: Color.fromRGBO(0, 125, 255, 1),
            onChanged: (String? newValue) {
              setState(() {
                selectedTexts[rowIndex]![index] = newValue!;
              });
            },
            items: <String>['留连', '空亡', selectedTexts[rowIndex]![index] ?? '']
                .where((element) => element.isNotEmpty) // 过滤掉空字符串
                .toSet() // 使用 Set 去重
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  width: 40, // Set the width of the dropdown items
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        )
            : _buildStaticBox(text, 16),
      ),
    );
  }


  Widget _buildStaticBox(String text, double fontSize) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "Alimama",
        ),
      ),
    );
  }
}






// 三宫具象法
class ThreeGongConcretization extends StatefulWidget {
  final Map<String, List<String>> threeGongResults;

  ThreeGongConcretization({required this.threeGongResults});

  @override
  _ThreeGongConcretizationState createState() => _ThreeGongConcretizationState();
}

class _ThreeGongConcretizationState extends State<ThreeGongConcretization> {
  Map<int, Map<int, String>> selectedTexts = {
    0: {0: '留连', 1: '留连', 2: '留连'},
    1: {0: '留连', 1: '留连', 2: '留连'},
    2: {0: '留连', 1: '留连', 2: '留连'},
  };

  @override
  void initState() {
    super.initState();
    selectedTexts = {
      0: {0: widget.threeGongResults['tianPan']![0], 1: widget.threeGongResults['tianPan']![1], 2: widget.threeGongResults['tianPan']![2]},
      1: {0: widget.threeGongResults['diPan']![0], 1: widget.threeGongResults['diPan']![1], 2: widget.threeGongResults['diPan']![2]},
      2: {0: widget.threeGongResults['renPan']![0], 1: widget.threeGongResults['renPan']![1], 2: widget.threeGongResults['renPan']![2]},
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '三宫具象',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Alimama',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildRelationRow(0, '天盘', selectedTexts[0]!.values.toList()),
          SizedBox(height: 20),
          _buildRelationRow(1, '地盘', selectedTexts[1]!.values.toList()),
          SizedBox(height: 20),
          _buildRelationRow(2, '人盘', selectedTexts[2]!.values.toList()),
        ],
      ),
    );
  }

  Widget _buildRelationRow(int rowIndex, String label, List<String> texts) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontFamily: "Alimama"),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: texts.asMap().entries.map((entry) {
            int index = entry.key;
            String text = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: _buildRoundedBox(rowIndex, index, text),
            );
          }).toList(),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildRoundedBox(int rowIndex, int index, String text) {
    return SizedBox(
      width: 70, // Set the fixed width
      height: 50, // Set the fixed height
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 125, 255, 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: text == '留连' || text == '空亡'
            ? DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedTexts[rowIndex]![index],
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            iconSize: 10,
            elevation: 16,
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Alimama"),
            dropdownColor: Color.fromRGBO(0, 125, 255, 1),
            onChanged: (String? newValue) {
              setState(() {
                selectedTexts[rowIndex]![index] = newValue!;
              });
            },
            items: <String>['留连', '空亡', selectedTexts[rowIndex]![index] ?? '']
                .where((element) => element.isNotEmpty) // 过滤掉空字符串
                .toSet() // 使用 Set 去重
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  width: 40, // Set the width of the dropdown items
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        )
            : _buildStaticBox(text, 16),
      ),
    );
  }

  Widget _buildStaticBox(String text, double fontSize) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "Alimama",
        ),
      ),
    );
  }
}



// 八卦具象法
class BaGuaConcretization extends StatelessWidget {
  final String baGuaResult;

  BaGuaConcretization({required this.baGuaResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // Increased radius for rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '八卦具象',
            style: TextStyle(
              fontSize: 24, // Larger font size
              fontFamily: 'Alimama', // Custom font
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildRelationRow('八卦', baGuaResult),
          SizedBox(height: 20),
          // Add new section title
          // Text(
          //   '图示',
          //   style: TextStyle(
          //     fontSize: 20, // Smaller font size for subtitle
          //     fontFamily: 'Alimama', // Custom font
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildRelationRow(String label, String text) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontFamily: "Alimama"),
        ),
        Spacer(),
        _buildRoundedBox(text, 16),
        Spacer(),
      ],
    );
  }

  Widget _buildRoundedBox(String text, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 125, 255, 1), // Customize color as needed
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "Alimama",
        ),
      ),
    );
  }
}


//风水
class FengShui extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // Increased radius for rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '风水',
            style: TextStyle(
              fontSize: 24, // Larger font size
              fontFamily: 'Alimama', // Custom font
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildRelationRow('坐向', '西方'),
          SizedBox(height: 20),
          _buildRelationRow('朝向', '东方'),
          SizedBox(height: 20),
          _buildRelationRow('入气', '东南'),
          SizedBox(height: 20),
          // Add new section title
          Text(
            '宅外八方',
            style: TextStyle(
              fontSize: 20, // Smaller font size for subtitle
              fontFamily: 'Alimama', // Custom font
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildRelationRow('南方', '南方为震(大安)'),
          SizedBox(height: 20),
          _buildRelationRow('北方', '北方为兑(赤口)'),
          SizedBox(height: 20),
          _buildRelationRow('东方', '东方为坎(小吉)'),
          SizedBox(height: 20),
          _buildRelationRow('西方', '南方为离(速喜)'),
          SizedBox(height: 20),
          _buildRelationRow('西北', '西北为坤(留连)'),
          SizedBox(height: 20),
          _buildRelationRow('东北', '东北为乾(留连)'),
          SizedBox(height: 20),
          _buildRelationRow('西南', '西南为巽(留连)'),
          SizedBox(height: 20),
          _buildRelationRow('东南', '西南为巽(留连)'),
          SizedBox(height: 20),

          // Add new section title
          Text(
            '宅内八方',
            style: TextStyle(
              fontSize: 20, // Smaller font size for subtitle
              fontFamily: 'Alimama', // Custom font
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildRelationRow('南方', '南方为震(大安)'),
          SizedBox(height: 20),
          _buildRelationRow('北方', '北方为兑(赤口)'),
          SizedBox(height: 20),
          _buildRelationRow('东方', '东方为坎(小吉)'),
          SizedBox(height: 20),
          _buildRelationRow('西方', '南方为离(速喜)'),
          SizedBox(height: 20),
          _buildRelationRow('西北', '西北为坤(留连)'),
          SizedBox(height: 20),
          _buildRelationRow('东北', '东北为乾(留连)'),
          SizedBox(height: 20),
          _buildRelationRow('西南', '西南为巽(留连)'),
          SizedBox(height: 20),
          _buildRelationRow('东南', '西南为巽(留连)'),
        ],
      ),
    );
  }

  Widget _buildRelationRow(String label, String text) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontFamily: "Alimama"),
        ),
        Spacer(),
        _buildRoundedBox(text, 16),
        Spacer(),
      ],
    );
  }

  Widget _buildRoundedBox(String text, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 125, 255, 1), // Customize color as needed
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: "Alimama",
        ),
      ),
    );
  }
}
