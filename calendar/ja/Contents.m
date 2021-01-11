% Financial Toolbox カレンダ関数
%
% 現在時刻と日付
%   today       - 現在日付
%   
% 日付と時刻のコンポ－ネント、およびフォーマット
%   datedisp    - 入力された日付からなる行列の表示
%   datefind    - 行列内の日付番号のインデックス
%   day         - 指定日付の日
%   eomdate     - 指定月の末日
%   hour        - 指定日、または時刻の時間の表示
%   lweekdate   - 指定月の最後の平日の日付
%   minute      - 指定日、または時刻の分の表示
%   month       - 指定日の月
%   months      - 指定した日付間の月数
%   m2xdate     - MATLAB 日付を EXCEL 日付に変換
%   nweekdate   - 月の指定された平日の日付
%   second      - 指定日、または時刻の秒の表示
%   x2mdate     - EXCEL 日付を MATLAB 日付に変換
%   year        - 指定日の年数
%   yeardays    - 指定年の日数
%   
% 金融日付
%   busdate     - 次の営業日、または前の営業日
%   datemnth    - 将来の月、または過去の月における日の日付
%   datewrkdy   - 将来、または過去の営業日の日付
%   days360     - 1年＝360日として計算された日付間の日数
%   days365     - 1年＝365日として計算された日付間の日数
%   daysdif     - ある日付カウント基準で計算された日付間の日数
%   daysact     - 現実の年に基づいて計算された日付間の日数
%   fbusdate    - 指定月の最初の営業日
%   holidays    - 休日及び休業日
%   isbusday    - 指定日が営業日かどうかを判定
%   lbusdate    - 月の最後の営業日
%   wrkdydif    - 指定した日付間の営業日数
%   yearfrac    - 指定した日付間の年の端数
%   
% クーポン債日付
%   accrfrac    - 経過利子クーポン期間の端数
%   cfamounts   - 指定した有価証券のキャッシュフローの額
%   cfdates     - 指定した有価証券に関するキャッシュフローの日付
%   cftimes     - 指定した有価証券に関するキャッシュフローの時間ファクタ
%   cfport      - キャッシュフローに対するポートフォリオのタイプ
%   cpncount    - 満期までのクーポン回数
%   cpndaten    - 指定日の後の次回クーポン支払日
%   cpndatenq   - 指定日の後の準 (quasi) クーポン支払日
%   cpndatep    - 指定日の前の前回クーポン支払日
%   cpndatepq   - 指定日の前の準クーポン支払日
%   cpndaysn    - 指定日と次回クーポン支払日間の日数
%   cpndaysp    - 指定日と前回クーポン支払日間の日数
%   cpnpersz    - 指定日を含む期間の日数のサイズ
%


% Copyright 1995-2006 The MathWorks, Inc. 
