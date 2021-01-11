%DATEMNTH  入力された月数だけ時間をずらすことにより、未来、また過去の日付を出力
%
%   TargetDate = datemnth(StartDate, NumberMonths, DayFlag,...
%        Basis, EndMonthRule)
%
%   詳細：この関数は、与えられた月数だけ時間をずらすことにより、ずらした
%         将来、または過去の日をシリアル番号日付で出力します。
%
%   入力:
%     StartDate - 最初の日付をシリアル番号日付、または、日付文字列で示す値で
%       構成される Nx1 または 1xN のベクトルです。
%     NumberMonths - 未来、または、過去にどれだけ時間をずらすのかを月数で
%       示す値で構成される Nx1 または 1xN のベクトルです。数値は整数でなければ
%       なりません。
%     DayFlag - 将来、または、過去の月の目標となる日付に対してどのような
%       実際の日付番号を出力するかを設定する値で構成される Nx1 または、
%       1xN のベクトルです。以下の値を設定します。
%       a) DayFlag = 0 (デフォルト) - 開始日の実際の日付番号に対応した
%             将来または過去の月の日付番号です。
%       b) DayFlag = 1 - 将来、または、過去の月の初日を示す日付番号です。
%       c) DayFlag = 2 - 将来、または、過去の月の末日を示す日付番号です。
%     Basis - 過去、または、将来の日付を出力するときに用いる日数計算方式
%       を示す Nx1 または 1xN のベクトル、または、スカラです。
%       以下の値を設定します。
%       1) Basis = 0 - actual/actual (デフォルト)
%       2) Basis = 1 - 30/360 SIA
%       3) Basis = 2 - actual/360
%       4) Basis = 3 - actual/365
%       5) Basis = 4 - 30/360 PSA
%       6) Basis = 5 - 30/360 ISDA
%       7) Basis = 6 - 30/360 ヨーロッパ
%       8) Basis = 7 - actual/365 日本
%       9) Basis = 8 - actual/actual ISMA
%      10) Basis = 9 - actual/360 ISMA
%      11) Basis = 10 - actual/365 ISMA
%      12) Basis = 11 - 30/360 ISMA
%      13) Basis = 12 - actual/365 ISDA
%     EndMonthRule - 月末規則が有効であるのかどうかを指定する Nx1 または 
%       1xN のベクトル、または、スカラ値です。
%       1) EndMonthRule = 1 - 規則が有効です (月の末日を最初の日付として
%             設定し、当該の月が 30 日以下の場合、将来または過去の対応する
%             月の日数が 28、29、30、または、31 日であるかどうかに関わらず、
%             対応する将来、または、過去の月の実際の末日が出力されるように
%             なります)。
%       2) EndMonthRule = 0 (デフォルト) - 月末規則は無効です。
%
%   出力:
%     TargetDate - 将来、または、過去の月の目標となる日を示すシリアル番号日付
%     で構成される Nx1 または 1xN のベクトルです。
%
%   例:
%     StartDate = '03-Jun-1997';
%     NumberMonths = 6;
%     DayFlag = 0;
%     Basis = 0;
%     EndMonthRule = 1;
%
%     TargetDate = datemnth(StartDate, NumberMonths, DayFlag,...
%          Basis, EndMonthRule)
%
%     は、以下を返します。
%
%     TargetDate = 729727 (03-Dec-1997)
%
%   参考 DAYS360, DAYS365, DAYSACT, DAYSDIF, WRKDYDIF.


%   Copyright 1995-2008 The MathWorks, Inc.
