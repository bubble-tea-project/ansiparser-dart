import 'package:ansiparser/ansiparser.dart';
import 'package:test/test.dart';

void main() {
  //
  test('Test 1', () {
    var check_1 = "[31mRED[0m [32mGREEN[0m [34mBLUE[0m";
    var ans_1 = [
      '<div class="line"><span class="fg_red">RED</span><span class=""> </span><span class="fg_green">GREEN</span><span class=""> </span><span class="fg_blue">BLUE</span></div>'
    ];

    var ansipScreen = newScreen();

    ansipScreen.put(check_1);
    ansipScreen.parse();

    var to_check_1 = ansipScreen.toHtml();

    expect(to_check_1.toString(), equals(ans_1.toString()));
  });

  test('Test 2', () {
    var check_2 = """[1;34mHello   [1;3H[47mW    

[m您現在位於
[0m系統負載: 輕輕鬆鬆[2;6H[m(140.112.172.11)""";

    var ans_2 = [
      '<div class="line"><span class="bold fg_blue">He</span><span class="bold fg_blue bg_white">W    </span><span class="bold fg_blue"> </span></div>',
      '<div class="line"><span class="">     (140.112.172.11)</span></div>',
      '<div class="line"><span class="">       您現在位於</span></div>',
      '<div class="line"><span class="">                 系統負載: 輕輕鬆鬆</span></div>'
    ];

    var ansipScreen = newScreen();

    ansipScreen.put(check_2);
    ansipScreen.parse();

    var to_check = ansipScreen.toHtml();

    expect(to_check.toString(), equals(ans_2.toString()));
  });

  test('Test 3', () {
    var check = "Hello\nWorld";
    var ans = [
      '<div class="line"><span class="">Hello</span></div>',
      '<div class="line"><span class="">     World</span></div>'
    ];

    var ansipScreen = newScreen();

    ansipScreen.put(check);
    ansipScreen.parse();

    var to_check = ansipScreen.toHtml();

    expect(to_check.toString(), equals(ans.toString()));
  });

  test('Test 4', () {
    var check = [];

    check.addAll([
      '\x1b[H\x1b[34;47m 作者 \x1b[0;44m es9114ian ()                                             \x1b[34;47m 看板 \x1b[0;44m C_Chat \x1b[m\x1b[K\r\n\x1b[34;47m 標題 \x1b[0;44m [討論] 膽大黨 167 厄卡倫的體能                                         \r\n\x1b[34;47m 時間 \x1b[0;44m Mon Sep 23 23:14:44 2024                                               \x1b[m\x1b[K\r\n  \x08\x08\x1b[36m─\x1b[4;3H  \x08\x08─\x1b[4;5H  \x08\x08─\x1b[4;7H  \x08\x08─\x1b[4;9H  \x08\x08─\x1b[4;11H  \x08\x08─\x1b[4;13H  \x08\x08─\x1b[4;15H  \x08\x08─\x1b[4;17H  \x08\x08─\x1b[4;19H  \x08\x08─\x1b[4;21H  \x08\x08─\x1b[4;23H  \x08\x08─\x1b[4;25H  \x08\x08─\x1b[4;27H  \x08\x08─\x1b[4;29H  \x08\x08─\x1b[4;31H  \x08\x08─\x1b[4;33H  \x08\x08─\x1b[4;35H  \x08\x08─\x1b[4;37H  \x08\x08─\x1b[4;39H  \x08\x08─\x1b[4;41H  \x08\x08─\x1b[4;43H  \x08\x08─\x1b[4;45H  \x08\x08─\x1b[4;47H  \x08\x08─\x1b[4;49H  \x08\x08─\x1b[4;51H  \x08\x08─\x1b[4;53H  \x08\x08─\x1b[4;55H  \x08\x08─\x1b[4;57H  \x08\x08─\x1b[4;59H  \x08\x08─\x1b[4;61H  \x08\x08─\x1b[4;63H  \x08\x08─\x1b[4;65H  \x08\x08─\x1b[4;67H  \x08\x08─\x1b[4;69H  \x08\x08─\x1b[4;71H  \x08\x08─\x1b[4;73H  \x08\x08─\x1b[4;75H  \x08\x08─\x1b[4;77H  \x08\x08─\x1b[4;79H\r\n\x1b[m\x1b[K\n傳送門\x1b[K\r\nhttps://shonenjumpplus.com/episode/17106567255342704977\r\n\x1b[K\nhttps://i.imgur.com/j9AI79P.jpeg\x1b[K\r\n上一話發現的小爺爺消失了，厄卡倫說那似乎是一種UMA（這種小爺爺UMA現實也是存在的嗎\r\n？）\x1b[K\r\nhttps://i.imgur.com/7w7PvlS.jpeg\x1b[K\r\nhttps://i.imgur.com/MNMzgyD.jpeg\x1b[K\r\n跳到後面體能測試，\x1b[K\r\n厄卡倫跑50M從原本的9秒縮短到5秒8。\x1b[K\r\nhttps://i.imgur.com/KDKnKx2.jpeg\x1b[K\r\n其他同學丟手球丟15M，厄卡倫能丟到35M。\x1b[K\r\nhttps://i.imgur.com/872bSnD.jpeg\x1b[K\r\n立定跳遠3M60（也太扯了吧w）\x1b[K\r\n反覆橫跑80次。\x1b[K\r\nhttps://i.imgur.com/RY8r16i.jpeg\x1b[K\r\nシャトルラン（日本其中一種體能測驗）能反覆跑120次，厄卡倫已經完全不是個普通人了w\r\n高速婆婆的力量明明已經消失，但之前做的各種鍛鍊讓厄卡倫的體能變得超強。\r\n\x1b[33;45m  瀏覽 第 1/5 頁 ( 11%) \x1b[1;30;47m 目前顯示: 第 01~22 行\x1b[0;47m  \x1b[31m(y)\x1b[30m回應\x1b[31m(X%)\x1b[30m推文\x1b[31m(h)\x1b[30m說明\x1b[31m(  \x08\x08←\x1b[24;74H)\x1b[30m離開\x1b[m\x1b[24;80H'
    ]);
    check.addAll([
      '\x1b[H高速婆婆的力量明明已經消失，但之前做的各種鍛鍊讓厄卡倫的體能變得超強。\x1b[K\r\n\x1b[K\n----\x1b[K\r\nSent from \x1b[1;34mBePTT \x1b[mon my ASUS_I006D\x1b[K\r\n\n--\x1b[K\r\n  \x08\x08\x1b[32m※\x1b[7;3H 發信站: 批踢踢實業坊(ptt.cc), 來自: 111.71.22.126 (臺灣)\r\n  \x08\x08※\x1b[8;3H 文章網址: https://www.ptt.cc/bbs/C_Chat/M.1727104486.A.198.html\r\n\x1b[0;1;37m推 \x1b[33megg781\x1b[0;33m: 那股力量令人在意的是最後一次使用時有點不對勁            \x1b[m09/23 23:16\r\n  \x08\x08\x1b[32m※\x1b[10;3H 編輯: es9114ian (111.71.22.126 臺灣), 09/23/2024 23:16:58\x1b[m\x1b[K\r\n  \x08\x08\x1b[1;31m→\x1b[11;3H \x1b[33megg781\x1b[0;33m: 高速婆婆看起來像把變質的力量回收避免厄卡倫被反噬        \x1b[m09/23 23:17\r\n  \x08\x08\x1b[32m※\x1b[12;3H 編輯: es9114ian (111.71.22.126 臺灣), 09/23/2024 23:18:13\r\n\x1b[0;1;37m推 \x1b[33mqk3380888\x1b[0;33m: 那個婆婆不需要了                                     \x1b[m09/23 23:18\r\n\x1b[1;37m推 \x1b[33mqwe88016\x1b[0;33m: 跟太監一樣，沒有蛋蛋體能會比較好                      \x1b[m09/23 23:18\r\n\x1b[1;37m推 \x1b[33mmikeneko\x1b[0;33m: 百年難得一見的練武奇才                                \x1b[m09/23 23:18\r\n  \x08\x08\x1b[1;31m→\x1b[16;3H \x1b[33meva05s\x1b[0;33m: 小小大叔算是滿有名的都市傳說，據說經常出現在醉倒半夢    \x1b[m09/23 23:20\r\n  \x08\x08\x1b[1;31m→\x1b[17;3H \x1b[33meva05s\x1b[0;33m: 半醒的人面前                                            \x1b[m09/23 23:20\r\n  \x08\x08\x1b[1;31m→\x1b[18;3H \x1b[33meva05s\x1b[0;33m: 大叔系都市傳說還有個也很有名的超時空管理者大叔，不確    \x1b[m09/23 23:20\r\n  \x08\x08\x1b[1;31m→\x1b[19;3H \x1b[33meva05s\x1b[0;33m: 定這部用過沒有                                          \x1b[m09/23 23:20\r\n\x1b[1;37m推 \x1b[33mgully\x1b[0;33m: 好像有一部的主角也是體能超強   叫什麼來著?  很爛的漫畫   \x1b[m09/23 23:23\r\n\x1b[1;37m推 \x1b[33mwenku8com\x1b[0;33m: 高速婆婆的術式已經刻在你身上了                       \x1b[m09/23 23:23\r\n  \x08\x08\x1b[1;31m→\x1b[22;3H \x1b[33meva05s\x1b[0;33m: 單純體能很強的主角不少吧....隨便猜個魔法榴彈，或者漂   \x1b[m 09/23 23:25\x1b[K\r\n  \x08\x08\x1b[1;31m→\x1b[23;3H \x1b[33meva05s\x1b[0;33m: 亮煉丹                                                 \x1b[m 09/23 23:25\r\n\x1b[34;46m  瀏覽 第 2/5 頁 ( 33%) \x1b[24;39H\x1b[1;30;47m22~44\x1b[24;72H  \x08\x08\x1b[0;31;47m←\x1b[24;74H\x1b[m\x1b[24;80H'
    ]);
    check.addAll([
      '\x1b[H  \x08\x08\x1b[1;31m→\x1b[1;3H \x1b[33meva05s\x1b[0;33m: 亮煉丹                                                 \x1b[m 09/23 23:25\r\n  \x08\x08\x1b[1;31m→\x1b[2;3H \x1b[33meva05s\x1b[0;33m: 魔法零蛋跟漂亮臉蛋....                                  \x1b[m09/23 23:25\r\n\x1b[1;37m推 \x1b[33mmacocu\x1b[0;33m: 10部戰鬥番，9部主角體能強吧...                          \x1b[m09/23 23:25\r\n  \x08\x08\x1b[1;31m→\x1b[4;3H \x1b[33mhaha98\x1b[0;33m: 靠腰 跟第一話比起來變帥又變強 難怪這麼多女人愛          \x1b[m09/23 23:26\r\n\x1b[1;37m推 \x1b[33mCCNK\x1b[0;33m: 小小老頭啊 就日本都市傳說                                 \x1b[m09/23 23:30\r\n\x1b[1;37m推 \x1b[33mCCNK\x1b[0;33m: https://tinyurl.com/22mpoquj                              \x1b[m09/23 23:32\r\n\x1b[1;37m推 \x1b[33mherry0815\x1b[0;33m: 蛋蛋不是回來了？                                     \x1b[m09/23 23:32\r\n\x1b[1;37m推 \x1b[33methan1988\x1b[0;33m: 那個說很爛漫畫是想酸咒..吧                           \x1b[m09/23 23:32\r\n  \x08\x08\x1b[1;31m→\x1b[9;3H \x1b[9;5H\x1b[33mva05s\x1b[9;12H\x1b[0;33m搞不好是馬修                                \x1b[9;67H\x1b[m \x1b[9;77H33\r\n\x1b[1;37m推 \x1b[33manomic24\x1b[0;33m: 他現在這個髮型真的比一開始好很多                      \x1b[m09/23 23:37\r\n  \x08\x08\x1b[1;31m→\x1b[11;3H \x1b[33manomic24\x1b[0;33m: 不知道小爺爺會不會再出現？會不會跟讓小桃恢復原狀有\x1b[11;77H\x1b[m3\r\n  \x08\x08\x1b[1;31m→\x1b[12;3H \x1b[33manomic24\x1b[0;33m: 關係？                                                \x1b[m09/23 23:37\x1b[13;4H\x1b[1;33maegis43210\x1b[0;33m: 現在的表現有一堆女人愛很正常\x1b[13;77H\x1b[m39\x1b[14;4H\x1b[1;33mnewtypeL9\x1b[0;33m: 變成光速蒙面俠等級了           \x1b[14;77H\x1b[m39\x1b[15;5H\x1b[1;33maple2378\x1b[0;33m: 感覺高倉臉也變帥了 錯覺嗎==\x1b[15;77H\x1b[m40\r\n\x1b[1;37m推 \x1b[33mtoulio81\x1b[0;33m: 我也覺得跟高速婆婆的力量有關，但如果是因為蛋蛋被做\x1b[16;77H\x1b[m48\r\n  \x08\x08\x1b[1;31m→\x1b[17;3H \x1b[33mtoulio81\x1b[0;33m: 了什麼，導致意外獲得力量更有趣\x1b[17;77H\x1b[m48\r\n\x1b[1;37m推 \x1b[33mRaiGend0519\x1b[0;33m: 光速蒙面俠40碼瀨那是4.1秒                      \x1b[18;77H\x1b[m57\r\n  \x08\x08\x1b[1;31m→\x1b[19;3H \x1b[33mRaiGend0519\x1b[0;33m: 厄卡倫60M 5.8秒，換算40碼是3.53秒\x1b[19;77H\x1b[m57\r\n  \x08\x08\x1b[1;31m→\x1b[20;3H \x1b[33mRaiGend0519\x1b[0;33m: 看這話是無意識在跑，集中精神爆發可能更快        \x1b[20;77H\x1b[m58\r\n  \x08\x08\x1b[1;31m→\x1b[21;3H \x1b[33mRaiGend0519\x1b[0;33m: 總覺得這話的意義是厄卡倫會跟綾瀨一樣發展出自己的\x1b[21;77H\x1b[m59\r\n  \x08\x08\x1b[1;31m→\x1b[22;3H \x1b[33mRaiGend0519\x1b[0;33m: 能力，畢竟...蛋蛋那麼強= ="                    \x1b[22;77H\x1b[m59\r\n\x1b[1;37m推 \x1b[33mreallurker\x1b[0;33m: 蛋蛋都回來了 蛋蛋的力量\x1b[23;72H\x1b[m4 00:08\x1b[24;11H\x1b[34;46m3\x1b[24;20H6\x1b[24;39H\x1b[1;30;47m44~66\x1b[24;72H  \x08\x08\x1b[0;31;47m←\x1b[24;74H\x1b[m\x1b[24;80H'
    ]);
    check.addAll([
      '\x1b[H\x1b[1;37m推 \x1b[33mreallurker\x1b[0;33m: 蛋蛋都回來了 蛋蛋的力量\x1b[1;72H\x1b[m4 00:08\r\n\x1b[1;37m推 \x1b[33mKylelightman\x1b[0;33m: 50M 5.8秒吧 所以算一下跟瀨那的速度一樣了\x1b[2;72H\x1b[m4 00:14\r\n  \x08\x08\x1b[1;31m→\x1b[3;3H \x1b[33mKylelightman\x1b[0;33m: 厄卡倫好猛              \x1b[3;72H\x1b[m4 00:14\r\n  \x08\x08\x1b[1;31m→\x1b[4;3H \x1b[33mRushMonkey\x1b[0;33m: 看來不需要什麼婆婆了 (x                   \x1b[4;72H\x1b[m4 00:15\x1b[5;4H\x1b[1;33mneroASHS\x1b[0;33m: 折返跑120橫紋肌還在？\x1b[5;72H\x1b[m4 00:18\x1b[6;4H\x1b[1;33mLittleJade\x1b[0;33m: 鍛鍊有成              \x1b[6;72H\x1b[m4 00:20\x1b[7;4H\x1b[1;33mCharmQuarkJr\x1b[0;33m: 問就是宿儺...高速婆婆的術式已經刻在厄卡倫的體內\x1b[7;72H\x1b[m4 00:21\x1b[8;4H\x1b[1;33miundertaker\x1b[0;33m: 主角要開始像隔壁那位一樣使用揍術了嗎\x1b[8;72H\x1b[m4 00:46\r\n\x1b[1;37m推 \x1b[33mDA3921999\x1b[0;33m: 再打出幾發黑閃就能使用完整術式了\x1b[9;72H\x1b[m4 01:38\r\n  \x08\x08\x1b[1;31m→\x1b[10;3H \x1b[33mDepthsharky\x1b[0;33m: 還是奶奶沒收走力量，怕爺爺封印奪走，自己去當餌\x1b[10;72H\x1b[m4 01:4\r\n\x1b[1;37m推 \x1b[33mhenry65\x1b[11;14H\x1b[0;33m變成體育生了  \x08\x08…\x1b[11;28H什麼時候打出黑閃？                  \x1b[11;72H\x1b[m4 02:44\r\n\x1b[1;37m推 \x1b[33micecube0413\x1b[0;33m: 蛋蛋之力\x1b[12;72H\x1b[m4 03:58\x1b[13;4H\x1b[1;33mFreeven\x1b[0;33m: 蛋蛋都回來了 蛋蛋的力量        \x1b[13;72H\x1b[m4 06:10\x1b[14;4H\x1b[1;33mkuff220\x1b[0;33m: 欸等等也太強XDD       \x1b[14;72H\x1b[m4 06:16\r\n  \x08\x08\x1b[1;31m→\x1b[15;3H \x1b[33mAmeNe43189\x1b[0;33m: 蛋蛋才是最強的吧= =       \x1b[15;72H\x1b[m4 06:25\x1b[16;4H\x1b[1;33mj022015\x1b[0;33m: 刻有蛋蛋術式了                                     \x1b[16;72H\x1b[m4 07:2\r\n\x1b[1;37m推 \x1b[33mstoryo41662\x1b[0;33m: 蛋蛋的力量...百米11.6，身高都還沒破1.8米根本也是\x1b[17;72H\x1b[m4 08:07\r\n  \x08\x08\x1b[1;31m→\x1b[18;3H \x1b[33mstoryo41662\x1b[18;17H\x1b[0;33m妖怪了吧？               \x1b[18;72H\x1b[m4 08:0\r\n\x1b[1;37m推 \x1b[33mtsaodin0220\x1b[19;17H\x1b[0;33m蛋蛋的力量                       \x1b[19;72H\x1b[m4 08:23\r\n\x1b[1;37m推 \x1b[33mdbfox\x1b[0;33m: 處男三十歲會變魔法師，這是提早把力量開發出來了嗎(誤\x1b[20;72H\x1b[m4 08:41\r\n\x1b[1;37m推 \x1b[21;5H\x1b[33mune\x1b[0;33m: 速度約等於光速蒙面俠了  \x08\x08…\x1b[21;34H                               \x1b[21;72H\x1b[m4 09:30\r\n\x1b[1;37m推 \x1b[33mOhmaZiO\x1b[0;33m:    勾登 波滷 一定大拇指 。 體育老師高腰褲令人在意\x1b[22;72H\x1b[m4 09:38\x1b[23;4H\x1b[1;33mCRPKT\x1b[0;33m: 那小隻的比較接近 gnome 吧   \x1b[23;75H\x1b[m9:52\x1b[24;11H\x1b[34;46m4\x1b[24;20H9\x1b[24;39H\x1b[1;30;47m66~88\x1b[24;72H  \x08\x08\x1b[0;31;47m←\x1b[24;74H\x1b[m\x1b[24;80H'
    ]);
    check.addAll([
      '\x1b[24;1H\n\x1b[K\n\x1b[K\n\x1b[K\n\x1b[K\n\x1b[K\x1b[24;80H\x1b[19;1H\x1b[1;37m推 \x1b[33mmomoCry\x1b[0;33m: 眼鏡仔好帥 準備跟女同學搞暗戀NTR                      \x1b[m 09/24 10:13\x1b[K\r\n\x1b[1;37m推 \x1b[33mStBernand\x1b[0;33m: 小小大叔在另一部陰陽眼見子裡也有出現                 \x1b[m09/24 10:48\r\n\x1b[1;37m推 \x1b[33mmamamia0419\x1b[0;33m: 人體為了應付詛咒時期的速度會慢慢變強吧             \x1b[m09/24 12:24\r\n\x1b[1;37m推 \x1b[33mstrp\x1b[0;33m: DanDaDan 該不會就是蛋O蛋吧？中間的我想不到，可能是主角    \x1b[m09/24 19:16\r\n  \x08\x08\x1b[1;31m→\x1b[23;3H \x1b[33mstrp\x1b[0;33m: 原本就有的能力，不然蛋蛋可以開宇宙大門怎樣都不合理啊！    \x1b[m09/24 19:16\r\n\x1b[44m  瀏覽 第 5/5 頁 (100%) \x1b[1;30;47m 目前顯示: 第 71~93 行\x1b[0;47m  \x1b[31m(y)\x1b[30m回應\x1b[31m(X%)\x1b[30m推文\x1b[31m(h)\x1b[30m說明\x1b[31m(  \x08\x08←\x1b[24;74H)\x1b[30m離開 \x1b[m'
    ]);

    var ans_html = [
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">LittleJade</span><span class="fg_yellow">: 鍛鍊有成                                            </span><span class="">09/24 00:20</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">CharmQuarkJr</span><span class="fg_yellow">: 問就是宿儺...高速婆婆的術式已經刻在厄卡倫的體內   </span><span class="">09/24 00:21</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">iundertaker</span><span class="fg_yellow">: 主角要開始像隔壁那位一樣使用揍術了嗎               </span><span class="">09/24 00:46</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">DA3921999</span><span class="fg_yellow">: 再打出幾發黑閃就能使用完整術式了                    </span><span class=""> 09/24 01:38</span></div>',
      '<div class="line"><span class="bold fg_red">→ </span><span class="bold fg_yellow">Depthsharky</span><span class="fg_yellow">: 還是奶奶沒收走力量，怕爺爺封印奪走，自己去當餌     </span><span class="">09/24 01:47</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">henry654</span><span class="fg_yellow">: 變成體育生了…什麼時候打出黑閃？                      </span><span class="">09/24 02:44</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">icecube0413</span><span class="fg_yellow">: 蛋蛋之力                                           </span><span class="">09/24 03:58</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">Freeven</span><span class="fg_yellow">: 蛋蛋都回來了 蛋蛋的力量                                </span><span class="">09/24 06:10</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">kuff220</span><span class="fg_yellow">: 欸等等也太強XDD                                        </span><span class="">09/24 06:16</span></div>',
      '<div class="line"><span class="bold fg_red">→ </span><span class="bold fg_yellow">AmeNe43189</span><span class="fg_yellow">: 蛋蛋才是最強的吧= =                                 </span><span class="">09/24 06:25</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">j022015</span><span class="fg_yellow">: 刻有蛋蛋術式了                                         </span><span class="">09/24 07:28</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">storyo41662</span><span class="fg_yellow">: 蛋蛋的力量...百米11.6，身高都還沒破1.8米根本也是   </span><span class="">09/24 08:07</span></div>',
      '<div class="line"><span class="bold fg_red">→ </span><span class="bold fg_yellow">storyo41662</span><span class="fg_yellow">: 妖怪了吧？                                         </span><span class="">09/24 08:07</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">tsaodin0220</span><span class="fg_yellow">: 蛋蛋的力量                                         </span><span class="">09/24 08:23</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">dbfox</span><span class="fg_yellow">: 處男三十歲會變魔法師，這是提早把力量開發出來了嗎(誤      </span><span class="">09/24 08:41</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">Rune</span><span class="fg_yellow">: 速度約等於光速蒙面俠了…                                  </span><span class="">09/24 09:30</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">OhmaZiO</span><span class="fg_yellow">:    勾登 波滷 一定大拇指 。 體育老師高腰褲令人在意     </span><span class=""> 09/24 09:38</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">CRPKT</span><span class="fg_yellow">: 那小隻的比較接近 gnome 吧                               </span><span class=""> 09/24 09:52</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">momoCry</span><span class="fg_yellow">: 眼鏡仔好帥 準備跟女同學搞暗戀NTR                      </span><span class=""> 09/24 10:13</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">StBernand</span><span class="fg_yellow">: 小小大叔在另一部陰陽眼見子裡也有出現                 </span><span class="">09/24 10:48</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">mamamia0419</span><span class="fg_yellow">: 人體為了應付詛咒時期的速度會慢慢變強吧             </span><span class="">09/24 12:24</span></div>',
      '<div class="line"><span class="bold fg_white">推 </span><span class="bold fg_yellow">strp</span><span class="fg_yellow">: DanDaDan 該不會就是蛋O蛋吧？中間的我想不到，可能是主角    </span><span class="">09/24 19:16</span></div>',
      '<div class="line"><span class="bold fg_red">→ </span><span class="bold fg_yellow">strp</span><span class="fg_yellow">: 原本就有的能力，不然蛋蛋可以開宇宙大門怎樣都不合理啊！    </span><span class="">09/24 19:16</span></div>',
      '<div class="line"><span class="bg_blue">  瀏覽 第 5/5 頁 (100%) </span><span class="bold fg_black bg_white"> 目前顯示: 第 71~93 行</span><span class="bg_white">  </span><span class="fg_red bg_white">(y)</span><span class="fg_black bg_white">回應</span><span class="fg_red bg_white">(X%)</span><span class="fg_black bg_white">推文</span><span class="fg_red bg_white">(h)</span><span class="fg_black bg_white">說明</span><span class="fg_red bg_white">(←)</span><span class="fg_black bg_white">離開 </span></div>'
    ];

    var ans_str = [
      '推 LittleJade: 鍛鍊有成                                            09/24 00:20',
      '推 CharmQuarkJr: 問就是宿儺...高速婆婆的術式已經刻在厄卡倫的體內   09/24 00:21',
      '推 iundertaker: 主角要開始像隔壁那位一樣使用揍術了嗎               09/24 00:46',
      '推 DA3921999: 再打出幾發黑閃就能使用完整術式了                     09/24 01:38',
      '→ Depthsharky: 還是奶奶沒收走力量，怕爺爺封印奪走，自己去當餌     09/24 01:47',
      '推 henry654: 變成體育生了…什麼時候打出黑閃？                      09/24 02:44',
      '推 icecube0413: 蛋蛋之力                                           09/24 03:58',
      '推 Freeven: 蛋蛋都回來了 蛋蛋的力量                                09/24 06:10',
      '推 kuff220: 欸等等也太強XDD                                        09/24 06:16',
      '→ AmeNe43189: 蛋蛋才是最強的吧= =                                 09/24 06:25',
      '推 j022015: 刻有蛋蛋術式了                                         09/24 07:28',
      '推 storyo41662: 蛋蛋的力量...百米11.6，身高都還沒破1.8米根本也是   09/24 08:07',
      '→ storyo41662: 妖怪了吧？                                         09/24 08:07',
      '推 tsaodin0220: 蛋蛋的力量                                         09/24 08:23',
      '推 dbfox: 處男三十歲會變魔法師，這是提早把力量開發出來了嗎(誤      09/24 08:41',
      '推 Rune: 速度約等於光速蒙面俠了…                                  09/24 09:30',
      '推 OhmaZiO:    勾登 波滷 一定大拇指 。 體育老師高腰褲令人在意      09/24 09:38',
      '推 CRPKT: 那小隻的比較接近 gnome 吧                                09/24 09:52',
      '推 momoCry: 眼鏡仔好帥 準備跟女同學搞暗戀NTR                       09/24 10:13',
      '推 StBernand: 小小大叔在另一部陰陽眼見子裡也有出現                 09/24 10:48',
      '推 mamamia0419: 人體為了應付詛咒時期的速度會慢慢變強吧             09/24 12:24',
      '推 strp: DanDaDan 該不會就是蛋O蛋吧？中間的我想不到，可能是主角    09/24 19:16',
      '→ strp: 原本就有的能力，不然蛋蛋可以開宇宙大門怎樣都不合理啊！    09/24 19:16',
      '  瀏覽 第 5/5 頁 (100%)  目前顯示: 第 71~93 行  (y)回應(X%)推文(h)說明(←)離開 '
    ];

    var ansipScreen = newScreen();

    for (var element in check) {
      ansipScreen.put(element);
      ansipScreen.parse();
    }

    var to_check_html = ansipScreen.toHtml();

    expect(to_check_html.toString(), equals(ans_html.toString()));

    var to_check_str = ansipScreen.toFormattedString();
    expect(to_check_str.toString(), equals(ans_str.toString()));
  });
}
