% CPNPERSZ クーポン期間の日数
%
% この関数は、NUMBONDS の確定利付債券に対して、決済日を含むクーポン期間の
% 日数を出力します。
%
%   NumDaysPeriod = cpnpersz(Settle, Maturity)
%
%   NumDaysPeriod = cpnpersz(Settle, Maturity, Period, Basis, EndMonthRule,...
%          IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
% 入力: 必須の引数は、NUMBONDS行1列、または、1行NUMBONDS列 のベクトル、または、
%       スカラ引数です。オプションの引数は全て NUMBONDS行1列、または、1行NUMBONDS列
%       のベクトル、スカラ、または空行列となります。オプション入力は、空行列によって
%       省略することもできます。さらにオプション入力の中で、引数リストの末尾に位置
%       する入力は省略することもできます。オプション入力の値をデフォルト値に設定する
%       には、NaN を入力値として設定してください。日付引数はシリアル日付番号、または
%       日付文字列です。SIA 確定利付債権の引数に関する詳細については、'help ftb' と
%       入力してください。 ある特定の引数に関する詳細については、コマンドライン
%      上で、'help ftb' + 引数名 (たとえば、Settle (決済日) に関するヘルプは、
%      "help ftbSettle") とタイプすれば参照できます。
%
%     Settle (必須) - 決済日
%     Maturity (必須) - 満期日
%
% オプションの入力:
%     Period - 年当たりのクーポン回数; デフォルトは2(半年払い)
%     Basis - 日数のカウント基準; デフォルトは 0 (actual/actual)
%     EndMonthRule - 月末規則; デフォルトは 1 (月末規則は有効)
%     IssueDate - 発行日
%     FirstCouponDate - 最初のクーポン日
%     LastCouponDate - 最後のクーポン日
%     StartDate - 支払いを前もってスタートさせる日付 (バージョン 2.0 では無視されます)
%
% 出力: 
%     NumDaysPeriod - 決済日を含むクーポン期間の日数を示すNUMBONDS行1列のベクトルです。
%
% 参考 CPNDAYSN, CPNDAYSP, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC.
 

% Copyright 1995-2006 The MathWorks, Inc.
